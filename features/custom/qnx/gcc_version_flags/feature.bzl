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

load("@rules_cc//cc/toolchains:args.bzl", "cc_args")
load("@rules_cc//cc/toolchains:feature.bzl", "cc_feature")

def make_gcc_version_flags_feature(cpu, version):
    """Creates a feature pinning qcc to the toolchain instance's resolved GCC version.

    Args:
        cpu: str, normalized target CPU as used in qcc's `gcc_nto*` identifiers
            (e.g. "aarch64le", "x86_64").
        version: str, GCC version resolved for this toolchain instance.

    Returns:
        A feature definition for the gcc_version_flags toolchain.
    """
    cc_args(
        name = "gcc_version_compile_args",
        actions = ["@rules_cc//cc/toolchains/actions:compile_actions"],
        args = ["-V{version},gcc_nto{cpu}".format(version = version, cpu = cpu)],
    )

    cc_args(
        name = "gcc_version_link_args",
        actions = ["@rules_cc//cc/toolchains/actions:link_actions"],
        args = ["-V{version},gcc_nto{cpu}_cxx".format(version = version, cpu = cpu)],
    )

    cc_feature(
        name = "gcc_version_flags",
        feature_name = "gcc_version_flags",
        args = [
            ":gcc_version_compile_args",
            ":gcc_version_link_args",
        ],
    )
