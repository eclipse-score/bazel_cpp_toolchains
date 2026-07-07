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

// Test for: libraries_to_link with whole-archive support
// This library provides utility functions that should always be linked

// This symbol might not be referenced directly, but should be linked with whole-archive
void unused_utility_function() {
    // This function demonstrates that even unreferenced symbols are linked
    // when whole-archive is used
}

// Export a simple utility
int utility_add(int a, int b) {
    return a + b;
}

int utility_multiply(int a, int b) {
    return a * b;
}
