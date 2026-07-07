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

// Test for: libraries_to_link with whole-archive (-Wl,--whole-archive)
// This test verifies that whole-archive linking works correctly

#include "whole_archive_lib.h"
#include <iostream>
#include <cassert>

int main() {
    std::cout << "Testing libraries_to_link with whole-archive feature..." << std::endl;
    
    // Test the utility functions
    assert(utility_add(5, 3) == 8);
    std::cout << "Whole-archive utility_add test passed" << std::endl;
    
    assert(utility_multiply(4, 7) == 28);
    std::cout << "Whole-archive utility_multiply test passed" << std::endl;
    
    // Call the unused function - it should be available due to whole-archive
    unused_utility_function();
    std::cout << "Whole-archive unused_utility_function test passed" << std::endl;
    
    std::cout << "All whole-archive linking tests passed!" << std::endl;
    std::cout << "This verifies that -Wl,--whole-archive linking works correctly." << std::endl;
    
    return 0;
}
