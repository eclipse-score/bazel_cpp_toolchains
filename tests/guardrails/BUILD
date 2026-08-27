# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************

"""Regression guardrail for the explicit-feature (`no_legacy_features`) model."""

load(":legacy_feature_guard.bzl", "no_legacy_features_guard_test")

# Validates the C++ toolchain resolved for the current --config. Run it under
# each platform config (x86_64-linux, aarch64-linux, x86_64-qnx, ...) to cover
# the whole toolchain matrix.
no_legacy_features_guard_test(
    name = "no_legacy_features_guard_test",
    visibility = ["//visibility:public"],
)
