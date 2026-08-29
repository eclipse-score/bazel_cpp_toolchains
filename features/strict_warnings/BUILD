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

cc_args(
    name = "linux_strict_warnings_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-Wbool-compare",
        "-Wconversion",
        "-Wdouble-promotion",
        "-Wextra",
        "-Winvalid-pch",
        "-Wlogical-not-parentheses",
        "-Wlogical-op",
        "-Wpedantic",
        "-Wswitch-bool",
        "-Wunused-but-set-parameter",
        "-Wvla",
    ],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "linux_strict_warnings_cxx_args",
    actions = ["@rules_cc//cc/toolchains/actions:cpp_compile_actions"],
    args = ["-Wnarrowing"],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "qnx_strict_warnings_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-Wextra",
        "-Wpedantic",
    ],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "strict_warnings",
    args = select({
        "@platforms//os:linux": [
            ":linux_strict_warnings_args",
            ":linux_strict_warnings_cxx_args",
        ],
        "@platforms//os:qnx": [":qnx_strict_warnings_args"],
    }),
    feature_name = "strict_warnings",
    implies = ["//features/minimal_warnings:minimal_warnings"],
    visibility = ["//visibility:public"],
)
