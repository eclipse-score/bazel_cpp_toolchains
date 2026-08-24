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

// Test for: warning feature override via user flags (copts)
// 
// This test verifies that the ordering between warning features and user flags
// is correct. Specifically, it tests that:
//
// 1. strict_warnings (implies minimal_warnings which enables -Wall) and 
//    warnings_as_errors are both enabled, making -Wshadow an error
// 2. Code with variable shadowing would trigger an error
// 3. User provides -Wno-shadow via copts (which becomes user_compile_flags)
// 4. The compilation SUCCEEDS because user_compile_flags comes AFTER warning
//    features in the features list, making user flags take precedence
//
// If the flag ordering regresses (e.g., warning features come after user flags),
// this test will fail to compile with a -Wshadow error, catching the regression
// immediately.

#include <iostream>

// This function intentionally has variable shadowing, which triggers -Wshadow
// when strict_warnings or all_wall_warnings are enabled. The test provides
// -Wno-shadow via copts, so this should compile successfully if flag ordering
// is correct.
int shadow_function(int value) {
    int result = value * 2;  // Outer result
    int final_result = result;  // Use outer result to avoid -Wunused-variable
    {
        // Intentional shadowing to trigger -Wshadow
        int result = value * 3;  // Inner result shadows outer
        final_result += result;  // Use inner result
    }
    return final_result;
}

int main() {
    std::cout << "Warning override test: shadow_function(5) = " 
              << shadow_function(5) << std::endl;
    
    std::cout << "Test passed! User -Wno-shadow flag successfully overrode "
              << "the strict_warnings feature." << std::endl;
    
    return 0;
}
