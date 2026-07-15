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

// Test for: random_seed feature (-frandom-seed=<output_file>)
//
// The random_seed feature makes builds reproducible by deriving GCC's internal
// random seed from the output file path. That seed is used when generating the
// mangled names of internal-linkage symbols (anonymous namespaces, local
// statics, lambdas). Its effect is a build-reproducibility property and is not
// directly observable at runtime within a single binary, so this is a
// build-and-run smoke test: it exercises exactly the kind of symbols the seed
// governs and confirms the toolchain compiles, links, and runs them correctly.

#include <cassert>
#include <iostream>

namespace {

int hidden_counter() {
    static int value = 0;
    return ++value;
}

struct HiddenHelper {
    int scale(int x) const { return x * 2; }
};

}  // namespace

int main() {
    std::cout << "Testing random_seed feature (build reproducibility)..." << std::endl;

    assert(hidden_counter() == 1);
    assert(hidden_counter() == 2);

    HiddenHelper helper;
    auto doubler = [&helper](int x) { return helper.scale(x); };
    assert(doubler(21) == 42);

    std::cout << "All random_seed tests passed!" << std::endl;
    return 0;
}
