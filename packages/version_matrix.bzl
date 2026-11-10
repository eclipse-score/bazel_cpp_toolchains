# *******************************************************************************
# Copyright (c) 2025 Contributors to the Eclipse Foundation
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

""" Configuration file holding list of predefeined GCC/SDP packages.
"""

VERSION_MATRIX = {
    "aarch64-linux-gcc_12.2.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/aarch64/gcc/12.2.0:gcc.BUILD",
        "sha256": "7279b1adb50361b21f5266b001980b6febb35fa8d83170901196b9edae3f06d9",
        "strip_prefix": "aarch64-unknown-linux-gnu",
        "url": "https://github.com/eclipse-score/toolchains_gcc_packages/releases/download/v0.0.4/aarch64-unknown-linux-gnu_gcc12.tar.gz",
    },
    "aarch64-linux-gcc_15.3.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/aarch64/gcc/15.3.0:gcc.BUILD",
        "sha256": "ff9fe6caed22f15a1dd87a93bff5cfa1536b5dddcff3364827f97ebc01a494a1",
        "strip_prefix": "aarch64-unknown-linux-gnu",
        "url": "https://github.com/eclipse-score/toolchains_gcc_packages/releases/download/v0.0.5/aarch64-unknown-linux-gnu_gcc15.tar.gz",
    },
    "aarch64-linux-autosd10": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/aarch64/autosd/10.0:autosd.BUILD",
        "extra_c_compile_flags": [
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc/aarch64-redhat-linux/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include",
        ],
        "extra_cxx_compile_flags": [
            "-nostdinc++",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/c++/14",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/c++/14/aarch64-redhat-linux",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/c++/14/backward",
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc/aarch64-redhat-linux/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include",
        ],
        "extra_link_flags": [
            "-B",
            "external/%{toolchain_pkg}%/usr/bin",
            "-L",
            "external/%{toolchain_pkg}%/lib64",
            "-L",
            "external/%{toolchain_pkg}%/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/gcc/aarch64-redhat-linux/14",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib64",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib",
            "-lm",
            "-ldl",
            "-lrt",
            "-lstdc++",
        ],
        "sha256": "981183eefabbfb1c8e7c7eebd9bc18ca4ab9d50ba4e3b4914cf94a0d971f0353",
        "strip_prefix": "sysroot",
        "url": "https://github.com/eclipse-score/os_autosd/releases/download/v0.2.0/autosd-toolchain-aarch64.tar.gz",
    },
    "aarch64-linux-autosd10-crossland": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/aarch64/autosd/10.0:autosd_cross.BUILD",
        "extra_c_compile_flags": [
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/x86_64/usr/lib/gcc/aarch64-redhat-linux/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/aarch64/usr/include",
        ],
        "extra_cxx_compile_flags": [
            "-nostdinc++",
            "-isystem",
            "external/%{toolchain_pkg}%/aarch64/usr/include/c++/14",
            "-isystem",
            "external/%{toolchain_pkg}%/aarch64/usr/include/c++/14/aarch64-redhat-linux",
            "-isystem",
            "external/%{toolchain_pkg}%/aarch64/usr/include/c++/14/backward",
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/x86_64/usr/lib/gcc/aarch64-redhat-linux/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/aarch64/usr/include",
        ],
        "extra_link_flags": [
            "-B",
            "external/%{toolchain_pkg}%/x86_64/usr/bin",
            "-L",
            "external/%{toolchain_pkg}%/x86_64/usr/lib/gcc/aarch64-redhat-linux/14",
            "-L",
            "external/%{toolchain_pkg}%/aarch64/lib64",
            "-L",
            "external/%{toolchain_pkg}%/aarch64/lib",
            "-L",
            "external/%{toolchain_pkg}%/aarch64/usr/lib64",
            "-L",
            "external/%{toolchain_pkg}%/aarch64/usr/lib",
            "-lm",
            "-ldl",
            "-lrt",
            "-lstdc++",
        ],
        "sha256": "c21025ddc5310c04d0203551ad1cbd1d60cc10842d91ca96c81dbdd9a2373a03",
        "strip_prefix": "sysroot",
        "url": "https://github.com/eclipse-score/os_autosd/releases/download/v0.2.0/autosd-toolchain-crossland.tar.gz",
    },
    "qnx-sdp_8.0.4": {
        "build_file": "@score_bazel_cpp_toolchains//packages/qnx/sdp/8.0:sdp.BUILD",
        "sha256": "146312c0bf22aab66e8294a06403f2ec6cfeeb074d8fa11549faffd84b7fe778",
        "strip_prefix": "",
        "url": "https://www.qnx.com/download/download/88447/installation_qnx_804_260520.tar.xz",
        "gcc_version": "12.2.0",
    },
    "qnx-sdp_8.0.5": {
        "build_file": "@score_bazel_cpp_toolchains//packages/qnx/sdp/8.0:sdp.BUILD",
        "sha256": "eaf000e6d8fe8b96685a0c0d5041e9fe62fe36c9fc3f0854033a7be9fbec8c89",
        "strip_prefix": "",
        "type": "tar.gz",
        "url": "https://api.github.com/repos/eclipse-score/qnx_sdp_pkg/releases/assets/706198299",
        "gcc_version": "12.2.0",
    },
    "x86_64-linux-gcc_12.2.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/x86_64/gcc/12.2.0:gcc.BUILD",
        "sha256": "e9b9a7a63a5f8271b76d6e2057906b95c7a244e4931a8e10edeaa241e9f7c11e",
        "strip_prefix": "x86_64-unknown-linux-gnu",
        "url": "https://github.com/eclipse-score/toolchains_gcc_packages/releases/download/v0.0.4/x86_64-unknown-linux-gnu_gcc12.tar.gz",
    },
    "x86_64-linux-gcc_15.3.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/x86_64/gcc/15.3.0:gcc.BUILD",
        "sha256": "c65e21725d4d9993bab0b4ef2aed7065a4bf1b0f232a068d778eb670f80daa60",
        "strip_prefix": "x86_64-unknown-linux-gnu",
        "url": "https://github.com/eclipse-score/toolchains_gcc_packages/releases/download/v0.0.5/x86_64-unknown-linux-gnu_gcc15.tar.gz",
    },
    "x86_64-linux-autosd10": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/x86_64/autosd/10.0:autosd.BUILD",
        "extra_c_compile_flags": [
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc/x86_64-redhat-linux/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include",
        ],
        "extra_cxx_compile_flags": [
            "-nostdinc++",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/c++/14",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/c++/14/x86_64-redhat-linux",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/c++/14/backward",
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc/x86_64-redhat-linux/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include",
        ],
        "extra_link_flags": [
            "-B",
            "external/%{toolchain_pkg}%/usr/bin",
            "-L",
            "external/%{toolchain_pkg}%/lib64",
            "-L",
            "external/%{toolchain_pkg}%/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/gcc/x86_64-redhat-linux/14",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib64",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib",
            "-lm",
            "-ldl",
            "-lrt",
            "-lstdc++",
        ],
        "sha256": "1ab0d9760b6dfcc1aca0b22ef085c2e9ffc10ddaa049f992d560152900d4e775",
        "strip_prefix": "sysroot",
        "url": "https://github.com/eclipse-score/os_autosd/releases/download/v0.2.0/autosd-toolchain-x86_64.tar.gz",
    },
    "aarch64-linux-sdk_2.0.0-beta2-ebclfsa": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/aarch64/ebclfsa/2.0.0-beta2:ebclfsa.BUILD",
        "extra_c_compile_flags": [
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc-cross/aarch64-linux-gnu/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/lib/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/x86_64-linux-gnu",
            "--no-canonical-prefixes",
        ],
        "extra_cxx_compile_flags": [
            "-nostdinc++",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include/c++/14",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include/c++/14/aarch64-linux-gnu",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include/c++/14/backward",
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc-cross/aarch64-linux-gnu/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/lib/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/x86_64-linux-gnu",
            "--no-canonical-prefixes",
        ],
        "extra_link_flags": [
            "-B",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/bin",
            "-L",
            "external/%{toolchain_pkg}%/lib/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/x86_64-linux-gnu",
            "-lm",
            "-ldl",
            "-lrt",
            "-static-libstdc++",
            "-static-libgcc",
            "-static",
            "--no-canonical-prefixes",
        ],
        # No `compiler_library_search_paths` on purpose: the SDK host binaries already
        # carry an $ORIGIN rpath to their own libraries, and exporting the SDK's
        # glibc 2.41 via LD_LIBRARY_PATH would also be inherited by Bazel's own
        # process-wrapper, which is linked against the (older) host glibc.
        "strip_prefix": "fastdev-sdk-trixie-ebclfsa-ebcl-qemuarm64",
        "sha256": "4cf7f0191988795f316f276b56e370ad60fc371954a881d158ebba0284d9d3f5",
        "url": "https://github.com/Elektrobit/eb_corbos_toolkit/releases/download/v2.0.0-beta2/fastdev-sdk-trixie-ebclfsa-ebcl-qemuarm64.tar.gz",
        # The SDK host binaries carry an $ORIGIN rpath into the SDK's own glibc 2.41
        # but still request the host loader (/lib64/ld-linux-x86-64.so.2). Running a
        # newer libc under an older ld.so aborts with "stack smashing detected", so
        # repoint the interpreter at the SDK loader (what relocate-sdk.sh does).
        # Rewrites the ELF interpreter of every host executable shipped by an EB corbos
        # SDK to the loader bundled with that SDK. This is the same operation the SDK's
        # own `relocate-sdk.sh` performs; it is inlined here because neither `patchelf`
        # nor `file` can be assumed to exist on the host, and the SDK-provided `patchelf`
        # cannot start before the interpreter is fixed (hence the explicit loader call).
        # Each entry of `patch_cmds` is passed to a separate `bash -c`, so this has to
        # stay a single command.
        "patch_cmds": [
            "sdk=$(pwd); " +
            "loader=$sdk/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2; " +
            "test -x \"$loader\" -a -x \"$sdk/usr/bin/patchelf\" || exit 1; " +
            # patchelf lives inside the tree that is about to be rewritten, so work on a copy.
            "tmp=$(mktemp -d); cp \"$sdk/usr/bin/patchelf\" \"$tmp/patchelf\"; " +
            "run_patchelf() { \"$loader\" --library-path \"$sdk/usr/lib/x86_64-linux-gnu:$sdk/lib/x86_64-linux-gnu\" \"$tmp/patchelf\" \"$@\"; }; " +
            "for binary in $(find usr/bin usr/sbin usr/libexec/gcc* usr/lib/gcc-cross usr/lib/llvm-*/bin -type f -perm -u+x 2>/dev/null); do " +
            "interpreter=$(run_patchelf --print-interpreter \"$binary\" 2>/dev/null) || continue; " +
            "test -n \"$interpreter\" || continue; " +
            "run_patchelf --set-interpreter \"$loader\" \"$binary\" >/dev/null 2>&1 || true; " +
            "done; " +
            "rm -rf \"$tmp\"",
        ],
    },
    "aarch64-linux-sdk_2.0.0-beta3-ebclfsa": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/aarch64/ebclfsa/2.0.0-beta3:ebclfsa.BUILD",
        "extra_c_compile_flags": [
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc-cross/aarch64-linux-gnu/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/lib/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/x86_64-linux-gnu",
            "--no-canonical-prefixes",
        ],
        "extra_cxx_compile_flags": [
            "-nostdinc++",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include/c++/14",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include/c++/14/aarch64-linux-gnu",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include/c++/14/backward",
            "-nostdinc",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/lib/gcc-cross/aarch64-linux-gnu/14/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/include",
            "-isystem",
            "external/%{toolchain_pkg}%/usr/include/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/lib/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/x86_64-linux-gnu",
            "--no-canonical-prefixes",
        ],
        "extra_link_flags": [
            "-B",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/bin",
            "-L",
            "external/%{toolchain_pkg}%/lib/aarch64-linux-gnu",
            "-L",
            "external/%{toolchain_pkg}%/usr/aarch64-linux-gnu/lib",
            "-L",
            "external/%{toolchain_pkg}%/usr/lib/x86_64-linux-gnu",
            "-lm",
            "-ldl",
            "-lrt",
            "-static-libstdc++",
            "-static-libgcc",
            "-static",
            "--no-canonical-prefixes",
        ],
        # No `compiler_library_search_paths` on purpose: the SDK host binaries already
        # carry an $ORIGIN rpath to their own libraries, and exporting the SDK's
        # glibc 2.41 via LD_LIBRARY_PATH would also be inherited by Bazel's own
        # process-wrapper, which is linked against the (older) host glibc.
        "strip_prefix": "fastdev-sdk-trixie-ebclfsa-ebcl-qemuarm64",
        "sha256": "72632b0925b1440e6470b429a97c62fb391bb3bf304adb11e6b79fa4410affc3",
        "url": "https://github.com/Elektrobit/eb_corbos_toolkit/releases/download/v2.0.0-beta3/fastdev-sdk-trixie-ebclfsa-ebcl-qemuarm64.tar.gz",
        # The SDK host binaries carry an $ORIGIN rpath into the SDK's own glibc 2.41
        # but still request the host loader (/lib64/ld-linux-x86-64.so.2). Running a
        # newer libc under an older ld.so aborts with "stack smashing detected", so
        # repoint the interpreter at the SDK loader (what relocate-sdk.sh does).
        # Rewrites the ELF interpreter of every host executable shipped by an EB corbos
        # SDK to the loader bundled with that SDK. This is the same operation the SDK's
        # own `relocate-sdk.sh` performs; it is inlined here because neither `patchelf`
        # nor `file` can be assumed to exist on the host, and the SDK-provided `patchelf`
        # cannot start before the interpreter is fixed (hence the explicit loader call).
        # Each entry of `patch_cmds` is passed to a separate `bash -c`, so this has to
        # stay a single command.
        "patch_cmds": [
            "sdk=$(pwd); " +
            "loader=$sdk/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2; " +
            "test -x \"$loader\" -a -x \"$sdk/usr/bin/patchelf\" || exit 1; " +
            "tmp=$(mktemp -d); cp \"$sdk/usr/bin/patchelf\" \"$tmp/patchelf\"; " +
            "run_patchelf() { \"$loader\" --library-path \"$sdk/usr/lib/x86_64-linux-gnu:$sdk/lib/x86_64-linux-gnu\" \"$tmp/patchelf\" \"$@\"; }; " +
            "for binary in $(find usr/bin usr/sbin usr/libexec/gcc* usr/lib/gcc-cross usr/lib/llvm-*/bin -type f -perm -u+x 2>/dev/null); do " +
            "interpreter=$(run_patchelf --print-interpreter \"$binary\" 2>/dev/null) || continue; " +
            "test -n \"$interpreter\" || continue; " +
            "run_patchelf --set-interpreter \"$loader\" \"$binary\" >/dev/null 2>&1 || true; " +
            "done; " +
            "rm -rf \"$tmp\"",
        ],
    },
}

