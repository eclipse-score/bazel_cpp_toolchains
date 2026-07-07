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

"""Toolchain Feature Verification Tests

These tests verify that specific toolchain features are correctly implemented
and functioning. Each test targets a particular feature or group of features
from the C++ toolchain configuration.

Tests are marked 'manual' for cross-compilation targets (QNX) to prevent
execution attempts on incompatible architectures. For native Linux builds,
tests can execute on the host machine.
"""

load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

# ============================================================================
# Feature Verification Tests
# ============================================================================

# Test for: feature_test.h/feature_test.cpp - Basic feature infrastructure
cc_library(
    name = "feature_test_lib",
    srcs = ["feature_test.cpp"],
    hdrs = ["feature_test.h"],
    linkstatic = select({
        "@score_bazel_platforms//runtime_es:ebclfsa": True,
        "//conditions:default": False,
    }),
)

# Test for: preprocessor_defines feature
# Verifies that -D preprocessor defines are correctly applied
cc_test(
    name = "defines_test",
    srcs = ["defines_test.cpp"],
    copts = [
        "-DFEATURE_TEST_ENABLED=1",
        "-DBUILD_VARIANT=\\\"debug\\\"",
    ],
    deps = [":feature_test_lib"],
)

# Test for: include_paths, compiler_input_flags features
# Verifies that -I, -iquote, -isystem include paths work correctly
cc_test(
    name = "include_paths_test",
    srcs = ["include_paths_test.cpp"],
    deps = [":feature_test_lib"],
)

# Test for: strict_warnings, minimal_warnings, warnings_as_errors features
# Verifies that warning levels are correctly configured
cc_test(
    name = "warnings_test",
    srcs = ["warnings_test.cpp"],
)

# Test for: coverage, gcc_coverage_map_format, dependency_file features
# Verifies that code coverage instrumentation is applied
cc_test(
    name = "coverage_test",
    srcs = ["coverage_test.cpp"],
    features = ["coverage"],
    deps = [":feature_test_lib"],
)

# Test for: supports_pic (Position-Independent Code) feature
# Verifies that -fPIC compilation flag is applied
cc_library(
    name = "pic_test_lib",
    srcs = ["pic_test_lib.cpp"],
    hdrs = ["pic_test_lib.h"],
    linkstatic = select({
        "@score_bazel_platforms//runtime_es:ebclfsa": True,
        "//conditions:default": False,
    }),
)

cc_test(
    name = "pic_test",
    srcs = ["pic_test.cpp"],
    deps = [":pic_test_lib"],
)

# Test for: archiver_flags, libraries_to_link features
# Verifies that multiple object files are correctly combined in static libraries
cc_library(
    name = "multifile_lib",
    srcs = [
        "multifile_lib_geometry.cpp",
        "multifile_lib_matrix.cpp",
        "multifile_lib_vector.cpp",
    ],
    hdrs = ["multifile_lib.h"],
    linkstatic = select({
        "@score_bazel_platforms//runtime_es:ebclfsa": True,
        "//conditions:default": False,
    }),
)

cc_test(
    name = "multifile_test",
    srcs = ["multifile_test.cpp"],
    deps = [":multifile_lib"],
)

# Test for: libraries_to_link with whole-archive support
# Verifies that -Wl,--whole-archive/-Wl,--no-whole-archive work correctly
cc_library(
    name = "whole_archive_lib",
    srcs = ["whole_archive_lib.cpp"],
    hdrs = ["whole_archive_lib.h"],
    linkstatic = select({
        "@score_bazel_platforms//runtime_es:ebclfsa": True,
        "//conditions:default": False,
    }),
)

cc_test(
    name = "whole_archive_test",
    srcs = ["whole_archive_test.cpp"],
    deps = [":whole_archive_lib"],
)

# Test for: pthread feature
# Verifies that POSIX threading is properly linked and functional
cc_library(
    name = "pthread_test_lib",
    srcs = ["pthread_test_lib.cpp"],
    hdrs = ["pthread_test_lib.h"],
    linkopts = ["-lpthread"],
    linkstatic = select({
        "@score_bazel_platforms//runtime_es:ebclfsa": True,
        "//conditions:default": False,
    }),
)

cc_test(
    name = "pthread_test",
    srcs = ["pthread_test.cpp"],
    linkopts = ["-lpthread"],
    deps = [":pthread_test_lib"],
)
