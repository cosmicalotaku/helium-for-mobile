#!/usr/bin/env bash
set -eo pipefail

source common.sh
set_keys

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Usage: ./sign.sh <input-apk-or-aab> <output-signed-file>" >&2
    exit 1
fi

export PATH="$PWD/chromium/src/third_party/jdk/current/bin/:$PATH"
export ANDROID_HOME="${ANDROID_HOME:-$PWD/chromium/src/third_party/android_sdk/public}"

if [[ "$INPUT_FILE" == *.apk ]]; then
    echo "==> Signing APK: $INPUT_FILE -> $OUTPUT_FILE"
    sign_apk "$INPUT_FILE" "$OUTPUT_FILE"
elif [[ "$INPUT_FILE" == *.aab ]]; then
    echo "==> Signing AAB: $INPUT_FILE -> $OUTPUT_FILE"
    sign_aab "$INPUT_FILE" "$OUTPUT_FILE"
else
    echo "Error: Unknown package format (must be .apk or .aab)" >&2
    exit 1
fi

echo "==> Successfully signed $OUTPUT_FILE"
