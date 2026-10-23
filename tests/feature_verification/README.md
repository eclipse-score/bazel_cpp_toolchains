<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Feature Verification Tests

This directory contains tests for verifying that specific C++ toolchain features are correctly implemented and functioning.

**For complete documentation, see [../../docs/test_suite.md](../../docs/test_suite.md)**

## Quick Reference

```bash
# Run all feature tests
bazel test --config x86_64-linux //:feature_verification_tests

# Run individual test
bazel test --config x86_64-linux //feature_verification:defines_test

# Build for cross-compilation (no execution)
bazel build --config aarch64-qnx //feature_verification:defines_test
```

## See Also

- Complete documentation: [../../docs/test_suite.md](../../docs/test_suite.md)
- Toolchain overview: [../../docs/overview.md](../../docs/overview.md)
- Features documentation: [../../docs/features.md](../../docs/features.md)
