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

# EBcLfSA ELF Enabler

`lisa-elf-enabler` belongs to the EBcLfSA SDK. Each Linux toolchain repository
generated with `runtime_ecosystem = "ebclfsa"` exports an `elf_enabler.bzl`
entry point bound to its own SDK package.

Configure and import that toolchain using the GCC extension in `MODULE.bazel`:

```starlark
gcc = use_extension("@score_bazel_cpp_toolchains//extensions:gcc.bzl", "gcc")
gcc.toolchain(
    name = "my_ebclfsa_toolchain",
    runtime_ecosystem = "ebclfsa",
    sdk_version = "2.0.0-beta2",
    target_cpu = "aarch64",
    target_os = "linux",
    use_default_package = True,
)
use_repo(gcc, "my_ebclfsa_toolchain")
```

Then use the SDK-bound rule in a `BUILD` file:

```starlark
load("@my_ebclfsa_toolchain//:elf_enabler.bzl", "elf_enabler")

elf_enabler(
    name = "my_result",
    src = ":some_executable",
)
```

There is no public `tool`, `tool_data`, or SDK override attribute. The rule
encapsulates the `:elf-enabler` and `:all_files` targets from the same SDK
package used by the named toolchain (including `sdp_to_link` configurations).
The EBcLfSA 2.0.0-beta2 package exposes the enabler as
`usr/bin/lisa-elf-enabler`. Older or custom packages must expose the same
`:elf-enabler` contract; missing tools fail the build rather than falling back
to another SDK or a program on `PATH`.

Multiple SDKs can coexist: load the entry point from the toolchain matching
the executable's SDK. This selection is explicit in the `load`, not inferred
from the executable or the active C++ toolchain.

## Contract

- `src` must provide exactly one file, normally a `cc_binary` output. It stays
  in the target configuration and may be cross-compiled.
- The SDK's enabler and files are private dependencies in the execution
  configuration. They must work on the build execution platform;
  the input executable is never run during post-processing.
- The rule copies `src` to a regular output file named after the target, sets
  mode `0755`, and invokes `lisa-elf-enabler <output>`. This assumes the
  enabler modifies its argument **in place**. It never modifies the original
  Bazel output. Tool failures fail the build.
- The SDK's `:all_files` are available in the sandbox, preserving its relative
  layout for tool dependencies. The rule does not recreate an SDK environment
  or configure dynamic library search paths.
- The action needs a POSIX shell, `cp`, and `chmod` on the execution platform.
- The result is exposed as the sole `DefaultInfo.files` entry, not as a
  `bazel run` target; source runfiles are not forwarded.

## Tests

Run from the separate `tests/` Bazel workspace:

```bash
cd tests
bazel test --config=aarch64-linux-ebclfsa-2.0.0-beta2 //:elf_enabler_tests
```

The tests live in `tests/ebclfsa/` and use the real EBcLfSA 2.0.0-beta2 SDK
and its generated entry point. They cross-compile an AArch64 executable, check
the enabler's supervision flag and checksum section, and compare its output
byte-for-byte with a direct SDK tool invocation. They also verify unchanged
input, executable permissions, paths containing spaces, private SDK tool
selection, and single-file input validation.

The shell tests run on the Linux build host, using `readelf`;
they never execute the AArch64 binaries and require no emulator. Tests are
platform-gated to this SDK configuration and included in `//:all_tests`.
The EBcLfSA CI workflow runs the suite.
