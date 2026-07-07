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

// Test for: preprocessor_defines, user_compile_flags, compiler_input_flags
// This test verifies that preprocessor defines are properly handled

#include "feature_test.h"
#include <cassert>
#include <iostream>

int main() {
    // Test preprocessor_defines feature
    // The FEATURE_TEST_ENABLED define is set via copts
    std::cout << "Testing preprocessor_defines feature..." << std::endl;
    
    // Test basic arithmetic operations
    assert(FeatureTester::add(2, 3) == 5);
    assert(FeatureTester::subtract(5, 3) == 2);
    assert(FeatureTester::multiply(4, 5) == 20);
    
    // Test that feature is properly defined
    std::cout << "Feature test enabled: " << (FEATURE_TEST_ENABLED ? "yes" : "no") << std::endl;
    std::cout << "Build variant: " << BUILD_VARIANT << std::endl;
    
    std::cout << "All preprocessor_defines tests passed!" << std::endl;
    return 0;
}
