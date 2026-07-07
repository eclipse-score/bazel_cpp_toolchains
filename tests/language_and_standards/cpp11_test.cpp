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

// Test for: C++11 language features
// This test verifies that C++11 features compile and run correctly

#include <iostream>
#include <memory>
#include <cassert>
#include <vector>

// Test 1: auto keyword
int get_value() { return 42; }

// Test 2: nullptr
void* test_nullptr(void* ptr) { return ptr; }

// Test 3: Range-based for loop
void test_range_based_for() {
    std::vector<int> v = {1, 2, 3, 4, 5};
    int sum = 0;
    for (int x : v) {
        sum += x;
    }
    assert(sum == 15);
}

// Test 4: Lambda expressions
int test_lambda() {
    auto add = [](int a, int b) { return a + b; };
    return add(5, 3);
}

// Test 5: unique_ptr and shared_ptr
void test_smart_pointers() {
    std::unique_ptr<int> up(new int(42));
    assert(*up == 42);
    
    std::shared_ptr<int> sp(new int(100));
    assert(*sp == 100);
}

// Test 6: Move semantics
class MoveTest {
public:
    int* data;
    MoveTest() : data(new int(0)) {}
    MoveTest(int val) : data(new int(val)) {}
    MoveTest(MoveTest&& other) noexcept : data(other.data) {
        other.data = nullptr;
    }
    ~MoveTest() { delete data; }
};

// Test 7: Variadic templates
template<typename... Args>
int count_args(Args...) {
    return sizeof...(Args);
}

// Test 8: Rvalue references
int process_rvalue(int&& val) {
    return val * 2;
}

int main() {
    std::cout << "Testing C++11 language features..." << std::endl;
    
    // Test auto keyword
    auto val = get_value();
    assert(val == 42);
    std::cout << "auto keyword test passed" << std::endl;
    
    // Test nullptr
    void* ptr = test_nullptr(nullptr);
    assert(ptr == nullptr);
    std::cout << "nullptr test passed" << std::endl;
    
    // Test range-based for
    test_range_based_for();
    std::cout << "range-based for test passed" << std::endl;
    
    // Test lambda
    int result = test_lambda();
    assert(result == 8);
    std::cout << "lambda test passed" << std::endl;
    
    // Test smart pointers
    test_smart_pointers();
    std::cout << "smart pointers test passed" << std::endl;
    
    // Test move semantics
    MoveTest mt1(50);
    MoveTest mt2(std::move(mt1));
    assert(*mt2.data == 50);
    assert(mt1.data == nullptr);
    std::cout << "move semantics test passed" << std::endl;
    
    // Test variadic templates
    int arg_count = count_args(1, 2, 3, 4, 5);
    assert(arg_count == 5);
    std::cout << "variadic templates test passed" << std::endl;
    
    // Test rvalue references
    int rval_result = process_rvalue(10);
    assert(rval_result == 20);
    std::cout << "rvalue references test passed" << std::endl;
    
    std::cout << "All C++11 tests passed!" << std::endl;
    return 0;
}
