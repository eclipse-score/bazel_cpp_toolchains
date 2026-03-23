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

echo -e "***********************************************************************************"
echo -e "Testing toolchain for x86_64 Linux as '\e[93mhost_config_1\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:x86_64-linux-gcc_12.2.0-posix\e[39m"
echo -e "Toolchain: \e[93m@score_gcc_toolchain//:x86_64-linux-gcc_12.2.0\e[39m" 
bazel test --config host_config_1 //:math_lib_test
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for x86_64 Linux as '\e[93mhost_config_2\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:x86_64-linux-gcc_12.2.0-posix\e[39m"
echo -e "Toolchain: \e[93m@my_toolchain//:x86_64-linux-gcc_12.2.0\e[39m" 
bazel test --config host_config_2 //:math_lib_test
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for x86_64 Linux as '\e[93mhost_config_3\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:x86_64-linux\e[39m"
echo -e "Toolchain: \e[93m@score_gcc_toolchain_bp//:x86_64-linux\e[39m" 
bazel test --config host_config_3 //:math_lib_test
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for x86_64 QNX as '\e[93mtarget_config_1\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:x86_64-qnx-sdp_8.0.0-posix\e[39m"
echo -e "Toolchain: \e[93m@score_qcc_toolchain//:x86_64-qnx-sdp_8.0.0\e[39m" 
bazel build --config target_config_1 //:main_cpp
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for Aarch64 QNX as '\e[93mtarget_config_2\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:aarch64-qnx-sdp_8.0.0-posix\e[39m"
echo -e "Toolchain: \e[93m@score_qcc_arm_toolchain//:aarch64-qnx-sdp_8.0.0\e[39m" 
bazel build --config target_config_2 //:main_cpp
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for Aarch64 Linux as '\e[93mtarget_config_3\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:aarch64-linux-gcc_12.2.0-posix\e[39m"
echo -e "Toolchain: \e[93m@score_aarch64_gcc_toolchain//:aarch64-linux-gcc_12.2.0\e[39m" 
bazel build --config target_config_3 //:main_cpp
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for x86_64 Linux (flavor: \e[93mautosd10) as '\e[93mtarget_config_4\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:x86_64-linux-autosd10\e[39m"
echo -e "Toolchain: \e[93m@score_autosd_10_toolchain//:x86_64-linux-autosd10\e[39m" 
bazel build --config target_config_4 //:main_cpp
bazel clean --expunge
echo -e "***********************************************************************************"
echo -e "Testing toolchain for Aarch64 Linux (flavor: \e[93mebclfsa) as '\e[93mtarget_config_5\e[39m' ..."
echo -e "Platform: \e[93m@score_bazel_platforms//:aarch64-linux-sdk_0.1.0-ebclfsa\e[39m"
echo -e "Toolchain: \e[93m@score_ebclfsa_toolchain//:aarch64-linux-sdk_0.1.0-ebclfsa\e[39m" 
bazel build --config target_config_5 //:main_cpp
bazel clean --expunge
