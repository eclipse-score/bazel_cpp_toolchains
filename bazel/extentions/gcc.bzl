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

""" Module extension for setting up GCC toolchains in Bazel.
"""
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@score_bazel_cpp_toolchains//bazel/extentions:common.bzl", "get_info", "tc_module_attrs", _attrs_archive = "archive_attrs")
load("@score_bazel_cpp_toolchains//bazel/rules:gcc.bzl", "gcc_toolchain")

# GCC interface API for toolchain tag class
_attrs_gcc_tc = {}
_attrs_gcc_tc.update(tc_module_attrs)
_attrs_gcc_tc.update({
    "name": attr.string(
        default = "score_gcc_toolchain",
        doc = "Toolchain repo name, default set to `score_gcc_toolchain`.",
    ),
    "target_os": attr.string(
        default = "linux",
        doc = "Target operating system for the GCC toolchain.",
    ),
})

# GCC interface API for archive tag class
archive_attrs = _attrs_archive

def _gcc_impl(mctx):
    """Extracts information about toolchain and instantiates nessesary rules for toolchain declaration.

    Args:
        mctx: A bazel object holding module information.

    """
    toolchains, archives = get_info(mctx, "gcc")
    for archive_info in archives:
        http_archive(
            name = archive_info["name"],
            urls = [archive_info["url"]],
            build_file = archive_info["build_file"],
            sha256 = archive_info["sha256"],
            strip_prefix = archive_info["strip_prefix"],
        )

    for toolchain_info in toolchains:
        gcc_toolchain(
            name = toolchain_info["name"],
            tc_pkg_repo = toolchain_info["package_to_link"],
            tc_cpu = toolchain_info["tc_cpu"],
            tc_os = toolchain_info["tc_os"],
            gcc_version = toolchain_info["tc_family_version"],
            extra_compile_flags = toolchain_info["extra_compile_flags"],
            extra_link_flags = toolchain_info["extra_link_flags"],
        )

gcc = module_extension(
    implementation = _gcc_impl,
    tag_classes = {
        "toolchain": tag_class(
            attrs = _attrs_gcc_tc,
        ),
        "package": tag_class(
            attrs = _attrs_archive,
        ),
    }
)