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
    name = "linkstamps_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["{linkstamp_paths}"],
    format = {"linkstamp_paths": "@rules_cc//cc/toolchains/variables:linkstamp_paths"},
    iterate_over = "@rules_cc//cc/toolchains/variables:linkstamp_paths",
    requires_not_none = "@rules_cc//cc/toolchains/variables:linkstamp_paths",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "linkstamps",
    args = [":linkstamps_args"],
    feature_name = "linkstamps",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)
