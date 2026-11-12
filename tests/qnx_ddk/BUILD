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

"""io-pkt Driver Development Kit (DDK) smoke build.

Verifies that QNX SDP's FreeBSD-derived kernel headers (usr/include/devs)
compile via the toolchain's opt-in `io_pkt_ddk` feature (see
features/custom/qnx/io_pkt_ddk), which is disabled by default and only
applies to targets that request it below.
"""

load("@rules_cc//cc:defs.bzl", "cc_library")

# Build only (`bazel build --config x86_64-qnx //qnx_ddk:io_pkt_ddk_test`).
# Not wired into any test_suite; `io_pkt_ddk` is opt-in so this is the only
# target affected by it.
cc_library(
    name = "io_pkt_ddk_test",
    srcs = ["io_pkt_ddk_test.c"],
    features = [
        "io_pkt_ddk",
        "c_std_c99",
    ],
    target_compatible_with = select({
        "@platforms//os:qnx": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
)
