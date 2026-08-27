/********************************************************************************
 * Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Apache License Version 2.0 which is available at
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 ********************************************************************************/
#ifndef FEATURE_TEST_H
#define FEATURE_TEST_H

// Test for preprocessor_defines feature
// These will be defined via Bazel cc_* rules with copts = ["-DFEATURE_TEST_ENABLED=1", ...]
#ifndef FEATURE_TEST_ENABLED
#define FEATURE_TEST_ENABLED 0
#endif

#ifndef BUILD_VARIANT
#define BUILD_VARIANT "unknown"
#endif

#ifndef COMPILE_VERSION
#define COMPILE_VERSION "unknown"
#endif

// Test for include_paths feature
// This header tests -I, -iquote, and -isystem directives

class FeatureTester {
public:
    static int add(int a, int b);
    static int subtract(int a, int b);
    static int multiply(int a, int b);
    static bool isDeterministic();
    static bool hasCorrectWarningLevel();
    static const char* getCompileVersion();
};

#endif // FEATURE_TEST_H
