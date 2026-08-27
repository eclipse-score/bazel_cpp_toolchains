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

"""Guardrail protecting the explicit-feature (`no_legacy_features`) contract.

The Linux and QNX toolchains deliberately enable the `no_legacy_features`
marker so that Bazel injects none of its implicit legacy C++ features. This
rule resolves the *active* C++ toolchain and reports a **test failure** if that
contract regresses, either because:

* the `no_legacy_features` marker is no longer enabled, or
* one of Bazel's implicit legacy features (which this repository never defines)
  has become active again.

The contract is evaluated deterministically from the resolved toolchain
configuration and surfaced as the test's exit status, so it needs no target
hardware and is exercised with `bazel test`.
"""

load("@rules_cc//cc:defs.bzl", "cc_common")
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cpp_toolchain", "use_cc_toolchain")

# The explicit-feature marker that must stay enabled on every toolchain.
_CONTRACT_MARKER = "no_legacy_features"

# Bazel auto-injects these "legacy" features only when a cc_toolchain does not
# declare `no_legacy_features`. This repository intentionally defines none of
# them, so if any becomes enabled the toolchain has regressed to relying on
# Bazel's legacy C++ feature behavior. Names here are chosen to NOT collide
# with the toolchain's own explicit feature names.
_DEFAULT_FORBIDDEN_LEGACY_FEATURES = [
    "legacy_compile_flags",
    "legacy_link_flags",
    "sysroot",
]

def _impl(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    marker_enabled = cc_common.is_enabled(
        feature_configuration = feature_configuration,
        feature_name = _CONTRACT_MARKER,
    )

    leaked = [
        name
        for name in ctx.attr.forbidden_legacy_features
        if cc_common.is_enabled(
            feature_configuration = feature_configuration,
            feature_name = name,
        )
    ]

    problems = []
    if not marker_enabled:
        problems.append(
            "the `{}` marker is NOT enabled in the resolved toolchain configuration; ".format(_CONTRACT_MARKER) +
            "Bazel will inject its implicit legacy C++ features.",
        )
    if leaked:
        problems.append(
            "Bazel legacy feature(s) are enabled again: {}.".format(", ".join(leaked)),
        )

    script = ctx.actions.declare_file(ctx.label.name + ".sh")

    if problems:
        message = [
            "=======================================================================",
            "EXPLICIT-FEATURE GUARDRAIL FAILED",
            "=======================================================================",
            "Target: {}".format(str(ctx.label)),
            "",
            "Problems detected:",
        ]
        message.extend(["  - " + p for p in problems])
        message.extend([
            "",
            "Expected contract (see docs/migration_guide.md):",
            "  * The cc_toolchain keeps the `{}` feature (enabled = True) in its".format(_CONTRACT_MARKER),
            "    `features` list.",
            "  * None of Bazel's implicit legacy C++ features are active.",
            "",
            "How to fix:",
            "  * Re-add / re-enable `{}` in the toolchain config templates".format(_CONTRACT_MARKER),
            "    under templates/linux/ and templates/qnx/.",
            "  * Provide any needed behavior through an explicit feature instead of",
            "    relying on Bazel legacy defaults.",
            "  * See tests/guardrails/README.md for details.",
            "=======================================================================",
        ])

        # Surface the verdict as a test failure (exit 1) rather than a build
        # failure. The heredoc delimiter is single-quoted so the message is
        # emitted verbatim (no shell expansion of backticks/braces).
        content = (
            "#!/usr/bin/env bash\n" +
            "cat >&2 <<'GUARDRAIL_EOF'\n" +
            "\n".join(message) + "\n" +
            "GUARDRAIL_EOF\n" +
            "exit 1\n"
        )
    else:
        content = (
            "#!/usr/bin/env bash\n" +
            "echo 'GUARDRAIL OK: {} enabled; no Bazel legacy features leaked ({}).'\n".format(
                _CONTRACT_MARKER,
                str(ctx.label),
            ) +
            "exit 0\n"
        )

    ctx.actions.write(output = script, content = content, is_executable = True)
    return DefaultInfo(executable = script)

no_legacy_features_guard_test = rule(
    implementation = _impl,
    doc = "Fails if the active C++ toolchain regresses to Bazel legacy feature behavior.",
    attrs = {
        "forbidden_legacy_features": attr.string_list(
            default = _DEFAULT_FORBIDDEN_LEGACY_FEATURES,
            doc = "Bazel legacy feature names that must never be enabled.",
        ),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
    },
    toolchains = use_cc_toolchain(),
    fragments = ["cpp"],
    test = True,
)
