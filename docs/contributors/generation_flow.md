<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Toolchain generation flow

This reference helps contributors understand how a `MODULE.bazel` declaration
becomes a generated toolchain repository, so that you can find where to change
package metadata, features, or templates. It doesn't describe how consumers
configure toolchains; see
[Build with a Linux toolchain](../consumers/getting_started.md).

## Generation steps

The repository turns a small `MODULE.bazel` declaration into a generated
toolchain repository through these steps:

1. `extensions/gcc.bzl` collects `gcc.toolchain` and `gcc.sdp` tags.
2. Package metadata is resolved from `packages/version_matrix.bzl` or from an
   explicit `gcc.sdp` declaration.
3. `rules/gcc.bzl` renders the shared `templates/BUILD.template` and
   `templates/cc_toolchain_config.bzl.template` into a new repository,
   substituting CPU, version, licensing, and flag placeholders.
4. The rendered `BUILD` file wires in the toolchain's feature set:
   per-instance features created at generation time (extra compile/link
   flags, sysroot link flags, compiler library search paths) plus the
   ordered `known_features`/`enabled_features` lists from
   `features/custom/linux/`, `features/custom/qnx/`, or
   `features/custom/ebclfsa_hi/`, which reference the
   reusable `cc_feature` targets under `features/native/`.
5. The consuming workspace enables the generated toolchain with
   `--extra_toolchains` and compatible platform constraints.

## Subsystem roles

`packages/version_matrix.bzl`

Defines the supported package matrix. Each entry maps a logical toolchain key
to download metadata and, when needed, extra compiler or linker flags and
archive patches.

`rules/common.bzl`

Provides small helpers that convert lists of flags into the Bazel `flag_group`
representation needed by the templates and repository rules. It also defines
the SDP version mappings used to map package releases to platform constraints.

`rules/gcc.bzl`

Generates the toolchain repository. It performs placeholder substitution and
emits the final `BUILD`, `cc_toolchain_config.bzl`, and `gcov` wrapper files,
substituting OS-specific values (for example, `compiler`, `abi_version`,
`toolchain_identifier`) into the shared templates below.

`features/`

Defines the toolchain's `cc_feature` / `cc_args` targets with
`@rules_cc//cc/toolchains`. `features/native/` holds one reusable target per
toolchain feature; `features/custom/linux/`, `features/custom/qnx/`, and
`features/custom/ebclfsa_hi/` hold platform-specific features plus the ordered
`known_features`/`enabled_features`
lists that `templates/BUILD.template` passes to `cc_toolchain_config`.

## Template files

A single set of templates serves Linux, QNX, and the EBcLfSA high-integrity
(HI) profile:

- `templates/cc_toolchain_config.bzl.template`
- `templates/BUILD.template`
- `templates/cc_gcov_wrapper.template`

## Implementation details

- Some package definitions rely on the `%{toolchain_pkg}%` placeholder, which
  is rewritten to the canonical Bzlmod repository name during repository-rule
  generation. This is handled by the `_get_canonical_pkg_name()` helper in
  `rules/gcc.bzl`.
- QNX `aarch64` is mapped internally to `aarch64le` where required by the
  underlying SDK layout. This normalization is a QNX-specific convention,
  centralized in the `_normalize_cpu()` helper. Linux toolchain binaries use
  the CPU name unchanged (for example, `aarch64-unknown-linux-gnu-gcov`).
- SDP version mapping is handled through `SDP_VERSION_MAPPING` in
  `rules/common.bzl`. Every patch version of a mapped series, for example
  `8.0.5`, `8.0.6`, and `8.0.12`, maps to the series' canonical version
  (`8.0.0` for the 8.0 series) because platform constraint support uses the
  older identifier. To map another series, add a `MAJOR.MINOR` key.
- Linux toolchains generate an extra `gcov_wrapper` script to work around how
  `rules_cc` integrates coverage. The gcov path uses the
  `{cpu}-unknown-linux-gnu-gcov` naming convention.

## Version matrix responsibilities

The version matrix is more than a list of URLs. It is also the place where the
repository centralizes:

- package build-file selection,
- archive extraction prefixes,
- sysroot-specific compiler flags,
- extra link flags,
- compiler library search paths,
- runtime-ecosystem variants such as AutoSD or EB corbos Linux for Safety Applications.
