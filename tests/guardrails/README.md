# Explicit-Feature Guardrail

This directory contains an automated guardrail that protects the
**explicit-feature model** established by the toolchain migration. Both the
Linux and QNX toolchains enable the `no_legacy_features` marker so that Bazel
injects **none** of its implicit legacy C/C++ features — every flag comes from a
feature this repository defines explicitly (see
[docs/features.md](../../docs/features.md) and
[docs/migration_guide.md](../../docs/migration_guide.md)).

The guardrail fails the test if that contract regresses.

## What it validates

`no_legacy_features_guard_test` (defined in
[`legacy_feature_guard.bzl`](legacy_feature_guard.bzl)) resolves the C++
toolchain configured for the current `--config` and checks that:

1. the `no_legacy_features` marker is still **enabled**, and
2. none of Bazel's implicit legacy features have become active again. It probes
   a set of legacy feature names that this repository intentionally never
   defines (`legacy_compile_flags`, `legacy_link_flags`, `sysroot`); if any is
   enabled, Bazel has re-injected its legacy feature set.

The verdict is deterministic (derived from the resolved toolchain
configuration) and is surfaced as the **test's exit status**, so it needs no
target hardware and runs for whichever toolchain the active `--config` selects.

## How to run it

```bash
cd tests

# Any toolchain in the matrix — run it as a test. The test binary is a plain
# host-runnable script, so cross-target configs work without target hardware.
bazel test --config=x86_64-linux //:guardrail_tests
bazel test --config=aarch64-linux //:guardrail_tests
bazel test --config=x86_64-qnx //:guardrail_tests
```

 CI runs the guardrail for every platform config covered by the GitHub Actions
 workflows under `.github/workflows/`.

## Interpreting a failure

A regression is reported as a normal **test failure**; the test log names the
exact problem, for example:

```
EXPLICIT-FEATURE GUARDRAIL FAILED
Problems detected:
  - the `no_legacy_features` marker is NOT enabled in the resolved toolchain
    configuration; Bazel will inject its implicit legacy C++ features.
```
or

```
Problems detected:
  - Bazel legacy feature(s) are enabled again: sysroot.
```

To fix it:

- Re-add / re-enable the `no_legacy_features` feature (`enabled = True`) in the
  toolchain config templates under `templates/linux/` and `templates/qnx/`, and
  keep it in each template's `features` list.
- Provide any behavior you need through an **explicit** feature rather than
  relying on a Bazel legacy default. See
  [docs/migration_guide.md](../../docs/migration_guide.md) for the supported
  extension mechanisms.

## Maintenance

- The list of probed legacy feature names lives in the
  `_DEFAULT_FORBIDDEN_LEGACY_FEATURES` constant in
  [`legacy_feature_guard.bzl`](legacy_feature_guard.bzl). Only add names that
  Bazel injects as legacy features **and** that this repository does not define
  itself, otherwise the probe would collide with a legitimate explicit feature.
- The guardrail is intentionally narrow: it checks the explicit-feature contract
  only and does not replace the functional feature-verification tests under
  `tests/feature_verification/`.
