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

// Test for: archiver_flags feature with multiple object files
// Part 1: Matrix operations

#include "multifile_lib.h"

Matrix2x2 Matrix2x2::identity() {
    Matrix2x2 result;
    result.data = {{{1.0, 0.0}, {0.0, 1.0}}};
    return result;
}

Matrix2x2 Matrix2x2::zeros() {
    Matrix2x2 result;
    result.data = {{{0.0, 0.0}, {0.0, 0.0}}};
    return result;
}

Matrix2x2 Matrix2x2::operator+(const Matrix2x2& other) const {
    Matrix2x2 result;
    for (int i = 0; i < 2; ++i) {
        for (int j = 0; j < 2; ++j) {
            result.data[i][j] = data[i][j] + other.data[i][j];
        }
    }
    return result;
}

Matrix2x2 Matrix2x2::operator*(const Matrix2x2& other) const {
    Matrix2x2 result = zeros();
    for (int i = 0; i < 2; ++i) {
        for (int j = 0; j < 2; ++j) {
            for (int k = 0; k < 2; ++k) {
                result.data[i][j] += data[i][k] * other.data[k][j];
            }
        }
    }
    return result;
}

double Matrix2x2::determinant() const {
    return data[0][0] * data[1][1] - data[0][1] * data[1][0];
}
