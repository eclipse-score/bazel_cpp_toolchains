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

"""Bazel module extension for QNX repositories."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

_attrs_qnx_swc = {
    "name": attr.string(
        mandatory = True,
        doc = "TBD",
    ),
    "build_file": attr.label(
        mandatory = False,
        default = "@score_bazel_cpp_toolchains//packages/qnx/common/qnxsoftwarecenter_clt/qnxsoftwarecenter_clt.BUILD",
        doc = "The path to the BUILD file of qnxsoftwarecentre_clt.",
    ),
    "sha256": attr.string(
        mandatory = True,
        doc = "Checksum of the file.",
    ),
    "url": attr.string(
        mandatory = True,
        doc = "Url to the installer file.",
    ),
}

def _get_swc_info(tags):
    """Gets QNX Software Centre information from given tags.

    Args:
        tags: A list of tags containing attribute information.

    Returns:
        dict: A dictionary with attribute information.
    """
    qnx_swc_info = []
    for tag in tags:
        qnx_swc_info.append({
            "name": tag.name,
            "build_file": tag.build_file,
            "sha256": tag.sha256,
            "url": tag.url,
        })
    return qnx_swc_info

def _qnx_software_centre_impl(mctx):
    """Implementation of the QNX repositories extension."""
    root = None
    for mod in mctx.modules:
        if not mod.is_root:
            fail("Only the root module can use the 'gcc' extension!")
        root = mod
    
    qnx_swc_infos = _get_swc_info(root.tags.installer)

    # Download the QNX installer
    for qnx_swc_info in qnx_swc_infos:
        print(qnx_swc_info["name"])
        http_file(
            name = qnx_swc_info["name"],
            url = qnx_swc_info["url"],
            sha256 = qnx_swc_info["sha256"],
            executable = True,
            downloaded_file_path = "qnx-swc-setup.run",
        )

    # Create the QNX Software Center repository
    qnxsoftwarecenter_clt(
        name = "qnxsoftwarecenter_clt",
        installer = "@{}//file".format(qnx_swc_info["name"]),
        build_file = qnx_swc_info["build_file"],
    )

qnxsoftwarecentre = module_extension(
    implementation = _qnx_software_centre_impl,
    tag_classes = {
        "installer": tag_class(
            attrs = _attrs_qnx_swc,
            doc = "Software Development Centre is tarball holding installation files for Software Development Package (SDP)",
        ),
    },
)