# Both integrity variants share archive metadata; the HI profile additionally
# repairs LLVM's host-library lookup without exporting LD_LIBRARY_PATH.
_EBCLFSA_HI_ROOT = "external/%{toolchain_pkg}%"
_EBCLFSA_HI_C_FLAGS = [
    "--target=aarch64-linux-gnu",
    "-nostdinc",
    "-isystem",
    _EBCLFSA_HI_ROOT + "/opt/lisa-libc/include",
    "-isystem",
    _EBCLFSA_HI_ROOT + "/usr/lib/llvm-20/lib/clang/20/include",
    "-fno-omit-frame-pointer",
    "-ffunction-sections",
    "-fdata-sections",
]
VERSION_MATRIX["aarch64-linux-sdk_2.0.0-beta3-ebclfsa-hi"] = dict(
    VERSION_MATRIX["aarch64-linux-sdk_2.0.0-beta3-ebclfsa"],
    compiler = "clang",
    target_libc = "musl",
    build_file = "@score_bazel_cpp_toolchains//packages/linux/aarch64/ebclfsa/2.0.0-beta3:ebclfsa_hi.BUILD",
    # Keep host libraries local to the tools, not in the action environment:
    # LD_LIBRARY_PATH would also affect Bazel's host process-wrapper.
    patch_cmds = [
        "set -eu; sdk=$(pwd); libs=$sdk/usr/lib/x86_64-linux-gnu; " +
        "loader=$libs/ld-linux-x86-64.so.2; " +
        "tmp=$(mktemp -d); trap 'rm -rf \"$tmp\"' EXIT; " +
        "cp \"$sdk/usr/bin/patchelf\" \"$tmp/patchelf\"; " +
        "run_patchelf() { \"$loader\" --library-path \"$libs/sdk-libc:$libs\" \"$tmp/patchelf\" \"$@\"; }; " +
        "for binary in usr/lib/llvm-20/bin/clang usr/lib/llvm-20/bin/lld " +
        "usr/bin/aarch64-linux-gnu-ar usr/bin/aarch64-linux-gnu-strip " +
        "usr/bin/aarch64-linux-gnu-readelf usr/bin/lisa-elf-enabler; do " +
        "run_patchelf --set-interpreter \"$loader\" \"$binary\"; " +
        "run_patchelf --force-rpath --set-rpath \"$libs/sdk-libc:$libs\" \"$binary\"; " +
        "done; " +
        "run_patchelf --force-rpath --set-rpath '$ORIGIN/sdk-libc:$ORIGIN' \"$libs/libLLVM.so.20.1\"",
    ],
    extra_c_compile_flags = _EBCLFSA_HI_C_FLAGS,
    extra_cxx_compile_flags = [
        "-nostdinc++",
        "-isystem",
        _EBCLFSA_HI_ROOT + "/opt/lisa-libcxx/include/c++/v1",
        "-fno-exceptions",
        "-fno-rtti",
    ] + _EBCLFSA_HI_C_FLAGS,
    extra_link_flags = [
        "--target=aarch64-linux-gnu",
        "--ld-path=" + _EBCLFSA_HI_ROOT + "/usr/lib/llvm-20/bin/ld.lld",
        "-nostdlib",
        "-static",
        "-Wl,--start-group",
        _EBCLFSA_HI_ROOT + "/opt/lisa-libcxx/lib/libc++.a",
        _EBCLFSA_HI_ROOT + "/opt/lisa-libcxx/lib/libc++abi.a",
        _EBCLFSA_HI_ROOT + "/usr/lib/llvm-20/lib/clang/20/lib/linux/libclang_rt.builtins-aarch64.a",
        _EBCLFSA_HI_ROOT + "/opt/lisa-libc/lib/aarch64-linux-gnu/crt1.o",
        _EBCLFSA_HI_ROOT + "/opt/lisa-libc/lib/aarch64-linux-gnu/libc.a",
        "-Wl,--end-group",
    ],
)
