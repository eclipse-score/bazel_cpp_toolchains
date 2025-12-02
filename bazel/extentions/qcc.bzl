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

""" Module extension for setting up QCC toolchains in Bazel.
"""
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@score_bazel_cpp_toolchains//bazel/extentions:common.bzl", "get_info", "tc_module_attrs", _attrs_archive = "archive_attrs")
load("@score_bazel_cpp_toolchains//bazel/rules:qcc.bzl", "qcc_toolchain")

# QCC interface API for toolchain tag class
_attrs_qcc_tc = {}
_attrs_qcc_tc.update(tc_module_attrs)
_attrs_qcc_tc.update({
    "name": attr.string(
        default = "score_qcc_toolchain",
        doc = "Toolchain repo name, default set to `score_qcc_toolchain`.",
    ),
    "target_os": attr.string(
        default = "qnx",
        doc = "Target operating system for the QCC toolchain.",
    ),
    "license_info_url": attr.string(
        default = "",
        doc = "URL of the QNX license server.",
    ),
    "license_info_variable": attr.string(
        default = "LM_LICENSE_FILE",
        doc = "QNX License info variable.",
    ),
    "sdp_version": attr.string(
        default = "8.0.0",
        doc = "Version of the SDP package.",
    ),
    "qnx_license_path": attr.string(
        default = "/opt/score_qnx/license/licenses",
        doc = "Path to the shared license file.",
    ),
})

# QCC interface API for archive (SDP) tag class
archive_attrs = _attrs_archive

def _impl(mctx):
    """Implementation of the module extension."""
    toolchains, archives = get_info(mctx, "qcc")
    for archive_info in archives:
        http_archive(
            name = archive_info["name"],
            urls = [archive_info["url"]],
            build_file = archive_info["build_file"],
            sha256 = archive_info["sha256"],
            strip_prefix = archive_info["strip_prefix"],
        )

    for toolchain_info in toolchains:
        qcc_toolchain(
            name = toolchain_info["name"],
            tc_pkg_repo = toolchain_info["package_to_link"],
            tc_cpu = toolchain_info["tc_cpu"],
            qcc_version = toolchain_info["tc_family_version"],
            sdp_version = toolchain_info["sdp_version"],
            license_info_variable = toolchain_info["license_info_variable"],
            license_info_value = toolchain_info["license_info_url"],
            extra_compile_flags = toolchain_info["extra_compile_flags"],
            extra_link_flags = toolchain_info["extra_link_flags"],
            qnx_license_path = toolchain_info["qnx_license_path"],
        )

qcc = module_extension(
    implementation = _impl,
    tag_classes = {
        "toolchain": tag_class(
            attrs = _attrs_qcc_tc,
        ),
        "sdp": tag_class(
            attrs = _attrs_archive,
        ),
    },
)