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
    name = "preprocessor_defines_args",
    actions = ["@rules_cc//cc/toolchains/actions:source_compile_actions"],
    args = ["-D{preprocessor_defines}"],
    format = {"preprocessor_defines": "@rules_cc//cc/toolchains/variables:preprocessor_defines"},
    iterate_over = "@rules_cc//cc/toolchains/variables:preprocessor_defines",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "preprocessor_defines",
    args = [":preprocessor_defines_args"],
    feature_name = "preprocessor_defines",
    visibility = ["//visibility:public"],
)
