# Bazel C++ Toolchains Examples

This directory contains a small C++ workspace used to smoke-test the toolchain
configurations declared in `.bazelrc`.

## Workspace Layout

- `.bazelrc` declares the example toolchain configurations.
- `MODULE.bazel` wires the example workspace to this repository through `local_path_override`.
- `tests/toolchain_smoke_tests.sh` is the source of truth for the toolchain smoke-test matrix.
- `test.sh` is a thin compatibility wrapper around the test runner.

## Default Targets

Run the example targets with the default toolchain:

```bash
bazel build //:main_cpp
bazel test //:math_lib_test
```

## Toolchain Smoke Tests

List the available smoke-test cases:

```bash
./tests/toolchain_smoke_tests.sh --list
```

Run the full matrix:

```bash
./test.sh
```

Run a subset of configurations:

```bash
./test.sh host_config_1 target_config_3
```

Keep running after a failure to collect the full result set:

```bash
./test.sh --keep-going
```

The runner isolates Bazel output per configuration outside the workspace under
`${XDG_CACHE_HOME:-$HOME/.cache}/score-bazel-cpp-toolchains/examples/` by default,
so the checks do not depend on `bazel clean --expunge` between cases. Set
`TOOLCHAIN_TEST_OUTPUT_ROOT` if you want to redirect that state.

## Smoke-Test Coverage

| Config | Coverage |
| --- | --- |
| `host_config_1` | Build `//:main_pthread_cpp`, run `//:math_lib_test` |
| `host_config_2` | Build `//:main_cpp`, run `//:math_lib_test` |
| `host_config_3` | Build `//:main_cpp`, run `//:math_lib_test` |
| `target_config_1` | Build `//:main_cpp` |
| `target_config_2` | Build `//:main_cpp` |
| `target_config_3` | Build `//:main_cpp`, build `//:main_pthread_cpp` |
| `target_config_4` | Build `//:main_cpp` |
| `target_config_5` | Build `//:main_cpp`, build `//:main_pthread_cpp` |
| `target_config_6` | Build `//:main_cpp` |
| `target_config_7` | Build `//:main_cpp` |

## Manual Commands By Platform

### x86_64 Linux

Default GCC host toolchain with pthread support:

```bash
bazel build --config=host_config_1 //:main_pthread_cpp
bazel test --config=host_config_1 //:math_lib_test
```

Custom GCC host toolchain:

```bash
bazel build --config=host_config_2 //:main_cpp
bazel test --config=host_config_2 //:math_lib_test
```

Base-platform host toolchain:

```bash
bazel build --config=host_config_3 //:main_cpp
bazel test --config=host_config_3 //:math_lib_test
```

### aarch64 Linux Cross-Compilation

Generic ARM64 Linux toolchain:

```bash
bazel build --config=target_config_3 //:main_cpp
bazel build --config=target_config_3 //:main_pthread_cpp
```

EB corbos Linux for Safety Applications toolchain:

```bash
bazel build --config=target_config_5 //:main_cpp
bazel build --config=target_config_5 //:main_pthread_cpp
```

### QNX Target Builds

Take care of license requirements when using these toolchains and dependencies in
your projects. See the repository README for details.

Packaged x86_64 QNX toolchain:

```bash
bazel build --config=target_config_1 //:main_cpp
```

Packaged aarch64 QNX toolchain:

```bash
bazel build --config=target_config_2 //:main_cpp
```

Local-SDP x86_64 QNX toolchain:

```bash
bazel build --config=target_config_6 //:main_cpp
```

Local-SDP aarch64 QNX toolchain:

```bash
bazel build --config=target_config_7 //:main_cpp
```
