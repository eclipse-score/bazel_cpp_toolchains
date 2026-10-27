#!/usr/bin/env python3

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

"""Downloads a GitHub release asset through the GitHub REST API.

Usage: fetch_github_release_asset.py <api_asset_url> <output_file>

The asset URL must have the form
https://api.github.com/repos/<owner>/<repo>/releases/assets/<id>.
The API answers with a redirect to a short-lived signed URL.
That URL is a bearer credential, so neither it nor the token is ever printed.
The token is sent only to api.github.com and never to the redirect target.

The token is taken from SCORE_GITHUB_TOKEN, GITHUB_TOKEN or GH_TOKEN, or
from the netrc entry for api.github.com or github.com.
"""

import netrc
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

_API_HOST = "api.github.com"
_ASSET_URL_PATTERN = re.compile(
    r"^https://api\.github\.com/repos/[^/]+/[^/]+/releases/assets/[0-9]+$"
)
_REDIRECT_CODES = (301, 302, 303, 307, 308)
_MAX_API_REDIRECTS = 5
_DOWNLOAD_ATTEMPTS = 3
_CHUNK_SIZE = 1 << 20


class _NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *args, **kwargs):
        return None


def _get_token():
    for var in ("SCORE_GITHUB_TOKEN", "GITHUB_TOKEN", "GH_TOKEN"):
        if os.environ.get(var):
            return os.environ[var]
    try:
        rc = netrc.netrc(os.environ.get("NETRC"))
        auth = rc.authenticators(_API_HOST) or rc.authenticators("github.com")
    except (OSError, netrc.NetrcParseError):
        auth = None
    return auth[2] if auth else None


def _resolve_signed_url(asset_url, token):
    opener = urllib.request.build_opener(_NoRedirect)
    url = asset_url
    for _ in range(_MAX_API_REDIRECTS):
        request = urllib.request.Request(url)
        request.add_header("Accept", "application/octet-stream")
        request.add_header("X-GitHub-Api-Version", "2022-11-28")
        if token:
            request.add_header("Authorization", "Bearer " + token)
        try:
            opener.open(request, timeout=60).close()
            sys.exit("GitHub API did not redirect to the asset content.")
        except urllib.error.HTTPError as error:
            if error.code not in _REDIRECT_CODES:
                hint = (
                    " Check that a token with read access is available."
                    if error.code in (401, 403, 404)
                    else ""
                )
                sys.exit(f"GitHub API returned HTTP {error.code}.{hint}")
            url = urllib.parse.urljoin(url, error.headers["Location"])
        # Renamed or transferred repositories redirect within the API host first.
        if urllib.parse.urlsplit(url).hostname != _API_HOST:
            return url
    sys.exit("Too many GitHub API redirects.")


def _download(asset_url, token, output):
    for attempt in range(1, _DOWNLOAD_ATTEMPTS + 1):
        # The signed URL expires after a few minutes, so every attempt resolves a fresh one.
        signed_url = _resolve_signed_url(asset_url, token)
        try:
            with (
                urllib.request.urlopen(signed_url, timeout=60) as response,
                open(output, "wb") as file,
            ):
                while chunk := response.read(_CHUNK_SIZE):
                    file.write(chunk)
            return
        except (OSError, urllib.error.URLError) as error:
            reason = getattr(error, "code", None) or type(error).__name__
            print(f"Download attempt {attempt} failed: {reason}", file=sys.stderr)
            time.sleep(2 * attempt)
    sys.exit("Download failed.")


def main(argv):
    if len(argv) != 3:
        sys.exit(f"Usage: {argv[0]} <api_asset_url> <output_file>")
    asset_url, output = argv[1], argv[2]
    if not _ASSET_URL_PATTERN.match(asset_url):
        sys.exit(f"Not a GitHub API release asset URL: {asset_url}")
    _download(asset_url, _get_token(), output)


if __name__ == "__main__":
    main(sys.argv)
