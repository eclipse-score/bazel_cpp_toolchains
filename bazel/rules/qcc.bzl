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

""" Module rule for defining GCC toolchains in Bazel.
"""

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

""" Module rule for defining GCC toolchains in Bazel.
"""

load("@score_bazel_cpp_toolchains//bazel/rules:common.bzl", "get_flag_groups")

def _impl(rctx):
    """ Implementation of the gcc_toolchain repository rule.

    Args:
        rctx: The repository context.
    """

    rctx.template(
        "BUILD",
        rctx.attr._cc_toolchain_common_build,
        {
            "%{tc_pkg_repo}": rctx.attr.tc_pkg_repo,
            "%{tc_cpu}": rctx.attr.tc_cpu,
            "%{tc_family}": "qcc",
            "%{tc_os}": "qnx",
            "%{tc_version}": rctx.attr.qcc_version,
        },
    )

    rctx.template(
        "qcc/BUILD",
        rctx.attr._cc_toolchain_qcc_build,
        {
            "%{tc_pkg_repo}": rctx.attr.tc_pkg_repo,
        },
    )

    extra_compile_flags = get_flag_groups(rctx.attr.extra_compile_flags)
    extra_link_flags = get_flag_groups(rctx.attr.extra_link_flags)

    rctx.template(
        "qcc/cc_toolchain_config.bzl",
        rctx.attr._cc_toolchain_config,
        {
            "%{tc_cpu}": "aarch64le" if rctx.attr.tc_cpu == "arm64" else rctx.attr.tc_cpu,
            "%{tc_cpu_cxx}": "aarch64le" if rctx.attr.tc_cpu == "arm64" else rctx.attr.tc_cpu,
            "%{tc_version}": rctx.attr.qcc_version,
            "%{sdp_version}": rctx.attr.sdp_version,
            "%{extra_compile_flags_switch}": "True" if len(rctx.attr.extra_compile_flags) else "False",
            "%{extra_compile_flags}":extra_compile_flags,
            "%{extra_link_flags_switch}": "True" if len(rctx.attr.extra_link_flags) else "False",
            "%{extra_link_flags}": extra_link_flags,
            "%{qnx_license_path}": rctx.attr.qnx_license_path,
            "%{use_license_info}": "False" if rctx.attr.license_info_value == "" else "True",
            "%{license_info_variable}": rctx.attr.license_info_variable,
            "%{license_info_value}": rctx.attr.license_info_value,
        },
    )

qcc_toolchain = repository_rule(
    implementation = _impl,
    attrs = {
        "tc_pkg_repo": attr.string(doc="The label name of toolchain tarbal"),
        "tc_cpu": attr.string(doc="Target platform CPU"),
        "qcc_version": attr.string(doc="GCC version number"),
        "sdp_version": attr.string(doc="SDP version number"),
        "qnx_license_path": attr.string(doc="QNX Lincese path"),
        "license_info_variable": attr.string(doc="QNX License info variable name (custom settings)"),
        "license_info_value": attr.string(doc="QNX License info value (custom settings)"),
        "extra_compile_flags": attr.string_list(doc="Extra/Additional compile flags."),
        "extra_link_flags": attr.string_list(doc="Extra/Additional link flags."),
        "_cc_toolchain_config": attr.label(
            default = "@score_bazel_cpp_toolchains//templates/qcc:cc_toolchain_config.bzl.template",
            doc = "Path to the cc_config.bzl template file.",
        ),
        "_cc_toolchain_common_build": attr.label(
            default = "@score_bazel_cpp_toolchains//templates/common:BUILD.template",
            doc = "Path to the Bazel BUILD file template for the toolchain.",
        ),
        "_cc_toolchain_qcc_build": attr.label(
            default = "@score_bazel_cpp_toolchains//templates/qcc:BUILD.template",
            doc = "Path to the Bazel BUILD file template for the toolchain.",
        ),
    },
)