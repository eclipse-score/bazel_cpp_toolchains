# *******************************************************************************
# Copyright (c) 2025 Contributors to the Eclipse Foundation
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

""" Common rules used by all drivers (cc configs)
"""

load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "flag_group")

def get_flag_groups(flags):
    """Converts a list of warning flags into a Bazel flag group representation.

    Args:
        flags (list[str]): A list of compiler warning flags.

    Returns:
        str: A formatted string representing the flag group in Bazel syntax.
    """
    if len(flags):
        return "[flag_group(flags = [" + ", ".join(['"%s"' % f for f in flags]) + "])]"
    return "[]"

def get_flag_group(flags):
    """Helper function to create a flag_group.

    Args:
        flags (list[str]): A list of compiler or linker flags.

    Returns:
        flag_group: A Bazel flag_group object containing the provided flags.
    """
    if len(flags):
        return [
            flag_group(
                flags = flags,
            ),
        ]
    return []
