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

load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_shell//shell:sh_test.bzl", "sh_test")
load("@score_ebclfsa_2.0.0-beta2_toolchain//:elf_enabler.bzl", "elf_enabler")

config_setting(
    name = "sdk_platform",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
        "@score_bazel_platforms//runtime_es:ebclfsa",
        "@score_bazel_platforms//version:sdk_2.0.0-beta2",
    ],
)

cc_binary(
    name = "original",
    srcs = ["original.cc"],
    linkstatic = True,
    target_compatible_with = select({
        ":sdk_platform": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
)

elf_enabler(
    name = "enabled",
    src = ":original",
)

elf_enabler(
    name = "enabled with spaces",
    src = ":original",
)

sh_test(
    name = "integration_test",
    size = "small",
    srcs = ["integration_test.sh"],
    args = [
        "$(rootpath :original)",
        "$(rootpath :enabled)",
        "$(rootpath :enabled with spaces)",
        "$(rootpath @score_ebclfsa_2.0.0-beta2_toolchain_pkg//:elf-enabler)",
    ],
    data = [
        ":enabled",
        ":enabled with spaces",
        ":original",
        "@score_ebclfsa_2.0.0-beta2_toolchain_pkg//:all_files",
        "@score_ebclfsa_2.0.0-beta2_toolchain_pkg//:elf-enabler",
    ],
)
