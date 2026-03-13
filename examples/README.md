# Bazel C++ Toolchains Examples

This directory contains example C++ projects demonstrating how to use the SCORE Bazel C++ toolchains with various target platforms and configurations.

## Configuration Details

The toolchain configurations are defined in:
- **`.bazelrc`** - Build configurations and platform settings
- **`MODULE.bazel`** - Toolchain dependencies and setup

## Building Targets

### Default Toolchain

Build a specific target with the default toolchain:
```bash
bazel build //:main_cpp
bazel test //:math_lib_test
```

### x86_64 Linux Builds

**Using the default GCC toolchain with pthread support:**
```bash
bazel build --config=host_config_1 //:main_pthread_cpp
bazel test --config=host_config_1 //:math_lib_test
```

**Using the custom GCC toolchain:**
```bash
bazel build --config=host_config_2 //:main_cpp
```

**Using the base platform configuration:**
```bash
bazel build --config=x86_64-linux //:main_cpp
```

### aarch64 Linux Cross-Compilation

**Build for ARM64 Linux:**
```bash
bazel build --config=target_config_3 //:main_cpp
bazel build --config=target_config_3 //:main_pthread_cpp
```

**Build for EB corbos Linux for Safety Applications (ARM64):**
```bash
bazel build --config=aarch64-ebclfsa //:main_cpp
bazel build --config=aarch64-ebclfsa //:main_pthread_cpp
bazel test  --config=aarch64-ebclfsa //:math_lib_test # this works if you have qemu-user-static installed and configured correctly
```

### QNX Target Builds

> **Note:** Take care of license requirements when using these toolchains and dependencies in your projects.
            See main README.md for details.

**Build for x86_64 QNX:**
```bash
bazel build --config=target_config_1 //:main_cpp
```

**Build for aarch64 QNX:**
```bash
bazel build --config=target_config_2 //:main_cpp
```
