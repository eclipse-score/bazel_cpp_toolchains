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

// Test for: the `c99` toolchain feature (enabled via the `features` attribute
// below, mirroring `--features=c99`). Unlike the other tests in this package,
// this does not pass `-std=` via copts: it relies entirely on the toolchain
// feature to select the C standard.
//
// GCC accepts C11-only keywords (_Generic, _Noreturn, ...) as an extension
// under -std=c99 too, so they don't actually depend on the active standard
// here. Instead this uses the standard-mandated `__STDC_VERSION__` macro in a
// real constraint: an array with a negative size is an ISO C constraint
// violation, so the typedef below only compiles when the active standard is
// exactly C99.
typedef char standard_must_be_c99[(__STDC_VERSION__ == 199901L) ? 1 : -1];

int main(void) {
    return sizeof(standard_must_be_c99) - 1;
}
