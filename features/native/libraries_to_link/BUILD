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

# static_library: dispatch on is_whole_archive
cc_nested_args(
    name = "whole_archive_static_library",
    args = [
        "-Wl,--whole-archive",
        "{lib_name}",
        "-Wl,--no-whole-archive",
    ],
    format = {"lib_name": "@rules_cc//cc/toolchains/variables:libraries_to_link.name"},
    requires_true = "@rules_cc//cc/toolchains/variables:libraries_to_link.is_whole_archive",
)

cc_nested_args(
    name = "non_whole_archive_static_library",
    args = ["{lib_name}"],
    format = {"lib_name": "@rules_cc//cc/toolchains/variables:libraries_to_link.name"},
    requires_false = "@rules_cc//cc/toolchains/variables:libraries_to_link.is_whole_archive",
)

cc_nested_args(
    name = "static_library_dispatch",
    nested = [
        ":whole_archive_static_library",
        ":non_whole_archive_static_library",
    ],
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "static_library",
)

cc_nested_args(
    name = "object_file_entry",
    args = ["{lib_name}"],
    format = {"lib_name": "@rules_cc//cc/toolchains/variables:libraries_to_link.name"},
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "object_file",
)

cc_nested_args(
    name = "object_file_group_entry",
    args = ["{object_file}"],
    format = {"object_file": "@rules_cc//cc/toolchains/variables:libraries_to_link.object_files"},
    iterate_over = "@rules_cc//cc/toolchains/variables:libraries_to_link.object_files",
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "object_file_group",
)

cc_nested_args(
    name = "dynamic_library_entry",
    args = ["-l{lib_name}"],
    format = {"lib_name": "@rules_cc//cc/toolchains/variables:libraries_to_link.name"},
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "dynamic_library",
)

cc_nested_args(
    name = "versioned_dynamic_library_entry",
    args = ["-l:{lib_name}"],
    format = {"lib_name": "@rules_cc//cc/toolchains/variables:libraries_to_link.name"},
    requires_equal = "@rules_cc//cc/toolchains/variables:libraries_to_link.type",
    requires_equal_value = "versioned_dynamic_library",
)

cc_nested_args(
    name = "iterate_libraries",
    iterate_over = "@rules_cc//cc/toolchains/variables:libraries_to_link",
    nested = [
        ":static_library_dispatch",
        ":object_file_entry",
        ":object_file_group_entry",
        ":dynamic_library_entry",
        ":versioned_dynamic_library_entry",
    ],
)

cc_args(
    name = "libraries_to_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    nested = [":iterate_libraries"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:libraries_to_link",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "libraries_to_link",
    args = [":libraries_to_link_args"],
    feature_name = "libraries_to_link",
    visibility = ["//visibility:public"],
)
