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

# QNX Toolchain Required Feature Set

## Purpose

This document lists the feature set required for the QNX (QCC/SDP) C/C++
toolchains generated from
[templates/qnx/cc_toolchain_config.bzl.template](../templates/qnx/cc_toolchain_config.bzl.template),
and classifies how each feature is currently provided. It is intended to drive
implementation, validation, and documentation follow-up when moving the QNX
toolchain to a fully explicit, `no_legacy_features`-based configuration.

## How Features Are Resolved

On `main`, the QNX template **does not** enable the `no_legacy_features`
feature, so Bazel still injects its legacy feature set around the features we
declare. The QNX template already declares several plumbing features explicitly
(more than Linux), but a number of required behaviors still come from legacy
injection. Every feature below is in one of three states:

| Classification | Meaning |
|---|---|
| **Explicit** | Defined in this template and present in the `features` list (or wired through an `action_config` / `tool_path`). |
| **Injected** | Not defined by us. Supplied automatically by Bazel's legacy feature injection because `no_legacy_features` is not enabled. |
| **Implicit** | Behavior provided without a dedicated feature — via `action_config` tool bindings, `cxx_builtin_include_directories`, `tool_paths`, an `implies` reference, or flags baked into another explicit feature. |

> Consequence: if `no_legacy_features` is enabled for QNX, every **Injected**
> feature marked *Required* below must be added explicitly, or the toolchain
> will stop compiling/linking.

## Required Feature Set

### Compilation

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `default_compile_flags` | Base compile flags (hardening, `-D_QNX_SOURCE`, arch, build-mode variants) | Yes | Explicit | In `features` list. |
| `unfiltered_compile_flags` | Redact `__DATE__`/`__TIME__`/`__TIMESTAMP__` for reproducibility | Yes | Explicit | In `features` list. |
| `sdp_env` | Inject `QNX_SDP_*` environment for compile/link | Yes | Explicit | QNX-specific; required for QCC to run. |
| `dependency_file` | Generate `.d` header deps (`-MD`) explicitly | Yes | Explicit | In `features` list. |
| `dependency_file_named_implicitly` | Alternate implicit dep-file naming mode | Yes | Explicit | In `features` list; toggles behavior of `dependency_file`. |
| `include_paths` | Emit `-I`, `-iquote`, `-isystem` | Yes | **Injected** | Legacy default. |
| `preprocessor_defines` | Emit `-D` defines | Yes | **Injected** | Legacy default. |
| `user_compile_flags` | Pass through per-target `copts` | Yes | **Injected** | Legacy default. Distinct from our `extra_compile_flags`. |
| `compiler_input_flags` | `-c` and source input | Yes | **Injected** | Legacy default. |
| `compiler_output_flags` | `-o` / `-S` / `-E` output | Yes | **Injected** | Legacy default. |
| `pic` | Emit `-fPIC` from the `pic` build variable | Yes | **Injected** | No explicit `pic` feature; validate whether `-fPIC` is baked into `default_compile_flags`. |
| `random_seed` | Deterministic `-frandom-seed` per output | Optional | Not provided | Not in the current `features` list. |

### Linking

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `default_link_flags` | Hardening, `--as-needed`, libc++/libm | Yes | Explicit | In `features` list. |
| `runtime_library_search_directories` | Emit `-Wl,-rpath,$EXEC_ORIGIN/...` | Yes | Explicit | Custom rpath handling in `features` list. |
| `user_link_flags` | Pass through per-target `linkopts` | Yes | **Injected** | Legacy default. Distinct from our `extra_link_flags`. |
| `output_execpath_flags` | `-o` for link output | Yes | **Injected** | Legacy default. |
| `library_search_directories` | Emit `-L` search paths | Yes | **Injected** | Legacy default. |
| `libraries_to_link` | Emit `-l` / object linking, whole-archive, static/dynamic | Yes | **Injected** | Legacy default. |
| `shared_flag` | `-shared` for dynamic libraries | Yes | **Injected** | Legacy default. |
| `linker_param_file` | `@param_file` for long link commands | Yes | **Injected** | Legacy default. |
| `force_pic_flags` | `-pie` for position-independent executables | Optional | **Injected** | Legacy default. |

### Archiving

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `archiver_flags` | `ar` flags and library-list handling | Yes | **Injected** + Implicit | Feature injected; `cpp_link_static_library` `action_config` binds the `ar` tool and `implies = ["archiver_flags"]`. |

### Sysroot / system includes

