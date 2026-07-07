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

// Test for: C language support
// This test verifies that pure C code compiles and runs correctly

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Test struct packing with pragma pack
#pragma pack(push, 1)
struct PackedData {
    uint8_t a;
    uint16_t b;
    uint8_t c;
};
#pragma pack(pop)

// Test named initializers (C99 designated initializers)
struct Config {
    int mode;
    const char* name;
    int timeout;
};

// Test compound literals (C99 feature)
int sum_array(const int* arr, int len) {
    int total = 0;
    for (int i = 0; i < len; ++i) {
        total += arr[i];
    }
    return total;
}

// Test C linkage and extern
extern int c_language_feature_count;
int c_language_feature_count = 5;  // Pragmas, designated init, compounds, etc.

int main() {
    printf("Testing C language support...\n");
    
    // Test 1: Struct packing
    struct PackedData data = {.a = 1, .b = 256, .c = 3};
    assert(data.a == 1);
    assert(data.b == 256);
    assert(data.c == 3);
    assert(sizeof(struct PackedData) == 4);  // Packed: 1 + 2 + 1 = 4 bytes
    printf("Struct packing test passed (size=%zu)\n", sizeof(struct PackedData));
    
    // Test 2: Designated initializers
    struct Config cfg = {
        .mode = 1,
        .name = "test",
        .timeout = 30
    };
    assert(cfg.mode == 1);
    assert(strcmp(cfg.name, "test") == 0);
    assert(cfg.timeout == 30);
    printf("Designated initializers test passed\n");
    
    // Test 3: Compound literals
    int sum = sum_array((int[]){1, 2, 3, 4, 5}, 5);
    assert(sum == 15);
    printf("Compound literals test passed (sum=%d)\n", sum);
    
    // Test 4: Variable declarations in loops (C99)
    int loop_sum = 0;
    for (int i = 0; i < 5; ++i) {
        loop_sum += i;
    }
    assert(loop_sum == 10);
    printf("C99 loop variable declaration test passed (sum=%d)\n", loop_sum);
    
    // Test 5: Restrict keyword
    int arr1[] = {1, 2, 3};
    int arr2[] = {4, 5, 6};
    int* restrict p1 = arr1;
    int* restrict p2 = arr2;
    assert(p1[0] == 1);
    assert(p2[0] == 4);
    printf("Restrict keyword test passed\n");
    
    printf("All C language support tests passed! (Features: %d)\n", c_language_feature_count);
    return 0;
}
