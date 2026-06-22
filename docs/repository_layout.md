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
|- examples/    Example workspace and smoke tests
|- extensions/  Bzlmod extension entry points
|- packages/    Toolchain package descriptors and version matrix
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

`templates/`

Holds the template files used by repository rules. These templates are
rendered into the generated toolchain repository and differ between Linux and
QNX because the execution environment, sysroot layout, and licensing model are
different.
> NOTE: Future plan is to have a single template for toolchain configuration.

`examples/`

A standalone Bazel workspace used as an integration surface. It declares
representative toolchain configurations and validates them with a smoke-test
runner.
> NOTE: These tests are just a sanity check. They should not be used as reference
> points for platform development.

`tools/`

Contains utility scripts that Bazel executes directly, most notably the QNX
credential helper used for authenticated downloads from `qnx.com`.