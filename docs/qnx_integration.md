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

# QNX Integration

## Integration Contract

This section defines the requirements and constraints for using `score_bazel_cpp_toolchains`
with QNX toolchains in your Bazel workspace.

### Obtaining QNX SDP and Licenses

#### QNX Software Development Platform (SDP)

The QNX SDP packages are obtained from the official QNX Software repositories:

- **QNX Momentics IDE and SDPs**: https://www.qnx.com/developers/downloads.html
- **QNX Documentation Portal**: https://www.qnx.com/developers/docs/
- **Account Registration**: https://account.qnx.com/

QNX SDP packages are typically distributed as `.tar.gz` or `.tar.bz2` archives and
contain the host tools (compiler, linker, archiver) and target libraries/headers.

#### Licensing

QNX toolchains require a valid QNX license to execute. For complete license
configuration details, see [License Configuration](#licensing).

### Local Installation Layout

The `score_bazel_cpp_toolchains` module expects QNX SDP packages to follow the standard
QNX directory structure after extraction. A typical installation looks like:

```
/path/to/qnx_sdp_VERSION/
├── host/                          # Host tools and libraries
│   └── linux/
│       └── x86_64/
│           ├── usr/
│           │   ├── bin/
│           │   │   ├── qcc           # QNX C compiler driver
│           │   │   ├── q++           # QNX C++ compiler driver
│           │   │   ├── qcc-clang     # Clang-based compiler (SDP 8.x)
│           │   │   ├── {TRIPLE}-ar   # Archiver
│           │   │   ├── {TRIPLE}-strip
│           │   │   └── {TRIPLE}-gcov
│           │   └── lib/
│           └── ...
├── target/                        # Target platform libraries and headers
│   └── qnx/
│       ├── usr/
│       │   ├── include/           # C and C++ headers
│       │   ├── include/c++/v1/    # C++ standard library headers
│       │   ├── lib/
│       │   └── ...
│       └── ...
└── ...
```

Where `{TRIPLE}` is the target triple, e.g. `aarch64-unknown-nto-qnx7.1.0`.

The toolchain locates these directories via the `QNX_HOST` and `QNX_TARGET` environment
variables, which are set automatically by the toolchain's `sdp_env` feature.

### Required Environment Variables and Bazel Configuration

#### Environment Variables

The QNX toolchain automatically manages `QNX_HOST` and `QNX_TARGET` through the
`sdp_env` feature and does not require explicit user configuration.

#### User `.bazelrc` Configuration

To use QNX toolchains in your workspace, add configuration entries for your target
platform. Add the following to your `.bazelrc` or `.bazelrc.local`:

For **x86_64-qnx**:
```text
build:x86_64-qnx --platforms=@score_bazel_platforms//:x86_64-qnx-sdp_8.0.0-posix
build:x86_64-qnx --extra_toolchains=@qnx_toolchain//:x86_64-qnx-sdp_8.0.0
build:x86_64-qnx --sandbox_writable_path=/var/tmp
```

For **aarch64-qnx**:
```text
build:aarch64-qnx --platforms=@score_bazel_platforms//:aarch64-qnx-sdp_8.0.0-posix
build:aarch64-qnx --extra_toolchains=@qnx_toolchain//:aarch64-qnx-sdp_8.0.0
build:aarch64-qnx --sandbox_writable_path=/var/tmp
```

**Note:** Replace `@qnx_toolchain` with your actual repository name from 
`use_repo(gcc, "qnx_toolchain")` in your `MODULE.bazel`.

If using the credential helper for authenticated downloads:
```text
common --credential_helper=*.qnx.com=/path/to/qnx_credential_helper.py
```

#### Toolchain Configuration in MODULE.bazel

Declare your QNX toolchain in `MODULE.bazel`:

```starlark
bazel_dep(name = "score_bazel_cpp_toolchains", version = "0.5.4")

gcc = use_extension("@score_bazel_cpp_toolchains//extensions:gcc.bzl", "gcc")

gcc.toolchain(
    name = "qnx_toolchain",
    target_cpu = "x86_64",
    target_os = "qnx",
    sdp_version = "8.0.0",
    use_default_package = True,
)

use_repo(gcc, "qnx_toolchain")
```

See [License Configuration](#licensing) for license-specific setup.

### Bazel Sandbox and Writable Paths

QNX toolchains require write access to `/var/tmp` for temporary configuration files
during compilation and linking. This is automatically configured via the toolchain's
`sdp_env` feature, which sets `QNX_CONFIGURATION_EXCLUSIVE=/var/tmp/.qnx`.

If your Bazel configuration restricts sandbox write paths, ensure that `/var/tmp`
is marked as writable:

```text
build --sandbox_writable_path=/var/tmp
```

### Verification: Testing the QNX Toolchain

To verify that the QNX toolchain is properly configured and usable, run a minimal
test build:

#### 1. Create a Test C File

Create a simple test file `hello_qnx.c`:

```c
#include <stdio.h>

int main() {
    printf("Hello from QNX!\n");
    return 0;
}
```

#### 2. Create a BUILD File

Create a `BUILD` file with a simple target:

```starlark
cc_binary(
    name = "hello_qnx",
    srcs = ["hello_qnx.c"],
)
```

#### 3. Run the Verification Build

You can verify the toolchain by building with explicit platform and toolchain selection:

For **x86_64-qnx**:
```bash
bazel build \
  --platforms=@score_bazel_platforms//:x86_64-qnx-sdp_8.0.0-posix \
  --extra_toolchains=@qnx_toolchain//:x86_64-qnx-sdp_8.0.0 \
  //:hello_qnx
```

For **aarch64-qnx**:
```bash
bazel build \
  --platforms=@score_bazel_platforms//:aarch64-qnx-sdp_8.0.0-posix \
  --extra_toolchains=@qnx_toolchain//:aarch64-qnx-sdp_8.0.0 \
  //:hello_qnx
```

**Tip:** If you've defined `build:<name>` configs in your `.bazelrc` (as shown in 
[User `.bazelrc` Configuration](#user-bazelrc-configuration)), you can simplify to:
```bash
bazel build --config=x86_64-qnx //:hello_qnx
bazel build --config=aarch64-qnx //:hello_qnx
```

#### 4. Verify Build Output

If the build succeeds, the output binary will be available at:

```
bazel-bin/hello_qnx
```

You can verify it's a QNX binary using file inspection:

```bash
file bazel-bin/hello_qnx
# Should output: ELF 64-bit LSB executable, {x86-64|aarch64}, version 1 (SYSV), dynamically linked, ...
# (architecture depends on your target: x86-64 for x86_64-qnx, aarch64 for aarch64-qnx)
```

Or use `qfile` if QNX tools are available:

```bash
qfile bazel-bin/hello_qnx
```

#### 5. Troubleshooting

- **License not found**: Ensure `QNX_SHARED_LICENSE_FILE` is set and points to a valid license file
- **QNX_HOST/QNX_TARGET not set**: The toolchain's `sdp_env` feature sets these automatically;
  if you see errors, verify the SDP package path is correct
- **Permission denied on /var/tmp**: Ensure `--sandbox_writable_path=/var/tmp` is in your `.bazelrc`
- **Compilation fails with QCC errors**: Verify the QCC compiler binary exists in the expected location
  and the SDP package structure is intact

## Licensing

QNX toolchains require a valid license to execute at build time. This section covers
all license-related configuration options.

### License File Location

QNX licenses are typically installed as a file accessible on the build machine. The
default shared license path expected by the module is:

```
/opt/score_qnx/license/licenses
```

This path has been agreed upon with all module owners and platform developers.

### Configuring the License Path

You can configure the license path in multiple ways, in order of precedence:

#### 1. Environment Variable (Runtime)

The generated toolchain sets `QNX_SHARED_LICENSE_FILE` for compile/link actions, based on the `license_path` toolchain attribute.
If you need to use the vendor-provided `QNXLM_LICENSE_FILE` mechanism instead, set it in your shell `export QNXLM_LICENSE_FILE=/path/to/your/license/file` or ensure it is provided to Bazel actions (e.g. via `--action_env=QNXLM_LICENSE_FILE=...`; when `--incompatible_strict_action_env` is enabled, exporting it in your shell alone is not sufficient).

This is useful when the license is not installed in the default location.

#### 2. Bazel Configuration (Workspace-wide)

In your `.bazelrc`:

```text
build --action_env=QNXLM_LICENSE_FILE=/path/to/your/license/file
```

#### 3. Toolchain Attributes (Per-toolchain)

In your `MODULE.bazel`, pass license configuration to the toolchain:

```starlark
gcc.toolchain(
    name = "qnx_toolchain",
    target_cpu = "x86_64",
    target_os = "qnx",
    sdp_version = "8.0.0",
    use_default_package = True,
    license_path = "/path/to/your/license/file",
)
```

### Custom License Configuration

For scenarios where the default license path or environment setup is insufficient,
you can configure the license URL:

```starlark
gcc.toolchain(
    name = "qnx_toolchain",
    target_cpu = "x86_64",
    target_os = "qnx",
    sdp_version = "8.0.0",
    use_default_package = True,
    license_path = "/path/to/your/license/file",
    license_info_url = "https://your-license-server.com/qnx-license",
)
```

The relevant `gcc.toolchain(...)` attributes for license configuration are:

- **`license_path`**: Path to the QNX license file directory
  (default: `/opt/score_qnx/license/licenses`)
- **`license_info_variable`**: Custom environment variable name for license configuration
- **`license_info_url`**: URL for license server or remote license resource

### Obtaining a QNX License

If you don't have a QNX license, obtain one from:

- **QNX Licensing Portal**: https://www.qnx.com/
- **Contact QNX Sales**: https://www.qnx.com/company/contact-us/

## Credential Helper

Authenticated QNX downloads are handled by the standalone script
`tools/qnx_credential_helper.py`.

Its purpose is to translate locally available QNX credentials into the cookie
header format expected by `qnx.com` download endpoints. Bazel executes it via
`--credential_helper`;

Supported registration patterns include:

```text
common --credential_helper=*.qnx.com=/absolute/path/to/qnx_credential_helper.py
common --credential_helper=*.qnx.com=qnx_credential_helper.py
common --credential_helper=*.qnx.com=%workspace%/path/to/qnx_credential_helper.py
```

The helper reads credentials in this order:

- `SCORE_QNX_USER` and `SCORE_QNX_PASSWORD`
- `~/.netrc` entry for `qnx.com`