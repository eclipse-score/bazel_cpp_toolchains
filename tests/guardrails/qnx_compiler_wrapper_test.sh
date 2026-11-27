#!/bin/bash
# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail
IFS=$'\n\t'

sdk_execpath="$1"
count="$2"
shift 2
wrappers=()
compilers=()
for ((index=0; index<count; index++)); do
    wrappers+=("$1")
    compilers+=("$2")
    shift 2
done
runfiles="$PWD"
root="$(mktemp -d "${TEST_TMPDIR:?}/qnx-cwd.XXXXXX")"
trap 'rm -rf -- "$root"' EXIT
execroot="${root}/relocated execroot"
mkdir -p "$execroot"
while [[ "$#" != 0 ]]; do
    source="${runfiles}/$1"
    destination="${execroot}/$2"
    mkdir -p "$(dirname -- "$destination")"
    cp -RL "$source" "$destination"
    shift 2
done
chmod -R u+w "$execroot"
export EXPECTED_SDK
logical_sdk="$(cd -L -- "${execroot}/${sdk_execpath}" && pwd -L)"
export QNX_CONFIGURATION_EXCLUSIVE=/var/tmp/.qnx
export QNX_SHARED_LICENSE_FILE=FAKE-LICENSE-FOR-TESTING
export LM_LICENSE_FILE=FAKE-SERVER-FOR-TESTING

# Keep the invoked path in the execroot even when the script is a sandbox
# symlink to a file outside it. The SDK must never resolve through that symlink.
mkdir -p "${root}/repository cache"
mv "${execroot}/${wrappers[0]}" "${root}/repository cache/qcc"
ln -s "${root}/repository cache/qcc" "${execroot}/${wrappers[0]}"

for sdk_layout in directory symlink; do
    if [[ "$sdk_layout" == symlink ]]; then
        mv "${execroot}/${sdk_execpath}" "${root}/repository cache/sdk"
        ln -s "${root}/repository cache/sdk" "${execroot}/${sdk_execpath}"
        physical_sdk="$(cd -- "${execroot}/${sdk_execpath}" && pwd -P)"
        [[ "$physical_sdk" != "$logical_sdk" ]] || exit 1
        printf 'Logical SDK: %s\nPhysical SDK: %s\n' "$logical_sdk" "$physical_sdk"
    fi
    for cwd in "$execroot" "${execroot}/external/crate/manifest" \
        "${execroot}/bazel-out/cmake/build/CMakeFiles/CMakeScratch/TryCompile-test"; do
        printf 'SDK layout: %s; cwd: %s\n' "$sdk_layout" "$cwd"
        mkdir -p "$cwd"
        touch "${cwd}/source file.c"
        (
            cd -- "$cwd"
            export EXPECTED_CWD="$PWD"
            EXPECTED_SDK="$logical_sdk"
            if [[ "$cwd" == "$execroot" ]]; then
                EXPECTED_SDK="/proc/self/cwd/${sdk_execpath}"
            fi
            export QNX_HOST=/proc/self/cwd/external/fake_sdp/host/linux/x86_64
            export QNX_TARGET=/proc/self/cwd/external/fake_sdp/target/qnx
            for ((index=0; index<count; index++)); do
                export EXPECTED_COMPILER="${compilers[index]}"
                wrapper="${wrappers[index]}"
                [[ "${wrapper##*/}" == qcc || "${wrapper##*/}" == q++ ]] || exit 1
                "${execroot}/${wrapper}" "-DVALUE=two words" "source file.c"
                status=0
                COMPILER_STATUS=42 "${execroot}/${wrapper}" "-DVALUE=two words" "source file.c" || status=$?
                [[ "$status" == 42 ]] || exit 1
                if [[ "$cwd" == "$execroot" ]]; then
                    "./${wrapper}" "-DVALUE=two words" "source file.c"
                fi
            done
        )
    done
done
