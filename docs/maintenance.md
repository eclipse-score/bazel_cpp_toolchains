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

# Maintenance

## Adding A New Toolchain Variant

Adding support for a new toolchain variant usually touches several layers:

1. add or extend package metadata in `packages/version_matrix.bzl`,
2. add a package BUILD descriptor under `packages/linux/` or `packages/qnx/`,
3. ensure the required template placeholders already exist, or extend the
   platform template files,
4. update the test workspace under `tests/` if the new variant should be
   validated by the test matrix (add a matching `--config` entry in
   `tests/.bazelrc`),
5. add or update documentation in this Markdown source and the repository README.

## When To Use The Version Matrix

Use the version matrix when a package should be part of the supported default
surface for consumers. This gives downstream users a shorter configuration and
centralizes special sysroot flags in one place.

Use explicit `gcc.sdp(...)` declarations when package metadata is local,
experimental, or intentionally not part of the default support matrix.

## Common Gotchas

- runtime-specific toolchains may need extra include and link flags that do not
  exist for standard GCC archives,
- QNX `aarch64` naming differs from some underlying SDK paths,
- QNX licensing and authentication requirements live outside Bazel target
  analysis and must be configured in the execution environment,
- documentation examples must stay aligned with actual `tests/.bazelrc`
  configuration names.

## Recommended Validation After Changes

For repository changes that affect toolchain resolution, package metadata, or
template generation, validate with the test workspace (a separate Bazel
workspace, so run the commands from `tests/`):

```bash
cd tests
bazel test --config x86_64-linux //...
bazel test --config x86_64-linux //:feature_verification_tests
bazel test --config x86_64-linux //:language_and_standards_tests
```

The available `--config` values (for example `x86_64-linux`, `aarch64-linux`,
`x86_64-qnx`, `aarch64-qnx`, `x86_64-linux-autosd10`, `aarch64-linux-ebclfsa`)
are defined in `tests/.bazelrc`.

For documentation-only changes, build or preview the Markdown site to catch
markup and table-of-contents/navigation issues before publishing.