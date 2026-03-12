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
#include <gtest/gtest.h>
#include <climits>

static int ubsan_buggy() {
    volatile int x = INT_MAX;
    volatile int y = 1;

    // Signed overflow is UB.
    return x + y;
}

TEST(UbsanBugReproTest, SignedOverflow_ShouldCrashUnderUndefinedBehaviorSanitizer) {
    // Requires -fno-sanitize-recover=undefined or UBSAN_OPTIONS=halt_on_error=1
    ASSERT_DEATH({ (void)ubsan_buggy(); }, ".*");
}