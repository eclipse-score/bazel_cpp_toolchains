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

// Shared entry point for the opt-in (disabled-by-default) toolchain feature
// tests. Each cc_test target in this package enables exactly one opt-in feature
// through its `features` attribute (and, where required, an additional command
// line flag documented in the BUILD file). These targets are tagged "manual" so
// they are excluded from CI wildcard runs; they exist so the opt-in features can
// be exercised and manually verified on demand.
//
// The body is a minimal build-and-run smoke test: it confirms that a binary
// built with the feature enabled compiles, links, and runs successfully.

#include <iostream>

int main() {
    std::cout << "opt-in feature smoke test: build + link + run OK" << std::endl;
    return 0;
}
