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

load("@rules_cc//cc/toolchains:args.bzl", "cc_args")
load("@rules_cc//cc/toolchains:feature.bzl", "cc_feature")
load("@rules_cc//cc/toolchains:feature_constraint.bzl", "cc_feature_constraint")

cc_args(
    name = "default_compile_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = select(
        {
            "@platforms//os:linux": [
                "-U_FORTIFY_SOURCE",
                "-D_XOPEN_SOURCE=700",
                "-fstack-protector",
                "-fdiagnostics-color=always",
                "-fno-omit-frame-pointer",
                "-ffunction-sections",
                "-fdata-sections",
                "-fno-canonical-system-headers",
                "-no-canonical-prefixes",
                "-z noexecstack",
            ],
            "@platforms//os:qnx": [
                "-fno-canonical-system-headers",
            ],
            "//conditions:default": [],
        },
    ),
)

# x86_64 requires -m64; other architectures need no CPU flags here
cc_args(
    name = "target_cpu_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = select({
        "@platforms//cpu:x86_64": ["-m64"],
        "//conditions:default": [],
    }),
    visibility = ["//visibility:public"],
)

cc_feature_constraint(
    name = "not_gnu11",
    none_of = ["//features/markers:gnu11"],
)

cc_feature_constraint(
    name = "is_gnu11",
    all_of = ["//features/markers:gnu11"],
)

cc_args(
    name = "c_std_c11_args",
    actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
    args = ["-std=c11"],
    requires_any_of = [":not_gnu11"],
)

cc_args(
    name = "c_std_gnu11_args",
    actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
    args = ["-std=gnu11"],
    requires_any_of = [":is_gnu11"],
)

cc_args(
    name = "default_cxx_compile_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:cpp_compile_actions"],
    args = ["-std=c++17"] +
           select({
               "@platforms//os:qnx": [
                   "-D_QNX_SOURCE",
               ],
               "//conditions:default": [],
           }),
)

cc_feature_constraint(
    name = "is_dbg",
    all_of = ["//features/markers:dbg"],
)

cc_args(
    name = "dbg_compile_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = [
        "-Og",
        "-g3",
    ],
    requires_any_of = [":is_dbg"],
)

cc_feature_constraint(
    name = "is_opt",
    all_of = ["//features/markers:opt"],
)

cc_feature_constraint(
    name = "is_fastbuild",
    all_of = ["//features/markers:fastbuild"],
)

cc_args(
    name = "opt_compile_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = [
        "-O2",
        "-DNDEBUG",
    ],
    requires_any_of = [
        ":is_opt",
        ":is_fastbuild",
    ],
)

cc_feature(
    name = "default_compile_flags",
    args = [
        ":default_compile_flags_args",
        ":target_cpu_flags_args",
        ":c_std_c11_args",
        ":c_std_gnu11_args",
        ":default_cxx_compile_flags_args",
        ":dbg_compile_flags_args",
        ":opt_compile_flags_args",
    ],
    feature_name = "default_compile_flags",
    visibility = ["//visibility:public"],
)
