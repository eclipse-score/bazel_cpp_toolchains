# Toolchain Tests

This directory contains comprehensive test suites for validating SCORE Bazel C++ toolchain functionality across different platforms and configurations.

**For complete test documentation, see [docs/test_suite.md](../docs/test_suite.md)**

## Quick Reference

### Run Tests

```bash
# All tests
bazel test --config x86_64-linux //...

# Feature verification tests
bazel test --config x86_64-linux //:feature_verification_tests

# Language and standards tests  
bazel test --config x86_64-linux //:language_and_standards_tests
```

> NOTE: `bazel test` executes the compiled binaries, so it is only valid when
> the execution machine matches the target platform. The `x86_64-linux` config
> runs on an x86_64 Linux host. For other configs (e.g. `x86_64-qnx`,
> `aarch64-qnx`, `aarch64-linux`), build on the host with `bazel build` and run
> the tests on the matching target platform. See
> [docs/test_suite.md](../docs/test_suite.md) for details.

### Test Directories

- **`feature_verification/`** - Toolchain feature validation tests
- **`language_and_standards/`** - C and C++ standard version tests

## Documentation

**Complete test documentation is located in [docs/test_suite.md](../docs/test_suite.md)**

See that document for:
- Detailed test descriptions
- Feature coverage matrix
- Cross-compilation guidance
- Troubleshooting guide
- Adding new tests
