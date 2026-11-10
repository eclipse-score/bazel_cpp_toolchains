# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

"""Host-executed checks of the resolved high-integrity toolchain."""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc:defs.bzl", "cc_common")
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cpp_toolchain", "use_cc_toolchain")

def _impl(ctx):
    toolchain = find_cpp_toolchain(ctx)
    configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    for name in ["no_legacy_features", "default_compile_flags", "extra_c_compile_flags", "extra_cxx_compile_flags", "extra_link_flags"]:
        if not cc_common.is_enabled(feature_configuration = configuration, feature_name = name):
            fail("Required high-integrity feature is not enabled: " + name)
    for name in ["supports_dynamic_linker", "shared_flag", "gcc_coverage_map_format", "coverage", "static_libgcc", "supports_fission"]:
        if cc_common.is_enabled(feature_configuration = configuration, feature_name = name):
            fail("Unsupported high-integrity feature is enabled: " + name)

    report = ctx.actions.declare_file(ctx.label.name + ".elf")
    ctx.actions.run_shell(
        inputs = depset([ctx.executable.binary], transitive = [toolchain.all_files]),
        tools = [ctx.executable.readelf],
        outputs = [report],
        arguments = [ctx.executable.readelf.path, ctx.executable.binary.path, report.path],
        command = """
set -eu
"$1" -h -l -d "$2" > "$3"
if ! grep -q 'Machine:.*AArch64' "$3" || grep -Eq 'INTERP|NEEDED' "$3"; then
    cat "$3" >&2
    echo "Expected a static AArch64 ELF with no dynamic loader or dependencies" >&2
    exit 1
fi
""",
        mnemonic = "HighIntegrityElf",
    )
    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
        script,
        "#!/usr/bin/env bash\nset -eu\ncat \"$TEST_SRCDIR/" + ctx.workspace_name + "/" + report.short_path + "\"\n",
        is_executable = True,
    )
    return DefaultInfo(executable = script, runfiles = ctx.runfiles(files = [report]))

configuration_test = rule(
    implementation = _impl,
    attrs = {
        "binary": attr.label(executable = True, cfg = "target", mandatory = True),
        "readelf": attr.label(executable = True, cfg = "exec", allow_single_file = True, mandatory = True),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    fragments = ["cpp"],
    toolchains = use_cc_toolchain(),
    test = True,
)

def _restriction_impl(ctx):
    toolchain = find_cpp_toolchain(ctx)
    configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    variables = cc_common.create_compile_variables(
        cc_toolchain = toolchain,
        feature_configuration = configuration,
        source_file = ctx.file.src.path,
    )
    args = cc_common.get_memory_inefficient_command_line(
        feature_configuration = configuration,
        action_name = ACTION_NAMES.cpp_compile,
        variables = variables,
    )
    compiler = cc_common.get_tool_for_action(
        feature_configuration = configuration,
        action_name = ACTION_NAMES.cpp_compile,
    )
    log = ctx.actions.declare_file(ctx.label.name + ".log")
    ctx.actions.run_shell(
        inputs = depset([ctx.file.src], transitive = [toolchain.all_files]),
        outputs = [log],
        arguments = [log.path, ctx.attr.diagnostic, compiler] + args + ["-fsyntax-only"],
        command = """
set -eu
log=$1
diagnostic=$2
shift 2
if "$@" > "$log" 2>&1; then
    echo "High-integrity compiler unexpectedly accepted restricted C++" >&2
    exit 1
fi
if ! grep -Fq "$diagnostic" "$log"; then
    cat "$log" >&2
    echo "Compilation failed for an unexpected reason" >&2
    exit 1
fi
""",
        mnemonic = "HighIntegrityRestriction",
    )
    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
        script,
        "#!/usr/bin/env bash\nset -eu\ncat \"$TEST_SRCDIR/" + ctx.workspace_name + "/" + log.short_path + "\"\n",
        is_executable = True,
    )
    return DefaultInfo(executable = script, runfiles = ctx.runfiles(files = [log]))

restriction_test = rule(
    implementation = _restriction_impl,
    attrs = {
        "src": attr.label(allow_single_file = [".cpp"], mandatory = True),
        "diagnostic": attr.string(mandatory = True),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    fragments = ["cpp"],
    toolchains = use_cc_toolchain(),
    test = True,
)
