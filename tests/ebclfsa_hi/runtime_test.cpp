/* Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdio>
#include <string>
#include <vector>

#if !defined(__clang__) || !defined(__aarch64__)
#error "The high-integrity toolchain must use Clang targeting AArch64"
#endif

#ifndef _LIBCPP_VERSION
#error "High-integrity applications must use libc++"
#endif

#if defined(__GLIBC__) || defined(__GLIBCXX__)
#error "QM runtime headers leaked into the high-integrity toolchain"
#endif

#if defined(__EXCEPTIONS) || defined(__GXX_RTTI) || defined(__cpp_exceptions) || defined(__cpp_rtti)
#error "Exceptions and RTTI must be disabled"
#endif

static_assert(__cplusplus >= 201703L, "C++17 is required");

extern "C" int check_c_runtime(void);

int main() {
    if (!check_c_runtime()) {
        std::fputs("musl C runtime check failed\n", stderr);
        return 1;
    }

    std::vector<std::int64_t> values{3, 1, 2};
    std::sort(values.begin(), values.end());
    const std::array<std::int64_t, 3> expected{1, 2, 3};
    const std::string message = std::string("high-integrity ") + "libc++";
    if (!std::equal(values.begin(), values.end(), expected.begin()) ||
        message != "high-integrity libc++") {
        std::fputs("libc++ runtime check failed\n", stderr);
        return 1;
    }
    return 0;
}
