# Specification: Ballerina Persist In-Memory Library

_Owners_: @daneshk @kaneeldias  
_Reviewers_: @daneshk  
_Created_: 2026/11/06  
_Updated_: 2026/11/06  
_Edition_: Swan Lake  

## Introduction

This is the specification for the `persist.inmemory` library of the [Ballerina language](https://ballerina.io/), which implements the in-memory datastore of the `persist` library. It covers what is specific to the in-memory datastore: the supported field types, how the generated in-memory client stores, reads and changes records, its errors, and its transaction behaviour. The data model, the derived entity types, the generated client API and the error types are specified in the [persist specification](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md), which this specification builds on and does not repeat.

The conforming implementation of the specification is released and included in the distribution. Any deviation from the specification is considered a bug. The released versions of the specification can be found under the relevant GitHub tag.

### Notation

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY and OPTIONAL are interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) and [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174) when, and only when, they appear in all capitals. Sentences that state behaviour in the present tense are also normative. The overview, notes and examples are informative.

## Contents

- [1. Overview](#1-overview)
- [2. Terminology](#2-terminology)
- [3. Supported types](#3-supported-types)
    - [3.1. Description](#31-description)
    - [3.2. Field types](#32-field-types)
    - [3.3. Nullable and optional fields](#33-nullable-and-optional-fields)
    - [3.4. Compile-time validation](#34-compile-time-validation)
- [4. In-memory client](#4-in-memory-client)
    - [4.1. Description](#41-description)
    - [4.2. Storage](#42-storage)
    - [4.3. Lifecycle](#43-lifecycle)
    - [4.4. Relation resolution](#44-relation-resolution)
    - [4.5. Reading records](#45-reading-records)
    - [4.6. Reading a record by identity](#46-reading-a-record-by-identity)
    - [4.7. Inserting records](#47-inserting-records)
    - [4.8. Updating a record](#48-updating-a-record)
    - [4.9. Deleting a record](#49-deleting-a-record)
    - [4.10. Errors](#410-errors)
- [5. Transactions](#5-transactions)
- [6. Security considerations](#6-security-considerations)
- [References](#references)

## 1. Overview

The in-memory datastore keeps the records of a data model in Ballerina tables in the memory of the running program. It needs no database and no configuration, and its records last only as long as the program.

The persist tool generates an in-memory client when the datastore of a model is `inmemory`, and the `InMemoryClient` test client when the test datastore is `inmemory`, as specified in the [persist tools specification](https://github.com/ballerina-platform/persist-tools/blob/main/docs/spec/spec.md). The generated client has the API specified in [derived entity types and persist clients](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md#4-derived-entity-types-and-persist-clients) of the persist specification. The `persist.inmemory` library provides the runtime that the generated client uses to read records, and its public types are used by the generated code. This specification states the behaviour of the generated client together with that runtime.

## 2. Terminology

This specification uses the terms of the [persist specification](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md#2-terminology), such as entity, identity field, relation field, owner, derived entity types and persist client, and the following terms:

- **In-memory client:** the persist client that the persist tool generates for the `inmemory` datastore or the `inmemory` test datastore.
- **Table:** the Ballerina table that holds the records of one entity, as specified in [4.2](#42-storage).
- **Identity:** the values of the identity fields of a record.
- **Foreign key fields:** the fields of the owner of a relation that hold the identity of the related record.
- **Target type:** the type that the `get` and `get` by identity resource methods return records of, given by their `targetType` argument.

## 3. Supported types

### 3.1. Description

The in-memory datastore accepts any field type in a data model, and nullable fields of any type.

### 3.2. Field types

1. A non-relation field of an entity MAY have any type, including the simple types of the persist specification, enum types, other record and imported types, and any array type.
2. The compiler plugin does not reject a union type, such as `int|string`, as the type of a non-relation field. Whether union types are supported is unspecified.
3. The identity fields follow the [data model definition](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md#3-data-model-definition) of the persist specification: an identity field is of type `int`, `string`, `float`, `boolean` or `decimal`, and is not nillable.
4. Relation fields follow the data model definition of the persist specification.

For example, these entities are valid with the in-memory datastore, and not with the other datastores, because of the `int[]` and `json` fields:

```ballerina
import ballerina/persist as _;

type Metrics record {|
    readonly int id;
    int[] readings;
    json metadata;
|};
```

### 3.3. Nullable and optional fields

Let `T` be a type that does not contain `()`.

| Field definition | Semantics | Example |
|---|---|---|
| `T field` | The field always has a value of type `T`. | `int[] readings;` |
| `T? field` | The field has a value of type `T`, or `()`. Allowed for every `T`, except on an identity field. | `string? description;` |
| `T field?` | Not allowed. | - |
| `T? field?` | Not allowed. | - |

### 3.4. Compile-time validation

The `persist` compiler plugin validates the model as specified in the [data model definition](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md#3-data-model-definition) of the persist specification. When the datastore of the model is `inmemory`:

1. A field type is never reported as unsupported: the plugin does not report `PERSIST_305` or `PERSIST_306`.
2. A nillable field is never reported: the plugin does not report `PERSIST_308`.
3. An optional field, `T field?` or `T? field?`, is reported with `PERSIST_304`.

## 4. In-memory client

### 4.1. Description

The in-memory client stores the records of each entity in a table, and implements the resource methods of the persist client on those tables.

### 4.2. Storage

1. The generated module has one table for each entity of the model. The table is keyed by the identity fields of the entity, so it holds at most one record for each identity.
2. Every table is empty when the program starts.
3. The tables belong to the generated module, not to a client object. All in-memory client objects of the module read and change the same tables.
4. The records are kept only in the memory of the program. They are lost when the program exits, and are not shared with any other program.
5. The table stores a copy of each record given to the `post` resource method, and each resource method returns copies of the stored records. Changing a value given to, or returned by, a resource method does not change the stored records.
6. Each check and change of a table is done while holding a lock on the table, so the resource methods MAY be called concurrently.

### 4.3. Lifecycle

1. Creating an in-memory client does not change the tables, and does not return an error.
2. The `close` function returns `()`, and does not change the tables or the client. A client remains usable after `close`.

### 4.4. Relation resolution

The in-memory datastore does not store relation fields. It resolves them when records are read, from the foreign key fields of the owner.

1. A field of the target type whose type is a record type, other than `time:Date`, `time:TimeOfDay`, `time:Utc` and `time:Civil`, or an array of such a record type, is read as a relation field. Only the fields of its record type are read from the related records.
2. For the `EntityType` relation field of the owner, the related record is the record of the related entity whose identity equals the foreign key fields of the owner record. When there is no such record, the relation field is absent from the result.
3. For the `EntityType[]` relation field of a 1-n relation, the related records are all the records of the related entity whose foreign key fields equal the identity of the record, in the order in which they were inserted. When there are no such records, the relation field is the empty array, `[]`.
4. Whether the `EntityType?` relation field of the entity that is not the owner of a 1-1 relation is resolved is unspecified.
5. Relations are resolved one level deep: a relation field of the target type is read with the fields of its own record type, and not with the relations of the related entity.

#### 4.4.1. Example: Resolving relations

For these entities, where `Employee` owns the relation:

```ballerina
type Employee record {|
    readonly string empNo;
    string firstName;
    string lastName;
    Department department;
|};

type Department record {|
    readonly string deptNo;
    string deptName;
    Employee[] employees;
|};
```

Two employees whose `departmentDeptNo` is `"department-12"` are read through their department with this target type:

```ballerina
type DepartmentInfo record {|
    string deptNo;
    string deptName;
    record {|
        string firstName;
        string lastName;
    |}[] employees;
|};

DepartmentInfo department = check dbClient->/departments/["department-12"].get();
// {deptNo: "department-12", deptName: "Marketing", employees: [{firstName: "Tom", lastName: "Scott"}, {firstName: "Jane", lastName: "Doe"}]}
```

The `employees` field is resolved by rule 3 of [4.4](#44-relation-resolution). A department with no employees has `employees: []`.

### 4.5. Reading records

1. The `get` resource method returns a stream of all the records of the entity, in the order in which they were inserted. It has no parameter that filters, orders or limits the records.
2. Each record of the stream has only the fields of the target type. A non-relation field of the target type takes the value of the field of the stored record, and a relation field is resolved as specified in [4.4](#44-relation-resolution).
3. The records of the entity, and the records that their `EntityType` relation fields are resolved from, are those in the tables when `get` is called. Changes made to the tables after the call do not affect them.
4. The `EntityType[]` relation fields of a record are resolved when the record is read from the stream.
5. When the entity has no records, the stream is empty.

> **Note:** Records are selected, ordered and limited by applying a Ballerina query expression to the stream.

### 4.6. Reading a record by identity

1. The `get` by identity resource method returns the record of the entity whose identity fields equal the path parameters.
2. The record has only the fields of the target type, as specified in rule 2 of [4.5](#45-reading-records).
3. When no record has the identity, the method returns a `persist:NotFoundError`.
4. When the record cannot be converted to the target type, such as when a required relation field of the target type is absent by rule 2 of [4.4](#44-relation-resolution), the method returns a `persist:Error`.

### 4.7. Inserting records

1. The `post` resource method processes the given records in order. For each record:
    1. If the table has a record with the same identity, the method returns a `persist:AlreadyExistsError` for that identity.
    2. Otherwise, the record is stored in the table.
2. When every record is stored, the method returns the identities of the records, in the order of the given records.
3. A record that has the same identity as an earlier record of the same array fails by rule 1.1.
4. When the array is empty, the method stores nothing and returns an empty array.
5. Whether the records before a failed record remain stored, and whether the insertion of the array is atomic with respect to concurrent operations, is unspecified.
6. The foreign key fields of a record are not checked: a record MAY refer to an identity that no record of the related entity has.

### 4.8. Updating a record

1. When no record has the identity given in the path, the `put` resource method returns a `persist:NotFoundError`.
2. Otherwise, each field that is present in the given update record replaces the value of that field in the stored record. A field that is absent keeps its value, and a nillable field that is given `()` is set to `()`. The identity of the record is not changed.
3. The method returns the updated record, of the entity type.
4. When the update record has no fields, the stored record is not changed, and is returned.
5. The check and the change are one atomic step with respect to other operations on the table.
6. Foreign key fields are not checked: an update MAY set them to an identity that no record of the related entity has.

### 4.9. Deleting a record

1. When no record has the identity given in the path, the `delete` resource method returns a `persist:NotFoundError`.
2. Otherwise, the method removes the record from the table and returns it, as it was before the deletion.
3. The check and the removal are one atomic step with respect to other operations on the table.
4. The records of other entities that refer to the deleted record through their foreign key fields are not checked or changed. Their relation fields to the deleted record are then resolved as specified in rule 2 of [4.4](#44-relation-resolution).

### 4.10. Errors

1. The in-memory client returns the errors of the [persist specification](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md#4-derived-entity-types-and-persist-clients). Its resource methods return them as follows:

    | Resource method | Error | Condition |
    |---|---|---|
    | `get` by identity | `persist:NotFoundError` | No record has the identity. |
    | `get` by identity | `persist:Error` | The record cannot be converted to the target type. |
    | `post` | `persist:AlreadyExistsError` | A record has the same identity as a given record. |
    | `put` | `persist:NotFoundError` | No record has the identity. |
    | `delete` | `persist:NotFoundError` | No record has the identity. |

2. The `persist:NotFoundError` and `persist:AlreadyExistsError` are created with `persist:getNotFoundError` and `persist:getAlreadyExistsError`, with the name of the entity and the identity of the record. A composite identity is given as a record of the identity fields, in the order of the identity fields.
3. The in-memory client does not return a `persist:ConstraintViolationError` or a `persist:ReadBackError`.
4. A failure of the query of `get` is returned from the stream as a `persist:Error`. What the stream does with a record that cannot be converted to the target type is unspecified.

For example, inserting an `OrderItem`, whose identity fields are `orderId` and `itemId`, with an identity that is already stored returns a `persist:AlreadyExistsError` with this message:

```
A record with the key '{"orderId":"order-1","itemId":"item-1"}' already exists for the entity 'OrderItem'.
```

## 5. Transactions

The in-memory client does not take part in Ballerina transactions. A resource method called inside a `transaction` statement changes the tables when it is called, and the change is not undone when the transaction rolls back.

## 6. Security considerations

1. The records are held unencrypted in the memory of the program. The library does not write them to any storage.
2. The in-memory datastore has no authentication or access control. Any code of the program that can use the generated module can read and change all its records.
3. The tables have no size limit. The number and size of the records are bounded only by the memory of the program.

## References

- [Ballerina persist specification](https://github.com/ballerina-platform/module-ballerina-persist/blob/main/docs/spec/spec.md)
- [Ballerina persist tools specification](https://github.com/ballerina-platform/persist-tools/blob/main/docs/spec/spec.md)
- [RFC 2119: Key words for use in RFCs to Indicate Requirement Levels](https://www.rfc-editor.org/rfc/rfc2119)
- [RFC 8174: Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words](https://www.rfc-editor.org/rfc/rfc8174)
