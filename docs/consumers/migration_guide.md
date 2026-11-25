<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Migrate to the explicit-feature model

This guide is for **downstream consumers** of
`score_bazel_cpp_toolchains`. It explains what changes when the toolchains run
under Bazel's explicit-feature model (`no_legacy_features`), which behaviors are
no longer supplied implicitly, and how to restore any behavior you still need —
explicitly and on purpose.

If your builds worked before and something now fails to compile or link with a
"missing flag / undefined behavior" symptom, this document is where to start. It
is designed so you can adopt the toolchains without reading the toolchain source.

## Summary

- The Linux, QNX, and EBcLfSA high-integrity toolchains enable **`no_legacy_features`**. Bazel no
  longer injects any of its built-in "legacy" compile/link/archive flags.
- Every flag the toolchain emits comes from a feature that is **defined
  explicitly** in the toolchain config. See
  [Toolchain features](features.md) for the full catalog.
- If you relied on a Bazel-default behavior that this toolchain does not define,
  the fix is to **turn it on explicitly** — via a target/package `features`
  attribute, a `--features` / `--host_features` flag, an opt-in feature, or one
  of the `extra_*_flags` toolchain attributes.
- Nothing falls back silently: under `no_legacy_features` a missing behavior is a
  broken build, not a quiet default.

## Why the model changed

### The legacy (implicit) model

Without `no_legacy_features`, Bazel automatically adds a large set of built-in
"legacy" features to every `cc_toolchain`. These features inject compile, link,
and archive flags on your behalf even when the toolchain author never declared
them. That is convenient, but it has two problems for a safety-oriented,
reproducible toolchain:

- The exact flags depend on the Bazel version, not on this repository, so builds
  are not fully self-described or reproducible.
- Behavior is implicit: it is hard to audit *why* a flag appears on the command
  line, and easy for an unintended flag to slip in.

### The explicit model

The Linux, QNX, and EBcLfSA high-integrity toolchain configurations always
enable `no_legacy_features`. It is a `cc_feature` defined in
`features/native/markers` and listed as initially enabled in the ordered
feature list of each profile:
[Linux](../../features/custom/linux/make_cc_features.bzl),
[QNX](../../features/custom/qnx/make_cc_features.bzl), and
[EBcLfSA high integrity](../../features/custom/ebclfsa_hi/make_cc_features.bzl).

With this feature enabled, Bazel injects **nothing** implicitly. Every compile,
link, and archive flag must come from a feature (or other toolchain wiring)
declared explicitly under [`features/`](../../features) and wired in by
[`templates/cc_toolchain_config.bzl.template`](../../templates/cc_toolchain_config.bzl.template).

As a result, this repository's feature set fully describes the command line.
What you see documented in [Toolchain features](features.md) is what you
get — no more, no less.

## Behaviors that are no longer implicit

Under `no_legacy_features`, none of Bazel's built-in legacy features are active.
The following table lists the behaviors most commonly *assumed* to be
automatic, and their status in this toolchain.

| Behavior you may have relied on (legacy) | Status here | How this toolchain provides it |
| --- | --- | --- |
| Default C/C++ compile flags | **Supported, explicit** | `default_compile_flags` feature (per-target flags differ) |
| `-D` preprocessor defines from `defines` / `local_defines` | **Supported, explicit** | `preprocessor_defines` feature |
| `-iquote` / `-I` / `-isystem` include paths | **Supported, explicit** | `include_paths` feature |
| Force-included headers (`-include`) | **Supported, explicit (Linux)** | `includes` feature |
| Position-independent code (`-fPIC`) | **Supported, explicit** | `pic` feature emits `-fPIC` when the `pic` build variable is available. |
| `.d` dependency file generation | **Supported, explicit** | `dependency_file` feature |
| Pass-through of user `copts` | **Supported, explicit** | `user_compile_flags` feature |
| Pass-through of user `linkopts` | **Supported, explicit** | `user_link_flags` feature (both) |
| Default / hardening link flags | **Supported, explicit** | `default_link_flags` feature |
| `-L` library search paths, `-Wl,-rpath` | **Supported, explicit** | `library_search_directories`, `runtime_library_search_directories` |
| Static archive creation (`ar`) | **Supported, explicit** | `archiver_flags` feature + `cpp_link_static_library` action |
| `--sysroot` handling | **Supported, explicit (Linux)** | `sysroot_link_flags` at link and assemble/preprocess-assemble; C/C++ compile-time header resolution relies on `cxx_builtin_include_directories` |
| Compiler / archiver / strip tool binding | **Supported, wiring** | `action_config` entries, not legacy `tool_paths` |
| `gcov` | **Supported, wiring** | `tool_paths` (`gcov_wrapper`) |
| Warnings (for example, `-Wall`) added by default | **Not part of this toolchain — injected** | `minimal_warnings` / `strict_warnings` / `all_wall_warnings` are defined by `score_cpp_policies`, not this toolchain, and only become available once brought in via `extra_known_features` / `extra_enabled_features`. |
| `-Werror` | **Not part of this toolchain — injected** | `warnings_as_errors`, defined by `score_cpp_policies` and injected the same way as the other warning features. |
| Sanitizers (asan/lsan/tsan/ubsan) | **Not part of this toolchain — injected (Linux)** | Defined by `score_cpp_policies` (`score_asan` / `score_lsan` / `score_tsan` / `score_ubsan`) and brought in via `extra_known_features` / `extra_enabled_features` |
| Fully static link (`-static`) | **Not implicit — opt-in (Linux)** | `fully_static_link` (disabled by default) |
| `-pthread` | **Supported, explicit (Linux)** | `use_pthread` (enabled by default) |
| Fission / split DWARF, linkstamps, strip, static-libgcc | **Supported, guarded (Linux)** | Guarded features; no-ops until the relevant build mode is active |
| Any other Bazel legacy default not listed above | **Not available** | Must be added explicitly (see below) |

