/*
 *  Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 LLC. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package io.ballerina.stdlib.persist.inmemory.datastore;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.types.ErrorType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.StreamType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.persist.ModuleUtils;
import io.ballerina.stdlib.persist.inmemory.Utils;

import java.util.Map;

import static io.ballerina.stdlib.persist.Constants.ERROR;
import static io.ballerina.stdlib.persist.Constants.KEY_FIELDS;
import static io.ballerina.stdlib.persist.Constants.RUN_READ_BY_KEY_QUERY_METHOD;
import static io.ballerina.stdlib.persist.Constants.RUN_READ_QUERY_METHOD;
import static io.ballerina.stdlib.persist.ErrorGenerator.wrapError;
import static io.ballerina.stdlib.persist.Utils.getEntity;
import static io.ballerina.stdlib.persist.Utils.getKey;
import static io.ballerina.stdlib.persist.Utils.getMetadata;
import static io.ballerina.stdlib.persist.Utils.getPersistClient;
import static io.ballerina.stdlib.persist.Utils.getRecordTypeWithKeyFields;
import static io.ballerina.stdlib.persist.Utils.getTransactionContextProperties;

/**
  * This class provides the in-memory query processing implementations for persistence.
  *
  * @since 0.3.1
  */
 public class InMemoryProcessor {
 
     private InMemoryProcessor() {
     }
 
     public static BStream query(Environment env, BObject client, BTypedesc targetType) {
         // This method will return `stream<targetType, persist:Error?>`

        BString entity = getEntity(env);
        BObject persistClient = getPersistClient(client, entity);
        BArray keyFields = (BArray) persistClient.get(KEY_FIELDS);
        RecordType recordType = (RecordType) targetType.getDescribingType();

        RecordType recordTypeWithIdFields = getRecordTypeWithKeyFields(keyFields, recordType);
        StreamType streamTypeWithIdFields = TypeCreator.createStreamType(recordTypeWithIdFields,
                PredefinedTypes.TYPE_NULL);

        BArray[] metadata = getMetadata(recordType);
        BArray fields = metadata[0];
        BArray includes = metadata[1];
        BArray typeDescriptions = metadata[2];

        Map<String, Object> trxContextProperties = getTransactionContextProperties();
        String strandName = env.getStrandName().isPresent() ? env.getStrandName().get() : null;

        Future balFuture = env.markAsync();
        env.getRuntime().invokeMethodAsyncSequentially(
                // Call `InMemoryClient.runReadQuery(string[] fields = [])`
                // which returns `stream<record {}, persist:Error?>`

                persistClient, RUN_READ_QUERY_METHOD,  strandName, env.getStrandMetadata(), new Callback() {
                    @Override
                    public void notifySuccess(Object o) {
                        BStream stream = (BStream) o;
                        balFuture.complete(Utils.createPersistInMemoryStreamValue(stream, targetType, fields,
                                includes, typeDescriptions, persistClient, null));
                    }

                    @Override
                    public void notifyFailure(BError bError) {
                        balFuture.complete(Utils.createPersistInMemoryStreamValue(null, targetType, fields, includes,
                                typeDescriptions, persistClient, wrapError(bError)));
                    }
                }, trxContextProperties, streamTypeWithIdFields, fields, true
        );

        return null;
    }

    public static Object queryOne(Environment env, BObject client, BArray path, BTypedesc targetType) {
        // This method will return `targetType|persist:Error`

        BString entity = getEntity(env);
        BObject persistClient = getPersistClient(client, entity);
        BArray keyFields = (BArray) persistClient.get(KEY_FIELDS);
        RecordType recordType = (RecordType) targetType.getDescribingType();

        RecordType recordTypeWithIdFields = getRecordTypeWithKeyFields(keyFields, recordType);
        ErrorType persistErrorType = TypeCreator.createErrorType(ERROR, ModuleUtils.getModule());
        Type unionType = TypeCreator.createUnionType(recordTypeWithIdFields, persistErrorType);

        BArray[] metadata = getMetadata(recordType);
        BArray fields = metadata[0];
        BArray includes = metadata[1];
        BArray typeDescriptions = metadata[2];

        Object key = getKey(env, path);

        Map<String, Object> trxContextProperties = getTransactionContextProperties();
        String strandName = env.getStrandName().isPresent() ? env.getStrandName().get() : null;

        Future balFuture = env.markAsync();
        env.getRuntime().invokeMethodAsyncSequentially(
                // Call `InMemoryClient.runReadByKeyQuery(
                //      typedesc<record {}> rowType, anydata key, string[] fields = [], string[] include = [],
                //      typedesc<record {}>[] typeDescriptions = []
                // )`
                // which returns `record {}|persist:Error`

                getPersistClient(client, entity), RUN_READ_BY_KEY_QUERY_METHOD, strandName, env.getStrandMetadata(),
                new Callback() {
                    @Override
                    public void notifySuccess(Object o) {
                        balFuture.complete(o);
                    }

                    @Override
                    public void notifyFailure(BError bError) {
                        balFuture.complete(wrapError(bError));
                    }
                },  trxContextProperties, unionType,
                targetType, true, key, true, fields, true, includes, true,
                typeDescriptions, true
        );

        return null;
    }
}
