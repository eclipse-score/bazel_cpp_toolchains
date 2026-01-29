# S-CORE Bazel C/C++ Toolchain Configuration Repository

This repository provides the configuration layer for all S-CORE C++ toolchains used in Bazel builds.</br>
It contains **no compiler binaries**. Instead, it defines:
* Toolchain configurations
* Toolchain rules and extensions for Bzlmod
* Common compiler flags
* Templates for generating toolchain configs
* Package descriptors for external toolchain binaries
* Tests ensuring correct toolchain behavior

All toolchain binaries (GCC, QCC, etc.) are downloaded through Bazel repositories defined in consuming workspaces. </br>
This repository is structured and versioned as a Bazel module and is intended to be consumed through MODULE.bazel.

## Key Goals

* Provide a centralized, unified configuration source for all C++ toolchains used across S-CORE.
* Enforce consistency through shared flags, templates, and mandatory feature tests.
* Support multiple compilers (GCC, QCC) and multiple platforms (Linux, QNX).
* Ensure reproducible builds across architectures by separating:
    * configuration logic (this repo).
    * binary/toolchain distributions (external packages).
* Support plug-and-play toolchain activation via Bzlmod extensions.

## Repository Structure

```bash
.
│
├── extensions                   # Module extensions for GCC/QCC toolchains
│   ├── BUILD
│   └── gcc.bzl
│
├── rules                        # Bazel rule implementations for toolchains
│   ├── BUILD
│   └── gcc.bzl
│
├── packages                     # Toolchain package descriptors (no binaries)
│   ├── linux/                   # Linux toolchain versions (GCC only)
│   ├── qnx/                     # QNX SDP/QCC toolchain metadata
│   └── version_matrix.bzl       # Supported toolchain version definitions
│
├── templates                    # Templates for toolchain definition and configuration
│   ├── linux/
│   ├── qnx/
│   ├── BUILD
│   └── BUILD.template
│
├── examples                     # Functional examples for toolchain validation
│
├── docs                         # Sphinx documentation sources
│
├── tools                        # Utility scripts (e.g., QNX credential helper)
│
├── MODULE.bazel                 # Module declaration for Bzlmod
├── BUILD
├── LICENSE
├── NOTICE
└── README.md

```

## Toolchain Model

This repository does not contain compiler binaries. </br>
Instead:
- Toolchain **packages** describe how to fetch compiler binaries via `http_archive` or internal artifact storage.
- Toolchain **templates** describe how Bazel should use the binaries.
- Toolchain **rules** and **extensions** generate and register toolchains.
- Toolchain **examples** validate the toolchains.
- This separation provides:
    - Hermetic configurations
    - Full reproducibility
    - Clear ownership boundaries
    - Easy addition of new compilers or versions


## Using Toolchains in a different Bazel Module

### GCC Example (Linux x86_64)

```starlark
bazel_dep(name = "score_cpp_toolchains", version = "0.1.0")
use_extension("@score_cpp_toolchains//extensions:gcc.bzl", "gcc")
gcc(
    target_os = "linux",
    target_cpu = "x86_64",
    version = "12.2.0",
    use_default_package = True,
)
use_repo(gcc, "score_gcc_toolchain")
```

### QCC Example (QNX ARM64)

```starlark
bazel_dep(name = "score_cpp_toolchains", version = "0.2.0")
use_extension("@score_cpp_toolchains//extensions:gcc.bzl", "gcc")
gcc(
    target_os = "qnx",
    target_cpu = "arm64",
    sdp_version = "8.0.0",
    version = "12.2.0",
    use_default_package = True,
)
use_repo(gcc, "score_gcc_qnx_toolchain")
```

The registration of toolchains is done by adding command line option `--extra_toolchains=@<toolchain_repo>//:toolchain_name`
In case above this would be:
```bash
--extra_toolchains=@score_gcc_toolchain//:x86_64-linux-gcc-12.2.0
--extra_toolchains=@score_gcc_qnx_toolchain//:x86_64-qnx-sdp-8.0.0
```

> NOTE: In case that more than one toolchain needs to be defined, the registration must be protected via config flags otherwise</br>
the first toolchain that matches constraints will be selected by toolchain resolutions.

## Configuration Flags

Shared flag sets live under: 

- [linux](templates/linux/cc_toolchain_flags.bzl.template)
- [qnx](templates/qnx/cc_toolchain_config.bzl.template)

These define:

- Base C/C++ flags  
- Optimization flags  
- PIC/PIE handling  
- Debug and sanitizer modes  
- Linker behavior  
- Warning levels  

## Templates

Templates define how toolchain files are generated:

- `BUILD.template`
- `cc_toolchain_config.bzl.template`
- `cc_gcov_wrapper.template`
- `cc_toolchain_flags.bzl.template`

These templates simplify adding:

- New compiler versions  
- New compiler families  
- New OS/arch combinations  

## Testing and Validation

Testing is part of the **integration gate pipeline**.

## Examples

Example cover:

- Simple compilation ( [examples/main.cpp](./examples/main.cpp))
- Toolchain registration behavior ([examples/.bazelrc](./examples/.bazelrc))

# Documentation

Documentation uses **Sphinx** and lives in `docs/`. (Not yet prepared!)

# QNX License

## Local License File

By default, the QNX toolchain uses `/opt/score_qnx/license/licenses` as the license path.
If you want to change this location, you can override it by setting the `license_path` variable
when calling the `gcc.toolchain(...)` function in your `MODULE.bazel` file.

**Example:**

```bazel
gcc.toolchain(
    name = "score_qcc_toolchain",
    target_os = "qnx",
    ...
    license_path = "/path/to/your/custom/licenses",
)
```

> **TODO:** Is it possible to set this via environment variable?

## License Servers

In case you are using a license server for QNX licenses (FLEXlm), you can set the license server information
either locally in your module or centrally in your bazel configuration.
This also applies to floating licenses.

### Module Local Configuration

You can set the license server for your toolchains by setting the variables `license_info_variable` and
`license_info_url` when calling the `gcc.toolchain(...)` function in your `MODULE.bazel` file.

**Example (for QNXLM_LICENSE_FILE variable):**

```bazel
gcc.toolchain(
    name = "score_qcc_toolchain",
    target_os = "qnx",
    ...
    license_info_variable = "QNXLM_LICENSE_FILE",
    license_info_url = "<port>@<license_server_host>",
)
```

### Central Configuration

In case you want to set the license server for all your bazel projects you can set the
environment variable in your `~/.bazelrc` file:

**Example (for QNXLM_LICENSE_FILE variable):**

```bazel
common --action_env=QNXLM_LICENSE_FILE=<port>@<license_server_host>
```

In case you do not want to set it for all commands you can also set it per build/test command:

```bazel
build --action_env=QNXLM_LICENSE_FILE=<port>@<license_server_host>
test --action_env=QNXLM_LICENSE_FILE=<port>@<license_server_host>
```

# Adding New Toolchain Versions

1. Update `packages/version_matrix.bzl`
2. Add a package descriptor (e.g., `packages/linux/x86_64/gcc/13.1.0`)
3. Generate configuration from templates
4. Update flags if needed
5. Submit through integration gate

---

# Tools

Utility scripts such as:

```
tools/qnx_credential_helper.py
```

are used for repository authentication flows.

---

# License

Distributed under:

- `LICENSE`
- `NOTICE`
