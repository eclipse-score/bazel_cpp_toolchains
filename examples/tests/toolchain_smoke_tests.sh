#!/usr/bin/env bash

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

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
EXAMPLES_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
DEFAULT_OUTPUT_ROOT_BASE="${XDG_CACHE_HOME:-$HOME/.cache}/score-bazel-cpp-toolchains/examples"
OUTPUT_ROOT_BASE=${TOOLCHAIN_TEST_OUTPUT_ROOT:-$DEFAULT_OUTPUT_ROOT_BASE}

usage() {
    cat <<'EOF'
Usage: ./tests/toolchain_smoke_tests.sh [--list] [--keep-going] [CONFIG ...]

Run basic smoke checks for one or more toolchain configs declared in .bazelrc.

Options:
  --list        Print the available toolchain test cases and exit.
    --keep-going  Continue with the remaining configs after a failure.
  -h, --help    Show this help message.

If no CONFIG values are provided, all test cases are executed.

Environment:
    TOOLCHAIN_TEST_OUTPUT_ROOT  Override the Bazel output root used for isolated test runs.
EOF
}

case_ids() {
    cat <<'EOF'
host_config_1
host_config_2
host_config_3
target_config_1
target_config_2
target_config_3
target_config_4
target_config_5
target_config_6
target_config_7
EOF
}

case_description() {
    case "$1" in
        host_config_1) echo "x86_64 Linux host toolchain with pthread feature" ;;
        host_config_2) echo "x86_64 Linux custom GCC host toolchain" ;;
        host_config_3) echo "x86_64 Linux host toolchain using base platform constraints" ;;
        target_config_1) echo "x86_64 QNX cross-toolchain from packaged SDP" ;;
        target_config_2) echo "aarch64 QNX cross-toolchain from packaged SDP" ;;
        target_config_3) echo "aarch64 Linux cross-toolchain" ;;
        target_config_4) echo "x86_64 Linux AutoSD 10 cross-toolchain" ;;
        target_config_5) echo "aarch64 Linux EB corbos Linux for Safety Applications toolchain" ;;
        target_config_6) echo "x86_64 QNX cross-toolchain from locally built SDP" ;;
        target_config_7) echo "aarch64 QNX cross-toolchain from locally built SDP" ;;
        *) return 1 ;;
    esac
}

case_commands() {
    case "$1" in
        host_config_1)
            printf '%s\n' \
                "build //:main_pthread_cpp" \
                "test //:math_lib_test"
            ;;
        host_config_2)
            printf '%s\n' \
                "build //:main_cpp" \
                "test //:math_lib_test"
            ;;
        host_config_3)
            printf '%s\n' \
                "build //:main_cpp" \
                "test //:math_lib_test"
            ;;
        target_config_1)
            printf '%s\n' "build //:main_cpp"
            ;;
        target_config_2)
            printf '%s\n' "build //:main_cpp"
            ;;
        target_config_3)
            printf '%s\n' \
                "build //:main_cpp" \
                "build //:main_pthread_cpp"
            ;;
        target_config_4)
            printf '%s\n' "build //:main_cpp"
            ;;
        target_config_5)
            printf '%s\n' \
                "build //:main_cpp" \
                "build //:main_pthread_cpp"
            ;;
        target_config_6)
            printf '%s\n' "build //:main_cpp"
            ;;
        target_config_7)
            printf '%s\n' "build //:main_cpp"
            ;;
        *) return 1 ;;
    esac
}

list_cases() {
    while IFS= read -r case_id; do
        printf '%-16s %s\n' "$case_id" "$(case_description "$case_id")"
    done < <(case_ids)
}

run_case() {
    local case_id=$1
    local output_root="$OUTPUT_ROOT_BASE/$case_id"

    rm -rf -- "$output_root"
    mkdir -p -- "$output_root"

    printf '================================================================================\n'
    printf 'Running %s\n' "$case_id"
    printf 'Description: %s\n' "$(case_description "$case_id")"

    while IFS= read -r command; do
        local mode=${command%% *}
        local target=${command#* }

        printf '  bazel %s --config=%s %s\n' "$mode" "$case_id" "$target"
        (
            cd -- "$EXAMPLES_DIR"
            bazel "--output_user_root=$output_root" \
                "$mode" \
                "--config=$case_id" \
                "$target"
        )
    done < <(case_commands "$case_id")
}

keep_going=false
list_only=false
declare -a requested_cases=()

while (($# > 0)); do
    case "$1" in
        --list)
            list_only=true
            ;;
        --keep-going)
            keep_going=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            requested_cases+=("$1")
            ;;
    esac
    shift
done

if "$list_only"; then
    list_cases
    exit 0
fi

if ((${#requested_cases[@]} == 0)); then
    mapfile -t requested_cases < <(case_ids)
fi

declare -a failed_cases=()

for case_id in "${requested_cases[@]}"; do
    if ! case_description "$case_id" >/dev/null; then
        printf 'Unknown toolchain test case: %s\n' "$case_id" >&2
        printf 'Use --list to inspect the supported values.\n' >&2
        exit 2
    fi

    if ! run_case "$case_id"; then
        failed_cases+=("$case_id")
        if ! "$keep_going"; then
            break
        fi
    fi
done

if ((${#failed_cases[@]} > 0)); then
    printf '================================================================================\n' >&2
    printf 'Toolchain smoke tests failed for: %s\n' "${failed_cases[*]}" >&2
    exit 1
fi

printf '================================================================================\n'
printf 'All requested toolchain smoke tests passed.\n'