Three categories deserve special attention because they are the most frequent
migration surprises:

1. **Warnings are not part of this toolchain on either platform.** All
   warning-level features (`minimal_warnings`, `strict_warnings`,
   `all_wall_warnings`, `warnings_as_errors`/`-Werror`) are defined by
   `score_cpp_policies` and only become available once injected via
   `extra_known_features` / `extra_enabled_features`.
2. **Fully static linking is opt-in on Linux.** It emits nothing until you
   enable `fully_static_link`. Linux enables `use_pthread` by default.
3. **Sanitizers are not part of this toolchain.** They are defined by the
   `score_cpp_policies` module and must first be injected via
   `extra_known_features` / `extra_enabled_features` before they can be enabled.
   See [Toolchain features](features.md#sanitizers-linux-opt-in).

For the authoritative and complete list, always refer to
[Toolchain features](features.md).

## Restore behavior explicitly

There are four mechanisms, ordered roughly from "most local" to "most global".
Pick the narrowest one that solves your problem.

### 1. Enable a feature on a target or package

Use the standard Bazel `features` attribute on a `cc_*` target, or set
`features` at the package level in a `BUILD` file. This is the right tool for a
one-off need.

```starlark
# BUILD — enable a feature for a single target
cc_binary(
    name = "app",
    srcs = ["main.cpp"],
    features = ["strict_warnings", "warnings_as_errors"],
)
```

You can also *disable* an enabled-by-default feature by prefixing it with `-`,
for example `features = ["-per_object_debug_info"]`.

### 2. Enable a feature build-wide with a flag

Use `--features` (target configuration) or `--host_features` (host/exec
configuration), typically pinned in a `.bazelrc` config. This mirrors how the
test workspace enables `use_pthread`:

```bash
# .bazelrc
build:myconfig --features=strict_warnings
build:myconfig --host_features=use_pthread
```

### 3. Turn on an opt-in feature that already exists

Some legacy-equivalent behaviors ship as opt-in features, including
`fully_static_link`. You can enable them with mechanism 1 or 2. See the
*Opt-in* entries in [Toolchain features](features.md). Other features, such as
`per_object_debug_info`, are enabled by default but emit flags only in the
appropriate build mode. Warnings and sanitizers must first be injected from
`score_cpp_policies`.

### 4. Inject raw flags through the toolchain attributes

If you need extra flags on *every* compile or link action for a toolchain
(rather than a named, reusable feature), use the existing `extra_*_flags`
attributes on `gcc.toolchain(...)`:

```starlark
gcc = use_extension("@score_bazel_cpp_toolchains//extensions:gcc.bzl", "gcc")

gcc.toolchain(
    name = "score_gcc_toolchain",
    target_cpu = "x86_64",
    target_os = "linux",
    version = "12.2.0",
    use_default_package = True,
    extra_compile_flags = ["-fno-common"],
    extra_cxx_compile_flags = ["-fno-rtti"],
    extra_link_flags = ["-Wl,--as-needed"],
)

use_repo(gcc, "score_gcc_toolchain")
```

> GCC 15.3.0 is available too — set `version = "15.3.0"` instead. See
> [Extension API](extension_api.md#gcctoolchain-attributes) for details.

These flow through the `extra_compile_flags`, `extra_c_compile_flags`,
`extra_cxx_compile_flags`, and `extra_link_flags` hooks documented in
[Extension API](extension_api.md) and [Toolchain features](features.md). Use them
for unconditional flags; use an existing opt-in feature (mechanisms 1–3) when the
behavior should be toggleable per target.

> **Ordering matters.** Flags from a feature later in the toolchain's feature
> list appear later on the command line. When you enable additional features,
> verify the resulting command line (for example, with `--subcommands`) if flag order is
> significant for your build.

## Migration scenarios

Each scenario is a concrete case: "I used to get X automatically; how do I get
it explicitly?"

### Scenario A — "My warnings disappeared"

**Symptom:** Code that used to warn (or fail on warnings) builds clean.

**Cause:** Warning-level features are not defined by this toolchain at all —
they are defined by `score_cpp_policies` and are only available once injected
into the toolchain via `extra_known_features` / `extra_enabled_features` (see
[Extension API](extension_api.md#feature-injection)).

**Fix:** Inject the warning features from `score_cpp_policies` on
`gcc.toolchain(...)`, then enable them like any other feature:

```starlark
gcc.toolchain(
    name = "score_gcc_toolchain",
    target_cpu = "x86_64",
    target_os = "linux",
    version = "12.2.0",
    use_default_package = True,
    extra_known_features = [
        "STRICT_WARNINGS_LABEL",
        "WARNINGS_AS_ERRORS_LABEL",
    ],
)
```

Replace `STRICT_WARNINGS_LABEL` and `WARNINGS_AS_ERRORS_LABEL` with the labels
of the `strict_warnings` and `warnings_as_errors` feature targets in
`score_cpp_policies`. See that module's documentation for the label names.

```bash
# .bazelrc
build --features=strict_warnings
build --features=warnings_as_errors
```

Or per target:

```starlark
cc_library(
    name = "core",
    srcs = ["core.cpp"],
    features = ["strict_warnings", "warnings_as_errors"],
)
```

### Scenario B — "Undefined reference to pthread symbols"

**Symptom:** Links fail with `pthread_*` undefined references.

**Cause:** The toolchain doesn't rely on a Bazel legacy feature for this flag.
The generic Linux profile enables `use_pthread` by default; a target or build
configuration might have disabled it, or a different profile might apply.

**Fix (Linux):** Check the selected toolchain and whether `use_pthread` was
disabled. If needed, enable it for the target, package, or build:

```starlark
cc_binary(
    name = "server",
    srcs = ["server.cpp"],
    features = ["use_pthread"],
)
```

```bash
# .bazelrc — or enable it build-wide
build --features=use_pthread
```

### Scenario C — "I need a fully static binary"

**Symptom:** Binary is dynamically linked; you expected `-static`.

**Cause:** On Linux, `fully_static_link` is opt-in (it also requires static system
archives, which some toolchains such as AutoSD do not ship).

**Fix:** Enable it only for the targets that need it:

```starlark
cc_binary(
    name = "standalone",
    srcs = ["main.cpp"],
    features = ["fully_static_link"],
)
```

If the link fails for missing `libc.a` / `libstdc++.a`, the underlying toolchain
does not provide static system libraries and this behavior is not available on
that platform.

### Scenario D — "A specific compiler/linker flag I always passed is gone"

**Symptom:** A flag that a legacy default used to add no longer appears.

**Cause:** The legacy feature that added it is inactive.

**Fix:** Decide whether it should be conditional or unconditional:

- Unconditional, every build → `extra_compile_flags` / `extra_link_flags` on
  `gcc.toolchain(...)` (mechanism 4).
- Conditional, only for some builds → put the flag in a named `.bazelrc` config
  (for example `build:hardened --copt=... --linkopt=...`) and select it with
  `--config=hardened` where needed.

### Scenario E — "I want a reusable downstream hardening profile"

**Symptom:** Several teams need the same set of extra flags or opt-in features,
applied consistently.

**Cause:** There is no single named switch for it.

**Fix:** Bundle the settings into a named `.bazelrc` config and select it with
`--config`. This groups existing opt-in features and/or raw flags behind one
name, without changing the toolchain:

```bash
# .bazelrc
build:hardened --features=strict_warnings
build:hardened --features=warnings_as_errors
build:hardened --copt=-fstack-protector-strong
```

```bash
bazel build --config=hardened //...
```

For flags that must apply to every build of a toolchain unconditionally, use the
`extra_compile_flags` / `extra_link_flags` attributes on `gcc.toolchain(...)`
(mechanism 4) instead.

### Scenario F — "Should this be enabled by default for everyone?"

If a behavior must apply to *all* builds (not opt-in), enable the feature
unconditionally in `.bazelrc`. Targets that must skip it can still disable it
locally with a `-` prefix:

```bash
# .bazelrc — on by default for every build
build --features=strict_warnings
```

```starlark
cc_library(
    name = "third_party_shim",
    srcs = ["shim.cpp"],
    # Opt this one target out of the default.
    features = ["-strict_warnings"],
)
```

## Migration checklist

- [ ] Build your workspace against the toolchain and collect any compile/link
      failures.
- [ ] For each failure, identify the legacy behavior involved using the
      [behavior table](#behaviors-that-are-no-longer-implicit).
- [ ] If the behavior maps to an **existing opt-in feature**, enable it with a
      target/package `features` attribute or a `--features` / `--host_features`
      flag.
- [ ] If you need **unconditional extra flags**, add them via
      `extra_compile_flags` / `extra_link_flags` on `gcc.toolchain(...)`.
- [ ] If you need a **reusable profile**, group the features/flags behind a named
      `.bazelrc` config and select it with `--config`.
- [ ] Verify the resulting command line with `bazel build --subcommands` when
      flag order matters.
- [ ] Pin the chosen settings in `.bazelrc` so the configuration is reproducible
      and self-describing.

## Related documentation

- [Toolchain features](features.md) — the authoritative feature catalog.
- [Extension API](extension_api.md) — `gcc.toolchain(...)` attributes and
  activation.
- [Maintenance](../contributors/maintenance.md) — how features and non-feature wiring are
  classified under `no_legacy_features`.
