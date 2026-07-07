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

"""Toolchain Verification Tests

Root test suite definition combining all test categories.
"""

# ============================================================================
# Test Suite for Language Support and C++ Standard Version Tests
# ============================================================================

test_suite(
    name = "language_and_standards_tests",
    tests = [
        "//language_and_standards:c_lang_test",
        "//language_and_standards:cpp11_test",
        "//language_and_standards:cpp14_test",
        "//language_and_standards:cpp17_test",
        "//language_and_standards:cpp20_test",
    ],
)

# ============================================================================
# Test Suite for Feature Verification Tests
# ============================================================================

test_suite(
    name = "feature_verification_tests",
    tests = [
        "//feature_verification:coverage_test",
        "//feature_verification:defines_test",
        "//feature_verification:include_paths_test",
        "//feature_verification:multifile_test",
        "//feature_verification:pic_test",
        "//feature_verification:pthread_test",
        "//feature_verification:whole_archive_test",
    ],
)
