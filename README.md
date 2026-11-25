<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# S-CORE Bazel C/C++ toolchains

This repository provides Bazel configuration for external Linux and QNX C/C++
toolchain packages. It does not contain compiler binaries.

## Use a toolchain

If you maintain a Bazel module that uses these toolchains, start with
[Build with a Linux toolchain](docs/consumers/getting_started.md). For QNX,
see [Integrate a QNX toolchain](docs/consumers/qnx_integration.md).

## Develop toolchain support

If you maintain this repository or add a toolchain variant, start with
[Add a toolchain variant](docs/contributors/add_toolchain.md). See
[Tests and validation](docs/contributors/tests_and_validation.md) for the
test workspace and execution requirements.

For the complete documentation map, see [Documentation](docs/README.md).
