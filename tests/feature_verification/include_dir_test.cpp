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

// Test for: include_paths feature (-I / -isystem via the `includes` attribute)
//
// The custom_math library exposes its header directory through the `includes`
// attribute. Bazel translates that into an include search path that is only
// passed to the compiler by the `include_paths` toolchain feature. Because the
// header is included below without its directory prefix, the compile only
// succeeds when that search path is emitted.

#include "custom_math.h"

#include <cassert>
#include <iostream>

int main() {
    std::cout << "Testing include_paths feature (includes attribute)..." << std::endl;

    assert(custom_math::triple(7) == 21);

    std::cout << "custom_math::triple(7) = " << custom_math::triple(7) << std::endl;
    std::cout << "All include_paths (includes attribute) tests passed!" << std::endl;
    return 0;
}
