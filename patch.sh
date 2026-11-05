#!/usr/bin/env bash
set -eo pipefail

export SCRIPT_DIR=$(realpath "$(dirname "$0")")

echo "==> [Aether] Applying resource overlays..."
mkdir -p chrome/android/java/res_aether_base/drawable
if [ -f "$SCRIPT_DIR/res/drawable/themed_app_icon.xml" ]; then
    cp "$SCRIPT_DIR/res/drawable/themed_app_icon.xml" chrome/android/java/res_aether_base/drawable/themed_app_icon.xml
fi

# Performance & Security manifest flags
sed -i 's|<application |<application android:extractNativeLibs="false" |' chrome/android/java/AndroidManifest.xml
sed -i 's|<data android:mimeType="message/rfc822"/>|<data android:mimeType="message/rfc822"/><data android:mimeType="application/pdf"/>|' chrome/android/java/AndroidManifest.xml

# Apply custom patch series from patches/series
if [ -f "$SCRIPT_DIR/patches/series" ]; then
    echo "==> [Aether] Applying patches/series..."
    while IFS= read -r patch_file || [ -n "$patch_file" ]; do
        # Ignore comments and empty lines
        [[ "$patch_file" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${patch_file// }" ]] && continue
        echo "--> Applying: $patch_file"
        git apply --whitespace=nowarn --verbose "$SCRIPT_DIR/$patch_file" || {
            echo "ERROR: Failed to apply $patch_file" >&2
            exit 1
        }
    done < "$SCRIPT_DIR/patches/series"
fi

export PATCHED=1
echo "==> [Aether] Patch application complete."
