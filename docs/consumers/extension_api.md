<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Extension API

This reference describes the module extension tags available to consumers.
For a complete configuration example, see
[Build with a Linux toolchain](getting_started.md).

## Consumer entry point

Consumers interact with this repository through the `gcc` module extension in
`@score_bazel_cpp_toolchains//extensions:gcc.bzl`.

Typical usage looks like this:

```starlark
bazel_dep(name = "score_bazel_cpp_toolchains", version = "0.5.4")

gcc = use_extension("@score_bazel_cpp_toolchains//extensions:gcc.bzl", "gcc")

gcc.toolchain(
    name = "score_gcc_toolchain",
    target_cpu = "x86_64",
    target_os = "linux",
    version = "12.2.0",
    use_default_package = True,
)

use_repo(gcc, "score_gcc_toolchain")
```

## Public tags

`gcc.toolchain(...)`

Declares a toolchain repository to generate.

`gcc.sdp(...)`

Declares a package repository explicitly. This is used when the package is not
taken from the default version matrix or when local QNX SDP generation is
required. The extension forwards its supported archive attributes to the
repository's `http_archive` wrapper, which handles GitHub release assets
separately.

## `gcc.toolchain(...)` attributes

The following attributes are required:

- `name` (string): generated toolchain repository name; there is no default.
- `target_cpu` (string): `x86_64` or `aarch64`.
- `target_os` (string): `linux` or `qnx`.

Common package selection attributes:

- `use_default_package` (boolean, default `False`): whether to use a package
  from the version matrix.
- `version` (string, default `""`): GCC version, for example `12.2.0` or
  `15.3.0`. See the [version matrix](../../packages/version_matrix.bzl). For
  QNX toolchains with an `sdp_version`, the extension sets an empty `version`
  to the GCC version that the SDP major release ships, and fails if you set a
  different value.
- `sdp_version` (string, default `""`): version of the SDP package.
- `sdk_version` (string, default `""`): SDK version, an alternative identifier used in
  matrix resolution.
- `sdp_to_link` (string, default `""`): name of the toolchain package to link with this
  toolchain. Set it together with `use_default_package = False` to link a package
  that you declare with `gcc.sdp`. Setting it together with
  `use_default_package = True` is an error. For default QNX packages, the extension uses a name based on the
  version-matrix entry so toolchains for different CPUs share one package
  repository (for example, QNX SDP 8.0.5 uses
  `qnx_sdp_8_0_5_pkg`). Each `sdp_version` maps to its own default package, so
  several SDP versions can coexist in one module. The default SDP 8.0.5 and
  8.0.6 packages are private. Other default packages use toolchain name + `_pkg`.
  See [QNX integration](qnx_integration.md) for access, locally built SDPs, and
  custom packages.
- `use_system_toolchain` (boolean, default `False`): skips default package
  linking. Its full system-toolchain behavior is not documented; check the
  implementation before relying on it.

Flag and runtime attributes (lists default to `[]` and strings to `""`):

- `extra_compile_flags` (string list): additional flags passed to the compiler.
- `extra_c_compile_flags` (string list): additional flags passed to the C compiler.
- `extra_cxx_compile_flags` (string list): additional flags passed to the C++
  compiler.
