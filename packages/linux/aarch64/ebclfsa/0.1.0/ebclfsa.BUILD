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

"""Build file for EBcLfSA 0.1.0 toolchain package"""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(["*/**/*"], exclude = ["usr/share/ca-certificates/**","usr/lib/ssl/certs/**", "lib/ssl/certs/**", "etc/ssl/certs/**", "usr/share/man/**", "usr/share/perl/**", "var/lib/**"]),
)

filegroup(
    name = "bin",
    srcs = ["usr/bin"],
)

filegroup(
    name = "ar",
    srcs = ["usr/bin/aarch64-linux-gnu-ar"],
)

filegroup(
    name = "cc",
    srcs = ["usr/bin/aarch64-linux-gnu-gcc-13.bin"],
)

filegroup(
    name = "gcov",
    srcs = ["usr/bin/aarch64-linux-gnu-gcov-13"],
)

filegroup(
    name = "cxx",
    srcs = ["usr/bin/aarch64-linux-gnu-g++-13.bin"],
)

filegroup(
    name = "strip",
    srcs = ["usr/bin/aarch64-linux-gnu-strip"],
)

filegroup(
    name = "elf-enabler",
    srcs = ["usr/bin/lisa-elf-enabler"],
)

filegroup(
    name = "ld_library_paths",
    srcs = ["usr/lib/x86_64-linux-gnu", "lib/x86_64-linux-gnu"],
)

# The sysroot for EBcLfSA is the entire extracted directory
filegroup(
    name = "sysroot_dir",
    srcs = ["."],
)
