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
load("@rules_cc//cc/toolchains:feature_set.bzl", "cc_feature_set")

cc_feature_set(
    name = "requires_coverage",
    all_of = ["//features/markers:coverage"],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "coverage_compile_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:c_compile",
        "@rules_cc//cc/toolchains/actions:cpp_compile",
        "@rules_cc//cc/toolchains/actions:cpp_module_compile",
        "@rules_cc//cc/toolchains/actions:preprocess_assemble",
    ],
    args = [
        "-fprofile-arcs",
        "-ftest-coverage",
    ],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "linux_coverage_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["--coverage"],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "qnx_coverage_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-lgcov"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "gcc_coverage_map_format",
    args = [":coverage_compile_args"] + select({
        "@platforms//os:linux": [":linux_coverage_link_args"],
        "@platforms//os:qnx": [":qnx_coverage_link_args"],
    }),
    feature_name = "gcc_coverage_map_format",
    requires_any_of = [":requires_coverage"],
    visibility = ["//visibility:public"],
)
