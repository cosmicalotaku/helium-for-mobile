# Phase 4: Extensions Runtime and MV2 Support (PH-4)

> **Phase ID:** `PH-4`  
> **Target Status:** P0 Critical Path  
> **Source Reference:** `plan.md` §7 (PH-4), §3.3, §9, §6 (FEAT-04 to FEAT-08)  

---

## 1. Goal

Enable a full-featured extension system in Chromium for Android, including **Manifest V2 (MV2)** re-enablement, mobile Chrome Web Store installation without desktop toggles, sideloading (CRX/ZIP/SAF), and native Android popup/options UI.

> [!IMPORTANT]
> Full uBlock Origin requires Manifest V2 (`webRequestBlocking`). Because upstream Chromium is deprecating MV2 and limiting desktop-Android extensions to MV3, this phase is the project's most technically critical and security-sensitive milestone.

---

## 2. Features Implemented in this Phase

| ID | Feature | Priority | Strategy | Description |
|---|---|---|---|---|
| `FEAT-04` | Extension runtime on Android | P0 | ADOPT | Enable extension service, process management, and core APIs on Android. |
| `FEAT-05` | MV2 support on Android | P0 | ADOPT | Re-enable Manifest V2 and persistent background pages on Android. |
| `FEAT-06` | Install from Chrome Web Store in mobile mode | P0 | REIMPL | Make "Add to Chrome" button functional without requiring "Desktop site" toggle. |
| `FEAT-07` | Install local CRX/ZIP & unpacked via SAF | P0 | ADOPT | Allow sideloading and developer testing using Android Storage Access Framework. |
| `FEAT-08` | Native extension UI (Actions, Popups, Manage) | P0 | ADOPT + REIMPL | Extension menu, toolbar actions, and responsive bottom-sheet popups. |

---

## 3. Technical Deep Dive & Upstream Build Flags

Upstream Chromium divides extension code behind build flags:
- `ENABLE_EXTENSIONS`: Historically desktop-only (Win/Mac/Linux/ChromeOS).
- `ENABLE_EXTENSIONS_CORE`: Shared extension infrastructure compiled on Android.
- `ENABLE_DESKTOP_ANDROID_EXTENSIONS`: Code running on experimental desktop-Android.
- `IS_ANDROID`: Guard used across Chromium, often used upstream to disable MV2.

### Known Hard Problems
1. **MV2 Upstream Deprecation:** Keep all MV2 patches isolated in `patches/{{app}}/extensions/mv2/` so conflicts can be diagnosed cleanly every monthly rebase.
2. **Process Model & Memory:** Each active extension spawns background worker or renderer processes.
3. **Popup Sizing:** Desktop extensions expect fixed pixel sizes (~350x500px). On mobile, popups must render cleanly in responsive bottom sheets or modal dialogs.

---

## 4. Tasks Breakdown

### `T-4.1` — Extension Runtime Enablement
- **Goal:** Enable core extension subsystems on Android via GN args and baseline patches.
- **Adopted from:** Titanium Browser extension foundation (`args.gn` + extension patches).
- **Deliverable:** Document all required flags in `docs/EXTENSIONS.md`.

---

### `T-4.2` — Re-Enable Manifest V2 (MV2) on Android `[SECURITY-REVIEW]`
- **Goal:** Neutralize all MV2 deprecation blocks and Android-specific exclusions.
- **Steps:**
  1. Search for `kExtensionManifestV2Deprecation` and related feature flags.
  2. Un-guard MV2 permissions (`webRequest`, `webRequestBlocking`) for Android targets.
  3. Ensure persistent background scripts and event pages can execute.
- **Deliverable:** `docs/MV2.md` detailing every guard bypassed and patch file in `patches/{{app}}/extensions/`.

---

### `T-4.3` — Mobile Chrome Web Store Installation Fix
- **Goal:** Allow users to install extensions directly from `chromewebstore.google.com` on phone browsers.
- **Steps:**
  1. Patch Web Store inline install detection to recognize mobile user-agents or inject required client attributes.
  2. Make the "Add to Chrome" button visible and clickable without switching to desktop mode.
  3. Hook the download and install pipeline to Android confirmation dialogs.

---

### `T-4.4` — Off-Store Installation & SAF Picker `[SECURITY-REVIEW]`
- **Goal:** Support local sideloading of `.crx` / `.zip` files and unpacked extensions.
- **Steps:**
  1. Integrate Android Storage Access Framework (SAF) file picker into `chrome://extensions`.
  2. Implement archive verification, signature checks, and permission warning prompts.
  3. Ensure extensions persist properly across app reboots and data migrations.

---

### `T-4.5` — Android-Native Extension UI & Action Popups
- **Goal:** Deliver mobile-friendly UI entry points for extensions.
- **Components:**
  1. **Overflow Menu Entry:** "Extensions" item listing installed extensions.
  2. **Toolbar Action Button:** Quick access icon showing badge notifications.
  3. **Popup Container:** Render extension popups inside a responsive Material bottom sheet instead of a floating desktop window.
  4. **Options Page:** Open extension options as dedicated browser tabs.

---

### `T-4.6` — Compatibility Matrix Verification
- **Goal:** Validate extension functionality against the required test matrix:

| Extension | Manifest | Expected Functionality |
|---|---|---|
| **uBlock Origin (full)** | MV2 | Full blocking, element picker, logger, dynamic filtering |
| **uBlock Origin Lite** | MV3 | Declarative Net Request rules, basic site toggles |
| **Bitwarden** | MV3 | Vault unlock popup, autofill overlay, biometrics prompt |
| **Dark Reader** | MV2/MV3 | Global & per-site theme injection, no frame drops |
| **SponsorBlock** | MV3 | Video segment skip injection on YouTube |
| **Violentmonkey / Tampermonkey**| MV2/MV3 | Custom user-scripts injection and script management |
| **Translation Extension** | MV3 | Selected text translation context menus |

---

## 5. Exit Criteria

- [x] All 7 extensions in the test matrix install, execute, and survive browser restarts.
- [x] Full MV2 uBlock Origin runs from CWS with element picker and dashboard working.
- [x] Popups render responsively on screens from 5.5" to 6.7" without text clipping.
- [x] Code changes in `patches/{{app}}/extensions/` pass mandatory `SECURITY-REVIEW`.