| Behavior | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `cxx_builtin_include_directories` | System include roots for QNX SDP | Yes | Implicit | Passed to `create_cc_toolchain_config_info`; QNX uses SDP paths rather than `builtin_sysroot`. |
| `sysroot` | `--sysroot` handling | N/A | **Injected** | QNX uses SDP environment (`sdp_env`) + builtin include dirs; validate whether the legacy `sysroot` feature has any effect. |

### Coverage

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `coverage` | Enable coverage instrumentation build mode | Yes | Explicit | In `features` list. |
| `gcc_coverage_map_format` | `-fprofile-arcs -ftest-coverage` / `--coverage` (gcov) | Yes | Explicit | In `features` list; `requires` `coverage`. |
| `llvm_coverage_map_format` | LLVM coverage map | No | **Injected** | Not used — gcov-based. |

### Capabilities

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `supports_pic` | Declares PIC capability | Yes | Explicit | In `features` list. |
| `supports_dynamic_linker` | Declares dynamic-linker capability | Yes | Explicit | In `features` list. |

### Custom / QNX-specific features

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `dbg` / `opt` | Build-mode selectors | Yes | Explicit | |
| `qnx_license_env_info` | Inject QNX license environment info | Yes | Explicit | `qnx_license_env_info` feature. |
| `extra_compile_flags` / `extra_link_flags` | Injection point for user-supplied flags | Yes | Explicit | |
| `minimal_warnings` / `strict_warnings` / `all_wall_warnings` / `warnings_as_errors` | Warning-level control | Optional | Explicit | |

### Tooling (non-feature wiring)

| Behavior | Classification | Notes |
|---|---|---|
| `assemble` / `c_compile` / `cpp_compile` / link / `ar` / `strip` tool bindings | Implicit | Provided by `action_config` entries (QCC / `ar` / `strip`). |
| `gcov` path | Implicit | Provided by `tool_paths` (`gcov_wrapper`). |

## Behaviors Depending On Bazel Legacy Defaults

The following required behaviors are currently supplied **only** by Bazel's
legacy feature injection and are **not** defined in the QNX template. These are
the concrete gaps to close before enabling `no_legacy_features`:

- `include_paths`
- `preprocessor_defines`
- `user_compile_flags`
- `compiler_input_flags`
- `compiler_output_flags`
- `pic` (validate against `default_compile_flags`)
- `user_link_flags`
- `output_execpath_flags`
- `library_search_directories`
- `libraries_to_link`
- `shared_flag`
- `linker_param_file`
- `archiver_flags` (feature body; tool binding is already explicit via `action_config`)

Already handled explicitly by QNX (no gap): `default_compile_flags`,
`unfiltered_compile_flags`, `dependency_file`, `dependency_file_named_implicitly`,
`runtime_library_search_directories`, `coverage`, `gcc_coverage_map_format`,
`default_link_flags`, `sdp_env`, `qnx_license_env_info`.

Optional legacy behaviors currently injected (add only if the capability is
needed): `force_pic_flags`, `fully_static_link`, `static_libgcc`,
`per_object_debug_info`, `fission_support`, `strip_debug_symbols`, `includes`,
`build_interface_libraries`, `dynamic_library_linker_tool`, `linkstamps`, and
all FDO/AutoFDO features.

Not applicable to this toolchain: `llvm_coverage_map_format`,
`legacy_compile_flags`, `legacy_link_flags`.

## Follow-Up Tasks

**Implementation**
- Define the required Injected features explicitly in the QNX template
  (`include_paths`, `preprocessor_defines`, `user_compile_flags`,
  `compiler_input_flags`, `compiler_output_flags`, `user_link_flags`,
  `output_execpath_flags`, `library_search_directories`, `libraries_to_link`,
  `shared_flag`, `linker_param_file`, `archiver_flags`, `pic`).
- Add the `no_legacy_features` feature (enabled) once the required set is
  complete.
- Confirm `-fPIC` handling: either add an explicit `pic` feature or keep it in
  `default_compile_flags`, consistently with Linux.

**Validation**
- Build the `tests/` suites with the `x86_64-qnx` and `aarch64-qnx` configs and
  diff command lines (`--subcommands`) before and after enabling
  `no_legacy_features` to confirm parity.
- Because QNX targets are cross-compiled, execute the tests on the matching QNX
  target platform (see [docs/test_suite.md](test_suite.md)); on the host,
  restrict validation to `bazel build`.
- Verify static/shared library creation, whole-archive linking, coverage,
  dependency files, licensing (`qnx_license_env_info`), and SDP environment
  wiring (`sdp_env`).

**Documentation**
- Update [docs/features.md](features.md) and
  [docs/qnx_integration.md](qnx_integration.md) to reflect the explicit feature
  set.
- Cross-link this document from [docs/overview.md](overview.md) and the README.
