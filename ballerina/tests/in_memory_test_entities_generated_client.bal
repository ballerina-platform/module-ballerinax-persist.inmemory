// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/persist;
import ballerina/jballerina.java;

const ALL_TYPES = "alltypes";
const STRING_ID_RECORD = "stringidrecords";
const INT_ID_RECORD = "intidrecords";
const FLOAT_ID_RECORD = "floatidrecords";
const DECIMAL_ID_RECORD = "decimalidrecords";
const BOOLEAN_ID_RECORD = "booleanidrecords";
const COMPOSITE_ASSOCIATION_RECORD = "compositeassociationrecords";
const ALL_TYPES_ID_RECORD = "alltypesidrecords";
final isolated table<AllTypes> key(id) alltypesTable = table [];
final isolated table<StringIdRecord> key(id) stringidrecordsTable = table [];
final isolated table<IntIdRecord> key(id) intidrecordsTable = table [];
final isolated table<FloatIdRecord> key(id) floatidrecordsTable = table [];
final isolated table<DecimalIdRecord> key(id) decimalidrecordsTable = table [];
final isolated table<BooleanIdRecord> key(id) booleanidrecordsTable = table [];
final isolated table<CompositeAssociationRecord> key(id) compositeassociationrecordsTable = table [];
final isolated table<AllTypesIdRecord> key(booleanType, intType, floatType, decimalType, stringType) alltypesidrecordsTable = table [];

