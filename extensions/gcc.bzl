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

""" Module extension for setting up GCC toolchains in Bazel.
"""
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@score_bazel_cpp_toolchains//packages:version_matrix.bzl", "VERSION_MATRIX")
load("@score_bazel_cpp_toolchains//rules:gcc.bzl", "gcc_toolchain")

# GCC interface API for archive tag class
_attrs_sdp = {
    "name": attr.string(
        default = "",
        doc = "package name of toolchain, default set to toolchain toolchain name + `_pkg`.",
    ),
    "build_file": attr.string(
        mandatory = False,
        default = "",
        doc = "The path to the BUILD file of selected archive.",
    ),
    "url": attr.string(
        mandatory = False,
        default = "",
        doc = "Url to the toolchain archive."
    ),
    "strip_prefix": attr.string(
        mandatory = False,
        default = "",
        doc = "Strip prefix from toolchain archive.", 
    ),
    "sha256": attr.string(
        mandatory = False,
        default = "",
        doc = "Checksum of the archive."
    ),
}

# GCC interface API for toolchain tag class
_attrs_tc = {
    "name": attr.string(
        mandatory = True,
        doc = "Toolchain repo name, default set to `score_gcc_toolchain`.",
    ),
    "sdp_to_link": attr.string(
        mandatory = False,
        default = "",
        doc = "Name of the toolchain package to be linked with this toolchain, default set to toolchain name + `_pkg`.",
    ),
    "use_default_package": attr.bool(
        default = False,
        doc = "Whether to use the default package from the version matrix, default set to False.",
    ),
    "use_system_toolchain": attr.bool(
        default = False,
        doc = "TBD",
    ),
    "runtime_ecosystem": attr.string(
        default = "posix",
        mandatory = False,
        doc = "TBD",
    ),
    "target_cpu": attr.string(
        mandatory = True,
        values = [
            "x86_64",
            "aarch64",
        ],
        doc = "Target platform CPU",
    ),
    "target_os": attr.string(
        mandatory = True,
        values = [
            "linux",
            "qnx",
        ],
        doc = "Target platform OS",
    ),
    "version": attr.string(
        default = "",
        mandatory = False,
        doc = "Version of the GCC toolchain.",
    ),
    "license_info_url": attr.string(
        default = "",
        mandatory = False,
        doc = "URL of the QNX license server.",
    ),
    "license_info_variable": attr.string(
        default = "",
        mandatory = False,
        doc = "QNX License info variable.",
    ),
    "sdp_version": attr.string(
        default = "8.0.0",
        mandatory = False,
        doc = "Version of the SDP package.",
    ),
    "license_path": attr.string(
        default = "/opt/score_qnx/license/licenses",
        mandatory = False,
        doc = "Path to the shared license file.",
    ),
    "extra_compile_flags": attr.string_list(
        mandatory = False,
        default = [],
        doc = "List of additional flags to be passed to compiler.",
    ),
    "extra_link_flags": attr.string_list(
        mandatory = False,
        default = [],
        doc = "List of additional flags to be passed to linker.",
    ),
}

def _get_packages(tags):
    """Gets archive information from given tags.

    Args:
        tags: A list of tags containing archive information.

    Returns:
        dict: A dictionary with archive information.
    """
    packages = []    
    for tag in tags:
        packages.append({
            "name": tag.name,
            "url": tag.url,
            "strip_prefix": tag.strip_prefix,
            "sha256": tag.sha256,
            "build_file": tag.build_file,
        })    
    return packages

def _get_toolchains(tags):
    """Gets toolchain information from given tags.

    Args:
        tags: A list of tags containing toolchain information.
    
    Returns:
        dict: A dictionary with toolchain information.
    """
    toolchains = []
    for tag in tags:
        toolchain = {
            "name": tag.name,
            "tc_cpu": tag.target_cpu,
            "tc_os": tag.target_os,
            "tc_family": "gcc", # TODO: it can be llvm, check if we need to pull it in common
            "tc_version": tag.version,
            "sdp_to_link": tag.sdp_to_link,
            "use_default_package": tag.use_default_package,
            "use_system_toolchain": tag.use_system_toolchain,
            "tc_extra_compile_flags": tag.extra_compile_flags,
            "tc_extra_link_flags": tag.extra_link_flags,
            "sdp_version": tag.sdp_version,
            "tc_license_info_variable": tag.license_info_variable,
            "tc_license_info_url": tag.license_info_url,
            "tc_license_path": tag.license_path,
            "tc_runtime_ecosystem": tag.runtime_ecosystem,
            "cc_toolchain_config": "@score_bazel_cpp_toolchains//templates/{}:cc_toolchain_config.bzl.template".format(tag.target_os),
            "cc_toolchain_flags": "@score_bazel_cpp_toolchains//templates/{}:cc_toolchain_flags.bzl.template".format(tag.target_os),
        }
        toolchains.append(toolchain)
    return toolchains

