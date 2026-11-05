#!/usr/bin/env bash
set -eo pipefail

export SCRIPT_DIR=$(realpath "$(dirname "$0")")

replace() {
    export org=$2 new=$3
    find "$1" -type f -exec sed -i "s@$org@$new@g" {} +
}

set_keys() {
    mkdir -p "$SCRIPT_DIR/keys"
    if [ -n "$LOCAL_TEST_JKS" ]; then
        echo "$LOCAL_TEST_JKS" | base64 -d > "$SCRIPT_DIR/keys/local.properties"
    fi
    if [ -n "$STORE_TEST_JKS" ]; then
        echo "$STORE_TEST_JKS" | base64 -d > "$SCRIPT_DIR/keys/test.jks"
    fi
    unset LOCAL_TEST_JKS
    unset STORE_TEST_JKS
}

sign_apk() {
    local in_apk="$1"
    local out_apk="$2"
    local apksigner
    apksigner=$(find "$ANDROID_HOME/build-tools" -name apksigner 2>/dev/null | sort -V | tail -n 1)
    if [ -z "$apksigner" ]; then
        echo "Error: apksigner not found in $ANDROID_HOME/build-tools" >&2
        return 1
    fi
    if [ -f "$SCRIPT_DIR/keys/local.properties" ] && [ -f "$SCRIPT_DIR/keys/test.jks" ]; then
        # shellcheck disable=SC1091
        source "$SCRIPT_DIR/keys/local.properties"
        "$apksigner" sign --verbose --ks "$SCRIPT_DIR/keys/test.jks" \
            --ks-pass "pass:$storePassword" \
            --key-pass "pass:$keyPassword" \
            --ks-key-alias "$keyAlias" \
            --out "$out_apk" "$in_apk"
    else
        echo "Warning: Signing keys not found in $SCRIPT_DIR/keys. Generating unsigned or self-signed debug package."
        cp "$in_apk" "$out_apk"
    fi
}

sign_aab() {
    local in_aab="$1"
    local out_aab="$2"
    if [ -f "$SCRIPT_DIR/keys/local.properties" ] && [ -f "$SCRIPT_DIR/keys/test.jks" ]; then
        # shellcheck disable=SC1091
        source "$SCRIPT_DIR/keys/local.properties"
        jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
            -keystore "$SCRIPT_DIR/keys/test.jks" \
            -storepass "$storePassword" \
            -keypass "$keyPassword" \
            -signedjar "$out_aab" "$in_aab" "$keyAlias"
    else
        echo "Warning: Signing keys not found for AAB. Copying unsigned package."
        cp "$in_aab" "$out_aab"
    fi
}

version_lt() {
    [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$1" ]
}
