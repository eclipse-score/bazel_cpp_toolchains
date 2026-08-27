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
#include "feature_test.h"

// Test for preprocessor_defines feature
int FeatureTester::add(int a, int b) {
    return a + b;
}

int FeatureTester::subtract(int a, int b) {
    return a - b;
}

int FeatureTester::multiply(int a, int b) {
    return a * b;
}

// Test for random_seed and deterministic builds
bool FeatureTester::isDeterministic() {
    #if FEATURE_TEST_ENABLED
    return true;
    #else
    return false;
    #endif
}

// Test for strict_warnings detection
bool FeatureTester::hasCorrectWarningLevel() {
    #ifdef __STRICT_WARNINGS__
    return true;
    #else
    return false;
    #endif
}

const char* FeatureTester::getCompileVersion() {
    return COMPILE_VERSION;
}
