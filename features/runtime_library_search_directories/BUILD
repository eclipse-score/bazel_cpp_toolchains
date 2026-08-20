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

# Linux: fork rpath on is_cc_test
cc_nested_args(
    name = "linux_rpath_test",
    args = ["-Wl,-rpath,$ORIGIN/{dir}"],
    format = {"dir": "@rules_cc//cc/toolchains/variables:runtime_library_search_directories"},
    requires_true = "@rules_cc//cc/toolchains/variables:is_cc_test",
)

cc_nested_args(
    name = "linux_rpath_exec",
    args = ["-Wl,-rpath,$EXEC_ORIGIN/{dir}"],
    format = {"dir": "@rules_cc//cc/toolchains/variables:runtime_library_search_directories"},
    requires_false = "@rules_cc//cc/toolchains/variables:is_cc_test",
)

cc_nested_args(
    name = "linux_rpath_iterate",
    iterate_over = "@rules_cc//cc/toolchains/variables:runtime_library_search_directories",
    nested = [
        ":linux_rpath_test",
        ":linux_rpath_exec",
    ],
)

cc_args(
    name = "runtime_dirs_linux_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    nested = [":linux_rpath_iterate"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:runtime_library_search_directories",
    visibility = ["//visibility:public"],
)

# QNX: always $EXEC_ORIGIN, QCC uses -Wl,-rpath
cc_nested_args(
    name = "qnx_rpath_iterate",
    args = ["-Wl,-rpath,$EXEC_ORIGIN/{dir}"],
    format = {"dir": "@rules_cc//cc/toolchains/variables:runtime_library_search_directories"},
    iterate_over = "@rules_cc//cc/toolchains/variables:runtime_library_search_directories",
)

cc_args(
    name = "runtime_dirs_qnx_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    nested = [":qnx_rpath_iterate"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:runtime_library_search_directories",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "runtime_library_search_directories",
    args = select({
        "@platforms//os:linux": [":runtime_dirs_linux_args"],
        "@platforms//os:qnx": [":runtime_dirs_qnx_args"],
    }),
    feature_name = "runtime_library_search_directories",
    visibility = ["//visibility:public"],
)
