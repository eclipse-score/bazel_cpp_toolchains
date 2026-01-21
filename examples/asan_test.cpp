/********************************************************************************
* Copyright (c) 2025 Contributors to the Eclipse Foundation
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

#include <gtest/gtest.h>

// Reproduce the buggy logic as a callable function (rather than a real main()).
static int buggy(int argc) {
    int *array = new int[100];
    delete[] array;

    // Prevent compiler from optimizing away the UB access.
    volatile int idx = argc;

    // Use-after-free (+ potential OOB if argc >= 100).
    return array[idx];
}

TEST(BugReproTest, UseAfterFree_ShouldCrashUnderSanitizers) {
    // Under ASan/UBSan this should reliably abort.
    // Regex ".*" accepts any sanitizer death message.
    ASSERT_DEATH({ (void)buggy(0); }, ".*");
}

TEST(BugReproTest, OutOfBoundsPlusUaf_ShouldCrashUnderSanitizers) {
    // argc=200 also implies out-of-bounds in addition to use-after-free.
    ASSERT_DEATH({ (void)buggy(200); }, ".*");
}