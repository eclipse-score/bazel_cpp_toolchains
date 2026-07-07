# Toolchain Tests

This directory contains comprehensive test suites for validating SCORE Bazel C++ toolchain functionality across different platforms and configurations.

**For complete test documentation, see [docs/test_suite.md](../docs/test_suite.md)**

## Quick Reference

### Run Tests

```bash
# All tests
bazel test --config host_config_1 //tests/...

# Feature verification tests
bazel test --config host_config_1 //tests/feature_verification:feature_verification_tests

# Language and standards tests  
bazel test --config host_config_1 //tests/language_and_standards:language_and_standards_tests
```

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
