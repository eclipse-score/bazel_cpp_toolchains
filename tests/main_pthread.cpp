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

#include <iostream>
#include <pthread.h>

void* say_hello(void* arg) {
    std::cout << "Hello from thread!" << std::endl;
    return nullptr;
}

int main() {
    pthread_t thread;

    if (pthread_create(&thread, nullptr, say_hello, nullptr) != 0) {
        std::cerr << "Error creating thread" << std::endl;
        return 1;
    }

    if (pthread_join(thread, nullptr) != 0) {
        std::cerr << "Error joining thread" << std::endl;
        return 2;
    }

    std::cout << "Hello from main!" << std::endl;
    return 0;
}