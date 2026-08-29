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

# Linux
cc_args(
    name = "linux_minimal_warnings_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-Wall",
        "-Wcast-align",
        "-Wcast-qual",
        "-Wformat-nonliteral",
        "-Wformat-signedness",
        "-Wformat=2",
        "-Wmissing-format-attribute",
        "-Wpointer-arith",
        "-Wredundant-decls",
        "-Wreturn-local-addr",
        "-Wsizeof-array-argument",
        "-Wundef",
        "-Wwrite-strings",
    ],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "linux_minimal_warnings_c_args",
    actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
    args = [
        "-Wbad-function-cast",
        "-Wmissing-prototypes",
    ],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "linux_minimal_warnings_cxx_args",
    actions = ["@rules_cc//cc/toolchains/actions:cpp_compile_actions"],
    args = [
        "-Wodr",
        "-Wreorder",
    ],
    visibility = ["//visibility:public"],
)

# QNX
cc_args(
    name = "qnx_minimal_warnings_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-Wall",
        "-Wno-error=deprecated-declarations",
        "-Wno-error=mismatched-new-delete",
    ],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "minimal_warnings",
    args = select({
        "@platforms//os:linux": [
            ":linux_minimal_warnings_args",
            ":linux_minimal_warnings_c_args",
            ":linux_minimal_warnings_cxx_args",
        ],
        "@platforms//os:qnx": [":qnx_minimal_warnings_args"],
    }),
    feature_name = "minimal_warnings",
    visibility = ["//visibility:public"],
)
