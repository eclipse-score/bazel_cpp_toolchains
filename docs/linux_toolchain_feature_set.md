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

# Linux Toolchain Required Feature Set

## Purpose

This document lists the feature set required for the Linux (GCC) C/C++
toolchains generated from
[templates/linux/cc_toolchain_config.bzl.template](../templates/linux/cc_toolchain_config.bzl.template),
and classifies how each feature is currently provided. It is intended to drive
implementation, validation, and documentation follow-up when moving the Linux
toolchain to an explicit, `no_legacy_features`-based configuration.

## How Features Are Resolved

The Linux template **does not** enable the `no_legacy_features` feature.
As a result, Bazel automatically injects its full legacy feature set around the
features we declare. Every feature below is therefore in one of three states:

| Classification | Meaning |
|---|---|
| **Explicit** | Defined in this template and present in the `features` list (or wired through an `action_config` / `tool_path`). |
| **Injected** | Not defined by us. Supplied automatically by Bazel's legacy feature injection because `no_legacy_features` is not enabled. |
| **Implicit** | Behavior provided without a dedicated feature — via `action_config` tool bindings, `builtin_sysroot`, `cxx_builtin_include_directories`, `tool_paths`, an `implies` reference, or flags baked into another explicit feature. |

> Consequence: if `no_legacy_features` is enabled for Linux, every **Injected**
> feature marked *Required* below must be added explicitly, or the toolchain
> will stop compiling/linking.

## Required Feature Set

### Compilation

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `default_compile_flags` | Base compile flags (`-fPIC`, hardening, arch, build-mode variants) | Yes | Explicit | In `features` list. |
| `unfiltered_compile_flags` | Redact `__DATE__`/`__TIME__`/`__TIMESTAMP__` for reproducibility | Yes | Explicit | In `features` list. |
| `include_paths` | Emit `-I`, `-iquote`, `-isystem` | Yes | **Injected** | Legacy default. |
| `preprocessor_defines` | Emit `-D` defines | Yes | **Injected** | Legacy default. |
| `user_compile_flags` | Pass through per-target `copts` | Yes | **Injected** | Legacy default. Distinct from our `extra_*_compile_flags`. |
| `compiler_input_flags` | `-c` and source input | Yes | **Injected** | Legacy default. |
| `compiler_output_flags` | `-o` / `-S` / `-E` output | Yes | **Injected** | Legacy default. |
| `dependency_file` | Generate `.d` header deps (`-MD`) | Yes | **Injected** | Legacy default. Required for correct incremental builds. |
| `pic` | Emit `-fPIC` from the `pic` build variable | Yes | **Injected** + Implicit | Legacy default; `-fPIC` is also baked into `default_compile_flags`. |
| `random_seed` | Deterministic `-frandom-seed` per output | Optional | Not provided | No feature; relies on compiler default. |

### Linking

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `default_link_flags` | Hardening, `--as-needed`, `--gc-sections`, libc++/libm | Yes | Explicit | In `features` list. |
| `user_link_flags` | Pass through per-target `linkopts` | Yes | **Injected** | Legacy default. Distinct from our `extra_link_flags`. |
| `output_execpath_flags` | `-o` for link output | Yes | **Injected** | Legacy default. |
| `library_search_directories` | Emit `-L` search paths | Yes | **Injected** | Legacy default. |
| `runtime_library_search_directories` | Emit `-rpath` | Yes | **Injected** | Legacy default. |
| `libraries_to_link` | Emit `-l` / object linking, whole-archive, static/dynamic | Yes | **Injected** | Legacy default. |
| `shared_flag` | `-shared` for dynamic libraries | Yes | **Injected** | Legacy default. |
| `linker_param_file` | `@param_file` for long link commands | Yes | **Injected** | Legacy default. |
| `force_pic_flags` | `-pie` for position-independent executables | Optional | **Injected** | Legacy default. |
| `fully_static_link` | `-static` fully static linking | Optional | **Injected** | Legacy default; unused by current tests. |
| `static_libgcc` | `-static-libgcc` in opt dynamic links | Optional | **Injected** | Legacy default. |

### Archiving

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `archiver_flags` | `ar` flags (`rcsD`) and library-list handling | Yes | **Injected** + Implicit | Feature injected; `cpp_link_static_library` `action_config` binds the `ar` tool and `implies = ["archiver_flags"]`. |

### Sysroot

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `sysroot` (compile) | `--sysroot` on compile actions | Yes | Implicit | Provided via `builtin_sysroot` passed to `create_cc_toolchain_config_info`. |
| `sysroot_link_flags` | `--sysroot` / `-Wl,--sysroot` on link actions | Yes | Explicit | Custom feature in `features` list. |

