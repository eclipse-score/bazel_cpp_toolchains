# Language and Standards Tests

This directory contains tests for verifying that the toolchain correctly supports different programming languages and C++ standard versions.

**For complete documentation, see [../../docs/test_suite.md](../../docs/test_suite.md)**

## Quick Reference

```bash
# Run all language tests
bazel test --config host_config_1 //tests/language_and_standards:language_and_standards_tests

# Run individual test
bazel test --config host_config_1 //tests/language_and_standards:cpp20_test

# Run with verbose output
bazel test --config host_config_1 --test_output=all //tests/language_and_standards:cpp20_test
```

## See Also

- Complete documentation: [../../docs/test_suite.md](../../docs/test_suite.md)
- Toolchain overview: [../../docs/overview.md](../../docs/overview.md)
