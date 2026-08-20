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
    name = "compiler_input_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
    args = [
        "-c",
        "{source_file}",
    ],
    format = {"source_file": "@rules_cc//cc/toolchains/variables:source_file"},
    requires_not_none = "@rules_cc//cc/toolchains/variables:source_file",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "compiler_input_flags",
    args = [":compiler_input_flags_args"],
    feature_name = "compiler_input_flags",
    visibility = ["//visibility:public"],
)
