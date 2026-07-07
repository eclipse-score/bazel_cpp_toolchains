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

// Test for: pthread feature
// This library demonstrates multi-threaded programming with POSIX threads

#include "pthread_test_lib.h"
#include <pthread.h>
#include <cstdlib>

// Shared state protected by mutex
static pthread_mutex_t state_mutex = PTHREAD_MUTEX_INITIALIZER;
static int sum = 0;
static int thread_count = 0;

// Thread function that adds to the sum
void* thread_adder(void* arg) {
    int value = *static_cast<int*>(arg);
    
    // Lock before modifying shared state
    pthread_mutex_lock(&state_mutex);
    sum += value;
    thread_count++;
    pthread_mutex_unlock(&state_mutex);
    
    delete static_cast<int*>(arg);
    return nullptr;
}

int get_sum_from_threads() {
    const int num_threads = 4;
    pthread_t threads[num_threads];
    
    // Create threads
    for (int i = 0; i < num_threads; ++i) {
        int* value = new int(i + 1);  // 1, 2, 3, 4
        pthread_create(&threads[i], nullptr, thread_adder, value);
    }
    
    // Wait for all threads to complete
    for (int i = 0; i < num_threads; ++i) {
        pthread_join(threads[i], nullptr);
    }
    
    return sum;  // Expected: 1 + 2 + 3 + 4 = 10
}

int get_thread_count() {
    pthread_mutex_lock(&state_mutex);
    int count = thread_count;
    pthread_mutex_unlock(&state_mutex);
    return count;
}

void reset_thread_state() {
    pthread_mutex_lock(&state_mutex);
    sum = 0;
    thread_count = 0;
    pthread_mutex_unlock(&state_mutex);
}
