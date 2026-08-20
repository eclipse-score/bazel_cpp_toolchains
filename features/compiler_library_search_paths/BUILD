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

cc_args(
    name = "compiler_library_search_paths_args",
    actions = [
        "@rules_cc//cc/toolchains/actions:source_compile_actions",
        "@rules_cc//cc/toolchains/actions:cpp_link_executable",
        "@rules_cc//cc/toolchains/actions:cpp_link_dynamic_library",
        "@rules_cc//cc/toolchains/actions:cpp_link_nodeps_dynamic_library",
    ],
    args = ["-Wl,-rpath,{compiler_library_search_paths}"],
    format = {"compiler_library_search_paths": "@rules_cc//cc/toolchains/variables:compiler_library_search_paths"},
    iterate_over = "@rules_cc//cc/toolchains/variables:compiler_library_search_paths",
    requires_not_none = "@rules_cc//cc/toolchains/variables:compiler_library_search_paths",
    visibility = ["//visibility:public"],
)

cc_feature(
    name = "compiler_library_search_paths",
    args = [":compiler_library_search_paths_args"],
    feature_name = "compiler_library_search_paths",
    requires_any_of = ["//features/linux_platform"],
    visibility = ["//visibility:public"],
)

# ERROR
