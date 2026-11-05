# Phase 5: Built-in uBlock Origin (PH-5)

> **Phase ID:** `PH-5`  
> **Target Status:** Core Feature Milestone  
> **Source Reference:** `plan.md` §7 (PH-5), §10, §6 (FEAT-09, FEAT-10)  

---

## 1. Goal

Integrate the full Manifest V2 edition of **uBlock Origin** directly into the browser as a pre-installed, build-time component extension that operates out-of-the-box on first launch with dedicated mobile UI quick toggles.

---

## 2. Features Implemented in this Phase

| ID | Feature | Priority | Strategy | Description |
|---|---|---|---|---|
| `FEAT-09` | Built-in uBO as a component extension | P0 | REIMPL (model on Helium) | Packaged at build time, pre-activated, protected from accidental deletion. |
| `FEAT-10` | uBO quick toggle on toolbar / menu | P0 | REIMPL | 1-tap toggle or popup access, long-press for site whitelisting. |

---

## 3. Architecture & Packaging Details

1. **Source & Pinned Release:**
   - Default upstream: Raymond Hill's (`gorhill/uBlock`) tagged releases.
   - Alternate: imput's fork (`imputnet/uBlock`) if authorized in ADR-04.
   - Pinned metadata in `components/ublock/`:
     - Version string
     - Source archive URL
     - SHA-256 integrity checksum
2. **Build-Time Component Registration:**
   - Download and unpack uBO assets at build time into `third_party/ublock/`.
   - Register uBO in Chromium's component extension loader for Android (locate the Android equivalent of desktop `ComponentLoader::AddDefaultComponentExtensions`).
3. **Lifecycle & Persistence:**
   - Active immediately upon first launch without user prompts.
   - Cannot be uninstalled, but can be disabled via toggle.
   - "Reset to Defaults" option available in browser settings.
4. **Filter List Updates:**
   - Rule/list updates follow the architecture decided in ADR-03 (direct or proxied).
   - Configurable update intervals and manual "Update Now" button.
   - Component extension code itself updates only when the browser app is updated.

---

## 4. Mobile UI Integration

- **Dedicated Toolbar Icon:**
  - Shield / power icon integrated into the top bar (configurable in toolbar settings).
  - Single tap: Opens uBO popup in bottom sheet.
  - Long press: Instantly toggles blocking for the current origin.
- **Overflow Menu Entry:**
  - "Ad Blocking" row showing current site status (Blocked: X elements).
- **Settings Deep-Link:**
  - Direct shortcut from Browser Settings -> "Ad Blocking" -> Opens uBO dashboard options tab.

---

## 5. Tasks Breakdown

### `T-5.1` — Component Extension Build Pipeline
- **Goal:** Automate downloading, checksum verification, and packaging of uBO during build.
- **Location:** `components/ublock/` and integration in `build.sh`.

---

### `T-5.2` — Android Component Loader Registration
- **Goal:** Ensure uBO is loaded as an immutable component extension on Android.
- **Files Touched:** Investigate `chrome/browser/extensions/component_loader.cc` and Android-specific initialization paths.
- **Patch Area:** `patches/{{app}}/ublock/0001-register-builtin-ublock.patch`.

---

### `T-5.3` — Mobile Quick-Toggle & Touch UI Adaptations
- **Goal:** Build Android UI controls and ensure uBO touch gestures work smoothly.
- **Tasks:**
  - Create toolbar button drawable and action listener in Java.
  - Fix element zapper / element picker to work with touch events instead of desktop hover states.
  - Ensure cosmetic filtering rules inject properly into mobile layouts.

---

### `T-5.4` — Filter Update Engine Integration
- **Goal:** Connect uBO list downloads to the network routing established in ADR-03.
- **Expose:** User toggle in "{{APP_NAME}} Services" settings to turn off automatic filter updates if desired.

---

## 6. Exit Criteria

- [x] uBlock Origin is active immediately on fresh app launch with zero user interaction.
- [x] Major ad-heavy test sites (and ad-blocker test suites) show ads blocked correctly.
- [x] Element picker works using mobile touchscreen taps.
- [x] Tapping toolbar button opens the uBO interface in ≤ 1 tap.
- [x] Filter list updates work without leaking client tracking data.
