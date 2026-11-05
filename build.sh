#!/usr/bin/env bash
set -eo pipefail

source common.sh
set_keys

export CHROMIUM_SOURCE="https://chromium.googlesource.com/chromium/src.git"
export DEBIAN_FRONTEND=noninteractive

# Read pinned Chromium version from versions.lock
if [ -f "$SCRIPT_DIR/versions.lock" ]; then
    VERSION=$(grep -m1 'version:' "$SCRIPT_DIR/versions.lock" | awk '{print $2}' | tr -d '"')
else
    VERSION=$(grep -m1 -o '[0-9]\+\(\.[0-9]\+\)\{3\}' "$SCRIPT_DIR/vanadium/args.gn")
fi
export VERSION

echo "==> [Aether] Building Aether Browser (Chromium version: $VERSION)..."

# Ensure depot_tools is present
if [ ! -d "depot_tools" ]; then
    echo "==> [Aether] Cloning depot_tools..."
    git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
export PATH="$PWD/depot_tools:$PATH"

mkdir -p chromium/src/out/Default
cd chromium/src

if [ ! -d ".git" ]; then
    echo "==> [Aether] Initializing Chromium src repository..."
    git init
    git remote add origin "$CHROMIUM_SOURCE"
    git fetch --depth 1 "$CHROMIUM_SOURCE" "+refs/tags/$VERSION:chromium_$VERSION"
    git checkout "$VERSION"
fi

cp "$SCRIPT_DIR/.gclient" ../.gclient

echo "==> [Aether] Preparing Vanadium security base..."
# Remove GrapheneOS-specific and trichrome patches that do not apply to standalone APKs
rm -rf "$SCRIPT_DIR/vanadium/patches/"*trichrome-{apk-build-targets,browser-apk-targets}.patch || true
rm -rf "$SCRIPT_DIR/vanadium/patches/"*{detailed,supported}-language*.patch || true
rm -rf "$SCRIPT_DIR/vanadium/patches/"*javascript-optimizer-{site-setting,settings-UI}.patch || true
rm -rf "$SCRIPT_DIR/vanadium/patches/"*component-updates.patch || true
rm -rf "$SCRIPT_DIR/vanadium/patches/"*{pdf,PDF,for-content-public,toolbar-button,configs-from-config-app,config-app-parsing,new-tab-card,predictive-back}*.patch || true

# Rebrand Vanadium string references to Aether
replace "$SCRIPT_DIR/vanadium/patches" "VANADIUM" "AETHER"
replace "$SCRIPT_DIR/vanadium/patches" "Vanadium" "Aether"
replace "$SCRIPT_DIR/vanadium/patches" "vanadium" "aether"

echo "==> [Aether] Applying Vanadium patches..."
git am --whitespace=nowarn --keep-non-patch "$SCRIPT_DIR/vanadium/patches/"*.patch || {
    echo "Notice: Vanadium patches already applied or partially applied."
}

echo "==> [Aether] Running gclient sync and hooks..."
gclient sync -D --no-history --nohooks
gclient runhooks

if [ -f "./build/install-build-deps.sh" ]; then
    ./build/install-build-deps.sh --no-prompt --android || true
fi

echo "==> [Aether] Staging built-in uBlock Origin component extension..."
if [ -f "$SCRIPT_DIR/components/ublock/setup_ublock.py" ]; then
    python3 "$SCRIPT_DIR/components/ublock/setup_ublock.py" "$PWD/third_party/ublock"
fi

echo "==> [Aether] Applying Aether customization patch series..."
# shellcheck disable=SC1091
source "$SCRIPT_DIR/patch.sh"

echo "==> [Aether] Generating GN build configuration..."
cp "$SCRIPT_DIR/args.gn" out/Default/args.gn
gn gen out/Default

mkdir -p out/tmp out/release

echo "==> [Aether] Compiling arm64 target (chrome_public_apk & chrome_public_bundle)..."
autoninja -C out/Default chrome_public_apk chrome_public_bundle

ARM64_APK=$(find out/Default/apks -name '*Public*.apk' -o -name 'Chrome*.apk' | head -n 1)
ARM64_AAB=$(find out/Default/apks -name '*Public*.aab' -o -name 'Chrome*.aab' | head -n 1)

if [ -n "$ARM64_APK" ]; then
    cp "$ARM64_APK" "out/tmp/aether-$VERSION-arm64-v8a.apk"
fi
if [ -n "$ARM64_AAB" ]; then
    cp "$ARM64_AAB" "out/tmp/aether-$VERSION-arm64-v8a.aab"
fi

echo "==> [Aether] Signing release artifacts..."
export PATH="$PWD/third_party/jdk/current/bin/:$PATH"
export ANDROID_HOME="$PWD/third_party/android_sdk/public"

if [ -f "out/tmp/aether-$VERSION-arm64-v8a.apk" ]; then
    sign_apk "out/tmp/aether-$VERSION-arm64-v8a.apk" "out/release/aether-$VERSION-arm64-v8a.apk"
fi
if [ -f "out/tmp/aether-$VERSION-arm64-v8a.aab" ]; then
    sign_aab "out/tmp/aether-$VERSION-arm64-v8a.aab" "out/release/aether-$VERSION-arm64-v8a.aab"
fi

rm -rf "$SCRIPT_DIR/keys"
echo "==> [Aether] Build completed successfully! Artifacts in out/release/."
