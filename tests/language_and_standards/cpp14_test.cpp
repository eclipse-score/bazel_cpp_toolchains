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

// Test for: C++14 language features
// This test verifies that C++14 features compile and run correctly

#include <iostream>
#include <cassert>
#include <memory>
#include <vector>

// Test 1: Auto return type deduction
auto get_number() {
    return 42;
}

auto get_string() {
    return "hello";
}

// Test 2: Generic lambdas with auto parameters
void test_generic_lambda() {
    auto generic = [](auto x, auto y) { return x + y; };
    assert(generic(5, 3) == 8);
    assert(generic(2.5, 1.5) == 4.0);
}

// Test 3: std::make_unique (C++14 enhancement)
void test_make_unique() {
    auto up = std::make_unique<int>(42);
    assert(*up == 42);
}

// Test 4: Variable templates
template<typename T>
constexpr auto PI = T(3.141592653589793);

void test_variable_templates() {
    double pi_double = PI<double>;
    assert(pi_double > 3.14 && pi_double < 3.15);
}

// Test 5: Binary literals
void test_binary_literals() {
    int binary_val = 0b1010;  // Binary literal: 10 in decimal
    assert(binary_val == 10);
}

// Test 6: Digit separator
void test_digit_separator() {
    int large_num = 1'000'000;
    assert(large_num == 1000000);
}

// Test 7: Constexpr enhancements (relaxed constexpr)
constexpr int constexpr_function(int x) {
    int result = 0;
    for (int i = 0; i < x; ++i) {
        result += i;
    }
    return result;
}

void test_constexpr() {
    constexpr int sum = constexpr_function(5);
    assert(sum == 10);  // 0 + 1 + 2 + 3 + 4 = 10
}

// Test 8: Tuple support with std::get
void test_tuple_features() {
    auto tup = std::make_tuple(1, 2.5, "test");
    assert(std::get<0>(tup) == 1);
    assert(std::get<1>(tup) == 2.5);
}

int main() {
    std::cout << "Testing C++14 language features..." << std::endl;
    
    // Test auto return type
    auto num = get_number();
    assert(num == 42);
    std::cout << "auto return type test passed" << std::endl;
    
    auto str = get_string();
    assert(str[0] == 'h');
    std::cout << "auto return type (string) test passed" << std::endl;
    
    // Test generic lambdas
    test_generic_lambda();
    std::cout << "generic lambdas test passed" << std::endl;
    
    // Test make_unique
    test_make_unique();
    std::cout << "make_unique test passed" << std::endl;
    
    // Test variable templates
    test_variable_templates();
    std::cout << "variable templates test passed" << std::endl;
    
    // Test binary literals
    test_binary_literals();
    std::cout << "binary literals test passed" << std::endl;
    
    // Test digit separator
    test_digit_separator();
    std::cout << "digit separator test passed" << std::endl;
    
    // Test constexpr enhancements
    test_constexpr();
    std::cout << "constexpr enhancements test passed" << std::endl;
    
    // Test tuple support
    test_tuple_features();
    std::cout << "tuple features test passed" << std::endl;
    
    std::cout << "All C++14 tests passed!" << std::endl;
    return 0;
}
