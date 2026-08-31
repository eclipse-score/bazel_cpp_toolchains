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

_ALL_ACTIONS = [
    "@rules_cc//cc/toolchains/actions:compile_actions",
    "@rules_cc//cc/toolchains/actions:link_actions",
    "@rules_cc//cc/toolchains/actions:strip",
    "@rules_cc//cc/toolchains/actions:ar_actions",
]

def make_compiler_library_search_paths(compiler_library_search_paths):
    """Creates the compiler_library_search_paths feature.

    Sets LD_LIBRARY_PATH for every toolchain action (compile, link, archive,
    strip) so the compiler/linker/ar/strip binaries themselves can find their
    own runtime shared libraries. This is unrelated to the artifacts being
    built, so it's an env var applied to all actions, not a linker flag.

    Args:
        compiler_library_search_paths: colon-joined path string, "" if none.
    """
    cc_args(
        name = "compiler_library_search_paths_args",
        actions = _ALL_ACTIONS,
        env = {"LD_LIBRARY_PATH": compiler_library_search_paths} if compiler_library_search_paths else {},
    )

    cc_feature(
        name = "compiler_library_search_paths",
        args = [":compiler_library_search_paths_args"],
        feature_name = "compiler_library_search_paths",
    )
