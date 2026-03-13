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

"""Build file for GCC external package"""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(["*/**/*"]),
)

filegroup(
    name = "bin",
    srcs = ["bin"],
)

filegroup(
    name = "ar",
    srcs = ["bin/aarch64-unknown-linux-gnu-ar"],
)

filegroup(
    name = "cc",
    srcs = ["bin/aarch64-unknown-linux-gnu-gcc"],
)

filegroup(
    name = "gcov",
    srcs = ["bin/aarch64-unknown-linux-gnu-gcov"],
)

filegroup(
    name = "cxx",
    srcs = ["bin/aarch64-unknown-linux-gnu-g++"],
)

filegroup(
    name = "strip",
    srcs = ["bin/aarch64-unknown-linux-gnu-strip"],
)

filegroup(
    name = "ld_library_paths",
    srcs = [],
)

filegroup(
    name = "sysroot_dir",
    srcs = ["aarch64-unknown-linux-gnu/sysroot"],
)