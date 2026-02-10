#!/usr/bin/env bash

echo -e "Testing 'host_config_1' ..."
bazel build --config host_config_1 //:main_cpp
bazel clean
echo -e "Testing 'host_config_2' ..."
bazel build --config host_config_2 //:main_cpp
bazel clean
echo -e "Testing 'host_config_3' ..."
bazel build --config host_config_3 //:main_cpp
bazel clean
echo -e "Testing 'target_config_1' ..."
bazel build --config target_config_1 //:main_cpp
bazel clean
echo -e "Testing 'target_config_2' ..."
bazel build --config target_config_2 //:main_cpp
bazel clean
echo -e "Testing 'target_config_3' ..."
bazel build --config target_config_3 //:main_cpp
bazel clean
