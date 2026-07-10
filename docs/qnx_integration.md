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

## Overview

This guide covers QNX integration with `score_bazel_cpp_toolchains` and is organized for two audiences:

- **Maintainers of Bazel modules**: If you want to add QNX support to your module, see [Adding QNX Support to Your Module](#adding-qnx-support-to-your-module). This section includes comprehensive integration steps and technical reference.
- **Users and contributors**: If you're working on a module that already has QNX configured, see [Quick Start: Using QNX](#quick-start-using-qnx).
- **Module maintainers documenting for contributors**: See [Documenting QNX Support](#documenting-qnx-support) for a template of what your users need to know.

---

## Adding QNX Support to Your Module

This section is for maintainers who want to integrate QNX toolchain support into their Bazel modules.

### Prerequisites

Before integrating QNX support, ensure:

1. **QNX SDP access**: Access to URL for downloading and extracting the QNX Software Development Platform (SDP) from https://www.qnx.com/developers/downloads.html
2. **Valid QNX license**: A QNX license file accessible at a known location (see [Licensing](#licensing) section)
3. **Bazel installed**: Version 8.0 or later
4. **Linux host**: Currently tested on Linux build hosts (macOS and Windows are not supported.)

### Integration Steps

#### Step 1: Declare the Toolchain Dependency

In your module's `MODULE.bazel`:

```starlark
bazel_dep(name = "score_bazel_cpp_toolchains", version = "0.5.4")

gcc = use_extension("@score_bazel_cpp_toolchains//extensions:gcc.bzl", "gcc")

gcc.toolchain(
    name = "qnx_toolchain",
    target_cpu = "x86_64",                      # or "aarch64"
    target_os = "qnx",
    sdp_version = "8.0.0",                      # match your SDP version but keep in mind proper platform constraint must exist otherwise toolchain resolution will fail.
    use_default_package = True,                 # only if you're using reference integration QNX SDP package provided by QNX for S-CORE.
    license_path = "/path/to/your/qnx/license", # default location `/opt/score_qnx/license/licenses`
)

use_repo(gcc, "qnx_toolchain")
```

For other target architectures and SDP versions, adjust `target_cpu` and `sdp_version` accordingly.

#### Step 2: Add Bazel Configuration

Create or update `.bazelrc` in your repository root:

```text
# QNX target configurations
build:x86_64-qnx --platforms=@score_bazel_platforms//:x86_64-qnx-sdp_8.0.0-posix
build:x86_64-qnx --extra_toolchains=@qnx_toolchain//:x86_64-qnx-sdp_8.0.0
build:x86_64-qnx --sandbox_writable_path=/var/tmp

build:aarch64-qnx --platforms=@score_bazel_platforms//:aarch64-qnx-sdp_8.0.0-posix
build:aarch64-qnx --extra_toolchains=@qnx_toolchain//:aarch64-qnx-sdp_8.0.0
build:aarch64-qnx --sandbox_writable_path=/var/tmp
```

> NOTE: Configuration variables are just an example, it's not mandatory to use exact configuration variables.

#### Step 3: Test the Integration

Create a simple test in your repository root:

```bash
# Test x86_64-qnx build
bazel build --config=x86_64-qnx //your/target:name

# Test aarch64-qnx build
bazel build --config=aarch64-qnx //your/target:name
```

#### Step 4: Add to CI/CD

Update your CI/CD pipeline to test QNX configurations:

```yaml
# Example for GitHub Actions
- name: Build for QNX
  run: |
    bazel build --config=x86_64-qnx //...
    bazel test --config=x86_64-qnx //...
```

> NOTE: For running tests, host platform must be QNX or use `--run_under=`. Check Bazel documentation for details.

### Common Integration Patterns

**Multi-target Modules**: If your module targets multiple architectures:

```starlark
gcc.toolchain(
    name = "qnx_x86_64",
    target_cpu = "x86_64",
    target_os = "qnx",
    sdp_version = "8.0.0",
    use_default_package = True,
)

gcc.toolchain(
    name = "qnx_aarch64",
    target_cpu = "aarch64",
    target_os = "qnx",
    sdp_version = "7.1.0",
    use_default_package = True,
)
```

---

## Reference: Technical Details for QNX Integration

### Obtaining QNX SDP and Licenses

#### QNX Software Development Platform (SDP)

The QNX SDP packages are obtained from the official QNX Software repositories:

- **QNX Momentics IDE and SDPs**: https://www.qnx.com/developers/downloads.html
- **QNX Documentation Portal**: https://www.qnx.com/developers/docs/
- **Account Registration**: https://account.qnx.com/

QNX SDP packages are typically distributed as `.tar.gz` or `.tar.bz2` archives and
contain the host tools (compiler, linker, archiver) and target libraries/headers.

#### Licensing

QNX toolchains require a valid QNX license to execute.

### SDP Installation Layout

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

### Environment Variables

The QNX toolchain automatically manages `QNX_HOST` and `QNX_TARGET` through the
`sdp_env` feature and does not require explicit user configuration.

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
[Step 2: Add Bazel Configuration](#step-2-add-bazel-configuration)), you can simplify to:
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

---

## Quick Start: Using QNX

If your module already has QNX support configured, follow these minimal steps to build for QNX.

### Prerequisites

1. **Access to QNX SDP package**: Your module downloads the SDP package automatically; you just need network access to the QNX repository
2. **Valid QNX license**: Ensure the license file is accessible at `/opt/score_qnx/license/licenses` (or a custom path configured for your module)
3. **Bazel installed**: Version 8.0 or later

> NOTE: Access to QNX repository is only needed in case you're using reference integration QNX SDP. In case of enterprise package please contact your QNX representative. 

### Building for QNX

Once your module has QNX configured (see your module's documentation for setup), build with:

```bash
# For x86_64 target
bazel build --config=x86_64-qnx //...

# For aarch64 target
bazel build --config=aarch64-qnx //...
```

### Running Tests

Tests can only run on a QNX platform or with `--run_under=`. For builds only:

```bash
# Build only (no test execution on non-QNX hosts)
bazel build --config=x86_64-qnx //...
```

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails with license errors | Check that QNX license is at `/opt/score_qnx/license/licenses` or ask your module maintainer for license configuration |
| Bazel fails to download SDP | Verify you have network access to https://www.qnx.com and check if credentials are configured (see your module's documentation) |
| Permission denied on `/var/tmp` | This is typically auto-configured; if you see errors, check your module's `.bazelrc` setup |

For detailed information about the toolchain, see [Reference: Technical Details](#reference-technical-details-for-qnx-integration).

---

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

---

## Licensing

QNX toolchains require a valid license to execute at build time. This section covers
all license-related configuration options.

### Obtaining a QNX License

- If you don't have a QNX license, obtain one from **QNX Licensing Portal**: https://www.qnx.com/
- If you want to use QNX free community license **QNX Everywhere**: https://www.qnx.com/developers/docs/qnxeverywhere/index.html

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

---

## Documenting QNX Support

This section is for module maintainers who want to document QNX support for their contributors.

### Why This Matters

When your module has QNX support integrated, contributors cloning your repository need clear instructions on how to:
- Set up their local environment
- Run builds and tests for QNX targets
- Troubleshoot common issues

This guide provides a template you can adapt and include in your module's documentation.

### Recommended Documentation Template

Create a file in your repository (e.g., `docs/QNX_SETUP.md` or add to `CONTRIBUTING.md`) with the following content, customized for your module:

---

#### **QNX Setup for Contributors**

This module supports building for QNX targets. Follow these steps to set up your environment.

##### Prerequisites

1. **Access to QNX SDP**
   - Verify that you have access to QNX SDP.
   - Extract the content for verification.

2. **Obtain QNX License**
   - Request from: https://www.qnx.com/company/contact-us/ (or contact your Project Lead)
   - Store the license file at: `/opt/score_qnx/license/licenses` (or configure custom path)

3. **Install Bazel**
   - Version 8.0 or later
   - Visit: https://bazel.build/install

##### Building for QNX

Build for your target architecture:

```bash
# x86_64-qnx
bazel build --config=x86_64-qnx //...

# aarch64-qnx
bazel build --config=aarch64-qnx //...
```

##### Running Tests for QNX (on QNX platform)

```bash
# x86_64-qnx
bazel test --config=x86_64-qnx //...

# aarch64-qnx
bazel test --config=aarch64-qnx //...
```

##### Troubleshooting

| Issue | Solution |
|-------|----------|
| `License not found` | Verify `QNX_SHARED_LICENSE_FILE` points to valid license file, or check default path `/opt/score_qnx/license/licenses` |
| `QNX_HOST/QNX_TARGET not set` | Ensure SDP is properly extracted; the toolchain sets these automatically if the path is correct |
| `Permission denied on /var/tmp` | Ensure `--sandbox_writable_path=/var/tmp` is in `.bazelrc` or `.bazelrc.local` |
| `qcc: command not found` | Verify QNX_HOST points to the correct host tools directory within your SDP |

---

### Customization Checklist

When adapting the template above for your module, consider:

- [ ] **Replace SDP version**: Update `8.0.0` to your module's target SDP version
- [ ] **Update paths**: Adapt default paths and examples to your environment conventions
- [ ] **Update configuration variables**: Adapt configuration variables to your moodule configurations
- [ ] **Add module-specific targets**: Include examples of building your actual targets, not just generic `//...`
- [ ] **CI/CD documentation**: Document how QNX is tested in your CI pipeline (GitHub Actions, GitLab CI, etc.)
- [ ] **Known limitations**: Note any features not yet supported on QNX
- [ ] **Additional resources**: Link to your module's main README, contribution guidelines, etc.
- [ ] **License details**: If your module requires special license setup, document it here
- [ ] **Contact information**: Provide a way for contributors to ask questions (GitHub issues, Slack channel, etc.)

### Integration into Your Repository

**Option 1: Separate documentation file**
Create `docs/QNX_SETUP.md` with detailed QNX setup instructions.

**Option 2: Embedded in CONTRIBUTING.md**
Add a "QNX Setup" section to your existing contribution guidelines.

**Option 3: Embedded in README.md**
Add a brief section with a link to more detailed QNX documentation elsewhere.

**Recommendation**: Start with Option 1 (separate file) for clarity, then reference it from `CONTRIBUTING.md` or `README.md`.