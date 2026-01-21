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

"""Small C++ CLI application for sanity testing"""

load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")

cc_binary(
    name = "main_cpp",
    srcs = ["main.cpp"],
)

cc_binary(
    name = "main_pthread_cpp",
    srcs = ["main_pthread.cpp"],
)

cc_library(
    name = "math_lib",
    srcs = ["math_lib.cpp"],
    hdrs = ["math_lib.h"],
)

cc_test(
    name = "math_lib_test",
    srcs = ["math_lib_test.cpp"],
    deps = [":math_lib"],
)

cc_test(
    name = "asan_test",
    srcs = ["asan_test.cpp"],
    features = ["asan"],
    deps = [
        "@googletest//:gtest",
        "@googletest//:gtest_main",
    ]
)