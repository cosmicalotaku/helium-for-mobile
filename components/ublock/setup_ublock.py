#!/usr/bin/env python3
"""
uBlock Origin Build-Time Component Extension Stager
Downloads, verifies SHA-256, and extracts uBlock Origin (MV2) into third_party/ublock/
for bundling into Aether Browser.
"""

import hashlib
import os
import sys
import urllib.request
import zipfile

UBLOCK_VERSION = "1.75.0"
UBLOCK_URL = f"https://github.com/gorhill/uBlock/releases/download/{UBLOCK_VERSION}/uBlock0_{UBLOCK_VERSION}.chromium.zip"
EXPECTED_SHA256 = "49214674f7c6c474e60da647c05bd28463b1f7a55b2a2b0a53e9d297ef7bf3c6"

def stage_ublock(target_dir):
    os.makedirs(target_dir, exist_ok=True)
    cache_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cache")
    os.makedirs(cache_dir, exist_ok=True)
    zip_path = os.path.join(cache_dir, f"uBlock0_{UBLOCK_VERSION}.chromium.zip")

    # Download if not cached
    if not os.path.exists(zip_path):
        print(f"==> [uBlock Stager] Downloading uBlock Origin {UBLOCK_VERSION}...")
        headers = {'User-Agent': 'AetherBrowser-BuildEngine/1.0'}
        req = urllib.request.Request(UBLOCK_URL, headers=headers)
        with urllib.request.urlopen(req) as resp, open(zip_path, 'wb') as out_f:
            out_f.write(resp.read())
    else:
        print(f"==> [uBlock Stager] Found cached archive: {zip_path}")

    # Verify SHA-256
    print("==> [uBlock Stager] Verifying SHA-256 integrity checksum...")
    sha256 = hashlib.sha256()
    with open(zip_path, 'rb') as f:
        for chunk in iter(lambda: f.read(65536), b''):
            sha256.update(chunk)
    digest = sha256.hexdigest()

    if digest != EXPECTED_SHA256:
        print(f"ERROR: Checksum mismatch! Expected {EXPECTED_SHA256}, got {digest}", file=sys.stderr)
        sys.exit(1)
    print(f"==> [uBlock Stager] Checksum verified: {digest}")

    # Extract to target directory
    print(f"==> [uBlock Stager] Extracting uBO assets to {target_dir}...")
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(target_dir)

    print("==> [uBlock Stager] Generating third_party/ublock/BUILD.gn...")
    build_gn_content = '''# Copyright 2026 The Aether Browser Authors. All rights reserved.
# Use of this source code is governed by a GPL-3.0 license that can be
# found in the LICENSE file.

import("//chrome/common/features.gni")
import("//tools/grit/grit_rule.gni")

grit("ublock_resources") {
  source = "ublock_resources.grd"
  outputs = [
    "grit/ublock_resources.h",
    "grit/ublock_resources_map.cc",
    "grit/ublock_resources_map.h",
    "ublock_resources.pak",
  ]
  output_dir = "$root_gen_dir/third_party/ublock"
}
'''
    with open(os.path.join(target_dir, "BUILD.gn"), 'w', encoding='utf-8') as gn_f:
        gn_f.write(build_gn_content)

    print("==> [uBlock Stager] uBlock Origin component staging completed successfully.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        target = sys.argv[1]
    else:
        # Default target path relative to chromium source root
        target = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "chromium", "src", "third_party", "ublock")
    stage_ublock(target)
