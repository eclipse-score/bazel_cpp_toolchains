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
    name = "quote_include_paths_args",
    actions = ["@rules_cc//cc/toolchains/actions:source_compile_actions"],
    args = [
        "-iquote",
        "{quote_include_paths}",
    ],
    format = {"quote_include_paths": "@rules_cc//cc/toolchains/variables:quote_include_paths"},
    iterate_over = "@rules_cc//cc/toolchains/variables:quote_include_paths",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "include_paths_args",
    actions = ["@rules_cc//cc/toolchains/actions:source_compile_actions"],
    args = ["-I{include_paths}"],
    format = {"include_paths": "@rules_cc//cc/toolchains/variables:include_paths"},
    iterate_over = "@rules_cc//cc/toolchains/variables:include_paths",
    visibility = ["//visibility:public"],
)

cc_args(
    name = "system_include_paths_args",
    actions = ["@rules_cc//cc/toolchains/actions:source_compile_actions"],
    args = [
        "-isystem",
        "{system_include_paths}",
    ],
    format = {"system_include_paths": "@rules_cc//cc/toolchains/variables:system_include_paths"},
    iterate_over = "@rules_cc//cc/toolchains/variables:system_include_paths",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "include_paths",
    args = [
        ":quote_include_paths_args",
        ":include_paths_args",
        ":system_include_paths_args",
    ],
    feature_name = "include_paths",
    visibility = ["//visibility:public"],
)
