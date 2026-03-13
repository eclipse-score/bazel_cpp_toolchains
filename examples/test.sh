#!/usr/bin/env bash

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

echo -e "Testing 'host_config_1' ..."
bazel test --config host_config_1 //:math_lib_test
bazel clean --expunge
echo -e "Testing 'host_config_2' ..."
bazel test --config host_config_2 //:math_lib_test
bazel clean --expunge
echo -e "Testing 'host_config_3' ..."
bazel test --config host_config_3 //:math_lib_test
bazel clean --expunge
echo -e "Testing 'target_config_1' ..."
bazel build --config target_config_1 //:main_cpp
bazel clean --expunge
echo -e "Testing 'target_config_2' ..."
bazel build --config target_config_2 //:main_cpp
bazel clean --expunge
echo -e "Testing 'target_config_3' ..."
bazel build --config target_config_3 //:main_cpp
bazel clean --expunge
echo -e "Testing 'target_config_4' ..."
bazel build --config target_config_4 //:main_cpp
bazel clean --expunge
echo -e "Testing 'aarch64-ebclfsa' ..."
bazel build --config aarch64-ebclfsa //:main_cpp
bazel clean --expunge
