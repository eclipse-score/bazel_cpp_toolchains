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

"""Analysis tests for the ELF enabler's output and input contracts."""

load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load("@score_ebclfsa_2.0.0-beta2_toolchain//:elf_enabler.bzl", "elf_enabler")

def _output_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)
    outputs = target[DefaultInfo].files.to_list()
    asserts.equals(env, 1, len(outputs))
    asserts.equals(env, "enabled", outputs[0].basename)

    actions = analysistest.target_actions(env)
    asserts.equals(env, 1, len(actions))
    action = actions[0]
    asserts.equals(env, "ElfEnable", action.mnemonic)
    asserts.equals(env, outputs, action.outputs.to_list())
    input_names = [f.basename for f in action.inputs.to_list()]
    asserts.true(env, "original" in input_names)
    asserts.true(env, "lisa-elf-enabler" in input_names)
    sdk_inputs = [
        f
        for f in action.inputs.to_list()
        if f.short_path.endswith("/usr/bin/lisa-elf-enabler")
    ]
    asserts.equals(env, 1, len(sdk_inputs))
    asserts.true(env, "score_ebclfsa_2.0.0-beta2_toolchain_pkg" in sdk_inputs[0].owner.repo_name)
    asserts.equals(env, sdk_inputs[0].path, action.argv[-1])
    return analysistest.end(env)

_output_test = analysistest.make(_output_test_impl)

def _invalid_input_test_impl(ctx):
    env = analysistest.begin(ctx)
    asserts.expect_failure(env, "must produce a single file")
    return analysistest.end(env)

_invalid_input_test = analysistest.make(_invalid_input_test_impl, expect_failure = True)

def elf_enabler_test_suite(name):
    """Creates output-contract and invalid-input tests.

    Args:
        name: Name of the test suite.
    """
    _output_test(
        name = name + "_output",
        size = "small",
        target_under_test = ":enabled",
        target_compatible_with = select({
            ":sdk_platform": [],
            "//conditions:default": ["@platforms//:incompatible"],
        }),
    )

    native.filegroup(
        name = name + "_multiple_files",
        srcs = ["original.cc", "integration_test.sh"],
    )

    tests = [name + "_output"]
    native.filegroup(name = name + "_empty")
    for invalid_files in ["multiple_files", "empty"]:
        invalid_name = name + "_invalid_src_" + invalid_files
        elf_enabler(
            name = invalid_name,
            src = ":" + name + "_" + invalid_files,
            tags = ["manual"],
        )
        _invalid_input_test(
            name = invalid_name + "_test",
            size = "small",
            target_under_test = ":" + invalid_name,
            target_compatible_with = select({
                ":sdk_platform": [],
                "//conditions:default": ["@platforms//:incompatible"],
            }),
        )
        tests.append(invalid_name + "_test")

    native.test_suite(
        name = name,
        tests = tests,
    )
