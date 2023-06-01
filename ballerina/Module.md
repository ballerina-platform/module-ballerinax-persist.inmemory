# Module Overview

This module provides in-memory table support for the `bal persist` feature, which provides functionality to store and query data from a relational database conveniently through a data model.

The In-Memory data store is a simple data store that stores data in memory. This data store is useful for testing purposes. The In-Memory data store is the default data store for Ballerina Persistence. Therefore, you do not need to explicitly specify the data store when you are using the In-Memory data store.

## Supported Ballerina Types
In-memory uses Ballerina tables as the data store. Therefore, all types supported by Ballerina are supported with `bal persist` when in-memory is used as the data source.

## Configuration
The In-Memory data store does not require any configuration.
