## Overview

The Persist In-Memory connector provides in-memory table support for the `bal persist` feature, enabling data storage and querying from in-memory tables conveniently through a data model. This data store is useful for testing purposes.

### Key Features

- Store and query data from in-memory tables through a data model
- Support for all Ballerina data types
- Default data store for `bal persist` with zero configuration
- Integration with `bal build` for seamless code generation

## How to use with `bal persist`

### Integrate to `bal build`

By default, `bal persist` utilizes the in-memory data store. Therefore, you do not need to explicitly specify the data store when you integrate to `bal build`.

1. Initialize `bal persist` and integrate to `bal build` using the following command,

    ```
    $ bal persist add --module <module_name>
    ```

2. After defining the entities, build the application using the following command,

    ```
    $ bal build
    ```

### One time generation

When using one-time generation, you need to specify the data store.

1. Initialize `bal persist` using the following command,

    ```
    $ bal persist init
    ```

2. Generate the persist client using the following command,

    ```
    $ bal persist generate --datastore inmemory --module <module_name>
   ```

## Supported Ballerina Types
In-memory uses Ballerina tables as the data store. Therefore, all types supported by Ballerina are supported with `bal persist` when in-memory is used as the data source.

## Configuration
The In-Memory data store does not require any configuration.

## Report issues

To report bugs, request new features, start new discussions, view project boards, etc., go to the [Ballerina standard library parent repository](https://github.com/ballerina-platform/ballerina-standard-library).

## Useful links
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
