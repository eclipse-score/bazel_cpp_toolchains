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
qnx_sdp_gen(
    name = "qnx_sdp",
    patchset = "patchset-qnx803-virtio.plist",
    qnxsoftwarecenter_clt = ":qnxsoftwarecenter_clt",
    visibility = ["//visibility:public"],
)