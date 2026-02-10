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
        "sha256": "8d70f31588f864e680db05b1e8053fe93655897af646335c48c2ea5bd6578947",
        "strip_prefix": "sysroot",
        "url": "https://github.com/eclipse-score/inc_os_autosd/releases/download/continuous/autosd-toolchain-aarch64.tar.gz",
    },
    "aarch64-qnx-sdp_8.0.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/qnx/aarch64/sdp/8.0.0:sdp.BUILD",
        "sha256": "f2e0cb21c6baddbcb65f6a70610ce498e7685de8ea2e0f1648f01b327f6bac63",
        "strip_prefix": "installation",
        "url": "https://www.qnx.com/download/download/79858/installation.tgz",
        "gcc_version": "12.2.0",
    },
    "x86_64-linux-gcc_12.2.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/x86_64/gcc/12.2.0:gcc.BUILD",
        "sha256": "e9b9a7a63a5f8271b76d6e2057906b95c7a244e4931a8e10edeaa241e9f7c11e",
        "strip_prefix": "x86_64-unknown-linux-gnu",
        "url": "https://github.com/eclipse-score/toolchains_gcc_packages/releases/download/v0.0.4/x86_64-unknown-linux-gnu_gcc12.tar.gz",
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
        "sha256": "525dcca237dfdff3d6c8f3650a0db77a93638141e8c91252544b37447ef9108c",
        "strip_prefix": "sysroot",
        "url": "https://github.com/eclipse-score/inc_os_autosd/releases/download/continuous/autosd-toolchain-x86_64.tar.gz",
    },
    "x86_64-qnx-sdp_8.0.0": {
        "build_file": "@score_bazel_cpp_toolchains//packages/qnx/x86_64/sdp/8.0.0:sdp.BUILD",
        "sha256": "f2e0cb21c6baddbcb65f6a70610ce498e7685de8ea2e0f1648f01b327f6bac63",
        "strip_prefix": "installation",
        "url": "https://www.qnx.com/download/download/79858/installation.tgz",
        "gcc_version": "12.2.0",
    },
}
