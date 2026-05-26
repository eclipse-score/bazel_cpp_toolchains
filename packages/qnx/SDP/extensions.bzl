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
load("//:qnx_install.bzl", "qnx_software_center_repository")

def _qnx_repositories_impl(module_ctx):
    """Implementation of the QNX repositories extension."""

    # Download the QNX installer
    http_file(
        name = "qnx_installer",
        url = "https://www.qnx.com/download/download/79441/qnx-setup-2.0.4-202501021438-linux.run",
        executable = True,
        downloaded_file_path = "qnx-setup-2.0.4-202501021438-linux.run",
    )

    # Create the QNX Software Center repository
    qnx_software_center_repository(
        name = "qnx_software_center",
        installer = "@qnx_installer//file:qnx-setup-2.0.4-202501021438-linux.run",
    )

qnx_repositories = module_extension(
    implementation = _qnx_repositories_impl,
)
