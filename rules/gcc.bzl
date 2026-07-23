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

load("@score_bazel_cpp_toolchains//rules:common.bzl", "SDP_VERSION_MAPPING", "get_flag_groups", "label_list_to_string")

# Constants
_OS_QNX = "qnx"
_OS_LINUX = "linux"
_CPU_AARCH64 = "aarch64"
_CPU_AARCH64LE = "aarch64le"
_SDP_VERSION_MAPPING = SDP_VERSION_MAPPING
_CANONICAL_REPO_SEPARATOR = "++"
_CANONICAL_REPO_TAG_SEPARATOR = "+"
_PLACEHOLDER_TOOLCHAIN_PKG = "%{toolchain_pkg}%"
_TRIPLE_AARCH64_QNX_FMT = "aarch64-unknown-nto-qnx{sdp}"
_TRIPLE_GENERIC_QNX_FMT = "{cpu}-pc-nto-qnx{sdp}"

def dict_union(x, y):
    """Merges two dictionaries into a new dictionary.

    Args:
        x: dict, the first dictionary to merge.
        y: dict, the second dictionary to merge (values override x on conflicts).

    Returns:
        dict: A new dictionary containing merged values from both x and y.
    """
    z = {}
    z.update(x)
    z.update(y)
    return z

def _get_cc_config_linux(rctx):
    """Generates cc_toolchain_config filegroup and rule content for Linux targets.

    Args:
        rctx: RepositoryContext object with toolchain attributes.

    Returns:
        str: BUILD file content defining filegroup and cc_toolchain_config for Linux.
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
    extra_known_features = {tc_extra_known_features},
    extra_enabled_features = {tc_extra_enabled_features},
    visibility = ["//visibility:public"],
)
""".format(
        tc_pkg_repo = rctx.attr.tc_pkg_repo,
        tc_cpu = rctx.attr.tc_cpu,
        tc_os = rctx.attr.tc_os,
        tc_extra_known_features = label_list_to_string(rctx.attr.extra_known_features),
        tc_extra_enabled_features = label_list_to_string(rctx.attr.extra_enabled_features),
    )

def _get_cc_config_qnx(rctx):
    """Generates cc_toolchain_config filegroup and rule content for QNX targets.

    Args:
        rctx: RepositoryContext object with toolchain attributes.

    Returns:
        str: BUILD file content defining filegroup and cc_toolchain_config for QNX.
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
    host_dir = "@{tc_pkg_repo}//:host_dir",
    target_dir = "@{tc_pkg_repo}//:target_dir",
    cxx_builtin_include_directories = "@{tc_pkg_repo}//:cxx_builtin_include_directories",
    target_cpu = "{tc_cpu}",
    target_os = "{tc_os}",
    extra_known_features = {tc_extra_known_features},
    extra_enabled_features = {tc_extra_enabled_features},
    visibility = ["//visibility:public"],
)
""".format(
        tc_pkg_repo = rctx.attr.tc_pkg_repo,
        tc_cpu = rctx.attr.tc_cpu,
        tc_os = rctx.attr.tc_os,
        tc_extra_known_features = label_list_to_string(rctx.attr.extra_known_features),
        tc_extra_enabled_features = label_list_to_string(rctx.attr.extra_enabled_features),
    )

def _normalize_cpu(cpu):
    """Converts CPU name to its normalized form for toolchain paths.

    Maps aarch64 to aarch64le for use in GCC triple names. Other CPUs pass through unchanged.

    Args:
        cpu: str, the CPU architecture name.

    Returns:
        str: Normalized CPU name suitable for GCC triple.
    """
    return _CPU_AARCH64LE if cpu == _CPU_AARCH64 else cpu

def _apply_sdp_version_mapping(sdp_version):
    """Applies version mapping for SDP compatibility constraints.

    Maps certain SDP versions to constraint-compatible versions for platform definitions.

    Args:
        sdp_version: str, the original SDP version.

    Returns:
        str: Mapped SDP version, or original if no mapping exists.
    """
    return _SDP_VERSION_MAPPING.get(sdp_version, sdp_version)

def _get_canonical_pkg_name(rctx):
    """Resolves the canonical repository name for the toolchain package.

    In bzlmod, repos created by module extensions follow the pattern:
    module++extension+repo_name. This function extracts the canonical name
    for the package repository.

    Args:
        rctx: RepositoryContext object.

    Returns:
        str: Canonical package repository name.
    """
    my_canonical_name = rctx.name
    if _CANONICAL_REPO_SEPARATOR in my_canonical_name:
        parts = my_canonical_name.rsplit(_CANONICAL_REPO_TAG_SEPARATOR, 1)
        prefix = parts[0] + _CANONICAL_REPO_TAG_SEPARATOR
        return prefix + rctx.attr.tc_pkg_repo
    else:
        return rctx.attr.tc_pkg_repo

