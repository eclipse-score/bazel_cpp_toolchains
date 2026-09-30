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

"""Module extension for fast prebuilt LLVM toolchains, an alternative to depending on toolchains_llvm directly."""

load("@score_bazel_cpp_toolchains//rules:fast_llvm_repo.bzl", "fast_llvm_repo")
load("@toolchains_llvm//toolchain:rules.bzl", "llvm_toolchain")

_attrs_tc = {
    "name": attr.string(
        mandatory = True,
        doc = "Name of the generated LLVM toolchain repository.",
    ),
    "version": attr.string(
        mandatory = True,
        doc = "LLVM version to extract (see rules/fast_llvm_repo.bzl for supported versions).",
    ),
}

def _package_root(package_name):
    extension_owner = str(Label("//:MODULE.bazel")).split("//")[0]
    return "%s+llvm+%s//" % (extension_owner, package_name)

def _impl(mctx):
    root = None
    for mod in mctx.modules:
        if not mod.is_root:
            fail("Only the root module can use the 'llvm' extension!")
        root = mod

    for tag in root.tags.toolchain:
        package_name = tag.name + "_pkg"
        fast_llvm_repo(
            name = package_name,
            llvm_version = tag.version,
        )
        llvm_toolchain(
            name = tag.name,
            llvm_version = tag.version,
            toolchain_roots = {
                "": _package_root(package_name),
            },
        )

llvm = module_extension(
    implementation = _impl,
    tag_classes = {
        "toolchain": tag_class(
            attrs = _attrs_tc,
            doc = "Declares an LLVM toolchain extracted via the fast host xz/tar pipeline.",
        ),
    },
)
