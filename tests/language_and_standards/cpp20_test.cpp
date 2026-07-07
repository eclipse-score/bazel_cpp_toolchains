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

// Test for: C++20 language features
// This test verifies that C++20 features compile and run correctly

#include <iostream>
#include <cassert>
#include <span>
#include <concepts>
#include <ranges>
#include <vector>

// Test 1: Concepts (simplified - basic constraint checking)
template<typename T>
concept Arithmetic = std::is_integral_v<T> || std::is_floating_point_v<T>;

template<Arithmetic T>
T add_concept(T a, T b) {
    return a + b;
}

void test_concepts() {
    int result_int = add_concept(5, 3);
    assert(result_int == 8);
    
    double result_double = add_concept(2.5, 1.5);
    assert(result_double == 4.0);
}

// Test 2: std::span (non-owning view over array)
int sum_span(std::span<int> values) {
    int sum = 0;
    for (int v : values) {
        sum += v;
    }
    return sum;
}

void test_span() {
    int arr[] = {1, 2, 3, 4, 5};
    int result = sum_span(arr);
    assert(result == 15);
    
    std::vector<int> vec = {10, 20, 30};
    result = sum_span(vec);
    assert(result == 60);
}

// Test 3: Designated initializers (C++20 enhancement)
struct Config {
    int timeout;
    int retries;
    bool verbose;
};

void test_designated_init() {
    Config cfg{.timeout = 30, .retries = 3};
    assert(cfg.timeout == 30);
    assert(cfg.retries == 3);
    assert(cfg.verbose == false);
}

// Test 4: Spaceship operator (<=>)
struct Version {
    int major, minor, patch;
    
    bool operator==(const Version& other) const = default;
    auto operator<=>(const Version& other) const = default;
};

void test_spaceship_operator() {
    Version v1{1, 0, 0};
    Version v2{1, 0, 1};
    Version v3{1, 0, 0};
    
    assert(v1 < v2);
    assert(v1 <= v2);
    assert(v2 > v1);
    assert(v1 == v3);
    assert(v1 != v2);
}

// Test 5: Ranges and views
void test_ranges() {
    std::vector<int> vec = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    // Count elements greater than 5
    int count = 0;
    for (auto x : vec | std::views::filter([](int v) { return v > 5; })) {
        count++;
    }
    assert(count == 5);
}

// Test 6: Default member initializer with NTTP (Non-Type Template Parameter)
struct DefaultInit {
    int value = 42;
};

void test_default_member_init() {
    DefaultInit di;
    assert(di.value == 42);
}

// Test 7: requires clauses (alternative to concepts)
template<typename T>
    requires std::is_integral_v<T>
int double_value(T x) {
    return x * 2;
}

void test_requires_clause() {
    int result = double_value(21);
    assert(result == 42);
}

// Test 8: Consteval and constexpr enhancements
consteval int compile_time_sum(int a, int b) {
    return a + b;
}

void test_consteval() {
    constexpr int result = compile_time_sum(10, 32);
    assert(result == 42);
}

// Test 9: Three-way comparison with std::weak_ordering
void test_comparison_categories() {
    int a = 5, b = 10;
    auto cmp = (a <=> b);
    assert(cmp < 0);  // a < b
}

int main() {
    std::cout << "Testing C++20 language features..." << std::endl;
    
    try {
        // Test concepts
        test_concepts();
        std::cout << "concepts test passed" << std::endl;
        
        // Test span
        test_span();
        std::cout << "std::span test passed" << std::endl;
        
        // Test designated initializers
        test_designated_init();
        std::cout << "designated initializers test passed" << std::endl;
        
        // Test spaceship operator
        test_spaceship_operator();
        std::cout << "spaceship operator test passed" << std::endl;
        
        // Test ranges and views
        test_ranges();
        std::cout << "ranges and views test passed" << std::endl;
        
        // Test default member initializers
        test_default_member_init();
        std::cout << "default member initializers test passed" << std::endl;
        
        // Test requires clause
        test_requires_clause();
        std::cout << "requires clause test passed" << std::endl;
        
        // Test consteval
        test_consteval();
        std::cout << "consteval test passed" << std::endl;
        
        // Test comparison categories
        test_comparison_categories();
        std::cout << "comparison categories test passed" << std::endl;
        
        std::cout << "All C++20 tests passed!" << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
