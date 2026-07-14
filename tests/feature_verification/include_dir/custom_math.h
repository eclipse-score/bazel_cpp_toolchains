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
#ifndef INCLUDE_DIR_CUSTOM_MATH_H
#define INCLUDE_DIR_CUSTOM_MATH_H

// This header lives in an `includes`-exposed directory. Consumers include it as
// "custom_math.h" (without the directory prefix), which only resolves when the
// include_paths feature emits the -I/-isystem search path for that directory.
namespace custom_math {

inline int triple(int value) {
    return value * 3;
}

}  // namespace custom_math

#endif  // INCLUDE_DIR_CUSTOM_MATH_H
