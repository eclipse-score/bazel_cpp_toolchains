# Toolchain Test Suite

This document provides comprehensive information about the SCORE Bazel C++ toolchain test suite, which validates toolchain functionality across different platforms and language standards.

## Overview

The test suite is organized into two main categories:

1. **Feature Verification Tests** - Validate specific toolchain compilation and linking features
2. **Language and Standards Tests** - Verify support for different programming languages and C++ standards

All tests are located in the `tests/` directory of the repository.

## Quick Start

All tests are defined in a separate Bazel workspace; therefore, Bazel commands must be run from the `tests/` directory.

Run all tests:
```bash
bazel test --config x86_64-linux //...
```

Run specific test suites:
```bash
bazel test --config x86_64-linux //:feature_verification_tests
bazel test --config x86_64-linux //:language_and_standards_tests
```

## Test Categories

### Feature Verification Tests (`tests/feature_verification/`)

These tests verify that specific toolchain features are correctly implemented and functioning. They validate compilation flags, linking behavior, and advanced toolchain capabilities.

#### Included Tests

1. **`defines_test`** - Preprocessor defines (`-D` flags)
   - Verifies preprocessor defines are applied during compilation
   - Tests multiple defines can be specified via `copts`

2. **`include_paths_test`** - Include path handling (`-I`, `-iquote`, `-isystem`)
   - Validates `-I` include directories are correctly handled
   - Tests `-iquote` quote search paths
   - Verifies `-isystem` system include paths

3. **`warnings_test`** - Warning level configuration
   - Tests strict_warnings, minimal_warnings, warnings_as_errors features
   - Includes code patterns that trigger specific warnings

4. **`coverage_test`** - Code coverage instrumentation
   - Verifies code coverage instrumentation flags are applied
   - Provides multiple code paths for coverage analysis
   - Can be analyzed with: `bazel coverage --combined_report=lcov //feature_verification:coverage_test`

5. **`pic_test`** - Position-Independent Code (`-fPIC`)
   - Tests -fPIC flag is correctly applied
   - Validates position-independent code patterns
   - Tests polymorphism, static variables, and C linkage with PIC

6. **`pthread_test`** - POSIX threading support
   - Verifies `-lpthread` correctly links pthread library
   - Tests thread creation, synchronization, and joining
   - Validates multiple threads can safely access shared state

7. **`multifile_test`** - Multi-file compilation and archiving
   - Tests multiple source files compile into separate object files
   - Validates object files are combined by archiver into static libraries
   - Complex operations across multiple object files link correctly

8. **`whole_archive_test`** - Whole-archive linking (`-Wl,--whole-archive`)
   - Verifies `-Wl,--whole-archive` and `-Wl,--no-whole-archive` work
   - Tests unused library symbols are linked when using whole-archive

#### Run Feature Tests

```bash
# All feature verification tests
bazel test --config x86_64-linux //:feature_verification_tests

# Individual tests
bazel test --config x86_64-linux //feature_verification:defines_test
bazel test --config x86_64-linux //feature_verification:pic_test
bazel test --config x86_64-linux //feature_verification:pthread_test
```

#### Feature Coverage

The feature verification tests cover 16 implemented toolchain features:

- ✅ `random_seed` - Deterministic builds
- ✅ `include_paths` - Header search paths
- ✅ `preprocessor_defines` - Macro definitions
- ✅ `user_compile_flags` - Custom compilation flags
- ✅ `compiler_input_flags` - Input file handling
- ✅ `compiler_output_flags` - Output file handling
- ✅ `archiver_flags` - Static library creation
- ✅ `user_link_flags` - Custom linking flags
- ✅ `linker_param_file` - Parameter file support
- ✅ `library_search_directories` - Library path handling
- ✅ `shared_flag` - Shared library compilation
- ✅ `output_execpath_flags` - Executable output
- ✅ `libraries_to_link` - Library linking (static, dynamic, whole-archive)
- ✅ `coverage` - Code coverage instrumentation
- ✅ `supports_pic` - Position-independent code
- ✅ `pthread` - POSIX threading

### Language and Standards Tests (`tests/language_and_standards/`)

These tests verify support for different programming languages and C++ standard versions. All tests execute on the host machine (Linux x86_64) and provide immediate feedback on toolchain language support.

#### Included Tests

1. **`c_lang_test`** - C language support (C99 and later)
   - Struct packing with `#pragma pack`
   - Designated initializers (C99)
   - Compound literals
   - Loop variable declarations
   - Restrict keyword

