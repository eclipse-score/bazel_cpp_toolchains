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

"""Repository rule to install QNX Software Center."""

def _qnx_software_center_repository_impl(repository_ctx):
    """Implementation of the QNX Software Center repository rule."""

    installer_label = repository_ctx.attr.installer
    install_dir = repository_ctx.path("qnx_software_center")

    # Check if QNX Software Center is already installed
    qnxsoftwarecenter_clt = repository_ctx.path("qnxsoftwarecenter/qnxsoftwarecenter_clt")

    if not qnxsoftwarecenter_clt.exists:
        # Download/symlink the installer file
        installer_path = repository_ctx.path(installer_label)

        # Make installer executable
        repository_ctx.execute(["chmod", "+x", str(installer_path)])

        # Run the installer
        result = repository_ctx.execute(
            [
                str(installer_path),
                "--nox11",
                "force-override disable-auto-start agree-to-license-terms",
                "disable-auto-start",
                "agree-to-license-terms",
                ".",
            ],
            timeout = 300,  # 5 minutes timeout
            quiet = False,
        )

        if result.return_code != 0:
            fail("Failed to extract QNX Software Center: %s\nStderr: %s" % (result.stdout, result.stderr))

    # Create a BUILD file that exports the qnxsoftwarecenter_clt binary
    # Note: The installer extracts to ./qnxsoftwarecenter (not qnx_software_center/qnxsoftwarecenter)
    repository_ctx.file("BUILD", """
exports_files([
    "qnxsoftwarecenter/qnxsoftwarecenter_clt",
])

filegroup(
    name = "qnxsoftwarecenter_clt",
    srcs = ["qnxsoftwarecenter/qnxsoftwarecenter_clt"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "all",
    srcs = glob(["qnxsoftwarecenter/**"]),
    visibility = ["//visibility:public"],
)
""")

qnx_software_center_repository = repository_rule(
    implementation = _qnx_software_center_repository_impl,
    attrs = {
        "installer": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "The QNX installer file",
        ),
    },
    local = False,
    doc = "Downloads and installs QNX Software Center",
)
