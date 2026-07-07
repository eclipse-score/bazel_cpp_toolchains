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

// Test for: supports_pic feature
// This test verifies that position-independent code compilation works
// When this test passes, it means -fPIC was applied correctly

#include "pic_test_lib.h"
#include <iostream>
#include <cassert>

int main() {
    std::cout << "Testing supports_pic (Position-Independent Code) feature..." << std::endl;
    
    // Test call counting (static local variables in PIC)
    assert(get_call_count() == 1);
    assert(get_call_count() == 2);
    assert(get_call_count() == 3);
    std::cout << "Static variable test passed" << std::endl;
    
    // Test position-safe computation
    assert(compute_position_safe(5) == 11);
    assert(compute_position_safe(10) == 21);
    std::cout << "Position-safe computation test passed" << std::endl;
    
    // Test C linkage function
    assert(pic_c_function(5) == 6);
    std::cout << "C linkage test passed" << std::endl;
    
    // Test polymorphism in PIC
    DerivedPICClass obj;
    assert(obj.getValue() == 84);
    std::cout << "Polymorphism test passed" << std::endl;
    
    // Test global state
    increment_global();
    std::cout << "Global state test passed" << std::endl;
    
    std::cout << "All supports_pic tests passed!" << std::endl;
    return 0;
}
