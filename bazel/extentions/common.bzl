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

""" Common functions for Bazel module extensions.
"""
load("@score_bazel_cpp_toolchains//packages:version_matrix.bzl", "VERSION_MATRIX")

# Common module attributes for package/sdp achive.
archive_attrs = {
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

# Coomon module attributes for toolchain configuration.
tc_module_attrs = {
    "package_to_link": attr.string(
        mandatory = False,
        default = "",
        doc = "Name of the toolchain package to be linked with this toolchain, default set to toolchain name + `_pkg`.",
    ),
    "use_default_package": attr.bool(
        default = False,
        doc = "Whether to use the default package from the version matrix, default set to False.",
    ),
    "target_cpu": attr.string(
        mandatory = True,
        values = [
            "x86_64",
            "arm64",
        ],
        doc = "Target platform CPU",
    ),
    "version": attr.string(
        default = "",
        doc = "Version of the GCC(QCC driver in case of QNX) toolchain.",
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

def _get_archives(tags):
    """Gets archive information from given tags.

    Args:
        tags: A list of tags containing archive information.

    Returns:
        dict: A dictionary with archive information.
    """
    archives = []    
    for tag in tags:
        archives.append({
            "name": tag.name,
            "url": tag.url,
            "strip_prefix": tag.strip_prefix,
            "sha256": tag.sha256,
            "build_file": tag.build_file,
        })    
    return archives

def _get_toolchains(tags, family):
    """Gets toolchain information from given tags.

    Args:
        tags: A list of tags containing toolchain information.
        family: An identifier that holds the driver type (gcc, qcc or llvm).
    
    Returns:
        dict: A dictionary with toolchain information.
    """
    toolchains = []
    for tag in tags:
        toolchain = {
            "name": tag.name,
            "tc_cpu": tag.target_cpu,
            "tc_os": tag.target_os,
            "tc_family": family,
            "tc_family_version": tag.version,
            "package_to_link": tag.package_to_link,
            "use_default_package": tag.use_default_package,
            "extra_compile_flags": tag.extra_compile_flags,
            "extra_link_flags": tag.extra_link_flags,
        }
        if hasattr(tag, "qnx_license_path"):
             toolchain.update({"qnx_license_path":  tag.qnx_license_path})
        if hasattr(tag, "license_info_url"):
            toolchain.update({"license_info_url": tag.license_info_url})
        if hasattr(tag, "license_info_variable"):
            toolchain.update({"license_info_variable": tag.license_info_variable})
        if hasattr(tag, "sdp_version"):
            toolchain.update({"sdp_version": tag.sdp_version})
        toolchains.append(toolchain)
    return toolchains

def get_info(mctx, family):
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
            fail("Only the root module can use the '{}' extension!".format(family))
        root = mod
    
    toolchains = _get_toolchains(mod.tags.toolchain, family)

    tags = None
    if family == "gcc":
        tags = mod.tags.package
    elif family == "qcc":
        tags = mod.tags.sdp
    else:
        fail("Unsupported family: {}".format(family))
    archives = _get_archives(tags)

    for toolchain in toolchains:
        if toolchain["package_to_link"] == "" and toolchain["use_default_package"]:
            pkg_name = "{}_pkg".format(toolchain["name"])
            # Check if archive with such name exists
            for archive in archives:
                if archive["name"] == pkg_name:
                    toolchain["package_to_link"] = pkg_name
                    break
            if toolchain["package_to_link"] == "":
                # Get the archive from matix
                identifier = toolchain["tc_family"]
                version = toolchain["tc_family_version"]
                if family == "qcc":
                    identifier = "sdp"
                    version = toolchain["sdp_version"]
                matrix = VERSION_MATRIX["{cpu}-{os}-{identifier}-{version}".format(
                    cpu = toolchain["tc_cpu"],
                    os = toolchain["tc_os"],
                    identifier = identifier,
                    version = version,
                )]
                archive = {
                    "name": pkg_name,
                    "url": matrix["url"],
                    "strip_prefix": matrix["strip_prefix"],
                    "sha256": matrix["sha256"],
                    "build_file": matrix["build_file"],
                }
                archives.append(archive)
                toolchain["package_to_link"] = pkg_name
    return toolchains, archives

