# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

"""Clang/musl/libc++ tools from the EBcLfSA beta3 SDK."""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(
        [
            "opt/**/*",
            "usr/**/*",
            "lib/**/*",
        ],
        exclude = [
            "usr/share/ca-certificates/**",
            "usr/lib/ssl/certs/**",
            "lib/ssl/certs/**",
            "usr/share/man/**",
            "usr/share/perl/**",
        ],
    ),
)

filegroup(
    name = "ar",
    srcs = ["usr/bin/aarch64-linux-gnu-ar"],
)

filegroup(
    name = "cc",
    srcs = ["usr/lib/llvm-20/bin/clang"],
)

filegroup(
    name = "cxx",
    srcs = ["usr/lib/llvm-20/bin/clang++"],
)

filegroup(
    name = "gcov",
    srcs = ["usr/bin/aarch64-linux-gnu-gcov-14"],
)

filegroup(
    name = "strip",
    srcs = ["usr/bin/aarch64-linux-gnu-strip"],
)

filegroup(
    name = "readelf",
    srcs = ["usr/bin/aarch64-linux-gnu-readelf"],
)

filegroup(
    name = "elf-enabler",
    srcs = ["usr/bin/lisa-elf-enabler"],
)

filegroup(
    name = "sysroot_dir",
    srcs = ["."],
)

filegroup(name = "cxx_builtin_include_directories")
