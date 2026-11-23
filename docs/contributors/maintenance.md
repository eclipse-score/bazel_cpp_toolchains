<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Maintenance

This reference helps contributors maintain feature and package wiring. For
the end-to-end workflow, see [Add a toolchain variant](add_toolchain.md).

## When to use the version matrix

Use the version matrix when a package should be part of the supported default
surface for consumers. This gives downstream users a shorter configuration and
centralizes special sysroot flags in one place.

Use explicit `gcc.sdp(...)` declarations when package metadata is local,
experimental, or intentionally not part of the default support matrix.

## Toolchain feature wiring

The Linux, QNX, and EBcLfSA high-integrity toolchain configs enable
**`no_legacy_features`**, so Bazel injects nothing implicitly. Every
compile, link, and archive flag must come from a feature (or wiring) declared
in the template. For the full feature list, see
[Toolchain features](../consumers/features.md). Not everything is a
feature, though; some behavior is provided by other toolchain wiring:

- **Compiler / archiver / strip tools** are bound through `action_config`
  entries (`assemble`, `c_compile`, `cpp_compile`, the link actions, and
  `cpp_link_static_library`), not `tool_paths`. The static-library action
  `implies = ["archiver_flags"]`, so the `archiver_flags` feature only supplies
  the flags while the `action_config` supplies the `ar` binary.
- **`gcov`** is provided via `tool_paths` (`gcov_wrapper`).
- **Sysroot (Linux)** — the sysroot path is passed as `builtin_sysroot` to
  `create_cc_toolchain_config_info`; compile-time header resolution relies on
  `cxx_builtin_include_directories`, so no `--sysroot` is needed for c/cxx
  compiles. Link-time `--sysroot` / `-Wl,--sysroot` and assembly-time
  `--sysroot` (assemble / preprocess-assemble; needed for `.S` sources since
  the extra_*_compile_flags include paths do not apply there) are emitted by
  the custom `sysroot_link_flags` feature. There is intentionally no legacy
  `sysroot` compile feature.
- **Sysroot / system includes (QNX)** — The package's `sysroot_dir` is passed
  as `builtin_sysroot`. System include roots come from
  `cxx_builtin_include_directories` (SDP paths), and the SDP environment is
  injected by the `sdp_env` feature.

When adding or auditing a feature, classify how each required behavior is
provided: an **explicit feature** in the `features` list, **tool/sysroot wiring**
as above, or **flags baked into another feature**. For example, `-fPIC` is
provided by the explicit `pic` feature on Linux and QNX. Under
`no_legacy_features` nothing is supplied automatically, so a missing behavior
means a broken build rather than a silent fallback.

> **Static archives:** `fully_static_link` (`-static`) requires static system
> libraries (`libc.a`, `libstdc++.a`, ...). Toolchains that ship only shared
> libraries (for example, AutoSD) cannot link fully static binaries, so that
> feature is opt-in and its test is marked incompatible with such platforms.

## Feature catalog (`features/`)

`features/` holds the toolchain's `cc_feature` / `cc_args` definitions, built
with `@rules_cc//cc/toolchains`. The
`templates/cc_toolchain_config.bzl.template` file only implements the
`cc_toolchain_config` rule and turns `known_features` / `enabled_features`
labels into the toolchain's feature list. It defines no features of its own.

- `features/native/`: one reusable `cc_feature`/`cc_args` target per toolchain
  feature (`default_compile_flags`, `include_paths`, `pic`,
  `sysroot_link_flags`, ...), including the capability markers (`dbg`, `opt`,
  `supports_pic`, ...). These mirror Bazel's legacy C++ features one-for-one.
- `features/custom/linux/`, `features/custom/qnx/`, and
  `features/custom/ebclfsa_hi/`: OS-specific features
  not covered by the native set (QNX `sdp_env`, `gcc_version_flags`), plus
  `make_cc_features.bzl`, which defines the ordered `_LINUX_FEATURES` /
  `_QNX_FEATURES` / `_EBCLFSA_HI_FEATURES` lists of
  `(label, initially_enabled)` pairs. Feature order determines command-line
  flag order, so change the order only on purpose. `get_feature_lists()`
  returns `(known_features, enabled_features)`, and `templates/BUILD.template`
  passes those straight into `cc_toolchain_config`'s `known_features` /
  `enabled_features` attributes — this is what the generated toolchain
  actually uses.
  The repository rule selects `ebclfsa_hi` for Linux toolchains with
  `runtime_ecosystem = "ebclfsa-hi"`; otherwise it selects the target OS.
  This keeps the restricted HI compile flags and feature list separate from
  generic Linux without changing platform OS constraints.
- Per-instance features whose content is dynamic per toolchain instance —
  `extra_compile_flags`, `extra_c_compile_flags`, `extra_cxx_compile_flags`,
  `extra_link_flags`, `compiler_library_search_paths`, `sysroot_link_flags` —
  are *not* static `features/native/*` targets. Instead
  `templates/BUILD.template` creates them at generation time (via
  `make_extra_compile_features()`, `make_extra_link_features()`,
  `make_compiler_library_search_paths()`, and `make_sysroot_link_flags()`, all
  defined under `features/native/<name>/features.bzl`) using fixed local
  target names (`:extra_compile_flags`, etc.), and `_LINUX_FEATURES` /
  `_QNX_FEATURES` reference those fixed names at the correct position in the
  ordered list. This keeps both feature order (repo-controlled) and
  per-instance dynamic content (caller-controlled via `gcc.toolchain(...)`
  attributes).
- `all_wall_warnings`, `minimal_warnings`, `strict_warnings`, and
  `warnings_as_errors` are not defined anywhere in this repository. The
  `score_cpp_policies` module defines them, and you inject them through
  `extra_known_features` / `extra_enabled_features` (the same mechanism as the
  sanitizers).

## Common problems

Watch for these problems when you change toolchain wiring:

- Runtime-specific toolchains might need extra include and link flags that
  don't exist for standard GCC archives.
- QNX `aarch64` naming differs from some underlying SDK paths.
- QNX licensing and authentication requirements live outside Bazel target
  analysis and must be configured in the execution environment.
- Documentation examples must stay aligned with the configuration names in
  `tests/.bazelrc`.

## Validate changes

For repository changes that affect toolchain resolution, package metadata, or
template generation, select checks using
[Test and validate toolchains](tests_and_validation.md).

For documentation-only changes, review the rendered Markdown and check links.
See [Maintain documentation](documentation.md).
