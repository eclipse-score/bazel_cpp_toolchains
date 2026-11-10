/* Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

struct Base {
    virtual ~Base() = default;
};

struct Derived : Base {};

Derived* forbidden_rtti(Base* object) {
    return dynamic_cast<Derived*>(object);
}
