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
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.persist.inmemory.Utils;

import static io.ballerina.stdlib.persist.Constants.RUN_READ_BY_KEY_QUERY_METHOD;
import static io.ballerina.stdlib.persist.Constants.RUN_READ_QUERY_METHOD;
import static io.ballerina.stdlib.persist.ErrorGenerator.wrapError;
import static io.ballerina.stdlib.persist.Utils.getEntity;
import static io.ballerina.stdlib.persist.Utils.getKey;
import static io.ballerina.stdlib.persist.Utils.getMetadata;
import static io.ballerina.stdlib.persist.Utils.getPersistClient;

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
        RecordType recordType = (RecordType) targetType.getDescribingType();
        BArray[] metadata = getMetadata(recordType);
        BArray fields = metadata[0];
        BArray includes = metadata[1];
        BArray typeDescriptions = metadata[2];

        return env.yieldAndRun(() -> {
            try {
                Object result = env.getRuntime().callMethod(
                        // Call `InMemoryClient.runReadQuery(string[] fields = [])`
                        // which returns `stream<record {}, persist:Error?>`
                        persistClient, RUN_READ_QUERY_METHOD, null, fields
                );
                BStream stream = (BStream) result;
                return Utils.createPersistInMemoryStreamValue(stream, targetType, fields,
                        includes, typeDescriptions, persistClient, null);
            } catch (BError bError) {
                return Utils.createPersistInMemoryStreamValue(null, targetType, fields, includes,
                        typeDescriptions, persistClient, wrapError(bError));
            }

        });
    }

    public static Object queryOne(Environment env, BObject client, BArray path, BTypedesc targetType) {
        // This method will return `targetType|persist:Error`

        BString entity = getEntity(env);
        RecordType recordType = (RecordType) targetType.getDescribingType();

        BArray[] metadata = getMetadata(recordType);
        BArray fields = metadata[0];
        BArray includes = metadata[1];
        BArray typeDescriptions = metadata[2];

        Object key = getKey(env, path);

        return env.yieldAndRun(() -> {
            try {
                return  env.getRuntime().callMethod(getPersistClient(client, entity), RUN_READ_BY_KEY_QUERY_METHOD,
                        null, targetType, key, fields, includes, typeDescriptions);

            } catch (BError bError) {
                return wrapError(bError);
            }
        });
    }
}
