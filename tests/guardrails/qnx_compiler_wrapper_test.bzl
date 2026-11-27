# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

"""Exercise analyzed compiler selections without a licensed SDP."""

load("@bazel_skylib//lib:shell.bzl", "shell")
load("@score_bazel_cpp_toolchains//rules:qnx_compiler_wrapper.bzl", "qnx_compiler_files", "qnx_compiler_wrapper")

def _fake_sdk_impl(ctx):
    sdk = ctx.actions.declare_directory(ctx.label.name)
    ctx.actions.run_shell(
        outputs = [sdk],
        arguments = [sdk.path],
        command = """
set -euo pipefail
mkdir -p "$1/host/linux/x86_64/usr/lib" "$1/target/qnx"
printf FAKE-LIBRARY-FOR-TESTING > "$1/host/linux/x86_64/usr/lib/liblicense.so.1"
printf FAKE-TARGET-FOR-TESTING > "$1/target/qnx/marker"
""",
    )
    return DefaultInfo(files = depset([sdk]))

_fake_sdk = rule(implementation = _fake_sdk_impl)

def _fake_compiler_impl(ctx):
    directory = ctx.label.name + "/vendor 'tools'"
    compiler = ctx.actions.declare_file(directory + "/" + ctx.attr.filename)
    helper = ctx.actions.declare_file(directory + "/compiler helper")
    ctx.actions.write(
        compiler,
        """#!/bin/bash
set -euo pipefail
export VENDOR_LAUNCHER_SELECTED="${0##*/}"
exec "${0%/*}/compiler helper" "$@"
""",
        is_executable = True,
    )
    ctx.actions.write(
        helper,
        """#!/bin/bash
set -euo pipefail
[[ -f "${QNX_HOST}/usr/lib/liblicense.so.1" ]] || exit 127
[[ "$QNX_HOST" == "${EXPECTED_SDK}/host/linux/x86_64" ]]
[[ "$QNX_TARGET" == "${EXPECTED_SDK}/target/qnx" ]]
[[ -f "${QNX_TARGET}/marker" ]]
[[ "$PWD" == "$EXPECTED_CWD" ]]
[[ "$QNX_CONFIGURATION_EXCLUSIVE" == /var/tmp/.qnx ]]
[[ "$QNX_SHARED_LICENSE_FILE" == FAKE-LICENSE-FOR-TESTING ]]
[[ "$LM_LICENSE_FILE" == FAKE-SERVER-FOR-TESTING ]]
[[ "$#" == 2 && "$1" == "-DVALUE=two words" && "$2" == "source file.c" ]]
[[ -f "$2" ]]
[[ "$VENDOR_LAUNCHER_SELECTED" == "$EXPECTED_COMPILER" ]]
exit "${COMPILER_STATUS:-0}"
""",
        is_executable = True,
    )
    return DefaultInfo(
        executable = compiler,
        runfiles = ctx.runfiles(files = [helper]),
    )

_fake_compiler = rule(
    implementation = _fake_compiler_impl,
    executable = True,
    attrs = {"filename": attr.string(mandatory = True)},
)

def _impl(ctx):
    inputs = ctx.attr.compiler_files[DefaultInfo].files
    args = [ctx.file.sdk.path, str(len(ctx.attr.wrappers))]
    for target, filename in zip(ctx.attr.wrappers, ctx.attr.filenames):
        args.extend([target[DefaultInfo].files_to_run.executable.path, filename])
    for file in inputs.to_list():
        args.extend([file.short_path, file.path])
    script = ctx.actions.declare_file(ctx.label.name + "_runner.sh")
    ctx.actions.write(
        script,
        "#!/bin/bash\nset -euo pipefail\nexec bash {} {}\n".format(
            shell.quote(ctx.file._test.short_path),
            " ".join([shell.quote(arg) for arg in args]),
        ),
        is_executable = True,
    )
    return DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(files = [ctx.file._test], transitive_files = inputs),
    )

_test = rule(
    implementation = _impl,
    test = True,
    attrs = {
        "wrappers": attr.label_list(cfg = "exec", mandatory = True),
        "compiler_files": attr.label(mandatory = True),
        "filenames": attr.string_list(mandatory = True),
        "sdk": attr.label(cfg = "exec", allow_single_file = True, mandatory = True),
        "_test": attr.label(default = ":qnx_compiler_wrapper_test.sh", allow_single_file = True),
    },
)

def qnx_compiler_wrapper_test(name, **kwargs):
    """Test standard names and alternate filegroup-selected vendor launchers."""
    sdk = name + "_sdp"
    _fake_sdk(name = sdk)
    wrappers = []
    filenames = ["qcc", "q++", "alternate-c-driver", "alternate-cxx-driver"]
    for index, filename in enumerate(filenames):
        compiler = name + "_compiler_" + str(index)
        selection = compiler + "_selection"
        wrapper = name + "_wrappers/" + str(index) + "/" + ("qcc" if index % 2 == 0 else "q++")
        _fake_compiler(name = compiler, filename = filename)
        native.filegroup(name = selection, srcs = [":" + compiler])
        qnx_compiler_wrapper(
            name = wrapper,
            compiler = ":" + selection,
            sdk_root = ":" + sdk,
            sdk_files = ":" + sdk,
        )
        wrappers.append(":" + wrapper)
    qnx_compiler_files(name = name + "_files", compilers = wrappers)
    _test(
        name = name,
        wrappers = wrappers,
        compiler_files = ":" + name + "_files",
        filenames = filenames,
        sdk = ":" + sdk,
        **kwargs
    )
