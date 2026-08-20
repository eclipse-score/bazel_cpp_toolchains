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
    name = "per_object_debug_info_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:assemble",
        "@rules_cc//cc/toolchains/actions:preprocess_assemble",
        "@rules_cc//cc/toolchains/actions:c_compile",
        "@rules_cc//cc/toolchains/actions:cpp_compile",
        "@rules_cc//cc/toolchains/actions:cpp_module_codegen",
    ],
    args = [
        "-gsplit-dwarf",
        "-g",
    ],
    requires_not_none = "@rules_cc//cc/toolchains/variables:per_object_debug_info_file",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "per_object_debug_info",
    args = [":per_object_debug_info_args"],
    feature_name = "per_object_debug_info",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)
