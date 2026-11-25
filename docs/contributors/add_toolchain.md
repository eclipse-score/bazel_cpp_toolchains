<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Add a toolchain variant

This guide helps contributors add a package-backed toolchain variant to this
repository and validate it. It doesn't describe a complete downstream platform
configuration; consumers should start with the
[consumer guide](../consumers/getting_started.md).

## Before you begin

- Identify the target CPU, operating system, compiler or SDK version, runtime
  ecosystem, and intended execution host.
- Obtain access to the package and its redistribution terms, and determine
  its archive URL, checksum, extraction layout, tools, headers, and libraries.
- Check the existing [version matrix](../../packages/version_matrix.bzl),
  [package descriptors](../../packages/), and
  [platform constraints](https://github.com/eclipse-score/bazel_platforms).
- Set up Bazel and the appropriate target or emulator, credentials, and
  license for the validation you intend to run. See
  [Tests and validation](tests_and_validation.md).

## Add the package and configuration

1. Add or adapt a package BUILD descriptor under `packages/`. Check the
   generated configuration's expected tool and directory labels in
   [`rules/gcc.bzl`](../../rules/gcc.bzl) and compare an existing descriptor
   for the same platform. The files referenced by those labels must match
   the extracted archive layout.
2. Add a [version matrix](../../packages/version_matrix.bzl) entry if the
   package should be a default. Include its URL, checksum, BUILD descriptor
   when needed, extraction prefix, and any required flags or patches. Use an
   explicit `gcc.sdp` declaration instead for a package that should not be
   in the default matrix.
3. Check version and runtime constraints against the target platform. For QNX,
   distinguish the actual SDP package version from the mapped platform
   version in [`rules/common.bzl`](../../rules/common.bzl). Coordinate any
   missing platform constraints in `score_bazel_platforms`.
4. Reuse existing features and shared templates where they describe the new
   toolchain correctly. If wiring or behavior differs, update the relevant
   definitions under `features/`, `rules/`, or `templates/`. See
   [Generation flow](generation_flow.md) and [Maintenance](maintenance.md).
5. Add a declaration to [`tests/MODULE.bazel`](../../tests/MODULE.bazel) and a
   matching configuration to [`tests/.bazelrc`](../../tests/.bazelrc). Add
   focused tests for behavior or restrictions that existing suites don't cover.
6. Update consumer documentation for the supported configuration and
   contributor guidance for any new maintenance or validation requirements.

For QNX, the matrix key is CPU-independent and the package descriptor provides
CPU-suffixed tool and file-group targets, for example `ar_x86_64` and
`compiler_files_x86_64`. Custom QNX packages use the same suffixed targets,
because the generated toolchain applies the suffix to every QNX package. Linux
package descriptors define the same targets without a suffix. See
[Package targets that the toolchain requires](../consumers/extension_api.md#package-targets-that-the-toolchain-requires)
for the full list. If the
SDK layout, compiler, or constraint changes, check the descriptor and version
mappings instead of assuming an older release's configuration applies.

## Verify the variant

Use [Tests and validation](tests_and_validation.md) to select host-side
guardrails, build checks, and execution tests appropriate to the target.
Confirm that the toolchain resolves, compiles, and links; where execution is
available, confirm that relevant tests pass. Record checks that could not run
and their missing prerequisites in the change description.

## Review checklist

- [ ] Archive metadata and package labels match the extracted package.
- [ ] Target constraints and any version mappings select the intended variant.
- [ ] Feature order, compiler and linker flags, sysroot, and tools are correct.
- [ ] Relevant tests pass, or unavailable checks and prerequisites are recorded.
- [ ] Consumer and contributor documentation reflects the change.

See [Maintain documentation](documentation.md) for the documentation review
and link-check expectations.
