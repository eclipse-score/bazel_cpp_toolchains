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

// Test for: C++17 language features
// This test verifies that C++17 features compile and run correctly

#include <iostream>
#include <cassert>
#include <optional>
#include <variant>
#include <string_view>

// Test 1: Structured bindings
struct Point {
    int x, y;
};

void test_structured_bindings() {
    Point p = {3, 4};
    auto [x, y] = p;
    assert(x == 3 && y == 4);
}

// Test 2: if constexpr
template<typename T>
auto describe_type() {
    if constexpr (std::is_integral_v<T>) {
        return "integral";
    } else if constexpr (std::is_floating_point_v<T>) {
        return "floating point";
    } else {
        return "other";
    }
}

void test_if_constexpr() {
    auto desc_int = describe_type<int>();
    assert(desc_int[0] == 'i');  // "integral"
}

// Test 3: std::optional
void test_optional() {
    std::optional<int> maybe_value = 42;
    assert(maybe_value.has_value());
    assert(maybe_value.value() == 42);
    
    std::optional<int> empty;
    assert(!empty.has_value());
}

// Test 4: std::variant
void test_variant() {
    std::variant<int, std::string> v = 42;
    assert(std::holds_alternative<int>(v));
    assert(std::get<int>(v) == 42);
    
    v = std::string("hello");
    assert(std::holds_alternative<std::string>(v));
}

// Test 5: std::string_view (non-owning string reference)
void test_string_view(std::string_view sv) {
    assert(sv.size() == 5);
    assert(sv[0] == 'h');
}

// Test 6: Fold expressions
template<typename... Args>
auto sum_all(Args... args) {
    return (... + args);  // Fold expression
}

void test_fold_expressions() {
    auto result = sum_all(1, 2, 3, 4, 5);
    assert(result == 15);
}

// Test 7: Inline variables
inline constexpr int GLOBAL_CONST = 100;

void test_inline_variable() {
    assert(GLOBAL_CONST == 100);
}

// Test 8: Nested namespaces with ::
namespace A::B::C {
    int nested_value = 42;
}

void test_nested_namespaces() {
    assert(A::B::C::nested_value == 42);
}

// Test 9: Structured binding in range-based for
void test_binding_in_for_loop() {
    Point points[] = {{0, 1}, {2, 3}, {4, 5}};
    int count = 0;
    for (auto [x, y] : points) {
        count++;
    }
    assert(count == 3);
}

int main() {
    std::cout << "Testing C++17 language features..." << std::endl;
    
    // Test structured bindings
    test_structured_bindings();
    std::cout << "structured bindings test passed" << std::endl;
    
    // Test if constexpr
    test_if_constexpr();
    std::cout << "if constexpr test passed" << std::endl;
    
    // Test optional
    test_optional();
    std::cout << "optional test passed" << std::endl;
    
    // Test variant
    test_variant();
    std::cout << "variant test passed" << std::endl;
    
    // Test string_view
    test_string_view("hello");
    std::cout << "string_view test passed" << std::endl;
    
    // Test fold expressions
    test_fold_expressions();
    std::cout << "fold expressions test passed" << std::endl;
    
    // Test inline variables
    test_inline_variable();
    std::cout << "inline variables test passed" << std::endl;
    
    // Test nested namespaces
    test_nested_namespaces();
    std::cout << "nested namespaces test passed" << std::endl;
    
    // Test structured binding in for loop
    test_binding_in_for_loop();
    std::cout << "structured binding in for loop test passed" << std::endl;
    
    std::cout << "All C++17 tests passed!" << std::endl;
    return 0;
}