2. **`cpp11_test`** - C++11 language features
   - `auto` keyword
   - `nullptr`
   - Range-based for loops
   - Lambda expressions
   - Smart pointers (`unique_ptr`, `shared_ptr`)
   - Move semantics
   - Variadic templates
   - Rvalue references

3. **`cpp14_test`** - C++14 language features
   - Auto return type deduction
   - Generic lambdas
   - `std::make_unique`
   - Variable templates
   - Binary literals (`0b1010`)
   - Digit separators (`1'000'000`)
   - Relaxed constexpr
   - Tuple support

4. **`cpp17_test`** - C++17 language features
   - Structured bindings (`auto [x, y] = point;`)
   - `if constexpr`
   - `std::optional`
   - `std::variant`
   - `std::string_view`
   - Fold expressions
   - Inline variables
   - Nested namespaces (`namespace A::B::C {}`)

5. **`cpp20_test`** - C++20 language features
   - Concepts and concept constraints
   - `std::span`
   - Designated initializers (enhanced)
   - Spaceship operator (`<=>`)
   - Ranges and views
   - `consteval`
   - Requires clauses
   - Three-way comparison

#### Run Language Tests

```bash
# All language and standards tests
bazel test --config x86_64-linux //:language_and_standards_tests

# Individual tests
bazel test --config x86_64-linux //language_and_standards:c_lang_test
bazel test --config x86_64-linux //language_and_standards:cpp11_test
bazel test --config x86_64-linux //language_and_standards:cpp20_test
```

#### Compilation Flags

Each test is compiled with specific flags to enable the corresponding language standard:

| Test | Compilation Flag | GCC Version Required |
|------|------------------|----------------------|
| c_lang_test | -std=c99 | Any (C99 support) |
| cpp11_test | -std=c++11 | GCC 4.8+ |
| cpp14_test | -std=c++14 | GCC 5+ |
| cpp17_test | -std=c++17 | GCC 7+ |
| cpp20_test | -std=c++20 | GCC 10+ |

## Running Tests

### Basic Commands

```bash
# Run all tests
bazel test --config x86_64-linux //...

# Run with verbose output
bazel test --config x86_64-linux --test_output=all //feature_verification:defines_test

# Run specific test directory
bazel test --config x86_64-linux //feature_verification/...
bazel test --config x86_64-linux //language_and_standards/...
```

### Platform-Specific Testing

Bazel `test` compiles a test binary **and executes it**. A binary built for a
target platform can only be executed on that target platform (or a
binary-compatible one). This has a direct consequence for how the suites are
run:

- **`bazel test` is only valid when the execution machine matches the target
  platform.** When the host equals the target — for example running the
  `x86_64-linux` config on an `x86_64` Linux host — the binaries build and run
  directly on the host.
- **For every other configuration the tests must be executed on the
  corresponding target platform.** On a non-matching host, use `bazel build` to
  verify only compilation and linking, then deploy and run the resulting
  binaries on the target — or invoke `bazel test` directly from that target
  platform.

#### Host equals target (e.g. Linux x86_64)

```bash
# Host is the target: binaries build and execute locally
bazel test --config x86_64-linux //...
```

#### Cross configurations (QNX, aarch64-linux, runtime-specific)

Configs such as `x86_64-qnx`, `aarch64-qnx`, `aarch64-linux`,
`x86_64-linux-autosd10`, and `aarch64-linux-ebclfsa` target platforms that
differ from a typical x86_64 Linux host. Do **not** run `bazel test` for these
configs on the host — the produced binaries are not executable there.

```bash
# On the host: verify compilation and linking only (no execution)
bazel build --config x86_64-qnx //...
bazel build --config aarch64-qnx //...
bazel build --config aarch64-linux //...

# On the matching target platform: build and execute the tests
bazel test --config x86_64-qnx //...
```

> IMPORTANT: `x86_64-qnx` tests must be executed on an `x86_64` QNX system,
> `aarch64-qnx` tests on an `aarch64` QNX system, `aarch64-linux` tests on an
> `aarch64` Linux system, and so on. Running them on a mismatched host will
> fail because the test binaries cannot be executed there.

## Expected Test Results

The counts below assume execution on a matching target platform (or the host
when the host equals the target).

### All tests on the host (`//...`)
```
Executed 13 tests: 13 passed
```

### Feature Verification Tests
- The `feature_verification_tests` suite aggregates 7 tests. `warnings_test`
  is defined separately and is picked up by wildcard targets such as
  `//feature_verification/...`.
- Expected output for the suite:
  ```
  Executed 7 tests: 7 passed
  ```

