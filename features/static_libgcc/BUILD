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
load("@rules_cc//cc/toolchains:feature_constraint.bzl", "cc_feature_constraint")

cc_feature_constraint(
    name = "is_static_link_cpp_runtimes",
    all_of = ["//features/markers:static_link_cpp_runtimes"],
)

cc_args(
    name = "static_libgcc_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:cpp_link_executable",
        "@rules_cc//cc/toolchains/actions:cpp_link_dynamic_library",
    ],
    args = ["-static-libgcc"],
    requires_any_of = [":is_static_link_cpp_runtimes"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "static_libgcc",
    args = [":static_libgcc_args"],
    feature_name = "static_libgcc",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)
