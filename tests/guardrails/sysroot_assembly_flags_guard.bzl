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

"""Guardrail for sysroot flags on assembly actions."""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc:defs.bzl", "cc_common")
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cpp_toolchain", "use_cc_toolchain")

_ASSEMBLY_ACTIONS = [
    ("assemble", ACTION_NAMES.assemble),
    ("preprocess-assemble", ACTION_NAMES.preprocess_assemble),
]

def _impl(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    variables = cc_common.create_compile_variables(
        cc_toolchain = cc_toolchain,
        feature_configuration = feature_configuration,
        source_file = ctx.file.src.path,
    )

    problems = []
    for action_label, action_name in _ASSEMBLY_ACTIONS:
        args = cc_common.get_memory_inefficient_command_line(
            feature_configuration = feature_configuration,
            action_name = action_name,
            variables = variables,
        )
        sysroot_flags = [
            arg
            for arg in args
            if arg.startswith("--sysroot=") and len(arg) > len("--sysroot=")
        ]
        linker_sysroot_flags = [
            arg
            for arg in args
            if arg.startswith("-Wl,--sysroot")
        ]
        if not sysroot_flags:
            problems.append(
                "{} is missing --sysroot=<path>; command line: {}".format(
                    action_label,
                    " ".join(args),
                ),
            )
        if linker_sysroot_flags:
            problems.append(
                "{} contains linker-only sysroot flag(s) {}; command line: {}".format(
                    action_label,
                    ", ".join(linker_sysroot_flags),
                    " ".join(args),
                ),
            )

    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    if problems:
        message = [
            "=======================================================================",
            "ASSEMBLY SYSROOT FLAGS GUARDRAIL FAILED",
            "=======================================================================",
            "Target: {}".format(str(ctx.label)),
            "",
            "Problems detected:",
        ]
        message.extend(["  - " + problem for problem in problems])
        message.extend([
            "",
            "Expected each assembly action to contain --sysroot=<path> and no",
            "-Wl,--sysroot linker flag.",
            "=======================================================================",
        ])
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
            "echo 'GUARDRAIL OK: assembly actions use the sysroot flag without linker flags.'\n" +
            "exit 0\n"
        )

    ctx.actions.write(output = script, content = content, is_executable = True)
    return DefaultInfo(executable = script)

sysroot_assembly_flags_guard_test = rule(
    implementation = _impl,
    doc = "Fails if assembly actions omit the sysroot flag or receive linker-only sysroot flags.",
    attrs = {
        "src": attr.label(allow_single_file = [".S"], mandatory = True),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
    },
    toolchains = use_cc_toolchain(),
    fragments = ["cpp"],
    test = True,
)
