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
#include <thread>
#include <chrono>

static int shared_value = 0;

static void tsan_buggy() {
    std::thread writer([]() {
        for (int i = 0; i < 100000; ++i) {
            shared_value = i;  // unsynchronized write
        }
    });

    std::thread reader([]() {
        int tmp = 0;
        for (int i = 0; i < 100000; ++i) {
            tmp = shared_value;  // unsynchronized read
        }
        (void)tmp;
    });

    writer.join();
    reader.join();
}

TEST(TsanBugReproTest, ReadWriteRace_ShouldCrashUnderThreadSanitizer) {
    ASSERT_DEATH({ tsan_buggy(); }, ".*");
}