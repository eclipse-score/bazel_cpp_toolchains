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

Examples And Validation
=======================

Example Workspace Purpose
-------------------------

The ``examples/`` directory is a separate Bazel workspace used as a lightweight
integration test bed for the repository.

It demonstrates how consumers declare toolchains while also serving as the main
smoke-test surface for validating that the generated toolchains can build and,
where appropriate, run example targets.

Important Files
---------------

``examples/MODULE.bazel``
   Declares representative Linux and QNX toolchain repositories and wires the
   example workspace back to the local checkout with ``local_path_override``.

``examples/.bazelrc``
   Defines named Bazel configurations that activate the generated toolchains and
   platforms.

``examples/BUILD``
   Contains small C++ targets used to verify compilation, linking, pthread
   support, and sanitizer integration.

``examples/tests/toolchain_smoke_tests.sh``
   Matrix runner that maps each configuration name to a small build or test
   sequence.

Smoke-Test Matrix
-----------------

The example workspace currently validates these configuration groups:

- Linux host toolchains
- Linux cross-compilation toolchains
- runtime-specific Linux toolchains such as AutoSD and EB corbos Linux for Safety Applications
- packaged QNX toolchains
- locally built QNX SDP toolchains

The smoke-test runner isolates Bazel state per configuration so it does not rely
on ``bazel clean --expunge`` between cases.

Useful Commands
---------------

.. code-block:: bash

   cd examples
   ./test.sh --list
   ./test.sh host_config_1
   ./test.sh --keep-going

What The Tests Prove
--------------------

The example workspace is not intended to be an exhaustive compiler correctness
suite. Instead, it answers a narrower question: did the configuration repository
produce a usable toolchain definition for each supported scenario?

In practice this means checking:

- successful compilation with the selected compiler and sysroot,
- correct toolchain registration and platform matching,
- basic linking behavior,
- feature coverage such as pthread-enabled builds,
- optional sanitizer feature wiring for the local Linux toolchain path.