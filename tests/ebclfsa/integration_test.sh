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

original="$PWD/$1"
enabled="$PWD/$2"
with_spaces="$PWD/$3"
enabler="$PWD/$4"

test "$(od -An -tx1 -N4 "$original" | tr -d ' \n')" = "7f454c46"
readelf -h "$original" | grep -q 'Machine:.*AArch64'
test "$(od -An -tu1 -j15 -N1 "$original" | tr -d ' \n')" = 0
original_hash="$(sha256sum "$original")"
cp "$original" "$TEST_TMPDIR/expected"
chmod 0755 "$TEST_TMPDIR/expected"
"$enabler" "$TEST_TMPDIR/expected"

for output in "$enabled" "$with_spaces"; do
    test -x "$output"
    test ! "$original" -ef "$output"
    readelf -h "$output" | grep -q 'Machine:.*AArch64'
    test "$(od -An -tu1 -j15 -N1 "$output" | tr -d ' \n')" = 83
    readelf -SW "$output" | grep -q '\.lisa\.cksums'
    cmp "$TEST_TMPDIR/expected" "$output"
    if cmp -s "$original" "$output"; then
        echo "The SDK enabler did not transform the executable" >&2
        exit 1
    fi
done
test "$original_hash" = "$(sha256sum "$original")"
