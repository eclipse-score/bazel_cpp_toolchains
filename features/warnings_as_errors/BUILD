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
    name = "linux_warnings_as_errors_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-Werror",
        "-Wno-error=deprecated-declarations",
    ],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "qnx_warnings_as_errors_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = ["-Werror"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "warnings_as_errors",
    args = select({
        "@platforms//os:linux": [":linux_warnings_as_errors_args"],
        "@platforms//os:qnx": [":qnx_warnings_as_errors_args"],
    }),
    feature_name = "warnings_as_errors",
    visibility = ["//visibility:public"],
)
