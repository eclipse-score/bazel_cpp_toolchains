<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Language and standards tests

This directory contains tests that verify that the toolchain supports C and
the C++ standard versions it declares. Use this page to run the tests. For
individual tests, see the
[test suite reference](../../docs/contributors/test_suite.md).

Run the commands in this page from the `tests/` workspace root, not from this
directory.

## Run the tests

To run all language tests, one test, or one test with verbose output, use the
following commands:

```bash
# Run all language tests
bazel test --config=x86_64-linux //:language_and_standards_tests

# Run individual test
bazel test --config=x86_64-linux //language_and_standards:cpp20_test

# Run with verbose output
bazel test --config=x86_64-linux --test_output=all //language_and_standards:cpp20_test
```

## See also

- [Test suite reference](../../docs/contributors/test_suite.md)
- [Toolchain overview](../../docs/consumers/overview.md)
