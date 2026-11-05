# Helium Desktop Patch Inventory & Analysis (T-0.3)

> **Document:** `docs/research/helium.md`  
> **Source Repository:** [`imputnet/helium`](https://github.com/imputnet/helium) (`helium-chromium`)  
> **License:** GNU General Public License v3.0 (GPL-3.0)  
> **Total Patches in Series:** 370  

---

## 1. Executive Summary

Helium for Desktop (Windows, macOS, Linux) by `imputnet` is an opinionated, minimalist, privacy-focused Chromium fork. It does not provide an official mobile build because its UI layer is built on desktop C++ Views (`chrome/browser/ui/views/`) rather than Android Java/XML.

This inventory maps all 370 patches in Helium's `patches/series` into functional groups to prepare for detailed triage in Phase 2.

---

## 2. Upstream Donor Patch Sets

| Group | Origin | Count | Key Focus Areas | Android Relevance |
|---|---|---|---|---|
| `upstream-fixes/` | Upstream backports | 2 | Missing build dependencies, wasm interpreter fixes | Check if needed on current Chromium. |
| `inox-patchset/` | Inox Browser | 6 | Disable RLZ, update pings, autofill manager, battery status | Highly relevant; mostly platform-agnostic C++. |
| `iridium-browser/` | Iridium Browser | 3 | Safe browsing disable reporting, disable profile auto-import | Mostly covered by Vanadium; check safe browsing flags. |
| `ungoogled-chromium/` | ungoogled-chromium | 68 | Disable Google host detection, GAIA, GCM, Webstore URLs, TRK blocking, referrer flags | Core foundation for de-Googling; many covered by Vanadium. |
| `bromite/` | Bromite project | 3 | Canvas/measureText fingerprinting mitigation, max connections flag | Fingerprinting flags can be evaluated for Android. |
| `debian/` | Debian Chromium | 1 | Disable Google API key missing infobar | Trivial, covered by GN args (`google_api_key = "x"`). |
| `brave/` | Brave Browser | 4 | Browser profile importer files, tab MRU cycling | Importers are desktop-only; MRU tab cycling concept can inspire Android tab switcher. |

---

## 3. Helium Core Patches (`helium/core/`)

Helium's custom patches constitute lines 103–238 (136 patches) of `patches/series`:

### 3.1 Services, Protocols, and Onboarding
- `helium/core/services-prefs.patch`, `services-schema-nag.patch`: Preferences for Helium Services backend (filter lists, extension proxying).
- `helium/core/override-chrome-protocol.patch`: Intercepts internal chrome schemes to point to Helium resources.
- `helium/core/onboarding-page.patch`: Custom local first-run onboarding.

### 3.2 Search Engine Defaults & Enhancements
- `helium/core/search/engine-defaults.patch`: Replaces default Google search with privacy-respecting alternatives (DuckDuckGo, Brave, Kagi).
- `helium/core/search/force-eu-search-features.patch`: Forces EU search choice provider mechanisms globally.

### 3.3 Decentralized Sync Subsystem (`helium/core/sync/*`)
- 17 dedicated patches implementing Helium's proprietary encrypted vault sync (`vault-format`, `vault-encryption`, `vault-transport`, `loopback-server-in-memory`).
- *Status for Android v1:* **DROPPED / OUT OF SCOPE** (desktop sync is still experimental; see `plan.md` §1.2).

### 3.4 Built-in uBlock Origin Subsystem
- `helium/core/ublock-setup-sources.patch`
- `helium/core/ublock-install-as-component.patch`: Injects uBO as a build-time component extension.
- `helium/core/ublock-reconfigure-defaults.patch`: Disables first-run tabs, enables cosmetic filters.
- `helium/core/ublock-helium-services.patch`: Routes filter-list update pings to Helium Services proxy.
- `helium/core/ublock-dns-uncloaking.patch`: Bridges Chromium DNS resolver to uBO for CNAME uncloaking.
- *Status for Android:* **HIGH PRIORITY MODEL** for Phase 5.

### 3.5 Fingerprinting Noise (`helium/core/noise/*`)
- Introduces pseudo-random subtle noise into HTML5 Canvas, Web Audio API, and Hardware Concurrency (`noise/core.patch`, `canvas.patch`, `audio.patch`, `hardware-concurrency.patch`).
- *Status for Android:* Candidate for Phase 3 / Phase 6 P1.

### 3.6 Network & Privacy Flags (`helium/core/network/*`)
- Global Privacy Control toggle (`network/global-privacy-control-pref.patch`).
- WebRTC default handling policy (`webrtc-default-handling-policy.patch`).
- QUIC v2 and Split ClientHello toggles (`split-clienthello.patch`).

---

## 4. Helium Settings & Views UI Patches

### 4.1 Settings (`helium/settings/`, 26 patches)
- Modifies desktop WebUI settings (`chrome/browser/resources/settings/`): removes Google Safety Hub, strips translate sections, restructures privacy menu.
- *Android Reality:* Chromium on Android uses native Android Java preferences (`PreferenceFragmentCompat`), not WebUI. All relevant settings changes must be **REIMPL** in Java.

### 4.2 Views UI (`helium/ui/`, 106 patches)
- Modifies desktop C++ Views (`chrome/browser/ui/views/`):
  - Compact toolbar height and layout constants.
  - Custom toolbar button visibility preferences (`toolbar-button-prefs.patch`).
  - Rounded window frame corners and titlebar buttons (`rounded-frame-corners.patch`).
  - Split View and Vertical Tabs (`split-view.patch`, `vertical.patch`).
  - Zen Mode auto-hiding chrome (`zen-mode.patch`).
- *Android Reality:* Android Chromium UI is written in Java and Android XML. Desktop Views patches **cannot compile on Android**. The functional concepts (compact toolbar, customizable action buttons, clean NTP, accent theming) must be implemented in Android Java.

---

## 5. Summary Conclusion for Android Port

1. **Port Candidates:** Helium's C++ network, search defaults, uBO component loader wiring, and noise patches are strong candidates for direct porting or adaptation.
2. **Re-implementation Targets:** All visual "Helium feel" items (toolbar customization, menus, settings, NTP) must be newly written in Java and XML.
3. **Drop Targets:** Desktop sync, desktop window frame geometry, and vertical sidebar tabs are dropped from our Android scope.
