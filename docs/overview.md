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

# Overview

## Purpose

The repository separates toolchain *configuration logic* from toolchain
*binary distributions*.

It exists to answer three practical needs:

- provide a single Bazel-native way to declare Linux and QNX C/C++ toolchains,
- keep package provenance, compiler flags, and platform constraints consistent,
- validate those toolchains through an example workspace instead of relying on
  ad hoc local setup.

## What The Repository Contains

The repository does not contain GCC, QCC, or QNX SDK binaries. Instead, it
contains the layers Bazel needs in order to fetch those binaries and expose
them as `cc_toolchain` targets:

- module extension logic in `extensions/`
- repository rules in `rules/`
- package metadata in `packages/`
- generated-file templates in `templates/`
- authentication helpers in `tools/`
- an example validation workspace in `examples/`

## Supported Platform Families

The current repository surface supports these platform families:

- Linux `x86_64` with packaged GCC toolchains
- Linux `aarch64` with packaged GCC toolchains
- Linux runtime-specific variants such as AutoSD and EB corbos Linux for Safety Applications
- QNX `x86_64` with packaged or locally built SDP-based toolchains
- QNX `aarch64` with packaged or locally built SDP-based toolchains

## Core Design Model

The configuration pipeline is intentionally layered:

1. A consuming project declares toolchains in `MODULE.bazel`.
2. The `gcc` module extension interprets those declarations.
3. Package metadata is resolved from either the default version matrix or a
   manually declared package.
4. Repository rules generate a Bazel repository containing the toolchain
   definition and platform-specific configuration files.
5. The consuming project activates those toolchains via `--extra_toolchains`
   and compatible platform constraints.

This keeps the consuming workspace small while centralizing platform policy,
default flags, sysroot wiring, and repository authentication behavior.