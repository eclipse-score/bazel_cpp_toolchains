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

load("@rules_cc//cc/toolchains:args.bzl", "cc_args")
load("@rules_cc//cc/toolchains:feature.bzl", "cc_feature")

_ACTIONS = [
    "@rules_cc//cc/toolchains/actions:compile_actions",
    "@rules_cc//cc/toolchains/actions:link_actions",
]

def make_sdp_env_feature(
        host_dir,
        target_dir,
        license_path,
        license_info_variable,
        license_info_value):
    """Creates a feature for the sdp_env toolchain.

    Args:
        host_dir: str, resolved path to the SDP host directory.
        target_dir: str, resolved path to the SDP target directory.
        license_path: str, path to the license file.
        license_info_variable: str, name of an extra license env var, "" if none.
        license_info_value: str, value of that extra license env var, "" if none.

    Returns:
        A feature definition for the sdp_env toolchain.
    """

    # cc_args' `env` has no mechanism to resolve labels/format custom
    # placeholders (see validate_env_variables in rules_cc) -- host_dir/
    # target_dir must already be plain resolved path strings.
    env = {
        "QNX_HOST": host_dir,
        "QNX_TARGET": target_dir,
        "QNX_CONFIGURATION_EXCLUSIVE": "/var/tmp/.qnx",
        "QNX_SHARED_LICENSE_FILE": license_path,
    }
    if license_info_value:
        env[license_info_variable] = license_info_value

    cc_args(
        name = "sdp_env_args",
        actions = _ACTIONS,
        env = env,
    )

    cc_feature(
        name = "sdp_env",
        feature_name = "sdp_env",
        args = [":sdp_env_args"],
    )
