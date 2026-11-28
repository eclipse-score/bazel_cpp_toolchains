# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

"""Cwd-independent launchers for the compiler artifacts selected by an SDP."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:shell.bzl", "shell")

def _relative_path(start, path):
    # Anchor execpaths before normalizing to retain sibling repository paths.
    start_parts = paths.normalize("execroot/_main/" + start).split("/")
    path_parts = paths.normalize("execroot/_main/" + path).split("/")
    common = 0
    for left, right in zip(start_parts, path_parts):
        if left != right:
            break
        common += 1
    return "/".join([".."] * (len(start_parts) - common) + path_parts[common:])

def _impl(ctx):
    wrapper = ctx.actions.declare_file(ctx.label.name)
    sdk_root = ctx.file.sdk_root.path if ctx.file.sdk_root else ctx.attr.sdk_files.label.workspace_root
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = wrapper,
        substitutions = {
            "'%{sdk_relative_path}'": shell.quote(_relative_path(wrapper.dirname, sdk_root)),
            "'%{compiler_relative_path}'": shell.quote(_relative_path(wrapper.dirname, ctx.file.compiler.path)),
        },
        is_executable = True,
    )
    compiler = ctx.attr.compiler[DefaultInfo]
    files = depset(
        [wrapper, ctx.file.compiler],
        transitive = [
            ctx.attr.sdk_files[DefaultInfo].files,
            compiler.default_runfiles.files,
            compiler.data_runfiles.files,
        ],
    )
    return [
        DefaultInfo(
            executable = wrapper,
            runfiles = ctx.runfiles(transitive_files = files),
        ),
        OutputGroupInfo(compiler_files = files),
    ]

qnx_compiler_wrapper = rule(
    implementation = _impl,
    executable = True,
    attrs = {
        "compiler": attr.label(allow_single_file = True, executable = True, cfg = "exec", mandatory = True),
        "sdk_root": attr.label(
            allow_single_file = True,
            doc = "Optional SDK directory artifact; otherwise use sdk_files' repository root.",
        ),
        "sdk_files": attr.label(mandatory = True),
        "_template": attr.label(
            default = "//templates:qnx_compiler_wrapper.template",
            allow_single_file = True,
        ),
    },
)

def _files_impl(ctx):
    return DefaultInfo(files = depset(
        transitive = [compiler[OutputGroupInfo].compiler_files for compiler in ctx.attr.compilers],
    ))

qnx_compiler_files = rule(
    implementation = _files_impl,
    attrs = {
        # Match cc_toolchain_config's executable attributes, including their
        # execution configuration, rather than building target-side launchers.
        "compilers": attr.label_list(cfg = "exec", mandatory = True),
    },
)
