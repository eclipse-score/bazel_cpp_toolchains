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

# Fast LLVM repository

## Purpose

`fast_llvm_repo` creates the prebuilt LLVM distribution repository consumed by
[`toolchains_llvm`](https://github.com/bazel-contrib/toolchains_llvm). It is a
performance-oriented alternative to the repository that `toolchains_llvm`
normally generates internally.

The rule is useful when LLVM setup is a significant part of the developer or
CI feedback time. In the measurements that motivated it, LLVM setup decreased
from roughly 220 seconds to 70 seconds. The exact result depends on the host;
the rule is not required for correctness.

## Usage with Bzlmod

The consuming module needs both `toolchains_llvm` and this module. The LLVM
version must currently be kept in sync in the two tags below:

```starlark
bazel_dep(name = "score_bazel_cpp_toolchains", version = "0.5.4", dev_dependency = True)
bazel_dep(name = "toolchains_llvm", version = "1.8.0", dev_dependency = True)

llvm = use_extension(
    "@toolchains_llvm//toolchain/extensions:llvm.bzl",
    "llvm",
    dev_dependency = True,
)
llvm.toolchain(
    name = "llvm_toolchain",
    llvm_version = "22.1.7",
)

fast_llvm_repo = use_repo_rule(
    "@score_bazel_cpp_toolchains//rules:fast_llvm_repo.bzl",
    "fast_llvm_repo",
)
fast_llvm_repo(
    name = "llvm_toolchain_llvm",
    llvm_version = "22.1.7",
)

# Keep the generated toolchain configuration, but replace its LLVM root.
llvm.toolchain_root(label = "@llvm_toolchain_llvm//:BUILD")

use_repo(llvm, "llvm_toolchain")
```

The repository name `llvm_toolchain_llvm` is intentional: it is the name that
`toolchains_llvm` normally derives for the LLVM distribution. The generated
`BUILD.bazel` is based on `toolchains_llvm`'s `BUILD.llvm_repo.tpl`, so the
existing toolchain configuration can continue to refer to the same layout.

## What the rule does

For the requested LLVM version, the rule:

1. rejects non-Linux hosts and selects the archive for the host architecture,
2. downloads it with a pinned SHA-256 checksum,
3. extracts it with parallel `xz -T0` output streamed to `tar`, using Bash's
   `pipefail` to check both process exit codes,
4. renders the BUILD file expected by `toolchains_llvm`.

The parallel XZ pipeline is the main optimization. It changes the extraction
implementation while leaving the LLVM archive, checksum verification, and
toolchain target layout intact.

## Why not `http_archive`?

`http_archive` can functionally download and unpack a `tar.xz`. However,
`toolchains_llvm` already uses Bazel's standard repository download-and-extract
mechanism for the LLVM repository it creates internally. That
`download_and_extract()` path is the slow part this rule is intended to
replace.

`http_archive` does not provide a switch to use the parallel `xz -T0` pipeline,
and `patch_cmds` run only after extraction. Using `http_archive` would therefore
not provide the performance improvement.

If the additional extraction time is acceptable, the original
`toolchains_llvm` setup remains the simpler option. This rule exists for the
case where the measured setup time justifies the additional repository-rule
maintenance.

## Scope and trade-offs

This is intentionally a small, specialized rule rather than a replacement for
`http_archive` or `toolchains_llvm`:

- only the versions and Linux architectures listed in
  [`fast_llvm_repo.bzl`](../rules/fast_llvm_repo.bzl) are supported;
- the fast path requires `bash`, `tar`, and `xz` on the host;
- the version/checksum table must be kept aligned with `toolchains_llvm`;
- the rule uses `toolchains_llvm`'s internal BUILD template, so upgrades of
  that dependency need to be checked; and
- the `llvm_version` values in the two module tags must not diverge.
