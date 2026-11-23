<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Integrate a QNX toolchain

This guide helps Bazel module maintainers configure a QNX toolchain and build
for an x86_64 QNX target from an x86_64 Linux host. It doesn't describe how to
add a toolchain package to this repository; see
[Maintenance](../contributors/maintenance.md) for that workflow.

## Before you begin

- Complete [Build with a Linux toolchain](getting_started.md) or configure an
  equivalent Linux host toolchain and the S-CORE Bazel registry. The examples
  use the `x86_64-linux` configuration from that guide.
- Obtain access to a compatible QNX Software Development Platform (SDP)
  package and a valid QNX license. Package access and license access are
  separate requirements.
- For the default SDP 8.0.5 package, obtain read access to its private GitHub
  release asset. Other consumers must provide a compatible package.
  See [QNX package authentication](qnx_authentication.md).
- Use a revision that contains the SDP 8.0.5 matrix entry. The `0.5.4` release
  used in the Linux example predates that entry. To use this checkout, add a
  local path override in `MODULE.bazel`:

  ```starlark
  local_path_override(
      module_name = "score_bazel_cpp_toolchains",
      path = "TOOLCHAINS_CHECKOUT",
  )
  ```

  Replace `TOOLCHAINS_CHECKOUT` with the path to this repository. For a
  published release with the entry, use that release instead.
- Make the license accessible to build actions. The default path is
  `/opt/score_qnx/license/licenses`; configure another path if needed.

## Declare the toolchain

1. In `MODULE.bazel`, add the QNX declaration to the `gcc` extension used by
   the Linux toolchain:

   ```starlark
   gcc.toolchain(
       name = "qnx_toolchain",
       target_cpu = "x86_64",
       target_os = "qnx",
       sdp_version = "8.0.5",
       use_default_package = True,
   )
   ```

2. Add `"qnx_toolchain"` to the existing `use_repo` call:

   ```starlark
   use_repo(gcc, "score_gcc_toolchain", "qnx_toolchain")
   ```

3. If the license is not at the default path, set `license_path` on the QNX
   declaration to the path accessible to build actions. For other license
   settings, see [Configure licensing](#configure-licensing).

4. Add a QNX configuration to `.bazelrc`:

   ```text
   build:x86_64-qnx --config=x86_64-linux
   build:x86_64-qnx --platforms=@score_bazel_platforms//:x86_64-qnx-sdp_8.0.0-posix
   build:x86_64-qnx --extra_toolchains=@qnx_toolchain//:x86_64-qnx-sdp_8.0.0
   build:x86_64-qnx --sandbox_writable_path=/var/tmp
   ```

   The generated toolchain uses `/var/tmp/.qnx` for QNX configuration.

5. From the module root, build the target from the Linux getting-started guide:

   ```bash
   bazel build --config=x86_64-qnx //:hello
   ```

   Confirm that Bazel reports a successful build. This checks compilation and
   linking, not execution on QNX.

To target `aarch64`, declare another toolchain with `target_cpu = "aarch64"`,
import its repository with `use_repo`, and select its corresponding platform
and generated toolchain label. See
[`tests/MODULE.bazel`](../../tests/MODULE.bazel) and
[`tests/.bazelrc`](../../tests/.bazelrc) for examples.

## Use a custom package

If you cannot access a default package or need another archive, create or
obtain a compatible package and BUILD descriptor. Replace the default-package
declaration with a package declaration and a toolchain linked to it:

```starlark
gcc.sdp(
    name = "qnx_package",
    build_file = "//toolchains:BUILD_FILE",
    sha256 = "ARCHIVE_SHA256",
    type = "tar.gz",
    url = "ARCHIVE_URL",
)

gcc.toolchain(
    name = "qnx_toolchain",
    target_cpu = "x86_64",
    target_os = "qnx",
    sdp_version = "8.0.5",
    sdp_to_link = "qnx_package",
    use_default_package = False,
)
```

Replace `BUILD_FILE` with your descriptor's filename, `ARCHIVE_SHA256` with
the archive checksum, and `ARCHIVE_URL` with its URL. Set `type` and
`sdp_version` to match your archive. The `use_repo` and `.bazelrc` steps in
[Declare the toolchain](#declare-the-toolchain) still apply; adjust the
generated label if the selected version maps to a different constraint. See
the [extension reference](extension_api.md#gccsdp-attributes).

For a custom QNX package, the generated configuration expects unsuffixed
`ar`, `gcov`, `strip`, `cxx_builtin_include_directories`, `cc`, `cxx`,
`all_files`, `sysroot_dir`, and `target_dir` targets. Shared default QNX
packages use CPU-suffixed targets for `ar`, `gcov`, `strip`, and
`cxx_builtin_include_directories`. The package must contain the expected host
tools and target headers and libraries.

## Select an SDP version

The package version and the platform constraint are resolved separately. The
[version matrix](../../packages/version_matrix.bzl) selects the archive by
its actual SDP version. The
[version mapping](../../rules/common.bzl) maps SDP 8.0.4, 8.0.5, and 8.0.6
to the `sdp_8.0.0` constraint and generated label.

Default QNX packages are shared across CPU-specific toolchain repositories.
For example, SDP 8.0.5 uses `qnx_sdp_8_0_5_pkg`. Different SDP versions use
different package repositories. If two versions have the same target
constraints, choose the intended toolchain through `--extra_toolchains` for
each configuration instead of registering both for that configuration.

## Configure licensing

The QNX `sdp_env` feature sets `QNX_HOST`, `QNX_TARGET`,
`QNX_CONFIGURATION_EXCLUSIVE`, and `QNX_SHARED_LICENSE_FILE` for compile and
link actions. The last value comes from the `license_path` attribute.
`license_info_variable` and `license_info_url` can specify an additional
license environment entry; see the [extension reference](extension_api.md).

If your licensing setup requires `QNXLM_LICENSE_FILE`, make it available to
the Bazel action environment according to your QNX license configuration.
With strict action environments, an exported shell variable alone isn't
sufficient; use an appropriate `--action_env` setting. Consult QNX licensing
documentation for vendor-specific behavior.

## Run QNX tests

The generated toolchain executes on an x86_64 Linux host; QNX binaries don't
run natively there. Build on that host and run the resulting binaries in a
compatible QNX environment, or use a configured QNX runner with Bazel's
`--run_under`. This repository's test workspace configures such a runner for
its QNX configurations. See [Tests and validation](../contributors/tests_and_validation.md)
for prerequisites and commands. Downstream modules must configure their own
runner and test environment.

## Troubleshoot

| Symptom | Check |
| --- | --- |
| Package download fails | Check the selected package URL, access, and credentials; see [QNX package authentication](qnx_authentication.md). |
| License error | Check the license path, license validity, and action environment. |
| Write error under `/var/tmp` | Check sandbox writable paths and permissions. |
| Toolchain cannot be selected | Check the target CPU, platform constraints, imported repository, and generated label. |
| QNX test cannot execute | Check the target environment or the configured QNX runner. |

## What's next

See [Extension API](extension_api.md) for attribute details and
[Toolchain features](features.md) for available features.