public isolated client class InMemoryTestEntitiesClient {
    *persist:AbstractPersistClient;

    private final map<InMemoryClient> persistClients;

    public isolated function init() returns persist:Error? {
        final map<TableMetadata> metadata = {
            [ALL_TYPES] : {
                keyFields: ["id"],
                query: queryAlltypes,
                queryOne: queryOneAlltypes
            },
            [STRING_ID_RECORD] : {
                keyFields: ["id"],
                query: queryStringidrecords,
                queryOne: queryOneStringidrecords
            },
            [INT_ID_RECORD] : {
                keyFields: ["id"],
                query: queryIntidrecords,
                queryOne: queryOneIntidrecords
            },
            [FLOAT_ID_RECORD] : {
                keyFields: ["id"],
                query: queryFloatidrecords,
                queryOne: queryOneFloatidrecords
            },
            [DECIMAL_ID_RECORD] : {
                keyFields: ["id"],
                query: queryDecimalidrecords,
                queryOne: queryOneDecimalidrecords
            },
            [BOOLEAN_ID_RECORD] : {
                keyFields: ["id"],
                query: queryBooleanidrecords,
                queryOne: queryOneBooleanidrecords
            },
            [COMPOSITE_ASSOCIATION_RECORD] : {
                keyFields: ["id"],
                query: queryCompositeassociationrecords,
                queryOne: queryOneCompositeassociationrecords
            },
            [ALL_TYPES_ID_RECORD] : {
                keyFields: ["booleanType", "intType", "floatType", "decimalType", "stringType"],
                query: queryAlltypesidrecords,
                queryOne: queryOneAlltypesidrecords
            }
        };
        self.persistClients = {
            [ALL_TYPES] : check new (metadata.get(ALL_TYPES).cloneReadOnly()),
            [STRING_ID_RECORD] : check new (metadata.get(STRING_ID_RECORD).cloneReadOnly()),
            [INT_ID_RECORD] : check new (metadata.get(INT_ID_RECORD).cloneReadOnly()),
            [FLOAT_ID_RECORD] : check new (metadata.get(FLOAT_ID_RECORD).cloneReadOnly()),
            [DECIMAL_ID_RECORD] : check new (metadata.get(DECIMAL_ID_RECORD).cloneReadOnly()),
            [BOOLEAN_ID_RECORD] : check new (metadata.get(BOOLEAN_ID_RECORD).cloneReadOnly()),
            [COMPOSITE_ASSOCIATION_RECORD] : check new (metadata.get(COMPOSITE_ASSOCIATION_RECORD).cloneReadOnly()),
            [ALL_TYPES_ID_RECORD] : check new (metadata.get(ALL_TYPES_ID_RECORD).cloneReadOnly())
        };
    }

    isolated resource function get alltypes(AllTypesTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get alltypes/[int id](AllTypesTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post alltypes(AllTypesInsert[] data) returns int[]|persist:Error {
        int[] keys = [];
        foreach AllTypesInsert value in data {
            lock {
                if alltypesTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("AllTypes", value.id);
                }
                alltypesTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put alltypes/[int id](AllTypesUpdate value) returns AllTypes|persist:Error {
        lock {
            if !alltypesTable.hasKey(id) {
                return persist:getNotFoundError("AllTypes", id);
            }
            AllTypes alltypes = alltypesTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                alltypes[k] = v;
            }
            alltypesTable.put(alltypes);
            return alltypes.clone();
        }
    }

    isolated resource function delete alltypes/[int id]() returns AllTypes|persist:Error {
        lock {
            if !alltypesTable.hasKey(id) {
                return persist:getNotFoundError("AllTypes", id);
            }
            return alltypesTable.remove(id).clone();
        }
    }

    isolated resource function get stringidrecords(StringIdRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get stringidrecords/[string id](StringIdRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post stringidrecords(StringIdRecordInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach StringIdRecordInsert value in data {
            lock {
                if stringidrecordsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("StringIdRecord", value.id);
                }
                stringidrecordsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put stringidrecords/[string id](StringIdRecordUpdate value) returns StringIdRecord|persist:Error {
        lock {
            if !stringidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("StringIdRecord", id);
            }
            StringIdRecord stringidrecord = stringidrecordsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                stringidrecord[k] = v;
            }
            stringidrecordsTable.put(stringidrecord);
            return stringidrecord.clone();
        }
    }

    isolated resource function delete stringidrecords/[string id]() returns StringIdRecord|persist:Error {
        lock {
            if !stringidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("StringIdRecord", id);
            }
            return stringidrecordsTable.remove(id).clone();
        }
    }

    isolated resource function get intidrecords(IntIdRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get intidrecords/[int id](IntIdRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post intidrecords(IntIdRecordInsert[] data) returns int[]|persist:Error {
        int[] keys = [];
        foreach IntIdRecordInsert value in data {
            lock {
                if intidrecordsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("IntIdRecord", value.id);
                }
                intidrecordsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put intidrecords/[int id](IntIdRecordUpdate value) returns IntIdRecord|persist:Error {
        lock {
            if !intidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("IntIdRecord", id);
            }
            IntIdRecord intidrecord = intidrecordsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                intidrecord[k] = v;
            }
            intidrecordsTable.put(intidrecord);
            return intidrecord.clone();
        }
    }

    isolated resource function delete intidrecords/[int id]() returns IntIdRecord|persist:Error {
        lock {
            if !intidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("IntIdRecord", id);
            }
            return intidrecordsTable.remove(id).clone();
        }
    }

    isolated resource function get floatidrecords(FloatIdRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get floatidrecords/[float id](FloatIdRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post floatidrecords(FloatIdRecordInsert[] data) returns float[]|persist:Error {
        float[] keys = [];
        foreach FloatIdRecordInsert value in data {
            lock {
                if floatidrecordsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("FloatIdRecord", value.id);
                }
                floatidrecordsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put floatidrecords/[float id](FloatIdRecordUpdate value) returns FloatIdRecord|persist:Error {
        lock {
            if !floatidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("FloatIdRecord", id);
            }
            FloatIdRecord floatidrecord = floatidrecordsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                floatidrecord[k] = v;
            }
            floatidrecordsTable.put(floatidrecord);
            return floatidrecord.clone();
        }
    }

    isolated resource function delete floatidrecords/[float id]() returns FloatIdRecord|persist:Error {
        lock {
            if !floatidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("FloatIdRecord", id);
            }
            return floatidrecordsTable.remove(id).clone();
        }
    }

    isolated resource function get decimalidrecords(DecimalIdRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get decimalidrecords/[decimal id](DecimalIdRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post decimalidrecords(DecimalIdRecordInsert[] data) returns decimal[]|persist:Error {
        decimal[] keys = [];
        foreach DecimalIdRecordInsert value in data {
            lock {
                if decimalidrecordsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("DecimalIdRecord", value.id);
                }
                decimalidrecordsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put decimalidrecords/[decimal id](DecimalIdRecordUpdate value) returns DecimalIdRecord|persist:Error {
        lock {
            if !decimalidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("DecimalIdRecord", id);
            }
            DecimalIdRecord decimalidrecord = decimalidrecordsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                decimalidrecord[k] = v;
            }
            decimalidrecordsTable.put(decimalidrecord);
            return decimalidrecord.clone();
        }
    }

    isolated resource function delete decimalidrecords/[decimal id]() returns DecimalIdRecord|persist:Error {
        lock {
            if !decimalidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("DecimalIdRecord", id);
            }
            return decimalidrecordsTable.remove(id).clone();
        }
    }

    isolated resource function get booleanidrecords(BooleanIdRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get booleanidrecords/[boolean id](BooleanIdRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post booleanidrecords(BooleanIdRecordInsert[] data) returns boolean[]|persist:Error {
        boolean[] keys = [];
        foreach BooleanIdRecordInsert value in data {
            lock {
                if booleanidrecordsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("BooleanIdRecord", value.id);
                }
                booleanidrecordsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put booleanidrecords/[boolean id](BooleanIdRecordUpdate value) returns BooleanIdRecord|persist:Error {
        lock {
            if !booleanidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("BooleanIdRecord", id);
            }
            BooleanIdRecord booleanidrecord = booleanidrecordsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                booleanidrecord[k] = v;
            }
            booleanidrecordsTable.put(booleanidrecord);
            return booleanidrecord.clone();
        }
    }

    isolated resource function delete booleanidrecords/[boolean id]() returns BooleanIdRecord|persist:Error {
        lock {
            if !booleanidrecordsTable.hasKey(id) {
                return persist:getNotFoundError("BooleanIdRecord", id);
            }
            return booleanidrecordsTable.remove(id).clone();
        }
    }

    isolated resource function get compositeassociationrecords(CompositeAssociationRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get compositeassociationrecords/[string id](CompositeAssociationRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post compositeassociationrecords(CompositeAssociationRecordInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach CompositeAssociationRecordInsert value in data {
            lock {
                if compositeassociationrecordsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("CompositeAssociationRecord", value.id);
                }
                compositeassociationrecordsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put compositeassociationrecords/[string id](CompositeAssociationRecordUpdate value) returns CompositeAssociationRecord|persist:Error {
        lock {
            if !compositeassociationrecordsTable.hasKey(id) {
                return persist:getNotFoundError("CompositeAssociationRecord", id);
            }
            CompositeAssociationRecord compositeassociationrecord = compositeassociationrecordsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                compositeassociationrecord[k] = v;
            }
            compositeassociationrecordsTable.put(compositeassociationrecord);
            return compositeassociationrecord.clone();
        }
    }

    isolated resource function delete compositeassociationrecords/[string id]() returns CompositeAssociationRecord|persist:Error {
        lock {
            if !compositeassociationrecordsTable.hasKey(id) {
                return persist:getNotFoundError("CompositeAssociationRecord", id);
            }
            return compositeassociationrecordsTable.remove(id).clone();
        }
    }

    isolated resource function get alltypesidrecords(AllTypesIdRecordTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get alltypesidrecords/[boolean booleanType]/[int intType]/[float floatType]/[decimal decimalType]/[string stringType](AllTypesIdRecordTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post alltypesidrecords(AllTypesIdRecordInsert[] data) returns [boolean, int, float, decimal, string][]|persist:Error {
        [boolean, int, float, decimal, string][] keys = [];
        foreach AllTypesIdRecordInsert value in data {
            lock {
                if alltypesidrecordsTable.hasKey([value.booleanType, value.intType, value.floatType, value.decimalType, value.stringType]) {
                    return persist:getAlreadyExistsError("AllTypesIdRecord", {booleanType: value.booleanType, intType: value.intType, floatType: value.floatType, decimalType: value.decimalType, stringType: value.stringType});
                }
                alltypesidrecordsTable.put(value.clone());
            }
            keys.push([value.booleanType, value.intType, value.floatType, value.decimalType, value.stringType]);
        }
        return keys;
    }

    isolated resource function put alltypesidrecords/[boolean booleanType]/[int intType]/[float floatType]/[decimal decimalType]/[string stringType](AllTypesIdRecordUpdate value) returns AllTypesIdRecord|persist:Error {
        lock {
            if !alltypesidrecordsTable.hasKey([booleanType, intType, floatType, decimalType, stringType]) {
                return persist:getNotFoundError("AllTypesIdRecord", {booleanType: booleanType, intType: intType, floatType: floatType, decimalType: decimalType, stringType: stringType});
            }
            AllTypesIdRecord alltypesidrecord = alltypesidrecordsTable.get([booleanType, intType, floatType, decimalType, stringType]);
            foreach var [k, v] in value.clone().entries() {
                alltypesidrecord[k] = v;
            }
            alltypesidrecordsTable.put(alltypesidrecord);
            return alltypesidrecord.clone();
        }
    }

    isolated resource function delete alltypesidrecords/[boolean booleanType]/[int intType]/[float floatType]/[decimal decimalType]/[string stringType]() returns AllTypesIdRecord|persist:Error {
        lock {
            if !alltypesidrecordsTable.hasKey([booleanType, intType, floatType, decimalType, stringType]) {
                return persist:getNotFoundError("AllTypesIdRecord", {booleanType: booleanType, intType: intType, floatType: floatType, decimalType: decimalType, stringType: stringType});
            }
            return alltypesidrecordsTable.remove([booleanType, intType, floatType, decimalType, stringType]).clone();
        }
    }

    public isolated function close() returns persist:Error? {
        return ();
    }
}

isolated function queryAlltypes(string[] fields) returns stream<record {}, persist:Error?> {
    table<AllTypes> key(id) alltypesClonedTable;
    lock {
        alltypesClonedTable = alltypesTable.clone();
    }
    return from record {} 'object in alltypesClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneAlltypes(anydata key) returns record {}|persist:NotFoundError {
    table<AllTypes> key(id) alltypesClonedTable;
    lock {
        alltypesClonedTable = alltypesTable.clone();
    }
    from record {} 'object in alltypesClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("AllTypes", key);
}

isolated function queryStringidrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<StringIdRecord> key(id) stringidrecordsClonedTable;
    lock {
        stringidrecordsClonedTable = stringidrecordsTable.clone();
    }
    return from record {} 'object in stringidrecordsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneStringidrecords(anydata key) returns record {}|persist:NotFoundError {
    table<StringIdRecord> key(id) stringidrecordsClonedTable;
    lock {
        stringidrecordsClonedTable = stringidrecordsTable.clone();
    }
    from record {} 'object in stringidrecordsClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("StringIdRecord", key);
}

isolated function queryIntidrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<IntIdRecord> key(id) intidrecordsClonedTable;
    lock {
        intidrecordsClonedTable = intidrecordsTable.clone();
    }
    return from record {} 'object in intidrecordsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneIntidrecords(anydata key) returns record {}|persist:NotFoundError {
    table<IntIdRecord> key(id) intidrecordsClonedTable;
    lock {
        intidrecordsClonedTable = intidrecordsTable.clone();
    }
    from record {} 'object in intidrecordsClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("IntIdRecord", key);
}

isolated function queryFloatidrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<FloatIdRecord> key(id) floatidrecordsClonedTable;
    lock {
        floatidrecordsClonedTable = floatidrecordsTable.clone();
    }
    return from record {} 'object in floatidrecordsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneFloatidrecords(anydata key) returns record {}|persist:NotFoundError {
    table<FloatIdRecord> key(id) floatidrecordsClonedTable;
    lock {
        floatidrecordsClonedTable = floatidrecordsTable.clone();
    }
    from record {} 'object in floatidrecordsClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("FloatIdRecord", key);
}

isolated function queryDecimalidrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<DecimalIdRecord> key(id) decimalidrecordsClonedTable;
    lock {
        decimalidrecordsClonedTable = decimalidrecordsTable.clone();
    }
    return from record {} 'object in decimalidrecordsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneDecimalidrecords(anydata key) returns record {}|persist:NotFoundError {
    table<DecimalIdRecord> key(id) decimalidrecordsClonedTable;
    lock {
        decimalidrecordsClonedTable = decimalidrecordsTable.clone();
    }
    from record {} 'object in decimalidrecordsClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("DecimalIdRecord", key);
}

isolated function queryBooleanidrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<BooleanIdRecord> key(id) booleanidrecordsClonedTable;
    lock {
        booleanidrecordsClonedTable = booleanidrecordsTable.clone();
    }
    return from record {} 'object in booleanidrecordsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneBooleanidrecords(anydata key) returns record {}|persist:NotFoundError {
    table<BooleanIdRecord> key(id) booleanidrecordsClonedTable;
    lock {
        booleanidrecordsClonedTable = booleanidrecordsTable.clone();
    }
    from record {} 'object in booleanidrecordsClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("BooleanIdRecord", key);
}

isolated function queryCompositeassociationrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<CompositeAssociationRecord> key(id) compositeassociationrecordsClonedTable;
    lock {
        compositeassociationrecordsClonedTable = compositeassociationrecordsTable.clone();
    }
    table<AllTypesIdRecord> key(booleanType, intType, floatType, decimalType, stringType) alltypesidrecordsClonedTable;
    lock {
        alltypesidrecordsClonedTable = alltypesidrecordsTable.clone();
    }
    return from record {} 'object in compositeassociationrecordsClonedTable
        outer join var alltypesidrecord in alltypesidrecordsClonedTable on ['object.alltypesidrecordBooleanType, 'object.alltypesidrecordIntType, 'object.alltypesidrecordFloatType, 'object.alltypesidrecordDecimalType, 'object.alltypesidrecordStringType] equals [alltypesidrecord?.booleanType, alltypesidrecord?.intType, alltypesidrecord?.floatType, alltypesidrecord?.decimalType, alltypesidrecord?.stringType]
        select persist:filterRecord({
            ...'object,
            "allTypesIdRecord": alltypesidrecord
        }, fields);
}

isolated function queryOneCompositeassociationrecords(anydata key) returns record {}|persist:NotFoundError {
    table<CompositeAssociationRecord> key(id) compositeassociationrecordsClonedTable;
    lock {
        compositeassociationrecordsClonedTable = compositeassociationrecordsTable.clone();
    }
    table<AllTypesIdRecord> key(booleanType, intType, floatType, decimalType, stringType) alltypesidrecordsClonedTable;
    lock {
        alltypesidrecordsClonedTable = alltypesidrecordsTable.clone();
    }
    from record {} 'object in compositeassociationrecordsClonedTable
    where persist:getKey('object, ["id"]) == key
    outer join var alltypesidrecord in alltypesidrecordsClonedTable on ['object.alltypesidrecordBooleanType, 'object.alltypesidrecordIntType, 'object.alltypesidrecordFloatType, 'object.alltypesidrecordDecimalType, 'object.alltypesidrecordStringType] equals [alltypesidrecord?.booleanType, alltypesidrecord?.intType, alltypesidrecord?.floatType, alltypesidrecord?.decimalType, alltypesidrecord?.stringType]
    do {
        return {
            ...'object,
            "allTypesIdRecord": alltypesidrecord
        };
    };
    return persist:getNotFoundError("CompositeAssociationRecord", key);
}

isolated function queryAlltypesidrecords(string[] fields) returns stream<record {}, persist:Error?> {
    table<AllTypesIdRecord> key(booleanType, intType, floatType, decimalType, stringType) alltypesidrecordsClonedTable;
    lock {
        alltypesidrecordsClonedTable = alltypesidrecordsTable.clone();
    }
    return from record {} 'object in alltypesidrecordsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneAlltypesidrecords(anydata key) returns record {}|persist:NotFoundError {
    table<AllTypesIdRecord> key(booleanType, intType, floatType, decimalType, stringType) alltypesidrecordsClonedTable;
    lock {
        alltypesidrecordsClonedTable = alltypesidrecordsTable.clone();
    }
    from record {} 'object in alltypesidrecordsClonedTable
    where persist:getKey('object, ["booleanType", "intType", "floatType", "decimalType", "stringType"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("AllTypesIdRecord", key);
}