### Coverage

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `coverage` | Enable coverage instrumentation build mode | Yes | Explicit | In `features` list. |
| `gcc_coverage_map_format` | `-fprofile-arcs -ftest-coverage` / `--coverage` (gcov) | Yes | Explicit | In `features` list; `requires` `coverage`. |
| `llvm_coverage_map_format` | LLVM coverage map | No | **Injected** | Not used — GCC toolchain. |

### Capabilities

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `supports_pic` | Declares PIC capability | Yes | Explicit | In `features` list. |
| `supports_dynamic_linker` | Declares dynamic-linker capability | Yes | Explicit | In `features` list. |
| `supports_fission` | Declares Fission capability | Optional | Explicit | In `features` list; no `per_object_debug_info`/`fission_support` features defined. |

### Custom / project features

| Feature | Purpose | Required | Classification | Notes |
|---|---|---|---|---|
| `dbg` / `opt` | Build-mode selectors | Yes | Explicit | |
| `compiler_library_search_paths` | Set `LD_LIBRARY_PATH` for toolchain libs | Yes | Explicit | |
| `extra_compile_flags` / `extra_c_compile_flags` / `extra_cxx_compile_flags` | Injection point for user-supplied compile flags | Yes | Explicit | |
| `extra_link_flags` | Injection point for user-supplied link flags | Yes | Explicit | |
| `minimal_warnings` / `strict_warnings` / `all_wall_warnings` / `warnings_as_errors` | Warning-level control | Optional | Explicit | |
| `sanitizer` / `asan` / `lsan` / `tsan` / `ubsan` | Sanitizer builds | Optional | Explicit | |
| `use_pthread` | Link pthread | Optional | Explicit | |
| `gnu11` | Select `-std=gnu11` vs `-std=c11` | Optional | Explicit | Marked temporary in source. |
| `supports_header_path_normalization` | Suppress absolute-path warnings for system headers | Optional | Explicit | |

### Tooling (non-feature wiring)

| Behavior | Classification | Notes |
|---|---|---|
| `assemble` / `c_compile` / `cpp_compile` / link / `ar` / `strip` tool bindings | Implicit | Provided by `action_config` entries. |
| `gcov` path | Implicit | Provided by `tool_paths` (`gcov_wrapper`). |

## Behaviors Depending On Bazel Legacy Defaults

The following required behaviors are currently supplied **only** by Bazel's
legacy feature injection and are **not** defined in the Linux template. These
are the concrete gaps to close before enabling `no_legacy_features`:

- `include_paths`
- `preprocessor_defines`
- `user_compile_flags`
- `compiler_input_flags`
- `compiler_output_flags`
- `dependency_file`
- `pic` (also partly implicit via `default_compile_flags`)
- `user_link_flags`
- `output_execpath_flags`
- `library_search_directories`
- `runtime_library_search_directories`
- `libraries_to_link`
- `shared_flag`
- `linker_param_file`
- `archiver_flags` (feature body; tool binding is already explicit via `action_config`)

Optional legacy behaviors currently injected (add only if the capability is
needed): `force_pic_flags`, `fully_static_link`, `static_libgcc`,
`per_object_debug_info`, `fission_support`, `strip_debug_symbols`, `includes`,
`build_interface_libraries`, `dynamic_library_linker_tool`, `linkstamps`, and
all FDO/AutoFDO features.

Not applicable to this toolchain: `llvm_coverage_map_format`,
`legacy_compile_flags`, `legacy_link_flags`.

## Follow-Up Tasks

**Implementation**
- Define the required Injected features explicitly in the Linux template,
  mirroring the reference implementations already present in the QNX template
  where applicable.
- Add the `no_legacy_features` feature (enabled) once the required set is
  complete.
- Decide whether `pic` should be an explicit feature or remain baked into
  `default_compile_flags`, and make it consistent with QNX.

**Validation**
- Build and run the `tests/` suites (`feature_verification_tests`,
  `language_and_standards_tests`) on the `x86_64-linux` config before and after
  enabling `no_legacy_features`, and diff the resulting command lines
  (`--subcommands`) to confirm parity.
- Verify static libraries (`archiver_flags`), shared libraries (`shared_flag`),
  whole-archive linking (`libraries_to_link`), coverage, PIC, and header
  dependency tracking (`dependency_file`) still function.

**Documentation**
- Update [docs/features.md](features.md) to reflect the explicit feature set.
- Cross-link this document from [docs/overview.md](overview.md) and the README.
