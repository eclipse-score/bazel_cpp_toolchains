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

# QNX SDP Distribution Build

load(":qnx_sdp.bzl", "qnx_sdp_distribution")

# Create the QNX SDP distribution from the patchset file
qnx_sdp_distribution(
    name = "qnx_sdp",
    patchset = "patchset-qnx803-virtio.plist",
    qnxsoftwarecenter_clt = ":qnxsoftwarecenter_clt",
    visibility = ["//visibility:public"],
)

# Package the SDP as a tarball for distribution (optional)
genrule(
    name = "qnx_sdp_tar",
    srcs = [":qnx_sdp"],
    outs = ["qnx803-sdp.tar.gz"],
    cmd = "tar -czf $@ -C $$(dirname $(location :qnx_sdp)) $$(basename $(location :qnx_sdp))",
    visibility = ["//visibility:public"],
)

# Create a filegroup that references the output directory
filegroup(
    name = "qnx_sdp_files",
    srcs = [":qnx_sdp"],
    visibility = ["//visibility:public"],
)

# Local stub for qnxsoftwarecenter_clt so the package can be built inside this
# repository for testing. Replace with the real installer binary when integrating
# into a consuming workspace that provides @qnx_software_center.
sh_binary(
    name = "qnxsoftwarecenter_clt",
    srcs = ["qnxsoftwarecenter_clt.sh"],
    visibility = ["//visibility:private"],
)
