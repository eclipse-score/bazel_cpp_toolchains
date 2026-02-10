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
    """ Helper function to merge 2 dict

    Args:
        x: The 1st dict
        y: The 2nd dict

    Returns:
        z: Merged dict
    """
    z = {}
    z.update(x)
    z.update(y)
    return z

def _get_cc_config_linux(rctx):
    """ Write configuration invocation function for Linux.
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
    """ Write configuration invocation function for QNX.
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
    tc_identifier = rctx.attr.tc_identifier

    if rctx.attr.tc_os == "qnx":
        cc_toolchain_config = _get_cc_config_qnx(rctx)
    elif rctx.attr.tc_os == "linux":
        cc_toolchain_config = _get_cc_config_linux(rctx)
    else:
        fail("Unsupported OS detected!")

    tc_identifier_short_1 = ""
    tc_identifier_long_1 = "[]"
    tc_identifier_short_2 = ""
    tc_identifier_long_2 = "[]"
    if not rctx.attr.use_base_constraints_only:
        if tc_identifier != "":
            tc_identifier_short_1 = "-{}".format(tc_identifier)
            tc_identifier_long_1 = "[\"@score_bazel_platforms//version:{}\"]".format(tc_identifier)
        if rctx.attr.tc_runtime_ecosystem != "":
            tc_identifier_short_2 = "-{}".format(rctx.attr.tc_runtime_ecosystem)
            tc_identifier_long_2 = "[\"@score_bazel_platforms//runtime_es:{}\"]".format(rctx.attr.tc_runtime_ecosystem)

    rctx.template(
        "BUILD",
        rctx.attr._cc_toolchain_build,
        {
            "%{cc_toolchain_config}": cc_toolchain_config,
            "%{tc_cpu}": rctx.attr.tc_cpu,
            "%{tc_identifier}": tc_identifier,
            "%{tc_os}": rctx.attr.tc_os,
            "%{tc_pkg_repo}": rctx.attr.tc_pkg_repo,
            "%{tc_runtime_es}": rctx.attr.tc_runtime_ecosystem,
            "%{tc_version}": rctx.attr.gcc_version,
            "%{tc_identifier_short_1}": tc_identifier_short_1,
            "%{tc_identifier_short_2}": tc_identifier_short_2,
            "%{tc_identifier_long_1}": tc_identifier_long_1,
            "%{tc_identifier_long_2}": tc_identifier_long_2,
        },
    )

    # Get canonical repository name for the toolchain package
    # In bzlmod, repos created by module extensions follow the pattern: module++extension+repo_name
    # Get our own canonical name (e.g., "score_bazel_cpp_toolchains++gcc+score_autosd_10_toolchain")
    # and replace our repo name with the package repo name
    my_canonical_name = rctx.name
    if "++" in my_canonical_name:
        parts = my_canonical_name.rsplit("+", 1)
        prefix = parts[0] + "+"
        canonical_pkg_name = prefix + rctx.attr.tc_pkg_repo
    else:
        canonical_pkg_name = rctx.attr.tc_pkg_repo

    # Replace %{toolchain_pkg}% placeholder in extra flags with canonical name
    def replace_placeholder(flags):
        return [flag.replace("%{toolchain_pkg}%", canonical_pkg_name) for flag in flags]

    extra_compile_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_compile_flags))
    extra_c_compile_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_c_compile_flags))
    extra_cxx_compile_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_cxx_compile_flags))
    extra_link_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_link_flags))

    template_dict = {
        "%{extra_c_compile_flags_switch}": "True" if len(rctx.attr.extra_c_compile_flags) else "False",
        "%{extra_c_compile_flags}": extra_c_compile_flags,
        "%{extra_compile_flags_switch}": "True" if len(rctx.attr.extra_compile_flags) else "False",
        "%{extra_compile_flags}": extra_compile_flags,
        "%{extra_cxx_compile_flags_switch}": "True" if len(rctx.attr.extra_cxx_compile_flags) else "False",
        "%{extra_cxx_compile_flags}": extra_cxx_compile_flags,
        "%{extra_link_flags_switch}": "True" if len(rctx.attr.extra_link_flags) else "False",
        "%{extra_link_flags}": extra_link_flags,
        "%{tc_cpu}": "aarch64le" if rctx.attr.tc_cpu == "aarch64" else rctx.attr.tc_cpu,
        "%{tc_identifier}": "gcc",
        "%{tc_runtime_es}": rctx.attr.tc_runtime_ecosystem,
        "%{tc_version}": rctx.attr.gcc_version,
    }

    if rctx.attr.tc_os == "qnx":
        extra_template_dict = {
            "%{license_info_value}": rctx.attr.license_info_value,
            "%{license_info_variable}": rctx.attr.license_info_variable,
            "%{license_path}": rctx.attr.license_path,
            "%{sdp_version}": rctx.attr.sdp_version,
            "%{tc_cpu_cxx}": "aarch64le" if rctx.attr.tc_cpu == "aarch64" else rctx.attr.tc_cpu,
            "%{use_license_info}": "False" if rctx.attr.license_info_value == "" else "True",
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
        "cc_toolchain_config": attr.label(
            doc = "Path to the cc_config.bzl template file.",
        ),
        "cc_toolchain_flags": attr.label(
            doc = "Path to the Bazel BUILD file template for the toolchain.",
        ),
        "extra_c_compile_flags": attr.string_list(doc = "Extra/Additional C-specific compile flags."),
        "extra_compile_flags": attr.string_list(doc = "Extra/Additional compile flags."),
        "extra_cxx_compile_flags": attr.string_list(doc = "Extra/Additional C++-specific compile flags."),
        "extra_link_flags": attr.string_list(doc = "Extra/Additional link flags."),
        "gcc_version": attr.string(doc = "GCC version string"),
        "use_base_constraints_only": attr.bool(doc="Boolean flag to state only base constraints should be used for toolchain compatibility definition"),
        "license_info_value": attr.string(doc = "License info value (custom settings)"),
        "license_info_variable": attr.string(doc = "License info variable name (custom settings)"),
        "license_path": attr.string(doc = "Lincese path"),
        "sdk_version": attr.string(doc = "SDP version string"),
        "sdp_version": attr.string(doc = "SDP version string"),
        "tc_cpu": attr.string(doc = "Target platform CPU."),
        "tc_identifier": attr.string(doc = "Constraint to be used for toolchain definition (e.g. gcc_12.2.0)."),
        "tc_os": attr.string(doc = "Target platform OS."),
        "tc_pkg_repo": attr.string(doc = "The label name of toolchain tarbal."),
        "tc_runtime_ecosystem": attr.string(doc = "Runtime ecosystem."),
        "tc_system_toolchain": attr.bool(doc = "Boolean flag to state if this is a system toolchain"),
        "_cc_gcov_wrapper_script": attr.label(
            default = "@score_bazel_cpp_toolchains//templates/linux:cc_gcov_wrapper.template",
        ),
        "_cc_toolchain_build": attr.label(
            default = "@score_bazel_cpp_toolchains//templates:BUILD.template",
            doc = "Path to the Bazel BUILD file template for the toolchain.",
        ),
    },
)
