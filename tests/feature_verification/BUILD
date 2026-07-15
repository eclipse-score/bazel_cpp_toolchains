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

Tests are executed by running `bazel test` on the matching target platform.
When the host equals the target (for example the x86_64-linux config on an
x86_64 Linux host) the tests build and run directly on the host. For other
target platforms (such as QNX), build the tests on the host to verify
compilation and linking, then execute them on the corresponding target.
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

# Test for: preprocessor_defines feature
# Unlike defines_test (which uses copts -> user_compile_flags), this target
# injects defines through the `local_defines` attribute, which is forwarded to
# the compiler only by the preprocessor_defines feature.
cc_test(
    name = "preprocessor_defines_test",
    srcs = ["preprocessor_defines_test.cpp"],
    local_defines = [
        "PP_DEFINES_FEATURE_ENABLED=1",
        "PP_DEFINES_ANSWER=42",
        "PP_DEFINES_LABEL=\\\"from_local_defines\\\"",
    ],
)

# Library that exposes its header directory via the `includes` attribute.
# Consumers include "custom_math.h" without the directory prefix, which only
# resolves when the include_paths feature emits the -I/-isystem search path.
cc_library(
    name = "custom_math",
    hdrs = ["include_dir/custom_math.h"],
    includes = ["include_dir"],
    linkstatic = select({
        "@score_bazel_platforms//runtime_es:ebclfsa": True,
        "//conditions:default": False,
    }),
)

# Test for: include_paths feature (-I / -isystem via the `includes` attribute)
cc_test(
    name = "include_dir_test",
    srcs = ["include_dir_test.cpp"],
    deps = [":custom_math"],
)

# Test for: user_link_flags feature
# Passes a linker flag through `linkopts`; Bazel forwards linkopts to the linker
# only via the user_link_flags feature. The --defsym flag defines an absolute
# symbol whose address is checked at runtime.
cc_test(
    name = "user_link_flags_test",
    srcs = ["user_link_flags_test.cpp"],
    linkopts = ["-Wl,--defsym=user_link_flags_marker=0x1234"],
)

# Test for: fully_static_link feature (-static)
# Enabling the feature emits -static directly, producing a binary with no
# dynamic library dependencies. The test verifies no shared objects are mapped
# at runtime. This feature is opt-in, so the target enables it explicitly.
#
# Fully static linking requires static system archives (libc.a, libstdc++.a,
# ...). The AutoSD toolchain ships only shared libraries, so the test is marked
# incompatible with the autosd10 platform and is skipped there.
cc_test(
    name = "fully_static_link_test",
    srcs = ["fully_static_link_test.cpp"],
    features = ["fully_static_link"],
    target_compatible_with = select({
        "@score_bazel_platforms//runtime_es:autosd10": ["@platforms//:incompatible"],
        "//conditions:default": [],
    }),
)

# Test for: random_seed feature (-frandom-seed=<output_file>)
# Build-and-run smoke test exercising internal-linkage symbols governed by the
# random seed used for reproducible builds.
cc_test(
    name = "random_seed_test",
    srcs = ["random_seed_test.cpp"],
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
