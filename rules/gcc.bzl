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

load("@score_bazel_cpp_toolchains//rules:common.bzl", "get_flag_groups")

def dict_union(x, y):
    """ TODO: Write docstrings
    """
    z = {}
    z.update(x)
    z.update(y)
    return z

def _get_cc_config_linux(rctx):
    """ TODO: Write docstring
    """
    return """
filegroup(
    name = "all_files",
    srcs = [
        "@{tc_pkg_repo}//:all_files",
        "gcov_wrapper",
    ]
)

cc_toolchain_config(
    name = "cc_toolchain_config",
    ar_binary = "@{tc_pkg_repo}//:ar",
    cc_binary = "@{tc_pkg_repo}//:cc",
    cxx_binary = "@{tc_pkg_repo}//:cxx",
    gcov_binary = "@{tc_pkg_repo}//:gcov",
    strip_binary = "@{tc_pkg_repo}//:strip",
    sysroot = "@{tc_pkg_repo}//:sysroot_dir",
    target_cpu = "{tc_cpu}",
    target_os = "{tc_os}",
    visibility = ["//visibility:public"],
)
""".format(
        tc_pkg_repo = rctx.attr.tc_pkg_repo,
        tc_cpu = rctx.attr.tc_cpu,
        tc_os = rctx.attr.tc_os,
    )

def _get_cc_config_qnx(rctx):
    """ TODO: Write docstring
    """
    return """
filegroup(
    name = "all_files",
    srcs = [
        "@{tc_pkg_repo}//:all_files",
    ]
)

cc_toolchain_config(
    name = "cc_toolchain_config",
    ar_binary = "@{tc_pkg_repo}//:ar",
    cc_binary = "@{tc_pkg_repo}//:cc",
    cxx_binary = "@{tc_pkg_repo}//:cxx",
    strip_binary = "@{tc_pkg_repo}//:strip",
    host_dir = "@{tc_pkg_repo}//:host_dir",
    target_dir = "@{tc_pkg_repo}//:target_dir",
    cxx_builtin_include_directories = "@{tc_pkg_repo}//:cxx_builtin_include_directories",
    target_cpu = "{tc_cpu}",
    target_os = "{tc_os}",
    visibility = ["//visibility:public"],
)
""".format(
        tc_pkg_repo = rctx.attr.tc_pkg_repo,
        tc_cpu = rctx.attr.tc_cpu,
        tc_os = rctx.attr.tc_os,
    )

def _impl(rctx):
    """ Implementation of the gcc_toolchain repository rule.

    Args:
        rctx: The repository context.
    """
    tc_identifier = "gcc_{}".format(rctx.attr.gcc_version)
    if rctx.attr.tc_os == "qnx":
        tc_identifier = "sdp_{}".format(rctx.attr.sdp_version)

    if rctx.attr.tc_os == "qnx":
        cc_toolchain_config = _get_cc_config_qnx(rctx)
    elif rctx.attr.tc_os == "linux":
        cc_toolchain_config = _get_cc_config_linux(rctx)
    else:
        fail("Unsupported OS detected!")

    rctx.template(
        "BUILD",
        rctx.attr._cc_toolchain_build,
        {
            "%{cc_toolchain_config}": cc_toolchain_config,
            "%{tc_pkg_repo}": rctx.attr.tc_pkg_repo,
            "%{tc_cpu}": rctx.attr.tc_cpu,
            "%{tc_os}": rctx.attr.tc_os,
            "%{tc_version}": rctx.attr.gcc_version,
            "%{tc_identifier}": tc_identifier, 
            "%{tc_runtime_es}": rctx.attr.tc_runtime_ecosystem,
        },
    )

    extra_compile_flags = get_flag_groups(rctx.attr.extra_compile_flags)
    extra_link_flags = get_flag_groups(rctx.attr.extra_link_flags)


    template_dict = {
        "%{tc_version}": rctx.attr.gcc_version,
        "%{tc_identifier}": "gcc",
        "%{tc_cpu}": "aarch64le" if rctx.attr.tc_cpu == "aarch64" else rctx.attr.tc_cpu,
        "%{tc_runtime_es}": rctx.attr.tc_runtime_ecosystem,
        "%{extra_compile_flags_switch}": "True" if len(rctx.attr.extra_compile_flags) else "False",
        "%{extra_compile_flags}":extra_compile_flags,
        "%{extra_link_flags_switch}": "True" if len(rctx.attr.extra_link_flags) else "False",
        "%{extra_link_flags}": extra_link_flags,
    }

    if rctx.attr.tc_os == "qnx":
        extra_template_dict = {
            "%{tc_cpu_cxx}": "aarch64le" if rctx.attr.tc_cpu == "aarch64" else rctx.attr.tc_cpu,
            "%{sdp_version}": rctx.attr.sdp_version,
            "%{license_path}": rctx.attr.license_path,
            "%{use_license_info}": "False" if rctx.attr.license_info_value == "" else "True",
            "%{license_info_variable}": rctx.attr.license_info_variable,
            "%{license_info_value}": rctx.attr.license_info_value,
        }
        template_dict = dict_union(template_dict, extra_template_dict)

    rctx.template(
        "cc_toolchain_config.bzl",
        rctx.attr.cc_toolchain_config,
        template_dict,
    )

    rctx.template(
        "flags.bzl",
        rctx.attr.cc_toolchain_flags,
        {},
    )

    if rctx.attr.tc_os == "linux":
        # There is an issue with gcov and cc_toolchain config. 
        # See: https://github.com/bazelbuild/rules_cc/issues/351
        rctx.template(
            "gcov_wrapper",
            rctx.attr._cc_gcov_wrapper_script,
            {
                "%{tc_gcov_path}": "external/score_bazel_cpp_toolchains++gcc+{repo}/bin/{cpu}-unknown-linux-gnu-gcov".format(
                    repo = rctx.attr.tc_pkg_repo,
                    cpu = "aarch64le" if rctx.attr.tc_cpu == "aarch64" else rctx.attr.tc_cpu,
                ),
            },
        )

gcc_toolchain = repository_rule(
    implementation = _impl,
    attrs = {
        "tc_pkg_repo": attr.string(doc="The label name of toolchain tarbal."),
        "tc_cpu": attr.string(doc="Target platform CPU."),
        "tc_os": attr.string(doc="Target platform OS."),
        "gcc_version": attr.string(doc="GCC version number"),
        "extra_compile_flags": attr.string_list(doc="Extra/Additional compile flags."),
        "extra_link_flags": attr.string_list(doc="Extra/Additional link flags."),
        "sdp_version": attr.string(doc="SDP version number"),
        "license_path": attr.string(doc="Lincese path"),
        "license_info_variable": attr.string(doc="License info variable name (custom settings)"),
        "license_info_value": attr.string(doc="License info value (custom settings)"),
        "tc_runtime_ecosystem": attr.string(doc="Runtime ecosystem."),
        "tc_system_toolchain": attr.bool(doc="Boolean flag to state if this is a system toolchain"),
        "cc_toolchain_config": attr.label(
            doc = "Path to the cc_config.bzl template file.",
        ),
        "cc_toolchain_flags": attr.label(
            doc = "Path to the Bazel BUILD file template for the toolchain.",
        ),
        "_cc_toolchain_build": attr.label(
            default = "@score_bazel_cpp_toolchains//templates:BUILD.template",
            doc = "Path to the Bazel BUILD file template for the toolchain.",
        ),
        "_cc_gcov_wrapper_script": attr.label(
            default = "@score_bazel_cpp_toolchains//templates/linux:cc_gcov_wrapper.template",
        )
    },
)