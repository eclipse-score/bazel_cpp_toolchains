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

load("@rules_cc//cc/toolchains:feature.bzl", "cc_feature")

# Capability markers — enabled state is set at toolchain assembly, not here.
cc_feature(
    name = "no_legacy_features",
    feature_name = "no_legacy_features",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "supports_pic",
    feature_name = "supports_pic",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "supports_dynamic_linker",
    feature_name = "supports_dynamic_linker",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "dbg",
    feature_name = "dbg",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "opt",
    feature_name = "opt",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "fastbuild",
    feature_name = "fastbuild",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "coverage",
    feature_name = "coverage",
    visibility = ["//visibility:public"],
)

## Linux specficic
cc_feature(
    name = "supports_fission",
    feature_name = "supports_fission",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "supports_header_path_normalization",
    feature_name = "supports_header_path_normalization",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "gnu11",
    feature_name = "gnu11",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)

## QNX only
cc_feature(
    name = "dependency_file_named_implicitly",
    feature_name = "dependency_file_named_implicitly",
    requires_any_of = ["//features/qnx_platform"],
    visibility = ["//visibility:public"],
)

# Linked runtime control
cc_feature(
    name = "static_link_cpp_runtimes",
    feature_name = "static_link_cpp_runtimes",
    visibility = ["//visibility:public"],
)
