#!/usr/bin/env python3

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

import json
import netrc
import os
import sys
import urllib.parse


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def get_token():
    for var in ("SCORE_GITHUB_TOKEN", "GITHUB_TOKEN", "GH_TOKEN"):
        if os.environ.get(var):
            return os.environ[var]
    try:
        rc = netrc.netrc()
        auth = rc.authenticators("api.github.com") or rc.authenticators("github.com")
    except Exception as excp:
        eprint(excp)
        auth = None
    if not auth:
        eprint("No GitHub token found in environment or .netrc")
        sys.exit(1)
    return auth[2]


if __name__ == "__main__":
    data = json.load(sys.stdin)
    host = urllib.parse.urlparse(data["uri"]).hostname

    # Only the API host is handled; the signed redirect target must not receive the token.
    if host != "api.github.com":
        eprint("Unsupported domain")
        sys.exit(1)

    print(
        json.dumps(
            {
                "headers": {
                    "Authorization": [f"Bearer {get_token()}"],
                    "Accept": ["application/octet-stream"],
                }
            }
        )
    )