- `extra_link_flags` (string list): additional flags passed to the linker.
- `extra_known_features` (label list): extra `cc_feature` features to add to this toolchain
  in an initially disabled state. See [Feature injection](#feature-injection).
- `extra_enabled_features` (label list): extra `cc_feature` features to add to this
  toolchain in an initially enabled state. See [Feature injection](#feature-injection).
- `ld_library_paths` (string list): paths relative to the sysroot which should build
  up the runtime linker path of the tools of this toolchain.
- `runtime_ecosystem` (string, default `""`): identifies the system-level
  runtime environment that a target is built to run in. The extension adds
  the value to the generated platform constraints and toolchain name. The
  value `ebclfsa-hi` on a Linux toolchain selects the EBcLfSA high-integrity
  feature list; see [Toolchain features](features.md). For other supported
  values, see the runtime constraints in
  [`score_bazel_platforms`](https://github.com/eclipse-score/bazel_platforms).
- `use_base_constraints_only` (boolean, default `False`): experimental.
  Uses only base platform constraints, limiting toolchain registration to one
  per base platform definition.

QNX-specific attributes:

- `license_path` (string): path to the shared license file, default
  `/opt/score_qnx/license/licenses`.
- `license_info_variable` (string, default `""`): QNX license info variable.
- `license_info_url` (string, default `""`): URL of the QNX license server.

## `gcc.sdp(...)` attributes

The `gcc.sdp` tag defines a package archive. Archive attributes correspond to
the identically named `http_archive` attributes. Specify a package name for
an explicit declaration; the tag's declared default is an empty string.

- `name` (string, default `""`): package repository name.
- `build_file` (label, default `None`): BUILD file for the archive.
- `url` (string, default `""`): URL of the toolchain archive.
- `sha256` (string, default `""`): checksum of the archive.
- `type` (string, default `""`): archive type, such as `tar.gz`; required for
  URLs without an archive extension.
- `strip_prefix` (string, default `""`): archive extraction prefix.
- `files` (string-to-label dictionary, default `{}`): paths to file labels
  to overlay on the repository as symlinks.
- `patches` (label list, default `[]`): patches to apply to the archive.
- `patch_args` (string list, default `[]`): arguments given to the patch tool.
  The effective default strip level is `-p0` (see
  `patch_strip`); `-p1` is usually needed for patches generated by Git.
  Arguments other than `-p` cause Bazel to use a patch command-line tool.
  Only affects files in `patches`.
- `patch_cmds` (string list, default `[]`): Bash commands run in the extracted
  archive root after extraction.
- `patch_strip` (integer, default `0`): equivalent to inserting `-pN` at the
  beginning of `patch_args` for value `N`.
- `patch_tool` (string, default `""`): patch utility to use instead of the
  Bazel-native implementation.

Archive attributes can be supplied either directly through `gcc.sdp(...)` or
through `packages/version_matrix.bzl`. The extension forwards matrix values for
`patches`, `patch_args`, `patch_cmds`, `patch_strip`, `patch_tool`, and `files`
to `http_archive` when present. Entries that omit these optional fields use the
native `http_archive` defaults.

### Private GitHub release assets

The extension instantiates archives through the `http_archive` wrapper in
`rules/http_archive.bzl`, which has the same interface as the native rule.
If `url` is a GitHub REST API release asset URL
(`https://api.github.com/repos/OWNER/REPO/releases/assets/ASSET_ID`), the
wrapper uses the `github_release_archive` repository rule from
`rules/github_release_archive.bzl`; all other URLs go to the native
`http_archive`.
The attributes stay the same, but `sha256` and `type` are mandatory.
Bazel 8 cannot download such assets itself: its downloader always sends a
browser-like `Accept` header, so GitHub answers with JSON metadata instead of
the archive.

`tools/fetch_github_release_asset.py` downloads the asset and hands it to
Bazel as a local file, so the checksum check and the repository cache still
apply.
Once the archive is in the repository cache, no token or network access is
needed.
The short-lived signed download URL never reaches Bazel, so it does not
appear in the console output or the Build Event Protocol.
The script requires `python3` on the host and reads the token in this order:

- `SCORE_GITHUB_TOKEN`, `GITHUB_TOKEN` or `GH_TOKEN`
- the netrc entry for `api.github.com` or `github.com` (`$NETRC` or `~/.netrc`)

The token needs read access to the repository contents.
It is not part of the repository definition, so rotating it does not trigger
a refetch.
No `--credential_helper` is needed for these URLs.

To declare such a package, use a call like the following:

```starlark
gcc.sdp(
    name = "my_qnx_sdp_pkg",
    build_file = "//toolchains:qnx_sdp.BUILD",
    sha256 = "ASSET_SHA256",
    type = "tar.gz",
    url = "https://api.github.com/repos/OWNER/REPO/releases/assets/ASSET_ID",
)
```

Replace `ASSET_SHA256` with the checksum of the asset, and replace `OWNER`,
`REPO`, and `ASSET_ID` with the repository owner, the repository name, and the
numeric ID of the release asset.

## Feature injection

`extra_known_features` and `extra_enabled_features` let a workspace add
rule-based `cc_feature` targets (defined outside this repository) to the
generated toolchain:

- `extra_known_features` — registers external features so they can be toggled
  per target via the `features` attribute or build-wide via `--features`.
- `extra_enabled_features` — registers *and* enables external features by
  default.

Sanitizers are the primary use case: they are defined by the
`score_cpp_policies` module and brought into the toolchain through these
attributes. See [Toolchain features](features.md#sanitizers-linux-opt-in).

Feature injection is a migration bridge with limited integration: it does not
perform additional correctness checks or handle feature `data` files. See
the attribute documentation in [`gcc.bzl`](../../extensions/gcc.bzl).

## Activation in a workspace

Declaring a toolchain repository is not enough on its own. Consumers still need
to activate the generated toolchain during Bazel analysis, typically with a
configuration such as:

```text
--extra_toolchains=@score_gcc_toolchain//:x86_64-linux-gcc_12.2.0
```

A GCC 15.3.0 toolchain is packaged as well. Activate it the same way by
referencing its generated label, for example:

```text
--extra_toolchains=@score_gcc_toolchain_15//:x86_64-linux-gcc_15.3.0
```

The test workspace under `tests/` provides complete `.bazelrc`
configurations for this activation step, including an `x86_64-linux-gcc15` /
`aarch64-linux-gcc15` config pair for the GCC 15.3.0 toolchain.

## Migration to the explicit-feature model

The generated toolchains run under Bazel's explicit-feature model
(`no_legacy_features`), so behaviors that Bazel adds implicitly in its legacy
model are not automatic. For the behavioral impact and how consumers restore
supported behavior explicitly, see the
[migration guide](migration_guide.md).

## Behavior notes

- The extension is intended for the root module.
- When `use_default_package` is enabled, the version matrix can inject extra
  include and link flags required by non-standard sysroot layouts.
- Sanitizer features are not registered automatically. They are defined by the
  `score_cpp_policies` module and made available through *feature injection* —
  the `extra_known_features` / `extra_enabled_features` attributes on
  `gcc.toolchain(...)`. See [Toolchain features](features.md#sanitizers-linux-opt-in)
  for the injected feature names.
- QNX toolchains use additional licensing and include-path parameters that do
  not apply to Linux toolchains.
