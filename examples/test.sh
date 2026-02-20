#!/usr/bin/env bash

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
