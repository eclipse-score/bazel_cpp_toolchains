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
[Add a toolchain variant](../contributors/add_toolchain.md) for that workflow.

## Before you begin

- Complete [Build with a Linux toolchain](getting_started.md) or configure an
  equivalent Linux host toolchain and the S-CORE Bazel registry. The examples
  use the `x86_64-linux` configuration from that guide.
- Obtain access to a compatible QNX Software Development Platform (SDP)
  package and a valid QNX license. Package access and license access are
  separate requirements.
- For a default package, obtain read access to its private GitHub release
  asset. SDP 8.0.5 and 8.0.6 are available this way; see
  [Authenticate QNX package downloads](qnx_authentication.md). If you can't
  access a default package, build your own SDP and use it instead; see
  [Use your own SDP](#use-your-own-sdp).
- Use a revision of this module whose
  [version matrix](../../packages/version_matrix.bzl) contains an entry for
  your SDP version. To use this checkout, add a local path override in
  `MODULE.bazel`:

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

## Use your own SDP

If you can't access a default package, or you need a different SDP build,
build the SDP yourself and make it available to this module. The
[`score_qnx_sdp`](https://github.com/eclipse-score/qnx_sdp) module installs a
QNX SDP through the QNX Software Center. For how to set up your QNX account
and license and how to define and build a `qnx_sdp` target, see its
[license and credentials](https://github.com/eclipse-score/qnx_sdp/blob/main/docs/license-and-credentials.md)
and [user guide](https://github.com/eclipse-score/qnx_sdp/blob/main/docs/user-guide.md).
This section covers only how to use the result with this module.

Building a `qnx_sdp` target produces an SDP directory, for example
`bazel-bin/qnx_sdp/` for a target named `qnx_sdp`. Choose one of the following
methods to use it:

| Method | Use it when | `MODULE.bazel` changes |
| --- | --- | --- |
| [Override the package repository](#override-the-package-repository) | The SDP is on your machine. | A one-time `use_repo` entry that you can commit. |
| [Host the SDP archive](#host-the-sdp-archive) | You share one SDP build through an HTTP server or Artifactory. | Package and toolchain declarations that you shouldn't commit. |

### Override the package repository

This method keeps the default-package declaration from
[Declare the toolchain](#declare-the-toolchain) and replaces the downloaded
package with your local SDP directory. Bazel doesn't download the package, so
you don't need access to the private release asset.

1. Add the package repository to the `use_repo` call of your `gcc` extension:

   ```starlark
   use_repo(gcc, "score_gcc_toolchain", "qnx_toolchain", "SDP_PACKAGE")
   ```

   Replace `SDP_PACKAGE` with the package repository name. For a default
   package, the name is `qnx_sdp_`, followed by the `sdp_version` with each
   dot replaced by an underscore, followed by `_pkg`. For example, SDP 8.0.5
   uses `qnx_sdp_8_0_5_pkg`.

2. Copy the SDP directory that you built to a stable location, because Bazel
   can remove build outputs.

3. Add the override to your user `~/.bazelrc` file instead of the `.bazelrc`
   file in your repository, so that your local path isn't checked in:

   ```text
   common --override_repository=SDP_PACKAGE=/ABSOLUTE/PATH/TO/SDP
   ```

   Replace `SDP_PACKAGE` with the name from step 1 and `/ABSOLUTE/PATH/TO/SDP`
   with the absolute path of the copied directory. Keep the `BUILD.bazel` file
   that the `qnx_sdp` rule copies into the SDP root; the generated toolchain
   reads the targets that it defines. For details about the flag, see the Bazel
   [`--override_repository` reference](https://bazel.build/reference/command-line-reference#param-override-repository).

4. From the module root, build the target from the Linux getting-started guide:

   ```bash
   bazel build --config=x86_64-qnx //:hello
   ```

   Confirm that Bazel reports a successful build.

### Host the SDP archive

This method downloads your SDP from your own server and links it to the QNX
toolchain declaration. It changes `MODULE.bazel` to point to your storage, so
don't commit these changes to a repository that others build.

1. Package the SDP directory as an archive, so that the archive root is the SDP
   root. For an example that uses `rules_pkg`, see
   [Use or package the output](https://github.com/eclipse-score/qnx_sdp/blob/main/docs/user-guide.md#use-or-package-the-output)
   in the `score_qnx_sdp` user guide.
2. Upload the archive to an HTTP server or Artifactory instance that your build
   machines can reach.
3. Replace the default-package declaration with a package declaration and a
   toolchain linked to it through `sdp_to_link`:

   ```starlark
   gcc.sdp(
       name = "qnx_package",
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

   Replace `ARCHIVE_SHA256` with the archive checksum and `ARCHIVE_URL` with
   the URL of the uploaded archive. Set `type` and `sdp_version` to match your
   archive. Keep `use_default_package = False`: if you set `sdp_to_link`
   together with `use_default_package = True`, the extension fails with an
   error, because the default package comes from the version matrix. For the
   attributes, see the
   [extension reference](extension_api.md#gccsdp-attributes).

4. Complete the `use_repo` and `.bazelrc` steps in
   [Declare the toolchain](#declare-the-toolchain). Adjust the generated label
   if the selected version maps to a different constraint.

The archive that you build from a `qnx_sdp` target already contains the
`BUILD.bazel` file that the generated toolchain needs, so you don't need to
set `build_file`. If you provide your own BUILD file with the `build_file`
attribute, make sure that it is compatible. The generated configuration
expects the targets `cc`, `cxx`, `all_files`, `sysroot_dir`, and `target_dir`,
and the CPU-suffixed targets `ar_CPU`, `gcov_CPU`, `strip_CPU`,
`cxx_builtin_include_directories_CPU`, and the file groups `ar_files_CPU`,
`as_files_CPU`, `compiler_files_CPU`, `coverage_files_CPU`, `dwp_files_CPU`,
`linker_files_CPU`, `objcopy_files_CPU`, and `strip_files_CPU`, where `CPU` is
`x86_64` or `aarch64`. For the full list, see
[Package targets that the toolchain requires](extension_api.md#package-targets-that-the-toolchain-requires).
The package must also contain the expected host tools and target headers and
libraries.

## Select an SDP version

The package version and the platform constraint are resolved separately. The
[version matrix](../../packages/version_matrix.bzl) selects the archive by
its actual SDP version. The [version mapping](../../rules/common.bzl) maps
every patch version of the SDP 8.0 series, for example 8.0.5, 8.0.6, and
8.0.12, to the `sdp_8.0.0` constraint and generated label.

For QNX toolchains, `version` is optional. If you omit it, the extension sets
it to the GCC version that the SDP major release ships (12.2.0 for SDP 8.x).
If you set it to a different value, the extension fails with an error that
names the expected version.

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

To diagnose a problem, find the symptom in the following table and run the
matching check:

| Symptom | Check |
| --- | --- |
| Package download fails | Check the selected package URL, access, and credentials; see [Authenticate QNX package downloads](qnx_authentication.md). If you can't get access, see [Use your own SDP](#use-your-own-sdp). |
| License error | Check the license path, license validity, and action environment. |
| Write error under `/var/tmp` | Check sandbox writable paths and permissions. |
| Toolchain cannot be selected | Check the target CPU, platform constraints, imported repository, and generated label. |
| QNX test cannot execute | Check the target environment or the configured QNX runner. |

## What's next

See [Extension API](extension_api.md) for attribute details and
[Toolchain features](features.md) for available features.
