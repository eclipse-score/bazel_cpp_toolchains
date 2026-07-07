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

// Part 2: Vector utilities

#include "multifile_lib.h"
#include <cmath>

double VectorUtils::dotProduct(double x1, double y1, double x2, double y2) {
    return x1 * x2 + y1 * y2;
}

double VectorUtils::magnitude(double x, double y) {
    return std::sqrt(x * x + y * y);
}

void VectorUtils::normalize(double& x, double& y) {
    double mag = magnitude(x, y);
    if (mag > 1e-9) {
        x /= mag;
        y /= mag;
    }
}
