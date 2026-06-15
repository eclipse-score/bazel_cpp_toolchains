# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
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

""" TODO: Write docstring
"""

def _qnxsoftwarecenter_clt_impl(rctx):
    """ TODO: Write docstring
    """

    output = rctx.download(
        url = rctx.attr.url,
        output = "qnx-swc-setup.run",
        sha256 = rctx.attr.sha256,
        executable = True,
    )

    # Make installer executable
    rctx.execute(["chmod", "+x", "./qnx-swc-setup.run"], quiet = True)

    # Run the installer
    result = rctx.execute(
        [
            "./qnx-swc-setup.run",
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

    rctx.template(
        "BUILD",
        rctx.attr.build_file,
        {},
    )

    rctx.file(
        "qnxsoftwarecenter/local_sdp/.keep",
        "",
        executable = False,
    )

qnxsoftwarecenter_clt = repository_rule(
    implementation = _qnxsoftwarecenter_clt_impl,
    attrs = {
        "build_file": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "The BUILD file that defines the QNX Software Center CLT targets",
        ),
        "url": attr.string(
            mandatory = True,
            doc = "The URL to download the QNX Software Center installer",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "The SHA256 checksum of the QNX Software Center installer",
        ),
    },
    doc = "Installs the QNX Software Center Command Line Tools (CLT) from a given installer file and BUILD file.",
)
