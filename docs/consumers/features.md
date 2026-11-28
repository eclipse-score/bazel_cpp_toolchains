<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Toolchain features

This reference helps consumers find features in the generic Linux and QNX
toolchain profiles. The feature definitions are in
[`features/`](../../features/), and the ordered profile lists are under
`features/custom/`. The EBcLfSA high-integrity profile has a separate feature
list and omits some generic Linux features; consult its
[feature list](../../features/custom/ebclfsa_hi/make_cc_features.bzl) for
that profile.

The generic Linux and QNX toolchains, and the high-integrity profile, enable
**`no_legacy_features`**, which turns off the features Bazel would otherwise
add implicitly. Toolchain flags come from explicitly declared features and
other toolchain wiring. If your builds depended on implicit legacy behavior,
see the [migration guide](migration_guide.md).

Each entry is tagged with the generic platform(s) it applies to: **(both)**,
**(Linux)**, or **(QNX)**. Unless noted as *opt-in (disabled by default)* or a
build-mode marker, a feature is enabled by default.

> **Note:** The order of features in the `features` list is significant. Flags
> from a later feature appear after those from an earlier feature on the command
> line.

## Capability markers
- **`no_legacy_features`** (both) — Disables Bazel's implicit legacy features.
- **`supports_pic`** (both) — Declares position-independent-code support.
- **`supports_dynamic_linker`** (both) — Declares dynamic-linking support.
- **`supports_fission`** (Linux) — Declares Fission (split DWARF) support.
- **`supports_header_path_normalization`** (Linux) — Suppresses absolute-path
  warnings for system headers.
- **`dbg`** / **`opt`** (both) — Well-known build-mode markers used to select flags.
- **`gnu11`** / **`c_std_c99`** (both, opt-in) — Select GNU C11 or C99
  compilation instead of the default C11 mode.

## Compilation
- **`unfiltered_compile_flags`** (both) — Redacts `__DATE__`/`__TIME__`/`__TIMESTAMP__`
  for reproducible builds.
- **`default_compile_flags`** (both) — Core compile flags plus `dbg`/`opt`
  build-mode variants (exact flags differ per target).
- **`pic`** (both) — Emits `-fPIC` when the `pic` build variable is available.
- **`random_seed`** (both) — Emits `-frandom-seed=<output_file>` for
  deterministic output.
- **`include_paths`** (both) — Emits `-iquote` / `-I` / `-isystem` from the
  `quote_include_paths`, `include_paths`, and `system_include_paths` variables.
- **`preprocessor_defines`** (both) — Emits `-D` defines (from `defines` /
  `local_defines`).
- **`includes`** (Linux) — Emits `-include <hdr>` for force-included headers.
- **`user_compile_flags`** (both) — Passes through user-supplied compile flags
  (`copts`).
- **`compiler_input_flags`** (both) — `-c` and the source file.
- **`compiler_output_flags`** (both) — `-S` / `-E` / `-o` output flags.
- **`compiler_library_search_paths`** (Linux) — Sets `LD_LIBRARY_PATH` so the
  compiler binary finds its shared libraries.
- **`dependency_file`** (both) — Generates `.d` dependency files. On QNX,
  the opt-in **`dependency_file_named_implicitly`** marker toggles between
  explicit and implicit naming.
- **`per_object_debug_info`** (Linux) — Emits `-gsplit-dwarf -g` under
  `--fission` (guarded; no-op otherwise).

## Linking / archiving
- **`archiver_flags`** (both) — `ar` flags (`rcsD`) and the object-file list for
  static archives.
- **`user_link_flags`** (both) — Passes through user-supplied link flags
  (`linkopts`).
- **`linker_param_file`** (both) — Uses `@param_file` for linker/archiver args.
- **`default_link_flags`** (both) — Default/hardening link flags (exact flags
  differ per target and build mode).
- **`library_search_directories`** (both) — Emits `-L` search paths.
- **`runtime_library_search_directories`** (both) — Emits `-Wl,-rpath` entries
  (`$ORIGIN` for `cc_test`, `$EXEC_ORIGIN` otherwise).
- **`shared_flag`** (both) — `-shared` for dynamic libraries.
- **`output_execpath_flags`** (both) — `-o` for the link output.
- **`libraries_to_link`** (both) — Handles whole-archive, static, object-file,
  dynamic, and versioned-dynamic library linking.
- **`sysroot_link_flags`** (Linux) — Adds `--sysroot` / `-Wl,--sysroot` at link,
  and `--sysroot` for assemble/preprocess-assemble actions (preprocessed `.S`
  sources need it to resolve sysroot headers).

### Opt-in link features (Linux)
These mirror Bazel's legacy features and are guarded, so they are no-ops until
the relevant build mode is active. All are enabled by default except where noted.
- **`fission_support`** — `-Wl,--gdb-index` under `--fission`.
- **`linkstamps`** — Passes `%{linkstamp_paths}` to the linker (`--stamp`).
- **`force_pic_flags`** — `-pie` for executables under `--force_pic`.
- **`strip_debug_symbols`** — `-Wl,-S` when the link output is stripped
  (for example, `fastbuild` or `opt`, not `dbg`).
- **`static_libgcc`** — `-static-libgcc` when `static_link_cpp_runtimes` is on.
- **`fully_static_link`** — `-static` for fully static executables. **Opt-in
  (disabled by default)**, since it forces static linking for every target and
  requires static system archives (unavailable on some toolchains, such as AutoSD).

## Warnings
The warning-level features (`minimal_warnings`, `strict_warnings`,
`all_wall_warnings`, `warnings_as_errors`) are defined in
[`score_cpp_policies`](https://github.com/eclipse-score/score_cpp_policies),
not in this toolchain. Provide them through *feature injection* with the
`extra_known_features` / `extra_enabled_features` attributes on
`gcc.toolchain(...)`.

## Sanitizers (Linux, opt-in)
Sanitizers are **not** defined by this toolchain. They are provided as
rule-based `cc_feature` definitions by the `score_cpp_policies` module and made
available through *feature injection* — the `extra_known_features` /
`extra_enabled_features` attributes on `gcc.toolchain(...)`. Once injected they
behave like any other opt-in feature.

- **`score_asan`** — AddressSanitizer (`-fsanitize=address`).
- **`score_lsan`** — LeakSanitizer (`-fsanitize=leak`).
- **`score_tsan`** — ThreadSanitizer (`-fsanitize=thread`).
- **`score_ubsan`** — UndefinedBehaviorSanitizer (`-fsanitize=undefined`).

See the `score_cpp_policies` documentation for the authoritative list and usage.

## Threading
- **`use_pthread`** (Linux) — Links with `-pthread`.

## Extra flag hooks (template-substituted)
- **`extra_compile_flags`** (both) — Extra flags for all compile actions.
- **`extra_c_compile_flags`** / **`extra_cxx_compile_flags`** (both) — Extra C /
  C++ compile flags.
- **`extra_link_flags`** (both) — Extra link flags.

## Coverage
- **`coverage`** (both, opt-in) — Base coverage feature.
- **`gcc_coverage_map_format`** (both, opt-in) — `-fprofile-arcs -ftest-coverage` at
  compile and `-lgcov` / `--coverage` at link.

## QNX environment
- **`sdp_env`** (QNX) — Injects QNX SDP environment variables (`QNX_HOST`,
  `QNX_TARGET`, license path, ...) into compile/link actions.
- **`gcc_version_flags`** (QNX) — Selects the QNX compiler version and CPU.
- **`io_pkt_ddk`** (QNX, opt-in) — Adds C compilation flags and headers for
  QNX io-pkt drivers and modules.