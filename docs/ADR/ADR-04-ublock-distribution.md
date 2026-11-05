# ADR-04: Built-in uBlock Origin Distribution & Packaging Strategy

> **Status:** Accepted (Recommended)  
> **Date:** 2026-11-05  
> **Author:** Antigravity AI & Maintainer  
> **Deciders:** Project Maintainer  
> **Phase:** Phase 5 (Task `T-5.1`)  

---

## 1. Context & Problem Statement

Helium Desktop's signature feature is that ad-blocking and privacy filtering are powered by **uBlock Origin (uBO)** out-of-the-box, rather than a limited in-house ad-block engine. 

For Aether Browser on Android, we must determine:
1. **Source Upstream:** Whether to bundle official upstream `gorhill/uBlock` or imputnet's `imputnet/uBlock` fork.
2. **Packaging Mechanism:** Build-time component extension vs runtime auto-download on first launch vs user-initiated install.
3. **Licensing Compliance:** Reconciling uBO's GPL-3.0 with Vanadium's GPL-2.0-only and Chromium's BSD-3-Clause.
4. **Lifecycle & Immutability:** Protecting the extension from accidental deletion while granting users complete control over toggling and whitelisting.

---

## 2. Options Considered

### Option 1: Build-Time Component Extension from Upstream `gorhill/uBlock` (Recommended)
- Pack the pinned upstream release archive (`uBlock0_1.75.0.chromium.zip`, SHA-256 verified) into `third_party/ublock/` at build time.
- Register uBO via Chromium's `ComponentLoader` under extension ID `cjpalhdlnbpafiamejdnhcphjbkeiagm`.
- **Pros:**
  - 100% offline out-of-the-box protection on first application launch (zero pings, zero initial download delay).
  - Immutable against accidental uninstallation or malicious deletion.
  - Complete fidelity with upstream uBO filter engines and rulesets.
- **Cons:** Increases final APK size by ~4.8 MB.

### Option 2: First-Launch Silent Webstore Download
- Download uBO from the Chrome Web Store immediately on first browser launch.
- **Pros:** Smaller initial APK download.
- **Cons:** Violates the "Zero Unsolicited Requests" principle; leaves user unprotected on their very first web visits before download finishes; fails if user installs or launches the browser offline.

### Option 3: imputnet's Fork (`imputnet/uBlock`)
- Imputnet maintains patches for Helium Desktop to route list updates to Helium Services and disable first-run tabs.
- **Pros:** Closely mirrors desktop Helium defaults.
- **Cons:** Imputnet's fork is not continuously synchronized with upstream security tags, and requires Helium Services proxy infrastructure.

---

## 3. Decision

We choose **Option 1 (Build-Time Component Extension from Upstream `gorhill/uBlock`)**:

1. **Source & Version Pin:**
   - Source: Upstream Raymond Hill release `1.75.0` (Manifest V2).
   - Archive URL: `https://github.com/gorhill/uBlock/releases/download/1.75.0/uBlock0_1.75.0.chromium.zip`
   - Checksum: `49214674f7c6c474e60da647c05bd28463b1f7a55b2a2b0a53e9d297ef7bf3c6`
2. **Licensing Isolation (Mere Aggregation):**
   - As documented in [`docs/LICENSES.md`](../LICENSES.md), uBlock Origin runs exclusively within Chromium's sandboxed extension runtime.
   - The browser C++/Java code interacts with uBO solely across standardized public IPC boundaries (`chrome.webRequest`, `chrome.runtime`, `chrome.storage`).
   - This constitutes **mere aggregation** under Section 5 of GPL-3.0 and Section 2 of GPL-2.0, completely preserving license integrity.
3. **Component Extension Registration:**
   - Registered as a default component extension in `chrome/browser/extensions/component_loader.cc`.
   - Prevented from being uninstalled via `standard_management_policy_provider.cc`, but user can disable ad blocking or toggle site protection in 1 tap via the toolbar shield icon.
4. **Network Updates:**
   - Follows ADR-03: direct decentralized list updates with header stripping and user-configurable update toggle in Settings.
