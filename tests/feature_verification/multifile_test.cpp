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

// Test for: archiver_flags, libraries_to_link
// This test exercises a static library built from multiple object files

#include "multifile_lib.h"
#include <iostream>
#include <cassert>
#include <cmath>

int main() {
    std::cout << "Testing archiver_flags and libraries_to_link features..." << std::endl;
    
    // Test matrix operations
    auto identity = Matrix2x2::identity();
    assert(identity.determinant() == 1.0);
    std::cout << "Matrix identity test passed" << std::endl;
    
    auto zeros = Matrix2x2::zeros();
    assert(zeros.determinant() == 0.0);
    std::cout << "Matrix zeros test passed" << std::endl;
    
    // Test matrix multiplication
    auto result = identity * identity;
    assert(result.determinant() == 1.0);
    std::cout << "Matrix multiplication test passed" << std::endl;
    
    // Test vector operations
    double x = 3.0, y = 4.0;
    double mag = VectorUtils::magnitude(x, y);
    assert(std::abs(mag - 5.0) < 1e-9);
    std::cout << "Vector magnitude test passed" << std::endl;
    
    double dot = VectorUtils::dotProduct(3.0, 4.0, 1.0, 0.0);
    assert(dot == 3.0);
    std::cout << "Vector dot product test passed" << std::endl;
    
    // Test vector normalization
    VectorUtils::normalize(x, y);
    mag = VectorUtils::magnitude(x, y);
    assert(std::abs(mag - 1.0) < 1e-9);
    std::cout << "Vector normalization test passed" << std::endl;
    
    // Test geometry
    bool equal = Geometry::arePointsEqual(1.0, 2.0, 1.0, 2.0);
    assert(equal);
    std::cout << "Geometry equality test passed" << std::endl;
    
    double dist_sq = Geometry::distanceSquared(0.0, 0.0, 3.0, 4.0);
    assert(dist_sq == 25.0);
    std::cout << "Geometry distance test passed" << std::endl;
    
    std::cout << "All archiver_flags and libraries_to_link tests passed!" << std::endl;
    std::cout << "This verifies that multiple object files were correctly archived and linked." << std::endl;
    
    return 0;
}
