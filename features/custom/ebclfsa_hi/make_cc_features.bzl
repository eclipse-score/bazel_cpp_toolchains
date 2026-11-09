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

_EBCLFSA_HI_FEATURES = [
    ("@score_bazel_cpp_toolchains//features/native/markers:no_legacy_features", True),
    (":compiler_library_search_paths", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/markers:dbg", False),
    ("@score_bazel_cpp_toolchains//features/native/unfiltered_compile_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/markers:gnu11", False),
    ("@score_bazel_cpp_toolchains//features/native/markers:c_std_c99", False),
    ("@score_bazel_cpp_toolchains//features/custom/ebclfsa_hi:compile_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/random_seed", True),
    ("@score_bazel_cpp_toolchains//features/native/include_paths", True),
    ("@score_bazel_cpp_toolchains//features/native/preprocessor_defines", True),
    (":extra_compile_flags", True),  # per-instance, see templates/BUILD.template
    (":extra_c_compile_flags", True),  # per-instance, see templates/BUILD.template
    (":extra_cxx_compile_flags", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/user_compile_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/compiler_input_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/compiler_output_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/dependency_file", True),
    ("@score_bazel_cpp_toolchains//features/native/per_object_debug_info", True),
    ("@score_bazel_cpp_toolchains//features/native/includes", True),
    ("@score_bazel_cpp_toolchains//features/native/archiver_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/linker_param_file", True),
    ("@score_bazel_cpp_toolchains//features/native/library_search_directories", True),
    ("@score_bazel_cpp_toolchains//features/native/output_execpath_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/libraries_to_link", True),
    ("@score_bazel_cpp_toolchains//features/native/user_link_flags", True),
    (":extra_link_flags", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/linkstamps", True),
    ("@score_bazel_cpp_toolchains//features/native/force_pic_flags", True),
    ("@score_bazel_cpp_toolchains//features/native/strip_debug_symbols", True),
    ("@score_bazel_cpp_toolchains//features/native/fully_static_link", False),
    (":sysroot_link_flags", True),  # per-instance, see templates/BUILD.template
    ("@score_bazel_cpp_toolchains//features/native/use_pthread", True),
    ("@score_bazel_cpp_toolchains//features/native/markers:opt", False),
    ("@score_bazel_cpp_toolchains//features/native/markers:supports_pic", True),
    ("@score_bazel_cpp_toolchains//features/native/pic", True),
    ("@score_bazel_cpp_toolchains//features/native/markers:supports_header_path_normalization", True),
]

def get_feature_lists():
    """Returns ordered known/enabled feature labels for EBcLfSA High Integrity.

    Returns:
        (known_features, enabled_features) tuple of flat label lists.
    """
    return (
        [label for label, _enabled in _EBCLFSA_HI_FEATURES],
        [label for label, enabled in _EBCLFSA_HI_FEATURES if enabled],
    )
