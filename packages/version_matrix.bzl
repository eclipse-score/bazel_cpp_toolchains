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

""" Configuration file holding list of predefeined GCC/SDP packages.
"""

VERSION_MATRIX = {
    "arm64-linux-gcc-12.2.0": {
        "url": "",
        "build_file": "",
        "strip_prefix": "",
        "sha256": "",
    },
    "arm64-qnx-sdp-8.0.0": {
        "url": "https://www.qnx.com/download/download/79858/installation.tgz",
        "build_file": "@score_bazel_cpp_toolchains//packages/qnx/arm64/sdp/8.0.0:sdp.BUILD",
        "strip_prefix": "installation",
        "sha256": "f2e0cb21c6baddbcb65f6a70610ce498e7685de8ea2e0f1648f01b327f6bac63",
    },
    "x86_64-linux-gcc-12.2.0": {
        "url": "https://github.com/eclipse-score/toolchains_gcc_packages/releases/download/0.0.1/x86_64-unknown-linux-gnu_gcc12.tar.gz",
        "build_file": "@score_bazel_cpp_toolchains//packages/linux/x86_64/gcc/12.2.0:gcc.BUILD",
        "strip_prefix": "x86_64-unknown-linux-gnu",
        "sha256": "457f5f20f57528033cb840d708b507050d711ae93e009388847e113b11bf3600",
    },
    "x86_64-qnx-sdp-8.0.0": {
        "url": "https://www.qnx.com/download/download/79858/installation.tgz",
        "build_file": "@score_bazel_cpp_toolchains//packages/qnx/x86_64/sdp/8.0.0:sdp.BUILD",
        "strip_prefix": "installation",
        "sha256": "f2e0cb21c6baddbcb65f6a70610ce498e7685de8ea2e0f1648f01b327f6bac63",
    },
}