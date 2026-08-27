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

#ifndef PTHREAD_TEST_LIB_H
#define PTHREAD_TEST_LIB_H

// Test for: pthread feature (POSIX threads linking)
// This library demonstrates pthread functionality

int get_sum_from_threads();
int get_thread_count();
void reset_thread_state();

#endif // PTHREAD_TEST_LIB_H
