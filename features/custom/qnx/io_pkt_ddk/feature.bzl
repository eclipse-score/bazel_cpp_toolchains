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
load("@rules_cc//cc/toolchains:feature_constraint.bzl", "cc_feature_constraint")

# usr/include/devs/opt_global.mk: feature flags, always on for the DDK.
_OPT_GLOBAL_ARGS = [
    "-DSMP",
    "-DEARLY_AP_STARTUP",
    "-DVIMAGE",
    "-DALTQ",
    "-DDEV_NETMAP",
    "-D_STRINGS_H_INCLUDED",
    "-D_UNISTD_H_INCLUDED",
]

_KERNEL_PERSONALITY_ARGS = [
    "-D__FreeBSD__",
    "-D_KERNEL",
    "-DHAVE_KERNEL_OPTION_HEADERS",
    "-D__EXT",
    "-fno-builtin-log",
    "-fno-strict-aliasing",
]

def make_io_pkt_ddk_feature(target_dir, cpu):
    """Creates the opt-in `io_pkt_ddk` feature for building QNX io-pkt drivers/modules.

    Mirrors usr/include/devs/devs.mk and mods.mk: the FreeBSD kernel
    compilation personality plus the devs/ include paths. Disabled by
    default; targets opt in with `features = ["io_pkt_ddk"]`.

    Args:
        target_dir: label (as a string) of this toolchain instance's SDP
            `target_dir` filegroup (e.g. "@score_qcc_toolchain_pkg//:target_dir").
        cpu: str, target CPU ("x86_64" or "aarch64") -- selects devs/include_$(CPU).

    Returns:
        A feature definition for the io_pkt_ddk toolchain feature.
    """
    cc_args(
        name = "io_pkt_ddk_args",
        actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
        args = _KERNEL_PERSONALITY_ARGS + _OPT_GLOBAL_ARGS + [
            "-I{target_dir}/usr/include/devs",
            "-I{target_dir}/usr/include/devs/contrib/ck/include",
            "-I{target_dir}/usr/include/devs/include_" + cpu,
            "-I{target_dir}/usr/include/devs/qnx",
            "-I{target_dir}/usr/include/devs/qnx-gen",
            "-I{target_dir}/usr/include/devs/sys-nto",
        ],
        format = {"target_dir": target_dir},
    )

    cc_feature_constraint(
        name = "io_pkt_ddk_is_dbg",
        all_of = ["@score_bazel_cpp_toolchains//features/native/markers:dbg"],
    )

    # devs.mk/mods.mk: only added for the "diag" VARIANT_LIST (QNX's -c dbg equivalent).
    cc_args(
        name = "io_pkt_ddk_diag_args",
        actions = ["@rules_cc//cc/toolchains/actions:c_compile_actions"],
        args = ["-DINVARIANTS", "-DINVARIANT_SUPPORT", "-DKTR"],
        requires_any_of = [":io_pkt_ddk_is_dbg"],
    )

    cc_feature(
        name = "io_pkt_ddk",
        feature_name = "io_pkt_ddk",
        args = [":io_pkt_ddk_args", ":io_pkt_ddk_diag_args"],
    )
