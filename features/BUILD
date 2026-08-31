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

# Order mirrors templates/cc_toolchain_config.bzl.template's `features = [...]` list,
# since feature order determines command-line flag order.
cc_feature_set(
    name = "linux",
    all_of = [
        "//features/native/markers:no_legacy_features",
        "//features/native/compiler_library_search_paths",
        "//features/native/markers:dbg",
        "//features/native/unfiltered_compile_flags",
        "//features/native/markers:gnu11",
        "//features/native/default_compile_flags",
        "//features/native/random_seed",
        "//features/native/include_paths",
        "//features/native/preprocessor_defines",
        "//features/native/user_compile_flags",
        "//features/native/compiler_input_flags",
        "//features/native/compiler_output_flags",
        "//features/native/dependency_file",
        "//features/native/per_object_debug_info",
        "//features/native/includes",
        "//features/native/default_link_flags",
        "//features/native/archiver_flags",
        "//features/native/linker_param_file",
        "//features/native/library_search_directories",
        "//features/native/shared_flag",
        "//features/native/output_execpath_flags",
        "//features/native/runtime_library_search_directories",
        "//features/native/libraries_to_link",
        "//features/native/user_link_flags",
        "//features/native/linkstamps",
        "//features/native/fission_support",
        "//features/native/force_pic_flags",
        "//features/native/strip_debug_symbols",
        "//features/native/static_libgcc",
        "//features/native/fully_static_link",
        "//features/native/sysroot_link_flags",
        "//features/native/use_pthread",
        "//features/native/markers:opt",
        "//features/native/markers:supports_dynamic_linker",
        "//features/native/markers:supports_pic",
        "//features/native/pic",
        "//features/native/markers:supports_header_path_normalization",
        "//features/native/markers:supports_fission",
        "//features/native/markers:coverage",
        "//features/native/gcc_coverage_map_format",
    ],
    visibility = ["//visibility:public"],
)

# Order mirrors templates/cc_toolchain_config.bzl.template's `features = [...]` list,
# since feature order determines command-line flag order.
cc_feature_set(
    name = "qnx",
    all_of = [
        "//features/native/markers:dbg",
        "//features/native/markers:no_legacy_features",
        "//features/native/unfiltered_compile_flags",
        "//features/native/default_compile_flags",
        "//features/native/random_seed",
        "//features/native/include_paths",
        "//features/native/preprocessor_defines",
        "//features/native/user_compile_flags",
        "//features/native/compiler_input_flags",
        "//features/native/compiler_output_flags",
        "//features/native/markers:dependency_file_named_implicitly",
        "//features/native/dependency_file",
        "//features/native/default_link_flags",
        "//features/native/archiver_flags",
        "//features/native/linker_param_file",
        "//features/native/library_search_directories",
        "//features/native/shared_flag",
        "//features/native/output_execpath_flags",
        "//features/native/libraries_to_link",
        "//features/native/user_link_flags",
        "//features/native/markers:coverage",
        "//features/native/markers:opt",
        "//features/native/markers:supports_dynamic_linker",
        "//features/native/markers:supports_pic",
        "//features/native/pic",
        "//features/native/runtime_library_search_directories",
        "//features/native/gcc_coverage_map_format",
    ],
    visibility = ["//visibility:public"],
)
