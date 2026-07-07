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

// Part 3: Geometry utilities

#include "multifile_lib.h"
#include <cmath>

bool Geometry::arePointsEqual(double x1, double y1, double x2, double y2, double epsilon) {
    double dx = x1 - x2;
    double dy = y1 - y2;
    return (dx * dx + dy * dy) < (epsilon * epsilon);
}

double Geometry::distanceSquared(double x1, double y1, double x2, double y2) {
    double dx = x1 - x2;
    double dy = y1 - y2;
    return dx * dx + dy * dy;
}
