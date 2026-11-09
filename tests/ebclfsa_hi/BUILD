# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")
load(":configuration_test.bzl", "configuration_test", "restriction_test")

restriction_test(
    name = "exceptions_rejected_test",
    src = "exceptions.cpp",
    diagnostic = "cannot use 'throw' with exceptions disabled",
    target_compatible_with = ["@score_bazel_platforms//runtime_es:ebclfsa-hi"],
)

restriction_test(
    name = "rtti_rejected_test",
    src = "rtti.cpp",
    diagnostic = "use of dynamic_cast requires -frtti",
    target_compatible_with = ["@score_bazel_platforms//runtime_es:ebclfsa-hi"],
)

configuration_test(
    name = "configuration_test",
    binary = ":runtime_test",
    readelf = "@score_ebclfsa_hi_toolchain_pkg//:readelf",
    target_compatible_with = ["@score_bazel_platforms//runtime_es:ebclfsa-hi"],
)

cc_library(
    name = "c_runtime",
    srcs = ["c_runtime.c"],
    target_compatible_with = ["@score_bazel_platforms//runtime_es:ebclfsa-hi"],
)

cc_test(
    name = "runtime_test",
    srcs = ["runtime_test.cpp"],
    target_compatible_with = ["@score_bazel_platforms//runtime_es:ebclfsa-hi"],
    deps = [":c_runtime"],
)
