# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

"""Regression checks for the independent Linux and EBcLfSA HI feature lists."""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("@score_bazel_cpp_toolchains//features/custom/ebclfsa_hi:make_cc_features.bzl", hi_features = "get_feature_lists")
load("@score_bazel_cpp_toolchains//features/custom/linux:make_cc_features.bzl", linux_features = "get_feature_lists")

def _feature_lists_test_impl(ctx):
    env = unittest.begin(ctx)
    linux_known, linux_enabled = linux_features()
    hi_known, hi_enabled = hi_features()
    native = "@score_bazel_cpp_toolchains//features/native/"
    compile_flags = "@score_bazel_cpp_toolchains//features/custom/ebclfsa_hi:compile_flags"
    omitted = [
        native + "default_link_flags",
        native + "static_libgcc",
        native + "gcc_coverage_map_format",
        native + "markers:coverage",
        native + "markers:supports_dynamic_linker",
        native + "shared_flag",
        native + "runtime_library_search_directories",
        native + "fission_support",
        native + "markers:supports_fission",
    ]
    for label in omitted:
        asserts.true(env, label in linux_known, "Linux must retain " + label)
        asserts.false(env, label in hi_known, "HI must not offer " + label)
    asserts.false(env, compile_flags in linux_known)
    asserts.true(env, native + "default_compile_flags" in linux_enabled)
    asserts.true(env, compile_flags in hi_enabled)

    # Preserve the existing flag order and defaults when separating the profiles.
    for linux, hi in [(linux_known, hi_known), (linux_enabled, hi_enabled)]:
        expected = [
            compile_flags if label == native + "default_compile_flags" else label
            for label in linux
            if label not in omitted
        ]
        asserts.equals(env, expected, hi)
    return unittest.end(env)

feature_lists_test = unittest.make(_feature_lists_test_impl)
