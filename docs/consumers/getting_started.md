<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Build with a Linux toolchain

This guide helps Bazel module maintainers configure an x86_64 Linux toolchain
and build a C++ target. For QNX, see
[Integrate a QNX toolchain](qnx_integration.md). For implementation details,
see [Maintenance](../contributors/maintenance.md).

## Before you begin

- Use an x86_64 Linux host with Bazel installed. The repository pins Bazel
  8.8.2 in `.bazelversion`.
- Ensure the host can access the S-CORE Bazel registry and the default
  toolchain package. The package URL and checksum are in the
  [version matrix](../../packages/version_matrix.bzl).
- Start with a Bazel module. The example uses module version `0.5.4`, as does
  this repository's test workspace; select a published version that provides
  the toolchain configuration you need. This documentation describes the
  checked-out source, which can differ from a published release.

## Declare the toolchain

1. Add the module dependencies and toolchain declaration to `MODULE.bazel`:

   ```starlark
   bazel_dep(name = "score_bazel_platforms", version = "1.3.0")
   bazel_dep(name = "score_bazel_cpp_toolchains", version = "0.5.4")
   bazel_dep(name = "rules_cc", version = "0.2.25")

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

2. Add registry and toolchain selection to `.bazelrc`:

   ```text
   common --registry=https://raw.githubusercontent.com/eclipse-score/bazel_registry/main/
   common --registry=https://bcr.bazel.build
   build:x86_64-linux --host_platform=@score_bazel_platforms//:x86_64-linux-gcc_12.2.0-posix
   build:x86_64-linux --extra_toolchains=@score_gcc_toolchain//:x86_64-linux-gcc_12.2.0
   ```

   These settings follow the host configuration in
   [`tests/.bazelrc`](../../tests/.bazelrc). `--host_platform` sets the host
   platform; Bazel uses it as the target platform unless you select another
   with `--platforms`.

3. Add a C++ target to `BUILD` in the module root:

   ```starlark
   load("@rules_cc//cc:defs.bzl", "cc_binary")

   cc_binary(
       name = "hello",
       srcs = ["hello.cc"],
   )
   ```

4. Add the source to `hello.cc` in the same directory:

   ```cpp
   #include <iostream>

   int main() {
     std::cout << "Hello from the toolchain\n";
   }
   ```

5. From the module root, build and run the target:

   ```bash
   bazel run --config=x86_64-linux //:hello
   ```

   Confirm that the command succeeds and prints `Hello from the toolchain`.

## What's next

- Select another package or provide an explicit archive: see
  [Extension API](extension_api.md).
- Configure features: see [Toolchain features](features.md).
- Cross-compile or validate repository changes: see
  [Tests and validation](../contributors/tests_and_validation.md).
