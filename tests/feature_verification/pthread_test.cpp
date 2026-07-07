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

// Test for: pthread feature
// This test verifies that POSIX threading is properly linked and functional

#include "pthread_test_lib.h"
#include <iostream>
#include <cassert>

int main() {
    std::cout << "Testing pthread feature..." << std::endl;
    
    // Reset state before test
    reset_thread_state();
    
    // Test thread creation and joining
    int sum = get_sum_from_threads();
    assert(sum == 10);  // 1 + 2 + 3 + 4
    std::cout << "Thread summation test passed (sum = " << sum << ")" << std::endl;
    
    // Verify thread count
    int count = get_thread_count();
    assert(count == 4);
    std::cout << "Thread count test passed (count = " << count << ")" << std::endl;
    
    // Test second run with reset
    reset_thread_state();
    sum = get_sum_from_threads();
    assert(sum == 10);
    std::cout << "Reset and re-run test passed" << std::endl;
    
    std::cout << "All pthread tests passed!" << std::endl;
    return 0;
}
