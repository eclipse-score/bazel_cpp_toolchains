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

"""Rule to create a QNX SDP distribution from a patchset file."""

def _qnx_sdp_distribution_impl(ctx):
    """Implementation of the QNX SDP distribution rule."""

    patchset = ctx.file.patchset
    qnxsoftwarecenter_clt = ctx.executable.qnxsoftwarecenter_clt

    # Output directory for the SDP distribution
    output_dir = ctx.actions.declare_directory(ctx.attr.name)

    # Create a script to run the qnxsoftwarecenter_clt command
    script = ctx.actions.declare_file(ctx.attr.name + "_install.sh")

    script_content = """#!/bin/bash
set -e

# Set up variables
QNXSOFTWARECENTER_CLT="{qnxsoftwarecenter_clt}"
PKG_PATCHLIST="{patchset}"
INSTALL_DIR="{install_dir}"

echo "srini - Installing QNX SDP from patchset $PKG_PATCHLIST using $QNXSOFTWARECENTER_CLT"
echo "srini - Output directory: $INSTALL_DIR"

# Create output directory
mkdir -p "$INSTALL_DIR"

# get proxy
# Strip protocol
temp="${{http_proxy#*://}}"
# Strip authentication if present
temp="${{temp#*@}}"
# Strip port and path
PROXYHOST="${{temp%%:*}}"
# Extract port if present
PROXYPORT="${{http_proxy##*:}}"

# Run qnxsoftwarecenter_clt to install packages from patchset
    "$QNXSOFTWARECENTER_CLT" \
    -proxy.host "$PROXYHOST" \
    -proxy.port "$PROXYPORT" \
    -myqnx.user "$SCORE_QNX_USER" \
    -myqnx.password "$SCORE_QNX_PASSWORD" \
    -importAndInstall "$PKG_PATCHLIST" \
    -destination "$INSTALL_DIR"

echo "QNX SDP distribution created successfully in $INSTALL_DIR"
""".format(
        qnxsoftwarecenter_clt = qnxsoftwarecenter_clt.path,
        patchset = patchset.path,
        install_dir = output_dir.path,
    )

    ctx.actions.write(
        output = script,
        content = script_content,
        is_executable = True,
    )

    # Run the installation script
    ctx.actions.run(
        inputs = [patchset, qnxsoftwarecenter_clt],
        outputs = [output_dir],
        executable = script,
        mnemonic = "QnxSdpInstall",
        progress_message = "Installing QNX SDP from patchset %s" % patchset.short_path,
        use_default_shell_env = True,
        execution_requirements = {
            "no-sandbox": "1",  # May need to run without sandbox for installer
        },
    )

    return [
        DefaultInfo(
            files = depset([output_dir]),
        ),
    ]

qnx_sdp_distribution = rule(
    implementation = _qnx_sdp_distribution_impl,
    attrs = {
        "patchset": attr.label(
            allow_single_file = [".plist"],
            mandatory = True,
            doc = "The patchset .plist file containing the package list",
        ),
        "qnxsoftwarecenter_clt": attr.label(
            default = "@qnx_software_center//:qnxsoftwarecenter_clt",
            executable = True,
            cfg = "exec",
            doc = "The qnxsoftwarecenter_clt binary",
        ),
    },
    doc = "Creates a QNX SDP distribution from a patchset file",
)
