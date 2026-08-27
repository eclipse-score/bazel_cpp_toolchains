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

# Maintenance

## Adding A New Toolchain Variant

Adding support for a new toolchain variant usually touches several layers:

1. add or extend package metadata in `packages/version_matrix.bzl`,
2. add a package BUILD descriptor under `packages/linux/` or `packages/qnx/`,
3. ensure the required template placeholders already exist, or extend the
   platform template files,
4. update the test workspace under `tests/` if the new variant should be
   validated by the test matrix (add a matching `--config` entry in
   `tests/.bazelrc`),
5. add or update documentation in this Markdown source and the repository README.

## When To Use The Version Matrix

Use the version matrix when a package should be part of the supported default
surface for consumers. This gives downstream users a shorter configuration and
centralizes special sysroot flags in one place.

Use explicit `gcc.sdp(...)` declarations when package metadata is local,
experimental, or intentionally not part of the default support matrix.

## Toolchain Feature Wiring

Both the Linux and QNX toolchain configs enable **`no_legacy_features`**, so
Bazel injects nothing implicitly — every compile/link/archive flag must come
from a feature (or wiring) declared in the template. See
[docs/features.md](features.md) for the full feature list. Not everything is a
feature, though; some behavior is provided by other toolchain wiring:

- **Compiler / archiver / strip tools** are bound through `action_config`
  entries (`assemble`, `c_compile`, `cpp_compile`, the link actions, and
  `cpp_link_static_library`), not `tool_paths`. The static-library action
  `implies = ["archiver_flags"]`, so the `archiver_flags` feature only supplies
  the flags while the `action_config` supplies the `ar` binary.
- **`gcov`** is provided via `tool_paths` (`gcov_wrapper`).
- **Sysroot (Linux)** — the sysroot path is passed as `builtin_sysroot` to
  `create_cc_toolchain_config_info`; compile-time header resolution relies on
  `cxx_builtin_include_directories`, so no `--sysroot` is needed at compile.
  Link-time `--sysroot` / `-Wl,--sysroot` is emitted by the custom
  `sysroot_link_flags` feature. There is intentionally no legacy `sysroot`
  compile feature.
- **Sysroot / system includes (QNX)** — QNX does not use `builtin_sysroot`;
  system include roots come from `cxx_builtin_include_directories` (SDP paths),
  and the SDP environment is injected by the `sdp_env` feature.

When adding or auditing a feature, classify how each required behavior is
provided: an **explicit feature** in the `features` list, **tool/sysroot wiring**
as above, or **flags baked into another feature** (e.g. `-fPIC` is an explicit
`pic` feature on Linux but part of `default_compile_flags` on QNX). Under
`no_legacy_features` nothing is supplied automatically, so a missing behavior
means a broken build rather than a silent fallback.

> **Static archives:** `fully_static_link` (`-static`) requires static system
> libraries (`libc.a`, `libstdc++.a`, ...). Toolchains that ship only shared
> libraries (e.g. AutoSD) cannot link fully static binaries, so that feature is
> opt-in and its test is marked incompatible with such platforms.

## Common Gotchas

- runtime-specific toolchains may need extra include and link flags that do not
  exist for standard GCC archives,
- QNX `aarch64` naming differs from some underlying SDK paths,
- QNX licensing and authentication requirements live outside Bazel target
  analysis and must be configured in the execution environment,
- documentation examples must stay aligned with actual `tests/.bazelrc`
  configuration names.

## Recommended Validation After Changes

For repository changes that affect toolchain resolution, package metadata, or
template generation, validate with the test workspace (a separate Bazel
workspace, so run the commands from `tests/`):

```bash
cd tests
bazel test --config x86_64-linux //...
bazel test --config x86_64-linux //:feature_verification_tests
bazel test --config x86_64-linux //:language_and_standards_tests
```

The available `--config` values (for example `x86_64-linux`, `aarch64-linux`,
`x86_64-qnx`, `aarch64-qnx`, `x86_64-linux-autosd10`, `aarch64-linux-ebclfsa`)
are defined in `tests/.bazelrc`.

For documentation-only changes, build or preview the Markdown site to catch
markup and table-of-contents/navigation issues before publishing.