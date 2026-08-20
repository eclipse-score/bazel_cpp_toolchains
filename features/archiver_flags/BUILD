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
load("@rules_cc//cc/toolchains:nested_args.bzl", "cc_nested_args")

cc_args(
    name = "archiver_static_flag_args",
    actions = ["@rules_cc//cc/toolchains/actions:ar_actions"],
    args = ["rcsD"],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "archiver_output_execpath_args",
    actions = ["@rules_cc//cc/toolchains/actions:ar_actions"],
    args = ["{output_execpath}"],
    format = {"output_execpath": "@rules_cc//cc/toolchains/variables:output_execpath"},
    requires_not_none = "@rules_cc//cc/toolchains/variables:output_execpath",
    visibility = ["//visibility:public"],
)

cc_nested_args(
    name = "archiver_object_file_entry",
    args = ["{lib_name}"],
    format = {"lib_name": "@rules_cc//cc/toolchains/variables:libraries_to_link.name"},
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "object_file",
)

cc_nested_args(
    name = "archiver_object_file_group_entry",
    args = ["{object_file}"],
    format = {"object_file": "@rules_cc//cc/toolchains/variables:libraries_to_link.object_files"},
    iterate_over = "@rules_cc//cc/toolchains/variables:libraries_to_link.object_files",
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "object_file_group",
)

cc_nested_args(
    name = "archiver_iterate_libraries",
    iterate_over = "@rules_cc//cc/toolchains/variables:libraries_to_link",
    nested = [
        ":archiver_object_file_entry",
        ":archiver_object_file_group_entry",
    ],
)

cc_args(
    name = "archiver_libraries_args",
    actions = ["@rules_cc//cc/toolchains/actions:ar_actions"],
    nested = [":archiver_iterate_libraries"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:libraries_to_link",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "archiver_flags",
    args = [
        ":archiver_static_flag_args",
        ":archiver_output_execpath_args",
        ":archiver_libraries_args",
    ],
    feature_name = "archiver_flags",
    visibility = ["//visibility:public"],
)
