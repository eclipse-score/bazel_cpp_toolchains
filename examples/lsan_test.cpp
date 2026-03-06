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
#include <cstdlib>

static void lsan_buggy() {
    int* leaked = new int[100];
    leaked[0] = 42;

    // Drop the last visible reference so LSan can't find it on the stack.
    leaked = nullptr;

    std::exit(0);
}

TEST(LsanBugReproTest, MemoryLeak_ShouldBeReportedByLeakSanitizer) {
    EXPECT_EXIT(
        { lsan_buggy(); },
        ::testing::ExitedWithCode(23),
        ".*");
}