# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

"""EBcLfSA High Integrity-specific compiler features."""

load("@rules_cc//cc/toolchains:feature.bzl", "cc_feature")

cc_feature(
    name = "compile_flags",
    args = [
        "//features/native/default_compile_flags:c_std_c11_args",
        "//features/native/default_compile_flags:c_std_gnu11_args",
        "//features/native/default_compile_flags:c_std_c99_args",
        "//features/native/default_compile_flags:default_cxx_compile_flags_args",
        "//features/native/default_compile_flags:dbg_compile_flags_args",
        "//features/native/default_compile_flags:opt_compile_flags_args",
    ],
    feature_name = "default_compile_flags",
    visibility = ["//visibility:public"],
)
