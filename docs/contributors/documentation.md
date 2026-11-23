<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Maintain documentation

This guide helps contributors keep the consumer and contributor documentation
accurate when toolchains or their validation change.

## Update and review documentation

1. Update the relevant consumer guide or reference when public configuration,
   package access, features, or supported behavior changes. Update contributor
   guidance when implementation or validation changes.
2. Check commands, labels, defaults, and expected results against the source
   and relevant test configurations. Run examples when their prerequisites are
   available; record checks you couldn't run and why in the change description.
3. Check relative links and anchors after moving or renaming content. Update
   links in the repository and keep existing forwarding pages usable for
   external readers.
4. Request review from the owners identified by
   [CODEOWNERS](../../.github/CODEOWNERS). Ask the appropriate platform
   maintainers to review platform-specific instructions.

The [documentation map](../README.md) lists the authoritative pages. The
forwarding pages at the original `docs/` paths preserve existing links; update
them if their destination changes. There is no documentation-site build
configured in this repository, so review Markdown rendering and links as part
of the change.
