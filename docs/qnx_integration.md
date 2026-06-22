<!--
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
-->

# QNX Integration

## Licensing

QNX toolchains require access to a valid license setup at execution time. The
repository exposes this through toolchain attributes rather than embedding
license material into the package itself.

Relevant `gcc.toolchain(...)` attributes are:

- `license_path`
- `license_info_variable`
- `license_info_url`

The default shared license path is `/opt/score_qnx/license/licenses`. This has been
agreed with all module owners and platform developers.

## Credential Helper

Authenticated QNX downloads are handled by the standalone script
`tools/qnx_credential_helper.py`.

Its purpose is to translate locally available QNX credentials into the cookie
header format expected by `qnx.com` download endpoints. Bazel executes it via
`--credential_helper`;

Supported registration patterns include:

```text
common --credential_helper=*.qnx.com=/absolute/path/to/qnx_credential_helper.py
common --credential_helper=*.qnx.com=qnx_credential_helper.py
common --credential_helper=*.qnx.com=%workspace%/path/to/qnx_credential_helper.py
```

The helper reads credentials in this order:

- `SCORE_QNX_USER` and `SCORE_QNX_PASSWORD`
- `~/.netrc` entry for `qnx.com`