def _impl(rctx):
    """Implementation of the gcc_toolchain repository rule.

    Creates toolchain configuration by instantiating templates with proper substitutions.
    Handles both Linux and QNX target platforms with platform-specific configuration.

    Args:
        rctx: RepositoryContext object providing access to rule attributes and methods.

    Fails:
        If an unsupported OS (not Linux or QNX) is specified in tc_os attribute.
    """
    tc_identifier = rctx.attr.tc_identifier

    if rctx.attr.tc_os == _OS_QNX:
        cc_toolchain_config = _get_cc_config_qnx(rctx)
    elif rctx.attr.tc_os == _OS_LINUX:
        cc_toolchain_config = _get_cc_config_linux(rctx)
    else:
        fail("Unsupported OS '{}' detected! Supported values: {}, {}".format(
            rctx.attr.tc_os,
            _OS_LINUX,
            _OS_QNX,
        ))

    # Build constraint identifiers for toolchain registration
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
    canonical_pkg_name = _get_canonical_pkg_name(rctx)

    # Replace %{toolchain_pkg}% placeholder in extra flags with canonical name
    def replace_placeholder(flags):
        return [flag.replace(_PLACEHOLDER_TOOLCHAIN_PKG, canonical_pkg_name) for flag in flags]

    extra_compile_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_compile_flags))
    extra_c_compile_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_c_compile_flags))
    extra_cxx_compile_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_cxx_compile_flags))
    extra_link_flags = get_flag_groups(replace_placeholder(rctx.attr.extra_link_flags))
    compiler_library_search_paths = replace_placeholder(rctx.attr.tc_compiler_library_search_paths)

    template_dict = {
        "%{compiler_library_search_paths_switch}": "True" if len(rctx.attr.tc_compiler_library_search_paths) else "False",
        "%{compiler_library_search_paths}": ":".join(["/proc/self/cwd/" + entry for entry in compiler_library_search_paths]),
        "%{extra_c_compile_flags_switch}": "True" if len(rctx.attr.extra_c_compile_flags) else "False",
        "%{extra_c_compile_flags}": extra_c_compile_flags,
        "%{extra_compile_flags_switch}": "True" if len(rctx.attr.extra_compile_flags) else "False",
        "%{extra_compile_flags}": extra_compile_flags,
        "%{extra_cxx_compile_flags_switch}": "True" if len(rctx.attr.extra_cxx_compile_flags) else "False",
        "%{extra_cxx_compile_flags}": extra_cxx_compile_flags,
        "%{extra_link_flags_switch}": "True" if len(rctx.attr.extra_link_flags) else "False",
        "%{extra_link_flags}": extra_link_flags,
        "%{tc_cpu}": _normalize_cpu(rctx.attr.tc_cpu),
        "%{tc_identifier}": "gcc",
        "%{tc_runtime_es}": rctx.attr.tc_runtime_ecosystem,
        "%{tc_version}": rctx.attr.gcc_version,
    }

    if rctx.attr.tc_os == _OS_QNX:
        mapped_sdp_version = _apply_sdp_version_mapping(rctx.attr.sdp_version)
        extra_template_dict = {
            "%{license_info_value}": rctx.attr.license_info_value,
            "%{license_info_variable}": rctx.attr.license_info_variable,
            "%{license_path}": rctx.attr.license_path,
            "%{sdp_version}": mapped_sdp_version,
            "%{tc_cpu_cxx}": _normalize_cpu(rctx.attr.tc_cpu),
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

    rctx.template(
        "shared_features.bzl",
        rctx.attr.cc_toolchain_shared_features,
        {},
    )

    if rctx.attr.tc_os == _OS_LINUX:
        # There is an issue with gcov and cc_toolchain config.
        # See: https://github.com/bazelbuild/rules_cc/issues/351
        rctx.template(
            "gcov_wrapper",
            rctx.attr._cc_gcov_wrapper_script,
            {
                "%{tc_gcov_path}": "external/{canonical_pkg}/bin/{cpu}-unknown-linux-gnu-gcov".format(
                    canonical_pkg = canonical_pkg_name,
                    cpu = rctx.attr.tc_cpu,
                ),
            },
        )
    elif rctx.attr.tc_os == _OS_QNX:
        # Generate gcov wrapper for QNX toolchains to enable `bazel coverage`.
        # See: https://github.com/bazelbuild/rules_cc/issues/351
        mapped_sdp_version = _apply_sdp_version_mapping(rctx.attr.sdp_version)
        if rctx.attr.tc_cpu == _CPU_AARCH64:
            gcov_triple = _TRIPLE_AARCH64_QNX_FMT.format(sdp = mapped_sdp_version)
        else:
            gcov_triple = _TRIPLE_GENERIC_QNX_FMT.format(cpu = rctx.attr.tc_cpu, sdp = mapped_sdp_version)
        rctx.template(
            "gcov_wrapper",
            rctx.attr._cc_gcov_wrapper_script,
            {
                "%{tc_gcov_path}": "external/{canonical_pkg}/host/linux/x86_64/usr/bin/{triple}-gcov".format(
                    canonical_pkg = canonical_pkg_name,
                    triple = gcov_triple,
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
        "cc_toolchain_shared_features": attr.label(
            doc = "Path to the shared features template.",
        ),
        "extra_c_compile_flags": attr.string_list(doc = "Extra/Additional C-specific compile flags."),
        "extra_compile_flags": attr.string_list(doc = "Extra/Additional compile flags."),
        "extra_cxx_compile_flags": attr.string_list(doc = "Extra/Additional C++-specific compile flags."),
        "extra_known_features": attr.label_list(doc = "Extra/Additional C++ FeatureInfo provider list"),
        "extra_enabled_features": attr.label_list(doc = "Extra/Additional C++ FeatureInfo provider list enabled by default"),
        "extra_link_flags": attr.string_list(doc = "Extra/Additional link flags."),
        "gcc_version": attr.string(doc = "GCC version string"),
        "use_base_constraints_only": attr.bool(doc = "Boolean flag to state only base constraints should be used for toolchain compatibility definition"),
        "license_info_value": attr.string(doc = "License info value (custom settings)"),
        "license_info_variable": attr.string(doc = "License info variable name (custom settings)"),
        "license_path": attr.string(doc = "Lincese path"),
        "sdk_version": attr.string(doc = "SDK version string"),
        "sdp_version": attr.string(doc = "SDP version string"),
        "tc_compiler_library_search_paths": attr.string_list(doc = "Additional search path which compiler needs."),
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
