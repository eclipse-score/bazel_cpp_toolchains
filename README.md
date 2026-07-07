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

# S-CORE Bazel C/C++ Toolchain Configuration Repository

This repository contains the configuration layer for S-CORE C and C++
toolchains used in Bazel builds. It does not ship compiler binaries. Instead,
it defines the metadata, templates, repository rules, module extension logic,
and validation workspace needed to fetch and register external toolchain
packages reproducibly.

The documentation below is organized around the main subsystems of the
repository: how consumers declare toolchains, how Bazel repositories are
generated, how platform packages are described, how the test workspace
validates the setup, and how QNX-specific authentication and licensing fit in.

## Documentation

- [Overview](docs/overview.md)
- [Repository layout](docs/repository_layout.md)
- [Extension API](docs/extension_api.md)
- [Generation flow](docs/generation_flow.md)
- [Examples and validation](docs/examples_and_validation.md)
- [QNX integration](docs/qnx_integration.md)
- [Test Suite](docs/test_suite.md) - Comprehensive test documentation
- [Maintenance](docs/maintenance.md)

## Quick Summary

**Module:** S-CORE Bazel C/C++ toolchain configurations

**Type:** Bazel module with repository rules, templates, and example validation

**Primary consumer entry point:** `@score_bazel_cpp_toolchains//extensions:gcc.bzl`

**Main validation surface:** `tests/` smoke-test workspace

## Key Capabilities

- Define Linux and QNX toolchains through a Bzlmod extension.
- Resolve default package metadata through `packages/version_matrix.bzl`.
- Generate toolchain repositories from platform-specific templates.
- Validate toolchain selections through the workspace test matrix.
