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

cc_feature_constraint(
    name = "is_opt",
    all_of = ["//features/markers:opt"],
)

# compress-debug only when neither opt nor fastbuild
cc_feature_constraint(
    name = "not_opt_not_fastbuild",
    none_of = [
        "//features/markers:opt",
        "//features/markers:fastbuild",
    ],
)

# Linux base link flags
cc_args(
    name = "linux_base_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = [
        "-lm",
        "-ldl",
        "-lrt",
        "-static-libstdc++",
        "-static-libgcc",
    ],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "linux_opt_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,--gc-sections"],
    requires_any_of = [":is_opt"],
    visibility = ["//visibility:public"],
)

cc_args(
    name = "linux_debug_compress_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = ["-Wl,--compress-debug-sections=zlib"],
    requires_any_of = [":not_opt_not_fastbuild"],
    visibility = ["//visibility:public"],
)

# QNX static link flags (the -V routing flag stays in toolchain config template)
cc_args(
    name = "qnx_base_link_args",
    actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
    args = [
        "-Wl,-z,relro",
        "-Wl,-z,now",
        "-Wl,--push-state",
        "-Wl,--as-needed",
        "-lc++",
        "-lm",
        "-Wl,--pop-state",
    ],
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "default_link_flags",
    args = select({
        "@platforms//os:linux": [
            ":linux_base_link_args",
            ":linux_opt_link_args",
            ":linux_debug_compress_link_args",
        ],
        "@platforms//os:qnx": [":qnx_base_link_args"],
    }),
    feature_name = "default_link_flags",
    visibility = ["//visibility:public"],
)
