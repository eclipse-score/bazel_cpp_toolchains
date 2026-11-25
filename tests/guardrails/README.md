<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Guardrail tests

This directory contains the `//:guardrail_tests` suite. Use this page to run
the suite, interpret a failure, and maintain the checks if you change
toolchain features or sysroot handling.

The suite protects the **explicit-feature model** of the toolchains. The Linux,
QNX, and EBcLfSA high-integrity (HI) toolchains enable the `no_legacy_features`
marker, so Bazel injects none of its implicit legacy C/C++ features. Every flag
comes from a feature that this repository defines explicitly. For background,
see the [feature reference](../../docs/consumers/features.md) and the
[migration guide](../../docs/consumers/migration_guide.md).

This page doesn't cover the functional tests in `tests/feature_verification/`.
The guardrails check the explicit-feature contract only and don't replace
those tests.

## Tests in the suite

The suite contains the following tests. Each test passes or fails through its
exit status and needs no target hardware.

- `feature_lists_test` (defined in
  [`feature_lists_test.bzl`](feature_lists_test.bzl)) checks that the Linux and
  EBcLfSA HI feature lists stay independent. The HI list omits the Linux-only
  features, uses the HI compile flags, and keeps the Linux flag order and
  defaults. This check doesn't depend on `--config`.
- `no_legacy_features_guard_test` (defined in
  [`legacy_feature_guard.bzl`](legacy_feature_guard.bzl)) resolves the C++
  toolchain for the current `--config` and checks that:

  1. The `no_legacy_features` marker is still enabled.
  2. None of Bazel's implicit legacy features are active. The test probes the
     legacy feature names that this repository never defines:
     `legacy_compile_flags`, `legacy_link_flags`, and `sysroot`. If any of
     them is enabled, Bazel has re-injected its legacy feature set.

- `sysroot_assembly_flags_guard_test` (defined in
  [`sysroot_assembly_flags_guard.bzl`](sysroot_assembly_flags_guard.bzl))
  resolves the toolchain and inspects the generated command lines for the
  `assemble` and `preprocess-assemble` actions. It requires a `--sysroot=`
  flag with a value and rejects `-Wl,--sysroot`, which is a linker-only flag.
  The test inspects the command lines instead of compiling
  [`sysroot_assembly.S`](sysroot_assembly.S) because host headers can mask a
  missing sysroot. The test runs only on Linux targets
  (`target_compatible_with = ["@platforms//os:linux"]`).

## Run the guardrails

To run the suite for a toolchain, run the following commands from the `tests/`
directory:

```bash
bazel test --config=x86_64-linux //:guardrail_tests
bazel test --config=aarch64-linux //:guardrail_tests
```

The test binaries are host-runnable scripts, so cross-target configurations
work without target hardware.

The QNX test configurations set a QNX runner and filter to C++ tests, so they
exclude the host-side guardrails. For the checks that run for each
configuration, see
[Test and validate toolchains](../../docs/contributors/tests_and_validation.md)
and the workflows in [`.github/workflows/`](../../.github/workflows/).

## Interpret a failure

A regression appears as a normal test failure. The test log names the problem.
For example, `no_legacy_features_guard_test` prints the following output when
the marker is disabled:

```
EXPLICIT-FEATURE GUARDRAIL FAILED
Problems detected:
  - the `no_legacy_features` marker is NOT enabled in the resolved toolchain
    configuration; Bazel will inject its implicit legacy C++ features.
```

It prints the following output when a legacy feature leaks:

```
Problems detected:
  - Bazel legacy feature(s) are enabled again: sysroot.
```

`sysroot_assembly_flags_guard_test` reports the action and the full command
line, for example:

```
ASSEMBLY SYSROOT FLAGS GUARDRAIL FAILED
Problems detected:
  - assemble is missing --sysroot=<path>; command line: ...
```

To fix a failure of `no_legacy_features_guard_test`:

1. Set the `no_legacy_features` feature to `True` in the ordered feature list
   of each affected toolchain:

   - [`features/custom/linux/make_cc_features.bzl`](../../features/custom/linux/make_cc_features.bzl)
     (`_LINUX_FEATURES`)
   - [`features/custom/qnx/make_cc_features.bzl`](../../features/custom/qnx/make_cc_features.bzl)
     (`_QNX_FEATURES`)
   - [`features/custom/ebclfsa_hi/make_cc_features.bzl`](../../features/custom/ebclfsa_hi/make_cc_features.bzl)
     (`_EBCLFSA_HI_FEATURES`)

2. Provide any behavior you need through an explicit feature instead of
   relying on a Bazel legacy default. For the supported extension mechanisms,
   see the [migration guide](../../docs/consumers/migration_guide.md).

To fix a failure of `sysroot_assembly_flags_guard_test`, check the
`sysroot_link_flags` feature in
[`features/native/sysroot_link_flags/features.bzl`](../../features/native/sysroot_link_flags/features.bzl):

- The `sysroot_assembly_flags_args` argument set applies `--sysroot=` to the
  assembly actions.
- The `sysroot_link_flags_args` argument set applies `-Wl,--sysroot=` and must
  stay scoped to link actions.

## Maintain the guardrails

- Add a name to `_DEFAULT_FORBIDDEN_LEGACY_FEATURES` in
  [`legacy_feature_guard.bzl`](legacy_feature_guard.bzl) only if Bazel injects
  it as a legacy feature and this repository doesn't define it. Otherwise, the
  probe collides with a legitimate explicit feature.
- Register a new guardrail in [`BUILD`](BUILD) and add it to the
  `guardrail_tests` suite in [`tests/BUILD`](../BUILD).
