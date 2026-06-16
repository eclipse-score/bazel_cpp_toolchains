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

""" TODO: Write docstring
"""

def _qnx_sdp_gen_impl(rctx):

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

    
    rctx.execute(["mkdir", "install"], quiet = True)
    result = rctx.execute(
    [
        str(rctx.path(rctx.attr.qnx_sdp_gen_script)),
        "--qnxsoftwarecenter-clt",
        "./qnxsoftwarecenter/qnxsoftwarecenter_clt",
        "--patchset",
        str(rctx.path(rctx.attr.patchset)),
        "--install-dir",
        "./install",
    ],
        timeout = 300,  # 5 minutes timeout
        quiet = False,
    )
    if result.return_code != 0:
        fail("Failed to extract build SDP: %s\nStderr: %s" % (result.stdout, result.stderr))

    rctx.template(
        "BUILD",
        rctx.attr.build_file,
        {
            "%{install_dir}": "install",
            "%{target_cpu}": rctx.attr.target_cpu,
        },
    )

qnx_sdp_gen = repository_rule(
    implementation = _qnx_sdp_gen_impl,
    attrs = {
        "build_file": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "The BUILD file that defines the QNX SDP distribution targets",
        ),
        "patchset": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "The patchset file that defines the QNX SDP distribution",
        ),
        "url": attr.string(
            mandatory = True,
            doc = "URL pointing to the QNX Software Center installer script.",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "SHA256 checksum of the QNX Software Center installer script.",
        ),
        "target_cpu": attr.string(
            mandatory = False,
            default = "x86_64",
            values = [
                "x86_64",
                "aarch64",
            ],
        ),
        "qnx_sdp_gen_script": attr.label(
            allow_single_file = True,
            mandatory = False,
            executable = True,
            cfg = "exec",
            default = "@score_bazel_cpp_toolchains//packages/qnx/common/sdp_gen:qnx_sdp_install.py",
            doc = "The script that generates the QNX SDP distribution.",
        ),
    },
)
