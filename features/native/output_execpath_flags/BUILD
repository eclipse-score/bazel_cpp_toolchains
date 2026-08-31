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
    name = "output_execpath_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = [
        "-o",
        "{output_execpath}",
    ],
    format = {"output_execpath": "@rules_cc//cc/toolchains/variables:output_execpath"},
    requires_not_none = "@rules_cc//cc/toolchains/variables:output_execpath",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "output_execpath_flags",
    args = [":output_execpath_flags_args"],
    feature_name = "output_execpath_flags",
    visibility = ["//visibility:public"],
)
