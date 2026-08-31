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

_COMPILE_ACTIONS = [
    "@rules_cc//cc/toolchains/actions:assemble",
    "@rules_cc//cc/toolchains/actions:preprocess_assemble",
    "@rules_cc//cc/toolchains/actions:c_compile",
    "@rules_cc//cc/toolchains/actions:cpp_compile",
    "@rules_cc//cc/toolchains/actions:cpp_module_compile",
    "@rules_cc//cc/toolchains/actions:cpp_header_parsing",
]

# Linux: standard -MD -MF flags
cc_args(
    name = "dependency_file_linux_args",
    actions = _COMPILE_ACTIONS,
    args = [
        "-MD",
        "-MF",
        "{dependency_file}",
    ],
    format = {"dependency_file": "@rules_cc//cc/toolchains/variables:dependency_file"},
    requires_not_none = "@rules_cc//cc/toolchains/variables:dependency_file",
    visibility = ["//visibility:public"],
)

# QNX: QCC-wrapped flags — explicit filename (dependency_file_named_implicitly is NOT active)
cc_feature_constraint(
    name = "not_dep_named_implicitly",
    none_of = ["//features/native/markers:dependency_file_named_implicitly"],
)

cc_args(
    name = "dependency_file_qnx_explicit_args",
    actions = _COMPILE_ACTIONS,
    args = [
        "-Wc,-MD,{dependency_file}",
        "-Wp,-MD,{dependency_file}",
    ],
    format = {"dependency_file": "@rules_cc//cc/toolchains/variables:dependency_file"},
    requires_any_of = [":not_dep_named_implicitly"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:dependency_file",
    visibility = ["//visibility:public"],
)

# QNX: QCC-wrapped flags — implicit filename (dependency_file_named_implicitly IS active)
cc_feature_constraint(
    name = "is_dep_named_implicitly",
    all_of = ["//features/native/markers:dependency_file_named_implicitly"],
)

cc_args(
    name = "dependency_file_qnx_implicit_args",
    actions = _COMPILE_ACTIONS,
    args = [
        "-Wc,-MD",
        "-Wp,-MD",
    ],
    requires_any_of = [":is_dep_named_implicitly"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "dependency_file",
    args = select({
        "@platforms//os:linux": [":dependency_file_linux_args"],
        "@platforms//os:qnx": [
            ":dependency_file_qnx_explicit_args",
            ":dependency_file_qnx_implicit_args",
        ],
    }),
    feature_name = "dependency_file",
    visibility = ["//visibility:public"],
)
