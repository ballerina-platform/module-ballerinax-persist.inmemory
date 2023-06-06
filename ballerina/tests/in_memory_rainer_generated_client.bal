// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerina/jballerina.java;

const EMPLOYEE = "employees";
const WORKSPACE = "workspaces";
const BUILDING = "buildings";
const DEPARTMENT = "departments";
const ORDER_ITEM = "orderitems";
final isolated table<Employee> key(empNo) employeesTable = table [];
final isolated table<Workspace> key(workspaceId) workspacesTable = table [];
final isolated table<Building> key(buildingCode) buildingsTable = table [];
final isolated table<Department> key(deptNo) departmentsTable = table [];
final isolated table<OrderItem> key(orderId, itemId) orderitemsTable = table [];

public isolated client class InMemoryRainierClient {
    *persist:AbstractPersistClient;

    private final map<InMemoryClient> persistClients;

    public isolated function init() returns persist:Error? {
        final map<TableMetadata> metadata = {
            [EMPLOYEE] : {
                keyFields: ["empNo"],
                query: queryEmployees,
                queryOne: queryOneEmployees
            },
            [WORKSPACE] : {
                keyFields: ["workspaceId"],
                query: queryWorkspaces,
                queryOne: queryOneWorkspaces,
                associationsMethods: {"employees": queryWorkspaceEmployees}
            },
            [BUILDING] : {
                keyFields: ["buildingCode"],
                query: queryBuildings,
                queryOne: queryOneBuildings,
                associationsMethods: {"workspaces": queryBuildingWorkspaces}
            },
            [DEPARTMENT] : {
                keyFields: ["deptNo"],
                query: queryDepartments,
                queryOne: queryOneDepartments,
                associationsMethods: {"employees": queryDepartmentEmployees}
            },
            [ORDER_ITEM] : {
                keyFields: ["orderId", "itemId"],
                query: queryOrderitems,
                queryOne: queryOneOrderitems
            }
        };
        self.persistClients = {
            [EMPLOYEE] : check new (metadata.get(EMPLOYEE).cloneReadOnly()),
            [WORKSPACE] : check new (metadata.get(WORKSPACE).cloneReadOnly()),
            [BUILDING] : check new (metadata.get(BUILDING).cloneReadOnly()),
            [DEPARTMENT] : check new (metadata.get(DEPARTMENT).cloneReadOnly()),
            [ORDER_ITEM] : check new (metadata.get(ORDER_ITEM).cloneReadOnly())
        };
    }

    isolated resource function get employees(EmployeeTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get employees/[string empNo](EmployeeTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post employees(EmployeeInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach EmployeeInsert value in data {
            lock {
                if employeesTable.hasKey(value.empNo) {
                    return persist:getAlreadyExistsError("Employee", value.empNo);
                }
                employeesTable.put(value.clone());
            }
            keys.push(value.empNo);
        }
        return keys;
    }

    isolated resource function put employees/[string empNo](EmployeeUpdate value) returns Employee|persist:Error {
        lock {
            if !employeesTable.hasKey(empNo) {
                return persist:getNotFoundError("Employee", empNo);
            }
            Employee employee = employeesTable.get(empNo);
            foreach var [k, v] in value.clone().entries() {
                employee[k] = v;
            }
            employeesTable.put(employee);
            return employee.clone();
        }
    }

    isolated resource function delete employees/[string empNo]() returns Employee|persist:Error {
        lock {
            if !employeesTable.hasKey(empNo) {
                return persist:getNotFoundError("Employee", empNo);
            }
            return employeesTable.remove(empNo).clone();
        }
    }

    isolated resource function get workspaces(WorkspaceTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get workspaces/[string workspaceId](WorkspaceTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post workspaces(WorkspaceInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach WorkspaceInsert value in data {
            lock {
                if workspacesTable.hasKey(value.workspaceId) {
                    return persist:getAlreadyExistsError("Workspace", value.workspaceId);
                }
                workspacesTable.put(value.clone());
            }
            keys.push(value.workspaceId);
        }
        return keys;
    }

    isolated resource function put workspaces/[string workspaceId](WorkspaceUpdate value) returns Workspace|persist:Error {
        lock {
            if !workspacesTable.hasKey(workspaceId) {
                return persist:getNotFoundError("Workspace", workspaceId);
            }
            Workspace workspace = workspacesTable.get(workspaceId);
            foreach var [k, v] in value.clone().entries() {
                workspace[k] = v;
            }
            workspacesTable.put(workspace);
            return workspace.clone();
        }
    }

    isolated resource function delete workspaces/[string workspaceId]() returns Workspace|persist:Error {
        lock {
            if !workspacesTable.hasKey(workspaceId) {
                return persist:getNotFoundError("Workspace", workspaceId);
            }
            return workspacesTable.remove(workspaceId).clone();
        }
    }

    isolated resource function get buildings(BuildingTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get buildings/[string buildingCode](BuildingTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post buildings(BuildingInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach BuildingInsert value in data {
            lock {
                if buildingsTable.hasKey(value.buildingCode) {
                    return persist:getAlreadyExistsError("Building", value.buildingCode);
                }
                buildingsTable.put(value.clone());
            }
            keys.push(value.buildingCode);
        }
        return keys;
    }

    isolated resource function put buildings/[string buildingCode](BuildingUpdate value) returns Building|persist:Error {
        lock {
            if !buildingsTable.hasKey(buildingCode) {
                return persist:getNotFoundError("Building", buildingCode);
            }
            Building building = buildingsTable.get(buildingCode);
            foreach var [k, v] in value.clone().entries() {
                building[k] = v;
            }
            buildingsTable.put(building);
            return building.clone();
        }
    }

    isolated resource function delete buildings/[string buildingCode]() returns Building|persist:Error {
        lock {
            if !buildingsTable.hasKey(buildingCode) {
                return persist:getNotFoundError("Building", buildingCode);
            }
            return buildingsTable.remove(buildingCode).clone();
        }
    }

    isolated resource function get departments(DepartmentTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get departments/[string deptNo](DepartmentTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post departments(DepartmentInsert[] data) returns string[]|persist:Error {
        string[] keys = [];
        foreach DepartmentInsert value in data {
            lock {
                if departmentsTable.hasKey(value.deptNo) {
                    return persist:getAlreadyExistsError("Department", value.deptNo);
                }
                departmentsTable.put(value.clone());
            }
            keys.push(value.deptNo);
        }
        return keys;
    }

    isolated resource function put departments/[string deptNo](DepartmentUpdate value) returns Department|persist:Error {
        lock {
            if !departmentsTable.hasKey(deptNo) {
                return persist:getNotFoundError("Department", deptNo);
            }
            Department department = departmentsTable.get(deptNo);
            foreach var [k, v] in value.clone().entries() {
                department[k] = v;
            }
            departmentsTable.put(department);
            return department.clone();
        }
    }

    isolated resource function delete departments/[string deptNo]() returns Department|persist:Error {
        lock {
            if !departmentsTable.hasKey(deptNo) {
                return persist:getNotFoundError("Department", deptNo);
            }
            return departmentsTable.remove(deptNo).clone();
        }
    }

    isolated resource function get orderitems(OrderItemTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get orderitems/[string orderId]/[string itemId](OrderItemTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post orderitems(OrderItemInsert[] data) returns [string, string][]|persist:Error {
        [string, string][] keys = [];
        foreach OrderItemInsert value in data {
            lock {
                if orderitemsTable.hasKey([value.orderId, value.itemId]) {
                    return persist:getAlreadyExistsError("OrderItem", {orderId: value.orderId, itemId: value.itemId});
                }
                orderitemsTable.put(value.clone());
            }
            keys.push([value.orderId, value.itemId]);
        }
        return keys;
    }

    isolated resource function put orderitems/[string orderId]/[string itemId](OrderItemUpdate value) returns OrderItem|persist:Error {
        lock {
            if !orderitemsTable.hasKey([orderId, itemId]) {
                return persist:getNotFoundError("OrderItem", {orderId: orderId, itemId: itemId});
            }
            OrderItem orderitem = orderitemsTable.get([orderId, itemId]);
            foreach var [k, v] in value.clone().entries() {
                orderitem[k] = v;
            }
            orderitemsTable.put(orderitem);
            return orderitem.clone();
        }
    }

    isolated resource function delete orderitems/[string orderId]/[string itemId]() returns OrderItem|persist:Error {
        lock {
            if !orderitemsTable.hasKey([orderId, itemId]) {
                return persist:getNotFoundError("OrderItem", {orderId: orderId, itemId: itemId});
            }
            return orderitemsTable.remove([orderId, itemId]).clone();
        }
    }

    public isolated function close() returns persist:Error? {
        return ();
    }
}

isolated function queryEmployees(string[] fields) returns stream<record {}, persist:Error?> {
    table<Employee> key(empNo) employeesClonedTable;
    lock {
        employeesClonedTable = employeesTable.clone();
    }
    table<Department> key(deptNo) departmentsClonedTable;
    lock {
        departmentsClonedTable = departmentsTable.clone();
    }
    table<Workspace> key(workspaceId) workspacesClonedTable;
    lock {
        workspacesClonedTable = workspacesTable.clone();
    }
    return from record {} 'object in employeesClonedTable
        outer join var department in departmentsClonedTable on ['object.departmentDeptNo] equals [department?.deptNo]
        outer join var workspace in workspacesClonedTable on ['object.workspaceWorkspaceId] equals [workspace?.workspaceId]
        select persist:filterRecord({
            ...'object,
            "department": department,
            "workspace": workspace
        }, fields);
}

isolated function queryOneEmployees(anydata key) returns record {}|persist:NotFoundError {
    table<Employee> key(empNo) employeesClonedTable;
    lock {
        employeesClonedTable = employeesTable.clone();
    }
    table<Department> key(deptNo) departmentsClonedTable;
    lock {
        departmentsClonedTable = departmentsTable.clone();
    }
    table<Workspace> key(workspaceId) workspacesClonedTable;
    lock {
        workspacesClonedTable = workspacesTable.clone();
    }
    from record {} 'object in employeesClonedTable
    where persist:getKey('object, ["empNo"]) == key
    outer join var department in departmentsClonedTable on ['object.departmentDeptNo] equals [department?.deptNo]
    outer join var workspace in workspacesClonedTable on ['object.workspaceWorkspaceId] equals [workspace?.workspaceId]
    do {
        return {
            ...'object,
            "department": department,
            "workspace": workspace
        };
    };
    return persist:getNotFoundError("Employee", key);
}

isolated function queryWorkspaces(string[] fields) returns stream<record {}, persist:Error?> {
    table<Workspace> key(workspaceId) workspacesClonedTable;
    lock {
        workspacesClonedTable = workspacesTable.clone();
    }
    table<Building> key(buildingCode) buildingsClonedTable;
    lock {
        buildingsClonedTable = buildingsTable.clone();
    }
    return from record {} 'object in workspacesClonedTable
        outer join var location in buildingsClonedTable on ['object.locationBuildingCode] equals [location?.buildingCode]
        select persist:filterRecord({
            ...'object,
            "location": location
        }, fields);
}

isolated function queryOneWorkspaces(anydata key) returns record {}|persist:NotFoundError {
    table<Workspace> key(workspaceId) workspacesClonedTable;
    lock {
        workspacesClonedTable = workspacesTable.clone();
    }
    table<Building> key(buildingCode) buildingsClonedTable;
    lock {
        buildingsClonedTable = buildingsTable.clone();
    }
    from record {} 'object in workspacesClonedTable
    where persist:getKey('object, ["workspaceId"]) == key
    outer join var location in buildingsClonedTable on ['object.locationBuildingCode] equals [location?.buildingCode]
    do {
        return {
            ...'object,
            "location": location
        };
    };
    return persist:getNotFoundError("Workspace", key);
}

isolated function queryBuildings(string[] fields) returns stream<record {}, persist:Error?> {
    table<Building> key(buildingCode) buildingsClonedTable;
    lock {
        buildingsClonedTable = buildingsTable.clone();
    }
    return from record {} 'object in buildingsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneBuildings(anydata key) returns record {}|persist:NotFoundError {
    table<Building> key(buildingCode) buildingsClonedTable;
    lock {
        buildingsClonedTable = buildingsTable.clone();
    }
    from record {} 'object in buildingsClonedTable
    where persist:getKey('object, ["buildingCode"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("Building", key);
}

isolated function queryDepartments(string[] fields) returns stream<record {}, persist:Error?> {
    table<Department> key(deptNo) departmentsClonedTable;
    lock {
        departmentsClonedTable = departmentsTable.clone();
    }
    return from record {} 'object in departmentsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneDepartments(anydata key) returns record {}|persist:NotFoundError {
    table<Department> key(deptNo) departmentsClonedTable;
    lock {
        departmentsClonedTable = departmentsTable.clone();
    }
    from record {} 'object in departmentsClonedTable
    where persist:getKey('object, ["deptNo"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("Department", key);
}

isolated function queryOrderitems(string[] fields) returns stream<record {}, persist:Error?> {
    table<OrderItem> key(orderId, itemId) orderitemsClonedTable;
    lock {
        orderitemsClonedTable = orderitemsTable.clone();
    }
    return from record {} 'object in orderitemsClonedTable
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryOneOrderitems(anydata key) returns record {}|persist:NotFoundError {
    table<OrderItem> key(orderId, itemId) orderitemsClonedTable;
    lock {
        orderitemsClonedTable = orderitemsTable.clone();
    }
    from record {} 'object in orderitemsClonedTable
    where persist:getKey('object, ["orderId", "itemId"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("OrderItem", key);
}

isolated function queryWorkspaceEmployees(record {} value, string[] fields) returns record {}[] {
    table<Employee> key(empNo) employeesClonedTable;
    lock {
        employeesClonedTable = employeesTable.clone();
    }
    return from record {} 'object in employeesClonedTable
        where 'object.workspaceWorkspaceId == value["workspaceId"]
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryBuildingWorkspaces(record {} value, string[] fields) returns record {}[] {
    table<Workspace> key(workspaceId) workspacesClonedTable;
    lock {
        workspacesClonedTable = workspacesTable.clone();
    }
    return from record {} 'object in workspacesClonedTable
        where 'object.locationBuildingCode == value["buildingCode"]
        select persist:filterRecord({
            ...'object
        }, fields);
}

isolated function queryDepartmentEmployees(record {} value, string[] fields) returns record {}[] {
    table<Employee> key(empNo) employeesClonedTable;
    lock {
        employeesClonedTable = employeesTable.clone();
    }
    return from record {} 'object in employeesClonedTable
        where 'object.departmentDeptNo == value["deptNo"]
        select persist:filterRecord({
            ...'object
        }, fields);
}

