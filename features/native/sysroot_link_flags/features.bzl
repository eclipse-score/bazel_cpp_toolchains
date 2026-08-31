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

load("@rules_cc//cc/toolchains:feature.bzl", "cc_feature")
load("@rules_cc//cc/toolchains/args:sysroot.bzl", "cc_sysroot")

def make_sysroot_link_flags(target_os, sysroot):
    """Creates the sysroot_link_flags feature for this toolchain's sysroot directory.

    cc_sysroot already emits "--sysroot={sysroot}" on its own; only the extra
    "-Wl,--sysroot={sysroot}" needs to be listed here.

    Args:
        sysroot: label of the directory rule for this toolchain's sysroot.
    """
    if target_os == "linux":
        cc_sysroot(
            name = "sysroot_link_flags_args",
            actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
            args = ["-Wl,--sysroot={sysroot}"],
            sysroot = sysroot,
        )

        cc_feature(
            name = "sysroot_link_flags",
            args = [":sysroot_link_flags_args"],
            feature_name = "sysroot_link_flags",
        )
