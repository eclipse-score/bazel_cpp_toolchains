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

"""Repository rule for fast extraction of prebuilt LLVM distributions.

This rule is intended to be used together with `toolchains_llvm`. It creates
the LLVM distribution repository that `toolchains_llvm` normally generates,
but uses the host's parallel `xz` decompressor before streaming into `tar`.
"""

# The supported LLVM releases. Each entry maps a requested version and host
# architecture to the upstream archive Bazel downloads and verifies.
_LLVM_DISTRIBUTIONS = {
    "19.1.0": {
        "aarch64": {
            # Official prebuilt LLVM package for 64-bit ARM Linux hosts.
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.0/clang+llvm-19.1.0-aarch64-linux-gnu.tar.xz",
            # SHA-256 pinned by toolchains_llvm for this exact upstream archive.
            "sha256": "7bb54afd330fe1a1c2d4c593fa1e2dbe2abd9bf34fb3597994ff41e443cf144b",
        },
        "x86_64": {
            # Official prebuilt LLVM package for 64-bit x86 Linux hosts.
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.0/LLVM-19.1.0-Linux-X64.tar.xz",
            # SHA-256 of that archive.
            "sha256": "cee77d641690466a193d9b88c89705de1c02bbad46bde6a3b126793c0a0f2923",
        },
    },
    "19.1.1": {
        "aarch64": {
            # Official prebuilt LLVM package for 64-bit ARM Linux hosts.
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/clang+llvm-19.1.1-aarch64-linux-gnu.tar.xz",
            # SHA-256 pinned by toolchains_llvm for this exact upstream archive.
            "sha256": "414d2ebef10c5035e9df10a224e81b484dbe17d319373050d0c1b3b1467040d2",
        },
        "x86_64": {
            # Official prebuilt LLVM package for 64-bit x86 Linux hosts.
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/LLVM-19.1.1-Linux-X64.tar.xz",
            "sha256": "8204de000b6a6921f0572e038336601e3225898e9a253c8aaa43b0a5fae8a4ce",
        },
    },
    "22.1.7": {
        "aarch64": {
            # Official prebuilt LLVM package for 64-bit ARM Linux hosts.
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.7/LLVM-22.1.7-Linux-ARM64.tar.xz",
            # SHA-256 from toolchains_llvm's distribution metadata for this
            # exact upstream archive. `ctx.download` rejects altered or corrupt
            # downloads.
            "sha256": "118ca2d3ad9da34367e05735317854e7977db45dc4c02a32af58da64c23b8789",
        },
        "x86_64": {
            # Official prebuilt LLVM package for 64-bit x86 Linux hosts.
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.7/LLVM-22.1.7-Linux-X64.tar.xz",
            "sha256": "edb0522b41e261819c06ea437d249f9b8acfa413d3805bc9920eec6fb76ff830",
        },
    },
}

_ARCH_ALIASES = {
    "aarch64": "aarch64",
    "amd64": "x86_64",
    "arm64": "aarch64",
    "x86_64": "x86_64",
}

def _log(message):
    print("[fast_llvm_repo] " + message)

# Implementation of `fast_llvm_repo`. Repository rules run while Bazel is
# preparing external dependencies, before analysing or building project code.
def _fast_llvm_repo_impl(ctx):
    # The distributions below contain Linux binaries and are used as the
    # execution root by `toolchains_llvm`; do not create a repository that
    # cannot run on the host.
    if ctx.os.name.lower() != "linux":
        fail("Unsupported host operating system: %s (fast_llvm_repo supports Linux hosts only)" % ctx.os.name)

    # Verify tools needed for extraction are available in the host's PATH. The rule
    # will fail with a clear message if any of them is missing.
    tar = ctx.which("tar")
    if not tar:
        fail("tar not found in PATH")
    xz = ctx.which("xz")
    if not xz:
        fail("xz not found in PATH")
    bash = ctx.which("bash")
    if not bash:
        fail("bash not found in PATH")

    # Select the archive native to the host which will execute this toolchain.
    host_arch = _ARCH_ALIASES.get(ctx.os.arch)
    if not host_arch:
        fail("Unsupported host architecture: %s" % ctx.os.arch)

    # Look up the requested release and its host-specific archive.
    distributions = _LLVM_DISTRIBUTIONS.get(ctx.attr.llvm_version)
    dist = distributions.get(host_arch) if distributions else None

    # Fail with a useful message if MODULE.bazel asks for a version that has no
    # URL and checksum entry yet.
    if not dist:
        fail("Unsupported LLVM version/host architecture: %s/%s" % (ctx.attr.llvm_version, host_arch))

    # Choose a temporary file inside this external repository for the archive.
    archive = ctx.path("llvm.tar.xz")

    # Download the archive and verify its SHA-256 before using it.
    _log("downloading LLVM %s for %s" % (ctx.attr.llvm_version, host_arch))
    ctx.download(
        url = dist["url"],
        output = archive,
        sha256 = dist["sha256"],
    )
    _log("download completed")

    # LLVM's archive has many independently decompressible XZ blocks. Let xz
    # decode them in parallel, then stream the resulting tar file directly to
    # tar; materializing the uncompressed archive would be wasteful. Bash's
    # `pipefail` makes a decompressor failure fail the whole pipeline.

    _log("extracting LLVM with xz -T0 and tar")

    result = ctx.execute(
        [
            bash,
            "-o",
            "pipefail",
            "-c",
            "set -e; \"$1\" -T0 -dc \"$2\" | \"$3\" -xf - --strip-components=1 -C \"$4\"",
            "fast_llvm_repo",
            xz,
            archive,
            tar,
            ctx.path("."),
        ],
        # Allow the relatively large archive up to 30 minutes to unpack.
        timeout = 1800,
        # Do not suppress command output from Bazel's repository-rule log.
        quiet = False,
    )

    # Stop repository creation if extraction reported an error.
    if result.return_code:
        fail(result.stderr)
    _log("extraction completed")

    # The archive is no longer needed after extraction; leave only the LLVM
    # distribution files in the external repository.
    ctx.delete(archive)

    # Generate the BUILD file expected by toolchains_llvm. LLVM 16 and later
    # store compiler resources in a directory named by the major version.
    _log("generating BUILD.bazel")
    ctx.template(
        "BUILD.bazel",
        Label("@toolchains_llvm//toolchain:BUILD.llvm_repo.tpl"),
        substitutions = {"{LLVM_VERSION}": ctx.attr.llvm_version.split(".")[0]},
    )
    _log("llvm setup completed")

# Public repository rule used from MODULE.bazel. Its only user-facing input
# is an LLVM version.
fast_llvm_repo = repository_rule(
    implementation = _fast_llvm_repo_impl,
    attrs = {
        # Required version key used to select an entry in `_LLVM_DISTRIBUTIONS`.
        "llvm_version": attr.string(mandatory = True),
    },
)
