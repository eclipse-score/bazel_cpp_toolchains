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

"""Build file for the AutoSD 10 GCC cross toolchain package (x86_64 host -> aarch64 target)"""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(["*/**/*"]),
)

filegroup(
    name = "bin",
    srcs = ["x86_64/usr/bin"],
)

# The cross archive is split into an x86_64/ host tree and an aarch64/ target
# sysroot. The host cross compiler lives under x86_64/usr/bin as target-prefixed
# aarch64-redhat-linux-* wrappers (there is no bare gcc/g++/ar/... in this
# package, unlike the native AutoSD package).
filegroup(
    name = "ar",
    srcs = ["x86_64/usr/bin/aarch64-redhat-linux-ar"],
)

filegroup(
    name = "cc",
    srcs = ["x86_64/usr/bin/aarch64-redhat-linux-gcc"],
)

filegroup(
    name = "gcov",
    srcs = ["x86_64/usr/bin/aarch64-redhat-linux-gcov"],
)

filegroup(
    name = "cxx",
    srcs = ["x86_64/usr/bin/aarch64-redhat-linux-g++"],
)

filegroup(
    name = "strip",
    srcs = ["x86_64/usr/bin/aarch64-redhat-linux-strip"],
)

# For the cross toolchain the aarch64 target sysroot is the ./aarch64 tree
# (the host-side compiler and its support files live under ./x86_64), unlike the
# native AutoSD package where the extracted root is itself the sysroot.
filegroup(
    name = "sysroot_dir",
    srcs = ["aarch64"],
)

# Builtin include directories for the compiler. The glibc/libstdc++ headers
# live in the target sysroot (aarch64/); the compiler's own builtin headers stay
# host-side under x86_64/usr/lib/gcc.
filegroup(
    name = "cxx_builtin_include_directories",
    srcs = [
        "aarch64/usr/include",
        "aarch64/usr/include/c++/14",
        "aarch64/usr/include/c++/14/backward",
        "aarch64/usr/include/c++/14/aarch64-redhat-linux",
        "x86_64/usr/lib/gcc/aarch64-redhat-linux/14/include",
    ],
)
