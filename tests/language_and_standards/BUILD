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

"""Language Support and C++ Standard Version Tests

These tests verify that the toolchain correctly supports:
- C language features (C99 and later)
- C++11, C++14, C++17, and C++20 language features
- Correct compilation flags for each standard version

All tests can execute on the host machine (Linux x86_64).
"""

load("@rules_cc//cc:defs.bzl", "cc_test")

# ============================================================================
# Language Support Tests
# ============================================================================

# Test for: C language support (C99 and later features)
# Verifies: struct packing, designated initializers, compound literals,
#           loop variable declarations, restrict keyword
cc_test(
    name = "c_lang_test",
    srcs = ["c_lang_test.c"],
)

# ============================================================================
# C++ Standard Version Tests
# ============================================================================

# Test for: C++11 language features
# Verifies: auto, nullptr, range-based for, lambdas, smart pointers,
#           move semantics, variadic templates, rvalue references
cc_test(
    name = "cpp11_test",
    srcs = ["cpp11_test.cpp"],
    copts = ["-std=c++11"],
)

# Test for: C++14 language features
# Verifies: auto return type deduction, generic lambdas, make_unique,
#           variable templates, binary literals, digit separator,
#           constexpr enhancements, tuple support
cc_test(
    name = "cpp14_test",
    srcs = ["cpp14_test.cpp"],
    copts = ["-std=c++14"],
)

# Test for: C++17 language features
# Verifies: structured bindings, if constexpr, optional, variant,
#           string_view, fold expressions, inline variables,
#           nested namespaces
cc_test(
    name = "cpp17_test",
    srcs = ["cpp17_test.cpp"],
    copts = ["-std=c++17"],
)

# Test for: C++20 language features
# Verifies: concepts, span, designated initializers, spaceship operator,
#           ranges and views, default member initializers, requires clause,
#           consteval
cc_test(
    name = "cpp20_test",
    srcs = ["cpp20_test.cpp"],
    copts = ["-std=c++20"],
)
