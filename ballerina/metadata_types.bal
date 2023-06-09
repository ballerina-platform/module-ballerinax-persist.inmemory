// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/persist;

# Represents the metadata of an entity.
#
# + keyFields - Array of strings containing key field names
# + query - Function pointer to query records as a stream
# + queryOne - Function pointer for query by key
# + associationsMethods - Map of associated query function pointers
public type TableMetadata record {|
    string[] keyFields;
    isolated function (string[]) returns stream<record {}, persist:Error?> query;
    isolated function (anydata) returns record {}|persist:NotFoundError queryOne;
    map<isolated function (record {}, string[]) returns record {}[]> associationsMethods = {};
|};
