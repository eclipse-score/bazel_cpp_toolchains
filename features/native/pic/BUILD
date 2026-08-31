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
    name = "pic_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:assemble",
        "@rules_cc//cc/toolchains/actions:preprocess_assemble",
        "@rules_cc//cc/toolchains/actions:c_compile",
        "@rules_cc//cc/toolchains/actions:cpp_compile",
        "@rules_cc//cc/toolchains/actions:cpp_module_codegen",
        "@rules_cc//cc/toolchains/actions:cpp_module_compile",
    ],
    args = ["-fPIC"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:pic",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "pic",
    args = [":pic_args"],
    feature_name = "pic",
    visibility = ["//visibility:public"],
)
