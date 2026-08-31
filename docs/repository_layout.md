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

# Repository Layout

## Top-Level Structure

The repository is organized by subsystem rather than by platform product:

```text
.
|- docs/        Markdown documentation sources
|- tests/       Test workspace and validation suites
|- extensions/  Bzlmod extension entry points
|- packages/    Toolchain package descriptors and version matrix
|- features/    Declarative cc_feature/cc_args toolchain-feature definitions
|- rules/       Repository rules and shared helpers
|- templates/   Generated file templates for toolchain repositories
`- tools/       Standalone utility scripts
```

## Directory Responsibilities

`extensions/`

Hosts the public module extension used by consumers. The main file,
`extensions/gcc.bzl`, defines the tag classes and resolves user declarations
into repository rule invocations.

`rules/`

Contains the repository rules that materialize a toolchain repository.
`rules/gcc.bzl` renders BUILD and configuration files from templates.

`packages/`

Stores package metadata and BUILD descriptors for supported toolchain
archives. The most important file is `packages/version_matrix.bzl`, which maps
logical toolchain identifiers to URLs, checksums, build files, and any
required extra flags.

`features/`

Holds declarative `cc_feature` / `cc_args` toolchain-feature definitions built
with `@rules_cc//cc/toolchains`. `features/native/` has one reusable target
per toolchain feature (mirroring the legacy Bazel C++ features); the
OS-specific `features/custom/linux/` and `features/custom/qnx/` packages hold
platform-only features (e.g. QNX `sdp_env`, `gcc_version_flags`) plus the
ordered `known_features`/`enabled_features` lists that
`templates/BUILD.template` passes to `cc_toolchain_config`.

`templates/`

Holds the shared template files rendered by repository rules into the
generated toolchain repository: `BUILD.template`,
`cc_toolchain_config.bzl.template`, and `cc_gcov_wrapper.template`. A single
template pair now covers both Linux and QNX; OS-specific behavior comes from
placeholder substitution in `rules/gcc.bzl` and from the OS-specific feature
lists in `features/custom/`, not from separate template directories.

`tests/`

A standalone Bazel workspace used as the integration and validation surface. It
declares representative toolchain configurations and validates them with
feature-verification and language-standard test suites.
> NOTE: These tests validate toolchain generation. They should not be used as
> reference points for platform development.

`tools/`

Contains utility scripts that Bazel executes directly, most notably the QNX
credential helper used for authenticated downloads from `qnx.com`.