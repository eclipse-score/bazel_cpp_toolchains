# Toolchain Features

These are the `cc_toolchain` features defined by the toolchain configs in
[`templates/linux/cc_toolchain_config.bzl.template`](../templates/linux/cc_toolchain_config.bzl.template)
and
[`templates/qnx/cc_toolchain_config.bzl.template`](../templates/qnx/cc_toolchain_config.bzl.template).

Both toolchains enable **`no_legacy_features`**, which turns off the features
Bazel would otherwise add implicitly. As a result every flag the toolchain emits
comes from a feature defined explicitly below.

Each entry is tagged with the platform(s) it applies to: **(both)**, **(Linux)**,
or **(QNX)**. Unless noted as *opt-in (disabled by default)*, a feature is
enabled by default.

> **Note:** The order of features in the `features` list is significant — flags
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

## Compilation
- **`unfiltered_compile_flags`** (both) — Redacts `__DATE__`/`__TIME__`/`__TIMESTAMP__`
  for reproducible builds.
- **`default_compile_flags`** (both) — Core compile flags plus `dbg`/`opt`
  build-mode variants (exact flags differ per target).
- **`pic`** (Linux) — Emits `-fPIC` when the `pic` build variable is available.
  (On QNX `-fPIC` is part of the default compile flags.)
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
  **`dependency_file_named_implicitly`** toggles between explicit and implicit
  naming.
- **`per_object_debug_info`** (Linux) — Emits `-gsplit-dwarf -g` under
  `--fission` (guarded; no-op otherwise).

## Linking / archiving
- **`archiver_flags`** (both) — `ar` flags (`rcsD`) and the object-file list for
  static archives.
- **`user_link_flags`** (both) — Passes
  through user-supplied link flags (`linkopts`).
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
- **`sysroot_link_flags`** (Linux) — Adds `--sysroot` / `-Wl,--sysroot` at link.

### Opt-in link features (Linux)
These mirror Bazel's legacy features and are guarded, so they are no-ops until
the relevant build mode is active. All are enabled by default except where noted.
- **`fission_support`** — `-Wl,--gdb-index` under `--fission`.
- **`linkstamps`** — Passes `%{linkstamp_paths}` to the linker (`--stamp`).
- **`force_pic_flags`** — `-pie` for executables under `--force_pic`.
- **`strip_debug_symbols`** — `-Wl,-S` when the link output is stripped
  (e.g. `fastbuild`/`opt`, not `dbg`).
- **`static_libgcc`** — `-static-libgcc` when `static_link_cpp_runtimes` is on.
- **`fully_static_link`** — `-static` for fully static executables. **Opt-in
  (disabled by default)**, since it forces static linking for every target and
  requires static system archives (unavailable on some toolchains, e.g. AutoSD).

## Warnings (all opt-in / disabled by default)
- **`minimal_warnings`** (both) — Baseline warning set.
- **`strict_warnings`** (both) — Stricter warnings; implies `minimal_warnings`.
- **`all_wall_warnings`** (Linux) — Broadest warning set; implies `strict_warnings`.
- **`warnings_as_errors`** (both) — Adds `-Werror`.

## Sanitizers (Linux, opt-in)
- **`sanitizer`** — Base sanitizer feature.
- **`asan`** / **`lsan`** / **`tsan`** / **`ubsan`** — Address / Leak / Thread /
  Undefined-Behavior sanitizers; each implies `sanitizer`.

## Threading
- **`use_pthread`** (Linux) — Links with `-pthread`.

## Extra flag hooks (template-substituted)
- **`extra_compile_flags`** (both) — Extra flags for all compile actions.
- **`extra_c_compile_flags`** / **`extra_cxx_compile_flags`** (Linux) — Extra C /
  C++ compile flags.
- **`extra_link_flags`** (both) — Extra link flags.

## Coverage
- **`coverage`** (both) — Base coverage feature.
- **`gcc_coverage_map_format`** (both) — `-fprofile-arcs -ftest-coverage` at
  compile and `-lgcov` / `--coverage` at link.

## QNX environment
- **`sdp_env`** (QNX) — Injects QNX SDP environment variables (`QNX_HOST`,
  `QNX_TARGET`, license path, ...) into compile/link actions.
- **`qnx_license_env_info`** (QNX) — Adds an optional license environment entry.