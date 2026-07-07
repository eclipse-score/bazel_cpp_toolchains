# Bazel C++ Toolchains Examples

This directory is intended for example C++ applications demonstrating how to use the SCORE Bazel C++ toolchains.

## Tests

**All tests have been moved to the `../tests/` directory.**

For comprehensive test documentation, including:
- Feature verification tests (8 tests covering toolchain features)
- Language and standard version tests (C, C++11, C++14, C++17, C++20)
- Build and execution instructions
- Cross-compilation guidance
- Troubleshooting guide

**See [docs/test_suite.md](../docs/test_suite.md)** for complete documentation.

### Quick Start

Run all tests:
```bash
bazel test --config host_config_1 //tests/...
```

Run specific test suites:
```bash
# Feature verification tests
bazel test --config host_config_1 //tests/feature_verification:feature_verification_tests

# Language and standards tests
bazel test --config host_config_1 //tests/language_and_standards:language_and_standards_tests
```

## Configuration

The toolchain configurations are defined in:
- **`.bazelrc`** - Build configurations and platform settings
- **`MODULE.bazel`** - Toolchain dependencies and setup

See [Toolchain Overview](../docs/overview.md) for more details.
