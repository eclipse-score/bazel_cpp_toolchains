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

"""Repository rule for archives published as (private) GitHub release assets.

Bazel 8 cannot download GitHub release assets through the REST API.
Its downloader always adds a browser-like `Accept` header, so GitHub answers
with JSON metadata instead of the asset content.
This rule delegates the network transfer to a helper script and hands the result
to Bazel as a local file, so the checksum check and the repository cache still apply.
The signed redirect URL never reaches Bazel, so it does not appear in logs or the BEP.
"""

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "patch", "symlink_files", "workspace_and_buildfile")

_API_ASSET_URL_PREFIX = "https://api.github.com/repos/"
_API_ASSET_URL_INFIX = "/releases/assets/"
_ARCHIVE_BASENAME = "_github_release_asset."
_DOWNLOADED_ARCHIVE = "_github_release_asset.download"
_FETCH_TIMEOUT_SECONDS = 3600

def is_github_release_asset_url(url):
    """Returns whether `url` has the form https://api.github.com/repos/<owner>/<repo>/releases/assets/<id>.

    Args:
        url: URL to check.

    Returns:
        True if the URL points to a GitHub release asset through the REST API.
    """
    if not url.startswith(_API_ASSET_URL_PREFIX):
        return False
    owner_repo, sep, asset_id = url[len(_API_ASSET_URL_PREFIX):].partition(_API_ASSET_URL_INFIX)
    return bool(sep) and len(owner_repo.split("/")) == 2 and asset_id.isdigit()

def _github_release_archive_impl(rctx):
    if not is_github_release_asset_url(rctx.attr.url):
        fail("{}: `url` must have the form {}<owner>/<repo>{}<id>, got: {}".format(
            rctx.name,
            _API_ASSET_URL_PREFIX,
            _API_ASSET_URL_INFIX,
            rctx.attr.url,
        ))
    if not rctx.attr.sha256:
        fail("{}: `sha256` is mandatory for GitHub release assets.".format(rctx.name))
    if not rctx.attr.type:
        fail("{}: `type` is mandatory for GitHub release assets, the URL has no file extension.".format(rctx.name))

    fetcher = rctx.path(rctx.attr._fetcher)

    # The file extension tells `extract` the archive type.
    archive = _ARCHIVE_BASENAME + rctx.attr.type
    download_args = dict(
        output = archive,
        sha256 = rctx.attr.sha256,
        canonical_id = rctx.attr.url,
    )

    # Without URLs, Bazel only consults the repository cache and the distdir.
    # `download_and_extract` would leave an empty temp directory behind on a cache miss.
    cached = rctx.download(url = [], allow_fail = True, **download_args)
    if not cached.success:
        python = rctx.which("python3")
        if not python:
            fail("{}: python3 is required to download GitHub release assets.".format(rctx.name))
        rctx.report_progress("Downloading GitHub release asset " + rctx.attr.url)
        result = rctx.execute(
            [python, fetcher, rctx.attr.url, _DOWNLOADED_ARCHIVE],
            timeout = _FETCH_TIMEOUT_SECONDS,
        )
        if result.return_code != 0:
            fail("{}: downloading {} failed:\n{}".format(rctx.name, rctx.attr.url, result.stderr))

        # Verifies the checksum and stores the archive in the repository cache.
        rctx.download(url = "file://" + str(rctx.path(_DOWNLOADED_ARCHIVE)), **download_args)
        rctx.delete(_DOWNLOADED_ARCHIVE)

    rctx.extract(archive, strip_prefix = rctx.attr.strip_prefix)
    rctx.delete(archive)

    workspace_and_buildfile(rctx)
    patch(rctx)
    symlink_files(rctx)

github_release_archive = repository_rule(
    implementation = _github_release_archive_impl,
    doc = """Downloads and extracts an archive published as a GitHub release asset.

Use this rule instead of `http_archive` for release assets of private repositories.
The `http_archive` wrapper in `rules/http_archive.bzl` selects it automatically for such URLs.
The archive is fetched through the GitHub REST API by `tools/fetch_github_release_asset.py`.
The script reads the token from `SCORE_GITHUB_TOKEN`, `GITHUB_TOKEN` or `GH_TOKEN`, or from the
netrc entry for `api.github.com` or `github.com`.
The token is not part of the repository definition, so rotating it does not trigger a refetch.
Once the archive is in the repository cache, no token and no network access are needed.
""",
    attrs = {
        "build_file": attr.label(
            allow_single_file = True,
            doc = "The file to use as the BUILD file for this repository.",
        ),
        "build_file_content": attr.string(
            doc = "The content for the BUILD file for this repository.",
        ),
        "files": attr.string_keyed_label_dict(
            doc = "A map of relative paths (key) to a file label (value) that are overlaid on the repository as symlinks.",
        ),
        "patch_args": attr.string_list(
            doc = "The arguments given to the patch tool, see `http_archive`.",
        ),
        "patch_cmds": attr.string_list(
            doc = "Bash commands to run after the patches are applied.",
        ),
        "patch_strip": attr.int(
            default = 0,
            doc = "When set to `N`, this is equivalent to inserting `-pN` to the beginning of `patch_args`.",
        ),
        "patch_tool": attr.string(
            doc = "The patch(1) utility to use instead of the Bazel-native patch implementation.",
        ),
        "patches": attr.label_list(
            doc = "A list of files that are to be applied as patches after extracting the archive.",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "The expected SHA-256 of the archive.",
        ),
        "strip_prefix": attr.string(
            doc = "A directory prefix to strip from the extracted files.",
        ),
        "type": attr.string(
            mandatory = True,
            doc = "The archive type, e.g. `tar.gz`.",
        ),
        "url": attr.string(
            mandatory = True,
            doc = "The asset URL in the form https://api.github.com/repos/<owner>/<repo>/releases/assets/<id>.",
        ),
        "_fetcher": attr.label(
            default = Label("//tools:fetch_github_release_asset.py"),
            allow_single_file = True,
        ),
    },
)
