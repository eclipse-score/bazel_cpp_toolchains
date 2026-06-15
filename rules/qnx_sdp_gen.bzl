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
    # result = rctx.execute(
    #     [
    #         str(rctx.path(rctx.attr.qnx_sdp_gen_script)),
    #         "--qnxsoftwarecenter-clt",
    #         str(rctx.path(rctx.attr.qnxsoftwarecenter_clt)),
    #         "--patchset",
    #         str(rctx.path(rctx.attr.patchset)),
    #         "--install-dir",
    #         "./local_sdp",
    #     ],
    #     timeout = 300,  # 5 minutes timeout
    #     quiet = False,
    # )
    # if result.return_code != 0:
    #     fail("Failed to extract build SDP: %s\nStderr: %s" % (result.stdout, result.stderr))

    rctx.template(
        "BUILD",
        rctx.attr.build_file,
        {},
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
        "qnxsoftwarecenter_clt": attr.label(
            mandatory = False,
            default = None,
            doc = "Label pointing to the qnxsoftwarecenter_clt installer target.",
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