def _create_and_link_sdp(toolchain_info):
    """ TODO: Write docstring
    """
    pkg_name = "{}_pkg".format(toolchain_info["name"])
    identifier = "gcc"
    version = toolchain_info["tc_version"]
    if toolchain_info["tc_os"] == "qnx":
        identifier = "sdp"
        version = toolchain_info["sdp_version"]
    matrix_key = "{cpu}-{os}-{identifier}-{version}".format(
        cpu = toolchain_info["tc_cpu"],
        os = toolchain_info["tc_os"],
        identifier = identifier,
        version = version,
    )
    matrix = VERSION_MATRIX[matrix_key]
    toolchain_info["sdp_to_link"] = pkg_name
    return {
        "name": pkg_name,
        "url": matrix["url"],
        "strip_prefix": matrix["strip_prefix"],
        "sha256": matrix["sha256"],
        "build_file": matrix["build_file"],
    }

def _get_info(mctx):
    """Gets raw info from module ctx about toolchain properties.

    Args:
        mctx: A bazel object holding module information.
        family: An identifier that holds the driver type (gcc, qcc or llvm).
    
    Returns:
        list: A list of dictionaries with toolchain and archive information.
    """
    root = None
    for mod in mctx.modules:
        if not mod.is_root:
            fail("Only the root module can use the 'gcc' extension!")
        root = mod

    toolchains = _get_toolchains(mod.tags.toolchain)
    packages = _get_packages(mod.tags.sdp)

    for tc in toolchains:
        # need to be sure not to link package in case of system toolchain.
        if tc["use_system_toolchain"]:
            continue

        if tc["use_default_package"]:
            packages.append(_create_and_link_sdp(tc))

    return toolchains, packages

def _impl(mctx):
    """Extracts information about toolchain and instantiates nessesary rules for toolchain declaration.

    Args:
       mctx: A bazel object holding module information.

    """
    toolchains, archives = _get_info(mctx)
    for archive_info in archives:
        http_archive(
            name = archive_info["name"],
            urls = [archive_info["url"]],
            build_file = archive_info["build_file"],
            sha256 = archive_info["sha256"],
            strip_prefix = archive_info["strip_prefix"],
        )

    for toolchain_info in toolchains:
        gcc_toolchain(
            name = toolchain_info["name"],
            extra_compile_flags = toolchain_info["tc_extra_compile_flags"],
            extra_link_flags = toolchain_info["tc_extra_link_flags"],
            license_info_variable = toolchain_info["tc_license_info_variable"],
            license_info_value = toolchain_info["tc_license_info_url"],
            license_path = toolchain_info["tc_license_path"],
            sdp_version = toolchain_info["sdp_version"],
            tc_cpu = toolchain_info["tc_cpu"],
            tc_os = toolchain_info["tc_os"],
            tc_pkg_repo = toolchain_info["sdp_to_link"],
            tc_system_toolchain = toolchain_info["use_system_toolchain"],
            tc_runtime_ecosystem = toolchain_info["tc_runtime_ecosystem"],
            gcc_version = toolchain_info["tc_version"],
            cc_toolchain_config = toolchain_info["cc_toolchain_config"],
            cc_toolchain_flags = toolchain_info["cc_toolchain_flags"],
        )

gcc = module_extension(
    implementation = _impl,
    tag_classes = {
        "toolchain": tag_class(
            attrs = _attrs_tc,
            doc = "Toolchain configuration parameters that define toolchain."
        ),
        "sdp": tag_class(
            attrs = _attrs_sdp,
            doc = "Software Development Package (short sdp) is tarball holding binaries of toolchain.",
        ),
    }
)