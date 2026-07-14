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

// Test for: fully_static_link feature (-static)
//
// The fully_static_link feature emits "-static" on the link, producing an
// executable with no dynamic library dependencies. This test confirms the
// binary is genuinely statically linked by scanning its own memory map
// (/proc/self/maps): a fully static binary maps no shared objects, so no
// mapped file path ends in ".so" (or contains ".so.").

#include <cassert>
#include <fstream>
#include <iostream>
#include <string>

namespace {

// Returns true if the running process has any shared object (.so) mapped,
// which would indicate the binary was NOT fully statically linked.
bool has_shared_object_mappings() {
    std::ifstream maps("/proc/self/maps");
    assert(maps.is_open() && "could not open /proc/self/maps");

    std::string line;
    while (std::getline(maps, line)) {
        if (line.find(".so") != std::string::npos) {
            return true;
        }
    }
    return false;
}

}  // namespace

int main() {
    std::cout << "Testing fully_static_link feature (-static)..." << std::endl;

    assert(!has_shared_object_mappings() &&
           "expected a fully static binary (no .so mappings)");

    std::cout << "fully_static_link test passed: no shared objects mapped"
              << std::endl;
    return 0;
}
