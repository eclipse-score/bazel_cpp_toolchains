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
load("@rules_cc//cc/toolchains/args:sysroot.bzl", "cc_sysroot")

cc_sysroot(
    name = "sysroot_link_flags_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,--sysroot={sysroot}"],
    requires_not_none = "@rules_cc//cc/toolchains/variables:sysroot",
    sysroot = "@rules_cc//cc/toolchains/variables:sysroot",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "sysroot_link_flags",
    args = [":sysroot_link_flags_args"],
    feature_name = "sysroot_link_flags",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)

# ERROR
