<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Toolchain Tests

This directory contains comprehensive test suites for validating SCORE Bazel C++ toolchain functionality across different platforms and configurations.

**For complete test documentation, see [docs/test_suite.md](../docs/test_suite.md)**

## Quick Reference

### Run Tests

```bash
# All tests
bazel test --config x86_64-linux //...

# Feature verification tests
bazel test --config x86_64-linux //:feature_verification_tests

# Language and standards tests  
bazel test --config x86_64-linux //:language_and_standards_tests
```

> NOTE: `bazel test` executes the compiled binaries, so it is only valid when
> the execution machine matches the target platform. The `x86_64-linux` config
> runs on an x86_64 Linux host. For other configs (e.g. `x86_64-qnx`,
> `aarch64-qnx`, `aarch64-linux`), build on the host with `bazel build` and run
> the tests on the matching target platform. See
> [docs/test_suite.md](../docs/test_suite.md) for details.

### Test Directories

- **`feature_verification/`** - Toolchain feature validation tests
- **`language_and_standards/`** - C and C++ standard version tests
- **`ebclfsa_hi/`** - Restricted Clang/musl/libc++ SDK verification

### EBcLfSA High Integrity (SDK 2.0.0-beta3)

Run these commands from this directory:

The test module applies the supplied platform patch and selects
`runtime_ecosystem = "ebclfsa-hi"`; the existing `ebclfsa` configuration remains QM.

```bash
# Host-side configuration, static AArch64 ELF and rejected-language-feature checks
bazel test --config=aarch64-linux-ebclfsa-hi --test_lang_filters=-cc \
    //:ebclfsa_hi_tests //:guardrail_tests

# Execute the cross-compiled C/C++ runtime test (requires qemu-user on the host)
bazel test --config=aarch64-linux-ebclfsa-hi \
    --run_under=/usr/bin/qemu-aarch64 //ebclfsa_hi:runtime_test
```

The runtime test checks Clang/AArch64, musl rather than glibc, libc++ rather than
libstdc++, disabled RTTI/exceptions, C11/C++17, C archiving and mixed C/C++ linking.
It exercises formatted C I/O and libc++ containers, algorithms and strings.
The host-side tests also verify that exception and `dynamic_cast` expressions
are rejected, and that the ELF has no interpreter or dynamic dependencies.
These tests are incompatible with QM platforms and are skipped there.

Use the dedicated suite, not the unrestricted feature suite: the HI runtime
deliberately lacks features required by some general-purpose/GoogleTest tests.

## Documentation

**Complete test documentation is located in [docs/test_suite.md](../docs/test_suite.md)**

See that document for:
- Detailed test descriptions
- Feature coverage matrix
- Cross-compilation guidance
- Troubleshooting guide
- Adding new tests
