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

"""Check SDK discovery by Cargo-like consumers without invoking a compiler."""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "feature", "tool_path")
load("@rules_cc//cc:defs.bzl", "CcToolchainConfigInfo", "cc_common", "cc_toolchain")
load("@rules_cc//cc/toolchains:feature_injection.bzl", "FeatureInfo", "convert_feature")
load("@score_bazel_cpp_toolchains//features/custom/qnx/sdp_env:feature.bzl", "make_sdp_env_feature")

_SDK_ROOT = "/proc/self/cwd/external/FAKE-SDP-FOR-TESTING"
_HOST = _SDK_ROOT + "/host/linux/x86_64"
_TARGET = _SDK_ROOT + "/target/qnx"

def _config_impl(ctx):
    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = [
            feature(name = "no_legacy_features", enabled = True),
            convert_feature(ctx.attr.sdp_env[FeatureInfo], enabled = True),
        ],
        toolchain_identifier = "FAKE-SDP-ENV-FOR-TESTING",
        host_system_name = "local",
        target_system_name = "qnx",
        target_cpu = "x86_64",
        target_libc = "unknown",
        compiler = "FAKE-COMPILER-FOR-TESTING",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = [
            tool_path(name = name, path = "/FAKE-COMPILER-MUST-NOT-BE-INVOKED")
            for name in ["ar", "cpp", "gcc", "gcov", "ld", "nm", "objdump", "strip"]
        ],
    )

_config = rule(
    implementation = _config_impl,
    attrs = {"sdp_env": attr.label(providers = [FeatureInfo], mandatory = True)},
    provides = [CcToolchainConfigInfo],
)

def _test_impl(ctx):
    configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = ctx.attr.cc_toolchain[cc_common.CcToolchainInfo],
    )
    expected = {
        "QNX_HOST": _HOST,
        "QNX_TARGET": _TARGET,
        "QNX_CONFIGURATION_EXCLUSIVE": "/var/tmp/.qnx",
        "QNX_SHARED_LICENSE_FILE": "FAKE-LICENSE-FOR-TESTING",
        "LM_LICENSE_FILE": "FAKE-SERVER-FOR-TESTING",
    }
    for action in [ACTION_NAMES.c_compile, ACTION_NAMES.cpp_compile, ACTION_NAMES.cpp_link_executable]:
        environment = cc_common.get_environment_variables(
            feature_configuration = configuration,
            action_name = action,
            variables = cc_common.empty_variables(),
        )
        for key, value in expected.items():
            if environment.get(key) != value:
                fail("{}: expected {}={}, got {}".format(action, key, value, environment.get(key)))
    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(script, "#!/bin/bash\nset -euo pipefail\nexit 0\n", is_executable = True)
    return DefaultInfo(executable = script)

_test = rule(
    implementation = _test_impl,
    test = True,
    attrs = {"cc_toolchain": attr.label(providers = [cc_common.CcToolchainInfo], mandatory = True)},
    fragments = ["cpp"],
)

def qnx_sdp_env_test(name, **kwargs):
    """Verify the original feature API and default SDK discovery environment."""
    make_sdp_env_feature(
        _HOST,
        _TARGET,
        "FAKE-LICENSE-FOR-TESTING",
        "LM_LICENSE_FILE",
        "FAKE-SERVER-FOR-TESTING",
    )
    _config(name = name + "_config", sdp_env = ":sdp_env")
    native.filegroup(name = name + "_empty")
    cc_toolchain(
        name = name + "_toolchain",
        toolchain_config = ":" + name + "_config",
        all_files = ":" + name + "_empty",
        ar_files = ":" + name + "_empty",
        as_files = ":" + name + "_empty",
        compiler_files = ":" + name + "_empty",
        dwp_files = ":" + name + "_empty",
        linker_files = ":" + name + "_empty",
        objcopy_files = ":" + name + "_empty",
        strip_files = ":" + name + "_empty",
    )
    _test(name = name, cc_toolchain = ":" + name + "_toolchain", **kwargs)
