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

# Extension API

## Consumer Entry Point

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

## Public Tags

`gcc.toolchain(...)`

Declares a toolchain repository to generate.

`gcc.sdp(...)`

Declares a package repository explicitly. This is used when the package is not
taken from the default version matrix or when local QNX SDP generation is
required.

## `gcc.toolchain(...)` Attributes

Required attributes:

- `name`: name of the generated repository
- `target_cpu`: target CPU, currently `x86_64` or `aarch64`
- `target_os`: target OS, currently `linux` or `qnx`

Common package selection attributes:

- `use_default_package`: resolve package metadata from `packages/version_matrix.bzl`
- `version`: GCC version string for Linux toolchains
- `sdp_version`: QNX SDP version string
- `sdk_version`: alternative SDK identifier used in matrix resolution
- `sdp_to_link`: override the package repository name that the toolchain uses

Flag and runtime attributes:

- `extra_compile_flags`
- `extra_c_compile_flags`
- `extra_cxx_compile_flags`
- `extra_link_flags`
- `ld_library_paths`
- `runtime_ecosystem`
- `use_base_constraints_only`

QNX-specific attributes:

- `license_path`
- `license_info_variable`
- `license_info_url`

## `gcc.sdp(...)` Attributes

The `gcc.sdp` tag defines the package side of the toolchain setup. Important
attributes are:

- `name`: repository name for the package
- `build_file`: BUILD file that exposes the package contents as Bazel targets
- `url`: url of the archive,
- `sha256`: sha256 of the archive
- `strip_prefix`: extraction prefix for packaged archives


## Activation In A Workspace

Declaring a toolchain repository is not enough on its own. Consumers still need
to activate the generated toolchain during Bazel analysis, typically with a
configuration such as:

```text
--extra_toolchains=@score_gcc_toolchain//:x86_64-linux-gcc_12.2.0
```

The test workspace under `tests/` provides complete `.bazelrc`
configurations for this activation step.

## Behavior Notes

- The extension is intended for the root module.
- When `use_default_package` is enabled, the version matrix can inject extra
  include and link flags required by non-standard sysroot layouts.
- QNX toolchains use additional licensing and include-path parameters that do
  not apply to Linux toolchains.