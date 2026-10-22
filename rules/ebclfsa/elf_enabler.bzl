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

"""SDK-bound implementation used by generated EBcLfSA toolchain entry points."""

def _elf_enabler_impl(ctx):
    output = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run_shell(
        inputs = [ctx.file.src] + ctx.files._sdk_files,
        tools = [ctx.file._enabler],
        outputs = [output],
        arguments = [ctx.file.src.path, output.path, ctx.file._enabler.path],
        command = """
set -eu
cp -- "$1" "$2"
chmod 0755 -- "$2"
"$3" "$2"
""",
        mnemonic = "ElfEnable",
        progress_message = "Enabling ELF executable %{label}",
    )

    return [DefaultInfo(files = depset([output]))]

def make_elf_enabler(sdk):
    """Creates the SDK-bound rule exported by a generated toolchain repository.

    This is a repository-generation helper, not the consumer API.

    Args:
        sdk: Label of the EBcLfSA package's all_files target.

    Returns:
        Rule with private dependencies on this SDK's enabler and files.
    """
    return rule(
        implementation = _elf_enabler_impl,
        doc = """Runs the EBcLfSA SDK's lisa-elf-enabler on a private copy of src.

The sole output is named after the target.
The original input is never modified or executed.
""",
        attrs = {
            "src": attr.label(
                allow_single_file = True,
                mandatory = True,
                doc = "Executable to copy and enable, usually a cc_binary target.",
            ),
            "_enabler": attr.label(
                allow_single_file = True,
                cfg = "exec",
                default = sdk.same_package_label("elf-enabler"),
            ),
            "_sdk_files": attr.label(
                cfg = "exec",
                default = sdk,
            ),
        },
    )
