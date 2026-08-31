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

def compute_feature_lists(target_os):
    """Returns the flat known/enabled feature label lists for target_os.

    Unlike cc_feature_set (which groups features for requires_any_of/requires_all_of
    constraints and does not itself provide FeatureInfo), cc_toolchain_config's
    known_features/enabled_features attrs require every entry to individually
    provide FeatureInfo — so this returns plain lists of cc_feature labels rather
    than a single grouping target.

    Per-instance features (extra_compile_flags, extra_c_compile_flags,
    extra_cxx_compile_flags, extra_link_flags, sysroot_link_flags,
    compiler_library_search_paths) are baked into _LINUX_FEATURES/_QNX_FEATURES
    directly since their target names never change across toolchain instances —
    see templates/BUILD.template for where those targets get created.

    Args:
        target_os: "linux" or "qnx".

    Returns:
        (known_features, enabled_features) tuple of flat label lists.
    """

_QNX_FEATURES = [
    ("@score_bazel_cpp_toolchains//features/native/markers:dbg", False),  # Bazel auto-toggles via -c dbg
    ("@score_bazel_cpp_toolchains//features/native/markers:no_legacy_features", True),
    ("@score_bazel_cpp_toolchains//features/native/unfiltered_compile_flags", True),
    ("@score_bazel_cpp_toolchains//features/custom/qnx/gcc_version_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/default_compile_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/random_seed", True),
    ("@score_bazel_cpp_toolchains//features/native/include_paths", True),
    ("@score_bazel_cpp_toolchains//features/native/preprocessor_defines", True),
    (":extra_compile_flags", True),  # per-instance, see templates/BUILD.template
    (":extra_c_compile_flags", True),  # per-instance, see templates/BUILD.template
    (":extra_cxx_compile_flags", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/user_compile_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/compiler_input_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/compiler_output_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/markers:dependency_file_named_implicitly", False),
    ("@score_bazel_cpp_toolchains//features/native/dependency_file", True),
    ("@score_bazel_cpp_toolchains//features/native/default_link_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/archiver_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/linker_param_file", True),
    ("@score_bazel_cpp_toolchains//features/native/library_search_directories", True),
    ("@score_bazel_cpp_toolchains//features/native/shared_flag", True),
    ("@score_bazel_cpp_toolchains//features/native/output_execpath_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/libraries_to_link", True),
    ("@score_bazel_cpp_toolchains//features/native/user_link_flags", True),
    (":extra_link_flags", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/markers:coverage", False),  # opt-in
    ("@score_bazel_cpp_toolchains//features/native/markers:opt", False),  # Bazel auto-toggles via -c opt
    (":sdp_env", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/markers:supports_dynamic_linker", True),
    ("@score_bazel_cpp_toolchains//features/native/markers:supports_pic", True),
    ("@score_bazel_cpp_toolchains//features/native/pic", True),
    ("@score_bazel_cpp_toolchains//features/native/runtime_library_search_directories", True),
    ("@score_bazel_cpp_toolchains//features/native/gcc_coverage_map_format", False),  # opt-in
]

def qnx_known_features():
    """Full ordered list of QNX feature labels — order drives flag order."""
    return [label for label, _enabled in _QNX_FEATURES]

def qnx_enabled_features():
    """Subset of QNX feature labels that start enabled — order is irrelevant here."""
    return [label for label, enabled in _QNX_FEATURES if enabled]

def get_feature_lists():
    """Returns the flat known/enabled feature label lists for QNX.

    Returns:
        (known_features, enabled_features) tuple of flat label lists.
    """
    return qnx_known_features(), qnx_enabled_features()
