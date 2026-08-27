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

"""Opt-in (disabled-by-default) toolchain feature tests.

Each target below exercises one of the opt-in features added to the Linux
toolchain. The features are disabled by default, so every target enables its
feature explicitly via the `features` attribute. Some features only emit flags
when an additional build mode is active (e.g. fission or force-pic); the exact
command needed to make each feature take effect is documented on the target.

All targets are tagged "manual" so that:
  * CI wildcard runs (`bazel test //...`) skip them, and
  * they are NOT part of the `//:feature_verification_tests` suite.

Run them explicitly on demand, e.g.:
    bazel test --config x86_64-linux \\
        //feature_verification/opt_in_features:fully_static_link_test
"""

load("@rules_cc//cc:defs.bzl", "cc_test")

# ---------------------------------------------------------------------------
# Compile-side opt-in features
# ---------------------------------------------------------------------------

# per_object_debug_info -> "-gsplit-dwarf -g" (fission split DWARF).
# Only emitted when fission is active; run with:
#   bazel test --config x86_64-linux --fission=yes \
#       //feature_verification/opt_in_features:per_object_debug_info_test
cc_test(
    name = "per_object_debug_info_test",
    srcs = ["opt_in_smoke.cpp"],
    features = ["per_object_debug_info"],
    tags = ["manual"],
)

# includes -> "-include %{includes}" (force-included headers).
# The `includes` build variable is only populated for force-included headers.
cc_test(
    name = "includes_test",
    srcs = ["opt_in_smoke.cpp"],
    features = ["includes"],
    tags = ["manual"],
)

# ---------------------------------------------------------------------------
# Link-side opt-in features
# ---------------------------------------------------------------------------

# fission_support -> "-Wl,--gdb-index". Only emitted when fission is active:
#   bazel test --config x86_64-linux --fission=yes \
#       //feature_verification/opt_in_features:fission_support_test
cc_test(
    name = "fission_support_test",
    srcs = ["opt_in_smoke.cpp"],
    features = ["fission_support"],
    tags = ["manual"],
)

# linkstamps -> passes "%{linkstamp_paths}" to the linker.
# Requires linkstamp inputs and --stamp to populate linkstamp_paths.
cc_test(
    name = "linkstamps_test",
    srcs = ["opt_in_smoke.cpp"],
    features = ["linkstamps"],
    tags = ["manual"],
)

# force_pic_flags -> "-pie" for executables. Only emitted under --force_pic. The
# test asserts its own ELF type is ET_DYN (PIE), so it must be run with:
#   bazel test --config x86_64-linux --force_pic \
#       //feature_verification/opt_in_features:force_pic_flags_test
cc_test(
    name = "force_pic_flags_test",
    srcs = ["force_pic_test.cpp"],
    features = ["force_pic_flags"],
    tags = ["manual"],
)

# strip_debug_symbols -> "-Wl,-S". Emitted when debug-symbol stripping is
# requested for the link output.
cc_test(
    name = "strip_debug_symbols_test",
    srcs = ["opt_in_smoke.cpp"],
    features = ["strip_debug_symbols"],
    tags = ["manual"],
)

# static_libgcc -> "-static-libgcc" (gated on the static_link_cpp_runtimes
# feature, which must also be enabled).
cc_test(
    name = "static_libgcc_test",
    srcs = ["opt_in_smoke.cpp"],
    features = [
        "static_libgcc",
        "static_link_cpp_runtimes",
    ],
    tags = ["manual"],
)

# ---------------------------------------------------------------------------
# Convenience suite (also manual; not wired into CI).
# ---------------------------------------------------------------------------
test_suite(
    name = "opt_in_feature_tests",
    tags = ["manual"],
    tests = [
        ":fission_support_test",
        ":force_pic_flags_test",
        ":includes_test",
        ":linkstamps_test",
        ":per_object_debug_info_test",
        ":static_libgcc_test",
        ":strip_debug_symbols_test",
    ],
)
