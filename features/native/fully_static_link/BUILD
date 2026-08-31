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
    name = "fully_static_link_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:cpp_link_executable",
        "@rules_cc//cc/toolchains/actions:cpp_link_dynamic_library",
        "@rules_cc//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    args = ["-static"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "fully_static_link",
    args = [":fully_static_link_args"],
    feature_name = "fully_static_link",
    visibility = ["//visibility:public"],
)
