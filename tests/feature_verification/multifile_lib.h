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

#ifndef MULTIFILE_LIB_H
#define MULTIFILE_LIB_H

#include <array>

// Test for archiver_flags: Multiple object files combined with 'ar'

struct Matrix2x2 {
    std::array<std::array<double, 2>, 2> data;
    
    static Matrix2x2 identity();
    static Matrix2x2 zeros();
    
    Matrix2x2 operator+(const Matrix2x2& other) const;
    Matrix2x2 operator*(const Matrix2x2& other) const;
    double determinant() const;
};

class VectorUtils {
public:
    static double dotProduct(double x1, double y1, double x2, double y2);
    static double magnitude(double x, double y);
    static void normalize(double& x, double& y);
};

class Geometry {
public:
    static bool arePointsEqual(double x1, double y1, double x2, double y2, double epsilon = 1e-9);
    static double distanceSquared(double x1, double y1, double x2, double y2);
};

#endif // MULTIFILE_LIB_H
