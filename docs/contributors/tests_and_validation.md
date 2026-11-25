<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Test and validate toolchains

This guide helps contributors choose validation for changes to toolchains,
packages, and features. The separate [`tests/`](../../tests/) Bazel workspace
checks toolchain generation and selected behaviors; it isn't a complete
platform configuration or a compiler correctness suite.

## Before you begin

- Install the Bazel version pinned in [`.bazelversion`](../../.bazelversion).
- Run the commands in this guide from the `tests/` directory. Its
  [`MODULE.bazel`](../../tests/MODULE.bazel) uses a local override for this
  checkout, and its [`.bazelrc`](../../tests/.bazelrc) defines the configurations.
- Ensure you can fetch the selected packages. QNX also requires package access,
  credentials, and a license; see
  [Integrate a QNX toolchain](../consumers/qnx_integration.md).
- For cross-target execution, provide a compatible target environment or an
  appropriate emulator and runner.

## Select checks

The root [`tests/BUILD`](../../tests/BUILD) defines these suites:

- `//:feature_verification_tests`: compile and link feature behavior.
- `//:language_and_standards_tests`: C and C++ language and standard support.
- `//:guardrail_tests`: host-side checks of feature lists and the explicit
  feature contract. See the [guardrail reference](../../tests/guardrails/README.md).
- `//:ebclfsa_hi_tests`: checks for the restricted EBcLfSA high-integrity
  profile, including host-side checks and a target runtime test.
- `//:all_tests`: aggregate suite; target compatibility affects which tests run.

See the [test suite reference](test_suite.md) for individual tests. Manual
feature tests and their invocation requirements are described in
[`opt_in_features/BUILD`](../../tests/feature_verification/opt_in_features/BUILD).

## Run native Linux tests

On an x86_64 Linux host, run the standard feature, language, and guardrail
suites:

```bash
bazel test --config=x86_64-linux \
  //:feature_verification_tests //:language_and_standards_tests //:guardrail_tests
```

Confirm that the selected tests pass. Test results depend on target
compatibility and Bazel's test selection; don't rely on a fixed total.

## Build for a cross target

For example, build the standard suites for AArch64 Linux:

```bash
bazel build --config=aarch64-linux \
  //:feature_verification_tests //:language_and_standards_tests
```

Confirm that compilation and linking succeed. A cross-build doesn't execute
the target binaries. Run them in a compatible target environment or use an
appropriate runner. The generated toolchains declare an x86_64 Linux execution
platform; running Bazel directly on a target OS doesn't by itself provide that
execution platform.

## Validate QNX

For a build-only check on the Linux host, use a configured QNX package and
license:

```bash
bazel build --config=x86_64-qnx \
  //:feature_verification_tests //:language_and_standards_tests
```

The `x86_64-qnx` and `aarch64-qnx` test configurations in `tests/.bazelrc`
set `--run_under` to the QNX runner and filter to C++ tests. Executing those
configurations requires the runner's QNX emulator and KVM setup, in addition to
package access and licensing. For those configurations, run:

```bash
bazel test --config=x86_64-qnx //:all_tests
```

Use the corresponding `aarch64-qnx` configuration for AArch64. The test
filter excludes host-side guardrails; don't assume that this command runs them.
See the [QNX CI workflow](../../.github/workflows/qnx.yml) for its configuration.

## Validate EBcLfSA high integrity

The high-integrity profile restricts language and runtime features. Use its
dedicated suite rather than assuming the general-purpose feature suite applies.
Run host-side checks:

```bash
bazel test --config=aarch64-linux-ebclfsa-hi --test_lang_filters=-cc \
  //:ebclfsa_hi_tests //:guardrail_tests
```

With `qemu-user` installed at `/usr/bin/qemu-aarch64`, run the target runtime
test:

```bash
bazel test --config=aarch64-linux-ebclfsa-hi \
  --run_under=/usr/bin/qemu-aarch64 //ebclfsa_hi:runtime_test
```

See the [EBcLfSA CI workflow](../../.github/workflows/ebclfsa.yml) for the
corresponding checks.

## Record results

Confirm that the selected checks pass. In the change description, record the
configurations tested and any checks you couldn't run, including missing
package access, licenses, target environments, or emulators.
