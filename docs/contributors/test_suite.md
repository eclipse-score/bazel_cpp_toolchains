<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Toolchain test suite reference

This reference helps contributors find tests for toolchain behavior. For
prerequisites and commands, see [Test and validate toolchains](tests_and_validation.md).
The [`tests/BUILD`](../../tests/BUILD) file is the source of truth for suite
membership.

## Feature verification

The `//:feature_verification_tests` suite includes the following tests:

| Test | Behavior |
| --- | --- |
| `defines_test` | Defines supplied through compile options. |
| `preprocessor_defines_test` | Defines supplied through `local_defines`. |
| `include_paths_test` | Header search paths. |
| `include_dir_test` | Include directories exported by a library. |
| `coverage_test` | Coverage instrumentation. |
| `pic_test` | Position-independent code. |
| `pthread_test` | Thread creation and synchronization. |
| `multifile_test` | Compilation and archiving of multiple files. |
| `whole_archive_test` | Whole-archive linking. |
| `user_link_flags_test` | User-supplied link options. |
| `random_seed_test` | Smoke test for the reproducible-build random seed. |
| `fully_static_link_test` | Fully static linking where compatible. |

These are defined in
[`tests/feature_verification/BUILD`](../../tests/feature_verification/BUILD).
The [`opt_in_features`](../../tests/feature_verification/opt_in_features/BUILD)
package contains manual tests for additional features and build modes. Check
their BUILD file for selection and command requirements.

## Language and standards

The `//:language_and_standards_tests` suite covers C (C99), C++11, C++14,
C++17, and C++20. The target definitions and standard-specific options are in
[`tests/language_and_standards/BUILD`](../../tests/language_and_standards/BUILD).
The tests run directly on the host when the host matches the target platform.
Otherwise, run them on the matching target platform.

## Guardrails

The `//:guardrail_tests` suite checks feature lists, the explicit-feature
contract, and assembly sysroot flags without executing target binaries. The
suite includes the following tests:

| Test | Behavior |
| --- | --- |
| `feature_lists_test` | The Linux and EBcLfSA high-integrity feature lists stay independent. |
| `no_legacy_features_guard_test` | The `no_legacy_features` marker is enabled, and no Bazel legacy features are active. |
| `sysroot_assembly_flags_guard_test` | Assembly actions use `--sysroot=` and don't receive `-Wl,--sysroot`. The test applies to Linux targets only. |

For failure interpretation, see
[Guardrail tests](../../tests/guardrails/README.md).

## EBcLfSA high integrity

The `//:ebclfsa_hi_tests` suite checks the EBcLfSA high-integrity
configuration, rejected language features, and runtime behavior. The suite
includes the following tests:

| Test | Behavior |
| --- | --- |
| `configuration_test` | Required features are enabled, unsupported features are disabled, and the runtime test binary is a static AArch64 ELF file. |
| `exceptions_rejected_test` | The compiler rejects C++ exceptions. |
| `rtti_rejected_test` | The compiler rejects runtime type information (RTTI). |
| `runtime_test` | The high-integrity runtime on AArch64. |

All tests in this suite are compatible only with the EBcLfSA high-integrity
runtime platform. The runtime test needs a compatible AArch64 environment or
emulator. For commands, see
[EBcLfSA high-integrity validation](tests_and_validation.md#validate-ebclfsa-high-integrity).

## Add a test

1. Add the source and a test target in the relevant `tests/` package.
2. Add the target to the appropriate suite in `tests/BUILD` if it belongs in
   the suite. Mark platform or runtime incompatibilities in the target.
3. Run the relevant validation from the `tests/` workspace.
4. If the test adds a distinct behavior, update this reference.
