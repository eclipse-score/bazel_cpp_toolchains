# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
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

def make_extra_compile_features(
    extra_compile_flags = None,
    extra_c_compile_flags = None,
    extra_cxx_compile_flags = None,
):

    cc_args(
        name = "extra_compile_flags_args",
        actions = ["@rules_cc//cc/toolchains/actions:source_compile_actions"],
        args = extra_compile_flags,
    )

    cc_feature(
        name = "extra_compile_flags",
        args = [":extra_compile_flags_args"],
        feature_name = "extra_compile_flags",
        implies = ["@score_bazel_cpp_toolchains//features/native/default_compile_flags"],
    )

    cc_args(
        name = "extra_c_compile_flags_args",
        actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
        args = extra_c_compile_flags,
    )

    cc_feature(
        name = "extra_c_compile_flags",
        args = [":extra_c_compile_flags_args"],
        feature_name = "extra_c_compile_flags",
        implies = ["@score_bazel_cpp_toolchains//features/native/default_compile_flags"],
    )

    cc_args(
        name = "extra_cxx_compile_flags_args",
        actions = ["@rules_cc//cc/toolchains/actions:cpp_compile_actions"],
        args = extra_cxx_compile_flags,
    )

    cc_feature(
        name = "extra_cxx_compile_flags",
        args = [":extra_cxx_compile_flags_args"],
        feature_name = "extra_cxx_compile_flags",
        implies = ["@score_bazel_cpp_toolchains//features/native/default_compile_flags"],
    )