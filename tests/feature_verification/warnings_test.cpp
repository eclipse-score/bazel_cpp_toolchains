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

// Test for: strict_warnings, minimal_warnings, warnings_as_errors
// This test verifies that warning levels are properly configured
// Note: This test is designed to compile WITHOUT warnings when 
// strict_warnings or warnings_as_errors are disabled.

#include <iostream>
#include <cstdint>

// Function to test variable shadowing (would trigger -Wshadow when strict_warnings is enabled)
int shadow_test(int value) {
    int result = value * 2;
    {
        // This variable shadows the outer 'result' - would be caught by -Wshadow
        int result = value * 3;
        return result;
    }
}

// Function to test implicit conversions (would trigger -Wconversion when strict_warnings is enabled)
void conversion_test() {
    double large_value = 3.14159;
    int small_value = static_cast<int>(large_value);  // Explicit cast avoids warning
    
    uint8_t byte_val = static_cast<uint8_t>(256);  // Explicit cast
    
    std::cout << "Conversion test: " << small_value << " " << byte_val << std::endl;
}

// Function to test sign conversion
void sign_conversion_test() {
    int positive = 42;
    unsigned int unsigned_val = static_cast<unsigned int>(positive);
    
    std::cout << "Sign conversion test: " << unsigned_val << std::endl;
}

int main() {
    std::cout << "Testing warning level features..." << std::endl;
    
    std::cout << "Shadow test result: " << shadow_test(5) << std::endl;
    conversion_test();
    sign_conversion_test();
    
    std::cout << "All warning level tests completed!" << std::endl;
    return 0;
}
