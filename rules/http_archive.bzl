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

"""Drop-in wrapper for the native `http_archive` repository rule.

It selects the repository rule that is able to fetch the given URLs.
GitHub REST API release asset URLs go to `github_release_archive`, because
the Bazel 8 downloader cannot fetch them (fixed in Bazel 9).
All other URLs go to the native `http_archive`.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _native_http_archive = "http_archive")
load("@score_bazel_cpp_toolchains//rules:github_release_archive.bzl", "github_release_archive", "is_github_release_asset_url")

def http_archive(
        name,
        urls,
        build_file = None,
        files = None,
        patch_args = None,
        patch_cmds = None,
        patch_strip = None,
        patch_tool = None,
        patches = None,
        sha256 = None,
        strip_prefix = None,
        type = None):
    """Downloads and extracts an archive, see the native `http_archive` for the attributes.

    Args:
        name: Name of the repository.
        urls: URLs of the archive.
        build_file: The file to use as the BUILD file for this repository.
        files: Map of relative paths to file labels overlaid on the repository as symlinks.
        patch_args: Arguments given to the patch tool.
        patch_cmds: Bash commands to run after the patches are applied.
        patch_strip: Equivalent to inserting `-pN` to the beginning of `patch_args`.
        patch_tool: The patch(1) utility to use.
        patches: Patch files to apply after extracting the archive.
        sha256: Expected SHA-256 of the archive.
        strip_prefix: Directory prefix to strip from the extracted files.
        type: Archive type, e.g. `tar.gz`.
    """
    common_args = dict(
        name = name,
        build_file = build_file,
        files = files,
        patch_args = patch_args,
        patch_cmds = patch_cmds,
        patch_strip = patch_strip,
        patch_tool = patch_tool,
        patches = patches,
        sha256 = sha256,
        strip_prefix = strip_prefix,
        type = type,
    )

    github_release_asset_urls = [url for url in urls if is_github_release_asset_url(url)]
    if not github_release_asset_urls:
        _native_http_archive(urls = urls, **common_args)
    elif len(urls) == 1:
        github_release_archive(url = urls[0], **common_args)
    else:
        fail("{}: a GitHub release asset URL cannot be combined with other URLs: {}".format(name, urls))
