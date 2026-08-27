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

// Test for: user_link_flags feature
//
// The target passes a linker flag through the `linkopts` attribute:
//     -Wl,--defsym=user_link_flags_marker=0x1234
// Bazel forwards `linkopts` to the linker exclusively via the `user_link_flags`
// toolchain feature. The linker's --defsym option defines the absolute symbol
// `user_link_flags_marker` at address 0x1234. If the user_link_flags feature is
// not applied, the flag is dropped, the symbol stays undefined, and linking
// fails. When the feature works, the symbol's address equals the injected value.

#include <cassert>
#include <cstdint>
#include <iostream>

extern "C" {
extern char user_link_flags_marker;
}

int main() {
    std::cout << "Testing user_link_flags feature..." << std::endl;

    auto marker_address = reinterpret_cast<std::uintptr_t>(&user_link_flags_marker);

    // The linker's --defsym places the absolute symbol at 0x1234. In a non-PIE
    // executable that is its exact runtime address. Position-independent
    // executables (the QNX default) are loaded at a page-aligned base, so only
    // the in-page offset of the symbol is guaranteed to survive; assert on that
    // portion, which still proves the injected --defsym value propagated.
#if defined(__QNXNTO__)
    assert((marker_address & 0xFFF) == (0x1234 & 0xFFF));
#else
    assert(marker_address == 0x1234);
#endif

    std::cout << "user_link_flags_marker address = 0x" << std::hex << marker_address
              << std::dec << std::endl;
    std::cout << "All user_link_flags tests passed!" << std::endl;
    return 0;
}
