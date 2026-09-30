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

`fast_llvm_repo` is an internal repository rule consumed by the `llvm` module
extension; it is not a public entry point and is not meant to be loaded
directly from a consumer's `MODULE.bazel`.

## Usage with Bzlmod

The recommended way to consume this rule is through the `llvm` module
extension in `extensions/llvm.bzl`, which wires `fast_llvm_repo` together with
`toolchains_llvm`'s `llvm_toolchain` for you from a single version value:

```starlark
module(name = "score_llvm_probe")
bazel_dep(name = "score_bazel_cpp_toolchains", version = "0.5.4")

llvm = use_extension("@score_bazel_cpp_toolchains//extensions:llvm.bzl", "llvm")
llvm.toolchain(name = "probe_llvm", version = "19.1.1")

use_repo(llvm, "probe_llvm", "probe_llvm_pkg")
```

Consumers do not need their own `bazel_dep(toolchains_llvm)` and only need to
track a single `version` value. See
[Extension API](extension_api.md#llvm-extension-optional-faster-alternative)
for the full attribute reference.

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
- `fast_llvm_repo` itself is not meant to be used directly outside of
  `extensions/llvm.bzl`.
