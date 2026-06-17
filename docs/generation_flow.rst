..
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

Generation Flow
===============

End-To-End Flow
---------------

The repository turns a small ``MODULE.bazel`` declaration into a generated
toolchain repository through these steps:

1. ``extensions/gcc.bzl`` collects ``gcc.toolchain`` and ``gcc.sdp`` tags.
2. Package metadata is resolved from ``packages/version_matrix.bzl`` or from an
   explicit ``gcc.sdp`` declaration.
3. ``rules/gcc.bzl`` renders a BUILD file and configuration files into a new
   repository.
4. Platform-specific templates from ``templates/linux/`` or ``templates/qnx/``
   are populated with CPU, version, licensing, and flag information.
5. The consuming workspace enables the generated toolchain with
   ``--extra_toolchains`` and compatible platform constraints.

Subsystem Roles
---------------

``packages/version_matrix.bzl``
   Defines the supported package matrix. Each entry maps a logical toolchain key
   to download metadata and, when needed, extra compiler or linker flags.

``rules/common.bzl``
   Provides small helpers that convert lists of flags into the Bazel
   ``flag_group`` representation needed by the templates and repository rules.

``rules/gcc.bzl``
   Generates the toolchain repository. It decides whether Linux or QNX template
   content is required, performs placeholder substitution, and emits the final
   ``BUILD``, ``cc_toolchain_config.bzl``, ``flags.bzl``, and Linux ``gcov``
   wrapper files.

``rules/qnx_sdp_gen.bzl``
   Handles the special case where a QNX SDP must be built locally rather than
   downloaded as a ready-made archive.

Template Families
-----------------

Linux templates:

- ``templates/linux/cc_toolchain_config.bzl.template``
- ``templates/linux/cc_toolchain_flags.bzl.template``
- ``templates/linux/cc_gcov_wrapper.template``

QNX templates:

- ``templates/qnx/cc_toolchain_config.bzl.template``
- ``templates/qnx/cc_toolchain_flags.bzl.template``

Shared template:

- ``templates/BUILD.template``

Important Implementation Details
--------------------------------

- Some package definitions rely on the ``%{toolchain_pkg}%`` placeholder, which
  is rewritten to the canonical Bzlmod repository name during repository-rule
  generation.
- QNX ``aarch64`` is mapped internally to ``aarch64le`` where required by the
  underlying SDK layout.
- SDP version ``8.0.3`` is normalized to ``8.0.0`` in the generated toolchain
  configuration because platform constraint support currently uses the older
  identifier.
- Linux toolchains generate an extra ``gcov_wrapper`` script to work around the
  current ``rules_cc`` coverage integration behavior.

Version Matrix Responsibilities
-------------------------------

The version matrix is more than a list of URLs. It is also the place where the
repository centralizes:

- package build-file selection,
- archive extraction prefixes,
- sysroot-specific compiler flags,
- extra link flags,
- compiler library search paths,
- runtime-ecosystem variants such as AutoSD or EB corbos Linux for Safety Applications.