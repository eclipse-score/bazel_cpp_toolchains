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

load("@rules_cc//cc/toolchains:feature_set.bzl", "cc_feature_set")

cc_feature_set(
    name = "features",
    all_of = [
        "//features/linux_platform",
        "//features/qnx_platform",
        "//features/markers:no_legacy_features",
        "//features/markers:supports_pic",
        "//features/markers:supports_dynamic_linker",
        "//features/markers:supports_fission",
        "//features/markers:supports_header_path_normalization",
        "//features/unfiltered_compile_flags",
        "//features/default_compile_flags",
        "//features/random_seed",
        "//features/include_paths",
        "//features/preprocessor_defines",
        "//features/user_compile_flags",
        "//features/compiler_input_flags",
        "//features/compiler_output_flags",
        "//features/dependency_file",
        "//features/per_object_debug_info",
        "//features/includes",
        "//features/archiver_flags",
        "//features/linker_param_file",
        "//features/library_search_directories",
        "//features/shared_flag",
        "//features/output_execpath_flags",
        "//features/runtime_library_search_directories",
        "//features/libraries_to_link",
        "//features/user_link_flags",
        "//features/linkstamps",
        "//features/fission_support",
        "//features/force_pic_flags",
        "//features/strip_debug_symbols",
        "//features/static_libgcc",
        "//features/pic",
        "//features/use_pthread",
        "//features/gcc_coverage_map_format",
    ],
    visibility = ["//visibility:public"],
)
