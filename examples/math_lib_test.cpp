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

#include "math_lib.h"
#include <cassert>

int main() {
    assert(add(2, 3) == 5);
    assert(sub(5, 3) == 2);

    // Note: sub(3, 5) is NOT tested → coverage will show a missed branch
    return 0;
}