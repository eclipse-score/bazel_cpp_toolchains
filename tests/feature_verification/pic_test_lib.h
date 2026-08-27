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

#ifndef PIC_TEST_LIB_H
#define PIC_TEST_LIB_H

void increment_global();
int get_call_count();
int compute_position_safe(int value);

class PICAwareClass {
public:
    virtual ~PICAwareClass() = default;
    virtual int getValue() { return 42; }
};

class DerivedPICClass : public PICAwareClass {
public:
    int getValue() override;
};

extern "C" {
    int pic_c_function(int x);
}

#endif // PIC_TEST_LIB_H
