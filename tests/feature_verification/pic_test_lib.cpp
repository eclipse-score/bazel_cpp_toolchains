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

// Test for: supports_pic feature (Position-Independent Code)
// This library is compiled with -fPIC for use in shared libraries
// When compiled with -fPIC, all memory references are relative

#include "pic_test_lib.h"

// Global variable to test position-independent addressing
static int global_counter = 0;

// Function using global state
void increment_global() {
    global_counter++;
}

// Function using static local variable
int get_call_count() {
    static int call_count = 0;
    return ++call_count;
}

// Function using position-independent code patterns
int compute_position_safe(int value) {
    // This computation should work correctly whether the code is
    // position-independent or not
    return value * 2 + 1;
}

// Implementation of DerivedPICClass::getValue()
int DerivedPICClass::getValue() {
    return 84;
}

// C linkage function for testing PIC with C calling conventions
extern "C" {
    int pic_c_function(int x) {
        return x + 1;
    }
}