### Language and Standards Tests
- All 5 tests pass when executed on a matching target platform.
- Each test verifies the appropriate language features and standard version.
- Expected output:
  ```
  Executed 5 tests: 5 passed
  ```

## Test Architecture

### Directory Structure

```
tests/
├── BUILD                                    # Root build file
├── README.md                                # Quick reference
├── feature_verification/
│   ├── BUILD                                # Feature test definitions
│   ├── feature_test.h/cpp                   # Test infrastructure
│   ├── defines_test.cpp                     # Individual feature tests
│   ├── include_paths_test.cpp
│   ├── warnings_test.cpp
│   ├── coverage_test.cpp
│   ├── pic_test_lib.h/cpp, pic_test.cpp
│   ├── multifile_lib.h and multifile_lib_*.cpp
│   ├── multifile_test.cpp
│   ├── whole_archive_lib.h/cpp
│   ├── whole_archive_test.cpp
│   ├── pthread_test_lib.h/cpp
│   └── pthread_test.cpp
└── language_and_standards/
    ├── BUILD                                # Language test definitions
    ├── c_lang_test.c                        # C language tests
    ├── cpp11_test.cpp                       # C++11 tests
    ├── cpp14_test.cpp                       # C++14 tests
    ├── cpp17_test.cpp                       # C++17 tests
    └── cpp20_test.cpp                       # C++20 tests
```

### Test Design Principles

1. **Feature Isolation** - Each test targets a specific feature or small group of related features
2. **Self-Contained** - Tests include all necessary source code and infrastructure
3. **Minimal Dependencies** - External dependencies are limited to standard libraries
4. **Clear Output** - Each test produces clear pass/fail output for verification
5. **Cross-Platform** - Feature tests work on both native and cross-compilation platforms

## Troubleshooting

### Test Compilation Failures

**Issue:** Test fails to compile with `-std=c++XX` flags

```bash
# Solution: Check if compiler supports the requested C++ standard
g++ --version
```

**Issue:** Cross-compilation tests fail with architecture mismatch

This happens when `bazel test` is run for a target platform on a mismatched
host. Build only on the host, then execute the tests on the matching target
platform:

```bash
# On the host: build only (no execution)
bazel build --config aarch64-qnx //...

# On the matching target platform: build and execute
bazel test --config aarch64-qnx //...
```

### Test Execution Failures

**Issue:** Tests timeout or hang

```bash
# Solution: Get detailed timeout information
bazel test --config x86_64-linux --test_verbose_timeout_warnings //...
```

**Issue:** Cannot find pthread library

```bash
# Solution: Install pthread development library
sudo apt-get install libpthread-stubs0-dev
```

**Issue:** Assertion failures in test output

```bash
# Solution: Run with full output for debugging
bazel test --config x86_64-linux --test_output=all //language_and_standards:cpp20_test
```

### Compiler Version Issues

**Issue:** Error about unsupported language feature

```bash
# Solution: Upgrade GCC to a version supporting the feature
sudo apt-get install g++-11

# Set as default
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

# Verify new version
g++ --version
```

## Adding New Tests

### Adding a Feature Test

1. Create test source files in `tests/feature_verification/`
2. Add library targets (if needed) and test target in BUILD file:
   ```python
   cc_test(
       name = "my_feature_test",
       srcs = ["my_feature_test.cpp"],
       copts = ["-DTEST_FEATURE=1"],
       deps = [":feature_test_lib"],
   )
   ```
3. Add test name to `feature_verification_tests` suite in BUILD
4. Document the test in this file

### Adding a Language Test

1. Create test source file in `tests/language_and_standards/`
2. Add test target in BUILD file:
   ```python
   cc_test(
       name = "cpp23_test",
       srcs = ["cpp23_test.cpp"],
       copts = ["-std=c++23"],
   )
   ```
3. Add test name to `language_and_standards_tests` suite in BUILD
4. Document the test in this file

## Integration with CI/CD

The test suite can be integrated into continuous integration pipelines:

```bash
# Full validation (native + cross-compilation builds)
bazel test --config x86_64-linux //language_and_standards/...
bazel build --config aarch64-qnx //feature_verification/...

# Generate test reports
bazel test --config x86_64-linux --test_summary=detailed //...
```

## Performance Characteristics

- **Feature Verification Tests**: ~10-30 seconds total
- **Language and Standards Tests**: ~20-50 seconds total
- **Full Suite**: ~30-80 seconds total (depends on compiler and system)

## Further Reading

- [Bazel C++ Toolchain Overview](overview.md)
- [Toolchain Generation Flow](generation_flow.md)
- [Repository Layout](repository_layout.md)
