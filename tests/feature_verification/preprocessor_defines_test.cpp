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

// Test for: preprocessor_defines feature
//
// Unlike defines_test (which passes -D via copts and therefore exercises the
// user_compile_flags feature), this test relies on the `local_defines` target
// attribute. Bazel forwards those values to the compiler exclusively through
// the `preprocessor_defines` toolchain feature. If that feature is not applied,
// the -D flags are never emitted and the #error directives below fail the build.

#ifndef PP_DEFINES_FEATURE_ENABLED
#error "preprocessor_defines feature not applied: PP_DEFINES_FEATURE_ENABLED is undefined"
#endif

#ifndef PP_DEFINES_ANSWER
#error "preprocessor_defines feature not applied: PP_DEFINES_ANSWER is undefined"
#endif

#include <cassert>
#include <cstring>
#include <iostream>

int main() {
    std::cout << "Testing preprocessor_defines feature..." << std::endl;

    // Values injected through the `local_defines` attribute.
    assert(PP_DEFINES_FEATURE_ENABLED == 1);
    assert(PP_DEFINES_ANSWER == 42);
    assert(std::strcmp(PP_DEFINES_LABEL, "from_local_defines") == 0);

    std::cout << "PP_DEFINES_ANSWER = " << PP_DEFINES_ANSWER << std::endl;
    std::cout << "PP_DEFINES_LABEL  = " << PP_DEFINES_LABEL << std::endl;
    std::cout << "All preprocessor_defines tests passed!" << std::endl;
    return 0;
}
