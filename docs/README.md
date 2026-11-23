<!-- ----------------------------------------------------------------------------
  Copyright (c) 2026 Contributors to the Eclipse Foundation

  See the NOTICE file(s) distributed with this work for additional
  information regarding copyright ownership.

  This program and the accompanying materials are made available under the
  terms of the Apache License Version 2.0 which is available at
  https://www.apache.org/licenses/LICENSE-2.0

  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------- -->

# Documentation

Choose a path based on whether you use an existing toolchain or develop
toolchain support. This documentation covers this Bazel module, not a complete
platform integration or compiler installation. It describes the source at this
revision; the public API and available packages can differ in older releases.

## Consumers

- [Build with a Linux toolchain](consumers/getting_started.md): declare,
  select, and verify a toolchain in your module.
- [Integrate a QNX toolchain](consumers/qnx_integration.md): configure QNX
  packages, authentication, and licensing.
- [Authenticate QNX package downloads](consumers/qnx_authentication.md):
  configure credentials for the selected package host.
- [Extension API](consumers/extension_api.md): look up tags and attributes.
- [Toolchain features](consumers/features.md): find supported features.
- [Explicit-feature migration guide](consumers/migration_guide.md): adapt
  builds that depended on implicit legacy features.
- [Overview](consumers/overview.md): understand the configuration model.

## Contributors

- [Add a toolchain variant](contributors/add_toolchain.md): follow the
  package-to-validation workflow.
- [Generation flow](contributors/generation_flow.md): understand how
  declarations become toolchain repositories.
- [Maintenance](contributors/maintenance.md): inspect feature and sysroot
  wiring.
- [Repository layout](contributors/repository_layout.md): find implementation
  components.
- [Tests and validation](contributors/tests_and_validation.md): choose and
  run appropriate checks.
- [Test suite reference](contributors/test_suite.md): look up individual tests.
- [Maintain documentation](contributors/documentation.md): update and review
  documentation with code changes.

The original paths under `docs/` remain as forwarding pages for existing links.
