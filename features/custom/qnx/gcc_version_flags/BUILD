# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
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
    name = "qnx_gcc_version_compile_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = select({
        "@score_bazel_platforms//settings:aarch64-qnx8": ["-V12.2.0,gcc_ntoaarch64le"],
        "@score_bazel_platforms//settings:x86_64-qnx8": ["-V12.2.0,gcc_ntox86_64"],
    }),
)

cc_args(
    name = "qnx_gcc_version_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = select({
        "@score_bazel_platforms//settings:aarch64-qnx8": ["-V12.2.0,gcc_ntoaarch64le_cxx"],
        "@score_bazel_platforms//settings:x86_64-qnx8": ["-V12.2.0,gcc_ntox86_64_cxx"],
    }),
)

cc_feature(
    name = "gcc_version_flags",
    args = [
        ":qnx_gcc_version_compile_args",
        ":qnx_gcc_version_link_args",
    ],
    feature_name = "gcc_version_flags",
    visibility = ["//visibility:public"],
)
