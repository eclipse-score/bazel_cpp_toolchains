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
4. update the example workspace if the new variant should be validated by the
   smoke-test matrix,
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
- documentation examples must stay aligned with actual `examples/.bazelrc`
  configuration names.

## Recommended Validation After Changes

For repository changes that affect toolchain resolution, package metadata, or
template generation, validate with the example workspace:

```bash
cd examples
./test.sh --list
./test.sh host_config_1
./test.sh --keep-going
```

For documentation-only changes, build or preview the Markdown site to catch
markup and table-of-contents/navigation issues before publishing.