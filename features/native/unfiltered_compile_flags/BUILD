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
    name = "unfiltered_compile_flags_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_compile_actions",
    ],
    args = [
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
        "-Wno-builtin-macro-redefined",
    ],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "unfiltered_compile_flags",
    args = [":unfiltered_compile_flags_args"],
    feature_name = "unfiltered_compile_flags",
    visibility = ["//visibility:public"],
)
