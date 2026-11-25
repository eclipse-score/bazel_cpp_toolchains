<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Authenticate QNX package downloads

This guide helps consumers configure access to QNX package downloads. Download
credentials don't replace the license needed to execute QNX tools; see
[Configure licensing](qnx_integration.md#configure-licensing).

## QNX download endpoints

For authenticated `qnx.com` downloads, the
[QNX credential helper](../../tools/qnx_credential_helper.py) converts QNX
credentials into the cookie header expected by the download endpoint. Register
the helper in your Bazel configuration:

```text
common --credential_helper=*.qnx.com=/absolute/path/to/qnx_credential_helper.py
```

Replace the example path with the absolute path to the helper. It reads
`SCORE_QNX_USER` and `SCORE_QNX_PASSWORD`, or a `qnx.com` entry in `~/.netrc`
if those variables aren't set. Obtain access to the selected package from QNX.

## Private GitHub release assets

The default SDP 8.0.5 and 8.0.6 packages are private GitHub release assets.
Their downloader requires Python 3 and a token with read access to the
repository contents. It checks `SCORE_GITHUB_TOKEN`, `GITHUB_TOKEN`, and
`GH_TOKEN`, then netrc entries for `api.github.com` or `github.com` (`$NETRC`
or `~/.netrc`). A QNX credential helper isn't used for these URLs.

In CI, supply the token through a secret on the runner. Do not commit
credentials. See [Private GitHub release assets](extension_api.md#private-github-release-assets)
for download and caching behavior. If you can't get access to the private
packages, build your own SDP instead; see
[Use your own SDP](qnx_integration.md#use-your-own-sdp).

## Verify access

Build a target using the selected package as described in
[Integrate a QNX toolchain](qnx_integration.md). If the fetch fails, check the
package URL, network access, and credentials for that package's host.
