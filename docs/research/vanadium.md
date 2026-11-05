# Vanadium Security & Privacy Audit (T-0.2)

> **Document:** `docs/research/vanadium.md`  
> **Source Repository:** [`GrapheneOS/Vanadium`](https://github.com/GrapheneOS/Vanadium)  
> **License:** GNU General Public License v2.0 only (GPL-2.0-only)  
> **Base Target:** Chromium on Android (`target_os = "android"`)  

---

## 1. Executive Summary

Vanadium is the hardened, privacy-oriented Chromium fork developed by the GrapheneOS project for Android. It serves as the base layer in our architecture. It provides world-class compiler-level security hardening, process sandboxing enhancements, and extensive baseline de-Googling out of the box.

---

## 2. Core Categories of Vanadium Patches

Vanadium carries over 300 individual patches in its `patches/` directory, categorized into four major domains:

### 2.1 Compiler Hardening & Memory Safety
- **Stack Protection:**
  - `0009-enable-stack-clash-protection-for-arm64-targets.patch`
  - `0010-switch-to-fstack-protector-strong.patch`
  - `0014-Only-enable-shadow_call_stack-on-android-arm64-targe.patch`
  - `0015-Use-fstack-protector-strong-with-shadow-call-stack-w.patch`
- **Variable Initialization & Integer Wrap:**
  - `0011-enable-fwrapv-in-Clang-for-non-UBSan-builds.patch` (well-defined signed integer overflow).
  - `0012-enable-ftrivial-auto-var-init-zero.patch` (automatic zero-initialization of uninitialized stack variables).
- **Process Sandboxing & JIT Control:**
  - `00234-Support-restriction-of-dynamic-code.patch`
  - `00235-Restriction-of-dynamic-code-execution-via-seccomp-bp.patch` (seccomp-bpf filters preventing dynamic W^X code execution).
  - `00252-Enable-origin-keyed-process-isolation-by-default.patch` (process isolation per origin rather than site).
  - `00278-Start-child-processes-in-JITless-mode-based-on-OS-co.patch` (optional JIT-less V8 execution).

### 2.2 Privacy & De-Googling (Built-in)
Vanadium already turns off a significant portion of Google's unsolicited network traffic:
- `0070-disable-first-run-welcome-page.patch` (no Google account onboarding).
- `0072-disable-seed-based-field-trials.patch` & `0073-disable-fetching-variations.patch` (stops Google remote experiment/config pings).
- `0075-disable-Media-Integrity-blink-extension-API-on-webvi.patch` (blocks Web Environment Integrity / DRM attestation).
- `0076-disable-navigation-error-correction-by-default.patch` (stops sending mistyped URLs to Google servers).
- `0077-disable-contextual-search-by-default.patch` (disables Google Search tap-to-search telemetry).
- `0078-disable-network-prediction-by-default.patch` (disables unsolicited prefetching).
- `0079-disable-metrics-by-default.patch` (disables UMA telemetry).
- `0080-disable-hyperlink-auditing-by-default.patch` (disables HTML `ping` tracking).
- `0081-disable-showing-popular-sites-by-default.patch` & `0082-disable-article-suggestions-feature-by-default.patch` (no Google Discover feed).
- `0247-Disable-password-leak-detection-by-default.patch` & `0248-Further-disable-password-leak-detection-checks.patch` (no hashed password uploads to Google).
- `0254-disable-misleading-new-tab-cards-by-default.patch` (clean new tab page).

### 2.3 Standalone Password Manager (Local SQLite Database)
Google Chromium removed local password database storage on Android, requiring Google Play Services and Google Password Manager. Vanadium explicitly restores the local SQLite database backend:
- `0265-Revert-removal-of-database-for-local-password-manage.patch`
- `0266-Restore-build-args-of-using-login-database-as-backen.patch` (`use_login_database_as_backend = true`)
- `0273-Restore-local-password-manager-UI.patch`  
This allows completely offline, non-Google password management on device.

### 2.4 Downstream Patches to Filter / Adapt
Because Vanadium is tailored for GrapheneOS system builds, several patches require filtering when building standalone APKs:
- **Trichrome & System WebView targets:** Patches building Trichrome library bundles (`*trichrome-*.patch`) do not apply to standalone `chrome_public_apk`.
- **GrapheneOS Config App:** Patches relying on the GrapheneOS configuration IPC provider (`*configs-from-config-app*.patch`) must be excluded.
- **Language / Font Packs:** Standalone APKs bundle necessary resources directly rather than through dynamic split downloads.

---

## 3. Benefits & Gaps for Our Project

### What Vanadium Gives Us For Free:
1. Robust memory safety and compiler mitigations.
2. Complete elimination of Google variations, UMA metrics, navigation error pings, and Discover feeds.
3. Fully functional offline password manager independent of Google Play Services.

### What Vanadium Lacks (To Be Added by Our Layers):
1. **No Extension Runtime:** Vanadium strictly follows upstream Chromium in disabling extensions on Android.
2. **No Manifest V2 Support:** Must be supplied by our Titanium-derived layer.
3. **No Built-in Ad-Blocker:** Does not bundle uBlock Origin.
4. **Standard Chrome UI:** Retains standard Android Chromium layout rather than Helium's compact, customizable toolbar and accent colors.
