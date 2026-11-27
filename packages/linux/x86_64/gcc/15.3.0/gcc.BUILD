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
    srcs = ["bin/x86_64-unknown-linux-gnu-ar"],
)

filegroup(
    name = "cc",
    srcs = ["bin/x86_64-unknown-linux-gnu-gcc"],
)

filegroup(
    name = "gcov",
    srcs = ["bin/x86_64-unknown-linux-gnu-gcov"],
)

filegroup(
    name = "cxx",
    srcs = ["bin/x86_64-unknown-linux-gnu-g++"],
)

filegroup(
    name = "strip",
    srcs = ["bin/x86_64-unknown-linux-gnu-strip"],
)

filegroup(
    name = "sysroot_dir",
    srcs = ["x86_64-unknown-linux-gnu/sysroot"],
)

filegroup(
    name = "cxx_builtin_include_directories",
)

filegroup(
    name = "empty",
)

filegroup(
    name = "as",
    srcs = ["bin/x86_64-unknown-linux-gnu-as"],
)

filegroup(
    name = "ld",
    srcs = ["bin/x86_64-unknown-linux-gnu-ld"],
)

# GCC looks up as/ld relative to its own location, so the unprefixed
# binutils in the target directory are needed as well.
filegroup(
    name = "binutils_pieces",
    srcs = glob(["x86_64-unknown-linux-gnu/bin/*"]),
)

filegroup(
    name = "compiler_pieces",
    srcs = glob([
        "libexec/gcc/x86_64-unknown-linux-gnu/*/cc1*",
        "lib/gcc/x86_64-unknown-linux-gnu/*/include/**",
        "lib/gcc/x86_64-unknown-linux-gnu/*/include-fixed/**",
    ]) + [":binutils_pieces"],
)

filegroup(
    name = "linker_pieces",
    srcs = glob([
        "lib/gcc/x86_64-unknown-linux-gnu/*/*.o",
        "lib/gcc/x86_64-unknown-linux-gnu/*/lib*",
        "libexec/gcc/x86_64-unknown-linux-gnu/*/collect2",
        "libexec/gcc/x86_64-unknown-linux-gnu/*/lto*",
        "libexec/gcc/x86_64-unknown-linux-gnu/*/liblto_plugin*",
        "lib/bfd-plugins/**",
        "x86_64-unknown-linux-gnu/lib/**",
    ]) + [":binutils_pieces"],
)

filegroup(
    name = "target_headers",
    srcs = glob([
        "x86_64-unknown-linux-gnu/include/**",
        "x86_64-unknown-linux-gnu/sysroot/usr/include/**",
    ]),
)

filegroup(
    name = "target_libraries",
    srcs = glob([
        "x86_64-unknown-linux-gnu/lib64/**",
        "x86_64-unknown-linux-gnu/sysroot/lib/**",
        "x86_64-unknown-linux-gnu/sysroot/lib64/**",
        "x86_64-unknown-linux-gnu/sysroot/usr/lib/**",
        "x86_64-unknown-linux-gnu/sysroot/usr/lib64/**",
    ]),
)

filegroup(
    name = "ar_files",
    srcs = [":ar"],
)

filegroup(
    name = "as_files",
    srcs = [":as"],
)

filegroup(
    name = "strip_files",
    srcs = [":strip"],
)

filegroup(
    name = "compiler_files",
    srcs = [
        ":as",
        ":cc",
        ":cxx",
        ":compiler_pieces",
        ":target_headers",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        ":cc",
        ":cxx",
        ":ld",
        ":linker_pieces",
        ":target_libraries",
    ],
)

filegroup(
    name = "coverage_files",
    srcs = [":gcov"],
)

# *******************************************************************************
# TODO: Aliases that are pointing to empty files as temp. solution.
# *******************************************************************************
alias(
    name = "dwp_files",
    actual = ":empty",
)

alias(
    name = "objcopy_files",
    actual = ":empty",
)