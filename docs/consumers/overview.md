<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Overview

This page helps Bazel module maintainers and contributors understand how this
repository configures C/C++ toolchains, so that you can choose where to start.
It doesn't contain commands. To configure a toolchain, see
[Build with a Linux toolchain](getting_started.md) or
[Integrate a QNX toolchain](qnx_integration.md).

## Purpose

The repository separates toolchain *configuration logic* from toolchain
*binary distributions*.

It exists to meet three needs:

- Provide a single Bazel-native way to declare Linux and QNX C/C++ toolchains.
- Keep package provenance, compiler flags, and platform constraints consistent.
- Validate those toolchains through a dedicated test workspace instead of
  relying on ad hoc local setup.

## Repository contents

The repository doesn't contain GCC, QCC, or QNX SDK binaries. Instead, it
contains the layers that Bazel needs to fetch those binaries and expose them as
`cc_toolchain` targets:

- Module extension logic in `extensions/`.
- Repository rules in `rules/`.
- Package metadata in `packages/`.
- Feature definitions in `features/`.
- Generated-file templates in `templates/`.
- Authentication helpers in `tools/`.
- A dedicated test workspace in `tests/`.

## Supported platform families

The repository supports these platform families:

- Linux AMD64 (`x86_64-linux`) with packaged GCC toolchains.
- Linux ARM64 (`aarch64-linux`) with packaged GCC toolchains.
- Linux runtime-specific variants (`x86_64-linux`, `aarch64-linux`), such as
  `AutoSD` and `EB corbos Linux for Safety Applications`.
- QNX AMD64 (`x86_64-qnx`) with packaged or locally built SDP-based
  toolchains.
- QNX ARM64 (`aarch64-qnx`) with packaged or locally built SDP-based
  toolchains.

## Configuration model

The configuration pipeline has these layers:

1. A consuming project declares toolchains in `MODULE.bazel`.
2. The `gcc` module extension interprets those declarations.
3. Package metadata is resolved from either the default version matrix or a
   manually declared package.
4. Repository rules generate a Bazel repository containing the toolchain
   definition and platform-specific configuration files.
5. The consuming project activates those toolchains through `--extra_toolchains`
   and compatible platform constraints.

This keeps the consuming workspace small while centralizing platform policy,
default flags, sysroot wiring, and repository authentication behavior.