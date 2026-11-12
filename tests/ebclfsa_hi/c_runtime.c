/* Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#if !defined(__clang__) || !defined(__aarch64__)
#error "The high-integrity toolchain must use Clang targeting AArch64"
#endif

#ifdef __GLIBC__
#error "High-integrity applications must not use glibc"
#endif

_Static_assert(__STDC_VERSION__ >= 201112L, "C11 is required");

int check_c_runtime(void) {
    char buffer[32];
    const uint64_t value = UINT64_C(123456789);
    int length = snprintf(buffer, sizeof(buffer), "%lu", (unsigned long)value);
    return length == 9 && strcmp(buffer, "123456789") == 0;
}
