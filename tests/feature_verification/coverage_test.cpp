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

// Test for: coverage, gcc_coverage_map_format, dependency_file
// This test verifies that coverage instrumentation is properly applied
// and dependency tracking works correctly

#include "feature_test.h"
#include <iostream>

// Function with multiple paths - some covered, some not
int conditional_function(int x) {
    if (x > 0) {
        return x * 2;  // This path is covered by the test
    } else if (x < 0) {
        return -x;  // This path is NOT covered
    } else {
        return 0;  // Edge case - may or may not be covered
    }
}

// Function with loops for coverage tracking
int loop_function(int iterations) {
    int sum = 0;
    for (int i = 0; i < iterations; ++i) {
        sum += i;
    }
    return sum;
}

int main() {
    std::cout << "Testing coverage instrumentation features..." << std::endl;
    
    // Exercise the covered path
    int result1 = conditional_function(5);
    std::cout << "conditional_function(5) = " << result1 << std::endl;
    
    // Exercise the loop function
    int sum = loop_function(10);
    std::cout << "loop_function(10) = " << sum << std::endl;
    
    // Test feature tester
    int add_result = FeatureTester::add(3, 4);
    std::cout << "FeatureTester::add(3, 4) = " << add_result << std::endl;
    
    std::cout << "Coverage test completed!" << std::endl;
    std::cout << "Note: Code coverage can be analyzed with: bazel coverage //:coverage_test --combined_report=lcov" << std::endl;
    
    return 0;
}
