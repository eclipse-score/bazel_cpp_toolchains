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

"""Build file for AutoSD 10 GCC toolchain package"""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(["*/**/*"]),
)

filegroup(
    name = "bin",
    srcs = ["usr/bin"],
)

filegroup(
    name = "ar",
    srcs = ["usr/bin/ar"],
)

filegroup(
    name = "cc",
    srcs = ["usr/bin/gcc"],
)

filegroup(
    name = "gcov",
    srcs = ["usr/bin/gcov"],
)

filegroup(
    name = "cxx",
    srcs = ["usr/bin/g++"],
)

filegroup(
    name = "strip",
    srcs = ["usr/bin/strip"],
)

# The sysroot for AutoSD is the entire extracted directory
# since it contains usr/ and lib64/ at the root
filegroup(
    name = "sysroot_dir",
    srcs = ["."],
)

# Builtin include directories for the compiler
# List directory paths directly (like QNX does)
filegroup(
    name = "cxx_builtin_include_directories",
    srcs = [
        "usr/lib/gcc/x86_64-redhat-linux/14/include",
        "usr/include",
        "usr/include/c++/14",
        "usr/include/c++/14/x86_64-redhat-linux",
        "usr/include/c++/14/backward",
    ],
)
