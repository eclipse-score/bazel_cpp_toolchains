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

// Test for: force_pic_flags feature (-pie under --force_pic)
//
// The force_pic_flags feature emits "-pie" for executable links when the
// `force_pic` build variable is available, which happens under --force_pic.
// A position-independent executable is an ELF object of type ET_DYN (as opposed
// to a classic ET_EXEC). This test reads its own ELF header via /proc/self/exe
// and asserts the type is ET_DYN, i.e. the binary really was linked as a PIE.
//
// This target is exercised in CI with:
//     bazel test --config x86_64-linux --force_pic \
//         //feature_verification/opt_in_features:force_pic_flags_test

#include <cassert>
#include <cstdint>
#include <cstdio>
#include <iostream>

namespace {

constexpr std::uint16_t kElfTypeExecutable = 2;  // ET_EXEC (non-PIE)
constexpr std::uint16_t kElfTypeSharedObject = 3;  // ET_DYN (PIE / shared)

// Reads the e_type field from this process's own ELF header.
std::uint16_t read_own_elf_type() {
    std::FILE* self = std::fopen("/proc/self/exe", "rb");
    assert(self != nullptr && "could not open /proc/self/exe");

    unsigned char header[20] = {0};
    const std::size_t read = std::fread(header, 1, sizeof(header), self);
    std::fclose(self);
    assert(read >= 18 && "short read of ELF header");

    // ELF magic: 0x7F 'E' 'L' 'F'.
    assert(header[0] == 0x7F && header[1] == 'E' && header[2] == 'L' &&
           header[3] == 'F' && "not an ELF file");

    // e_type is a 16-bit field at offset 16 (little-endian on x86_64).
    return static_cast<std::uint16_t>(header[16]) |
           static_cast<std::uint16_t>(header[17] << 8);
}

}  // namespace

int main() {
    std::cout << "Testing force_pic_flags feature (PIE executable)..." << std::endl;

    const std::uint16_t e_type = read_own_elf_type();
    std::cout << "ELF e_type = " << e_type
              << " (2=ET_EXEC, 3=ET_DYN/PIE)" << std::endl;

    // With --force_pic the executable must be a position-independent ET_DYN.
    assert(e_type == kElfTypeSharedObject &&
           "expected a PIE executable (ET_DYN); was force_pic applied?");
    (void)kElfTypeExecutable;

    std::cout << "force_pic_flags test passed: executable is PIE (ET_DYN)"
              << std::endl;
    return 0;
}
