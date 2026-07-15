<!--
# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************
-->

# Tests And Validation

## Test Workspace Purpose

The `tests/` directory is a separate Bazel workspace used as the integration
test bed for the repository.

It demonstrates how consumers declare toolchains while also serving as the main
validation surface for confirming that the generated toolchains can build and,
where appropriate, run test targets.

These tests are intended for validating global changes on the module extension
side and for verifying toolchain features and language-standard support. They
are not a reference point for full platform setup. For a proper build on a
dedicated platform, consumers must consult the relevant platform developers and
owners rather than relying on these tests as a platform configuration guide.

For the full catalog of individual tests, see
[test_suite.md](test_suite.md).

## Important Files

`tests/MODULE.bazel`

Declares representative Linux and QNX toolchain repositories and wires the test
workspace back to the local checkout with `local_path_override`.

`tests/.bazelrc`

Defines named Bazel configurations (activated with `--config`) that select the
generated toolchains and platforms.

`tests/BUILD`

Defines the `feature_verification_tests` and `language_and_standards_tests`
test suites that aggregate the individual test targets.

`tests/feature_verification/`

C++ targets that verify toolchain features such as preprocessor defines,
include paths (including the `includes` attribute), user-supplied compile and
link flags, warnings, coverage, position-independent code, pthread support,
multi-file archiving, whole-archive linking, reproducible-build random seed, and
fully static linking. The `opt_in_features/` subpackage holds manual tests for
features that are disabled by default or require a specific build mode.

`tests/language_and_standards/`

C and C++ targets that verify language support across C, C++11, C++14, C++17,
and C++20.

## Validation Matrix

The test workspace validates these configuration groups (see `tests/.bazelrc`
for the exact `--config` names):

- Linux host toolchains (`x86_64-linux`, `x86_64-linux-custom`, `x86_64-linux-bp`)
- Linux cross-compilation toolchains (`aarch64-linux`)
- runtime-specific Linux toolchains such as AutoSD (`x86_64-linux-autosd10`)
  and EB corbos Linux for Safety Applications (`aarch64-linux-ebclfsa`)
- packaged QNX toolchains (`x86_64-qnx`, `aarch64-qnx`)

## Useful Commands

The `tests/` directory is a separate Bazel workspace, so run the commands from
within it:

```bash
cd tests

# Run every test with the host toolchain
bazel test --config x86_64-linux //...

# Run a single test suite
bazel test --config x86_64-linux //:feature_verification_tests
bazel test --config x86_64-linux //:language_and_standards_tests

# Build against a cross-compilation or runtime-specific target
bazel build --config aarch64-qnx //...
```

## What The Tests Prove

The test workspace is not intended to be an exhaustive compiler correctness
suite. Instead, it answers a narrower question: did the configuration
repository produce a usable toolchain definition for each supported scenario?

In practice this means checking among other things:

- successful compilation with the selected compiler and sysroot,
- correct toolchain registration and platform matching,
- basic linking behavior,
- feature coverage such as pthread-enabled builds, include-path handling, and
  whole-archive linking,
- language and C++ standard-version support.