# Feature Verification Tests

This directory contains tests for verifying that specific C++ toolchain features are correctly implemented and functioning.

**For complete documentation, see [../../docs/test_suite.md](../../docs/test_suite.md)**

## Quick Reference

```bash
# Run all feature tests
bazel test --config host_config_1 //tests/feature_verification:feature_verification_tests

# Run individual test
bazel test --config host_config_1 //tests/feature_verification:defines_test

# Build for cross-compilation (no execution)
bazel build --config target_config_1 //tests/feature_verification:defines_test
```

## See Also

- Complete documentation: [../../docs/test_suite.md](../../docs/test_suite.md)
- Toolchain overview: [../../docs/overview.md](../../docs/overview.md)
- Features documentation: [../../docs/features.md](../../docs/features.md)
