# Phase 1: Reproducible Build Infrastructure (PH-1)

> **Phase ID:** `PH-1`  
> **Target Status:** First Testable Milestone  
> **Source Reference:** `plan.md` §7 (PH-1), §4.3, §5  

---

## 1. Goal

Set up an automated, reproducible build pipeline capable of compiling the clean base (Vanadium / Titanium per ADR-01) with our unique branding and signing key into an installable, runnable Android APK/AAB.

> [!TIP]
> This is the **first phase where you get an installable APK** to test on a physical phone (via USB or Wireless Debugging) or on an emulator.

---

## 2. Hard Rules & Constraints for this Phase

- **R-NO-INVENT:** Build flags and GN args must be verified against `gn args --list` and base project scripts. Do not guess build targets.
- **R-VERSION:** Lock exact commits/tags in `versions.lock` (Chromium version, Vanadium commit, base patch tag).
- **R-NO-SUBMODULE-EDITS:** Never edit upstream submodules in-place. All customizations must be applied via `patch.sh` consuming `patches/series`.
- **R-COMPILE:** The build must cleanly compile and produce signed artifacts on local machines and CI.

---

## 3. Tasks Breakdown

### `T-1.1` — Repository Skeleton & Versions Lock
- **Goal:** Set up the directory tree and version tracking file.
- **Repository Layout:**
  ```
  ├── .github/workflows/
  ├── vanadium/                 # git submodule pinned to exact commit
  ├── patches/
  │   ├── series                # ordered list of patches
  │   └── {{app}}/branding/
  ├── res/                      # replacement app icons, drawables, strings
  ├── docs/
  ├── .gclient
  ├── args.gn                   # release args
  ├── args.debug.gn             # debug / dev args
  ├── versions.lock
  ├── common.sh
  ├── patch.sh
  ├── build.sh
  └── sign.sh
  ```
- **File:** `versions.lock` containing:
  - Chromium exact version / tag
  - Vanadium submodule commit hash
  - Target build toolchain versions

---

### `T-1.2` — Build Scripts Engine (`common.sh`, `patch.sh`, `build.sh`, `sign.sh`)
- **Goal:** Provide reliable local & CI execution scripts.
- **Steps:**
  1. `common.sh`: Environment variables, paths, depot_tools setup, Python runtime checks.
  2. `patch.sh`: Automated application of `patches/series` against `src/` using `git apply` / `patch` with fuzz=0 verification.
  3. `build.sh`:
     - Run `gclient sync` at pinned version.
     - Execute `patch.sh`.
     - Run `gn gen out/Default --args="..."`.
     - Build target using `autoninja -C out/Default <target_apk>`.
  4. `sign.sh`: Automated APK signing and zip-aligning using `apksigner`.

---

### `T-1.3` — GN Arguments & Target Specification
- **Goal:** Pin down exact GN args and target APK definitions in `docs/BUILD.md`.
- **Requirements:**
  - Base GN flags: `target_os="android"`, `target_cpu="arm64"` (and `x86_64` for emulator).
  - Release vs. Debug profiles: optimizations, symbol levels, ProGuard/R8 configs.
  - Document the exact APK target (e.g. `chrome_public_apk` or base's custom bundle).

---

### `T-1.4` — App Branding & Package ID Customization
- **Goal:** Change app name, package identifier, and launcher icons without breaking build dependencies.
- **Changes:**
  - Package ID: `{{PACKAGE_ID}}` (defined in ADR-02).
  - App Name: `{{APP_NAME}}` (MUST NOT be "Helium" or "Titanium").
  - Drawables & Mipmaps: Launcher icons, monochrome icons, vector drawables in `res/`.
  - Patch creation: `patches/{{app}}/branding/0001-app-branding-and-package-id.patch`.

---

### `T-1.5` — GitHub Actions CI/CD Pipeline
- **Goal:** Automated reproducible builds and artifact publishing in CI.
- **Workflow:** `.github/workflows/build.yml`
  - Workflow dispatch (manual trigger) + release triggers.
  - Runner specification: large runner / self-hosted machine with ≥300 GB SSD & 32+ GB RAM.
  - Checkout caching strategy.
  - Signing from GitHub Secrets keystore.
  - GitHub build provenance / attestation generation.

---

### `T-1.6` — Developer Loop & Testing Guide
- **Goal:** Document local dev flow, incremental compilation, and device testing.
- **Topics in `docs/BUILD.md`:**
  - Incremental builds (`autoninja` rebuild loops).
  - USB testing: `adb install -r -d out/Default/apks/...`.
  - **Wireless Debugging:** Pairing (`adb pair`) and connecting (`adb connect`) over Wi-Fi.
  - Logcat inspection: `adb logcat -s chromium`.
  - Remote inspection via `chrome://inspect/#devices`.

---

## 4. Deliverables

1. Core automation scripts: `common.sh`, `patch.sh`, `build.sh`, `sign.sh`.
2. Initial configuration: `versions.lock`, `args.gn`, `args.debug.gn`, `.gclient`.
3. Branding patch: `patches/{{app}}/branding/`.
4. CI workflow: `.github/workflows/build.yml`.
5. Documentation: `docs/BUILD.md`.

---

## 5. Exit Criteria

- [ ] Clean build runs from scratch twice in a row in CI and succeeds without error.
- [ ] Signed APK installs cleanly on an emulator and a physical Android device alongside stock Chrome.
- [ ] App launches, can browse websites, and displays `{{APP_NAME}}` in the "About" screen.
