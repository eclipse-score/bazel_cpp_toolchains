<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Feature verification tests

This directory contains tests that verify that specific C++ toolchain
features are correctly implemented. Use this page to run the tests. For
individual tests, see the
[test suite reference](../../docs/contributors/test_suite.md).

Run the commands in this page from the `tests/` workspace root, not from this
directory.

## Run the tests

To run all feature tests, one test, or a cross-compilation build, use the
following commands:

```bash
# Run all feature tests
bazel test --config x86_64-linux //:feature_verification_tests

# Run individual test
bazel test --config x86_64-linux //feature_verification:defines_test

# Build for cross-compilation (no execution)
bazel build --config aarch64-qnx //feature_verification:defines_test
```

## See also

- [Test suite reference](../../docs/contributors/test_suite.md)
- [Toolchain overview](../../docs/consumers/overview.md)
- [Toolchain features](../../docs/consumers/features.md)
