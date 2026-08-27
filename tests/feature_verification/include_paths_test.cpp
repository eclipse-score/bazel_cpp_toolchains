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

// Test for: include_paths feature
// This test verifies that include directories (-I, -iquote, -isystem) are properly handled
// When this compiles successfully, it means include_paths feature is working

#include "feature_test.h"  // -iquote directory
#include <iostream>         // -isystem directory

// Custom nested include structure to test path handling
namespace include_path_test {
    class IncludePathTester {
    public:
        static void test() {
            std::cout << "Include path test: Successfully included feature_test.h" << std::endl;
            std::cout << "Include path test: Successfully included <iostream>" << std::endl;
        }
    };
}

int main() {
    std::cout << "Testing include_paths feature..." << std::endl;
    
    // If this compiles, it means include_paths is working correctly
    include_path_test::IncludePathTester::test();
    
    // Test accessing the included header
    FeatureTester tester;
    int result = FeatureTester::add(1, 1);
    std::cout << "Include path test: FeatureTester::add(1, 1) = " << result << std::endl;
    
    std::cout << "All include_paths tests passed!" << std::endl;
    return 0;
}
