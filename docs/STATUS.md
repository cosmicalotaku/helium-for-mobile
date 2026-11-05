# Project Status & Execution Ledger

> **Last Updated:** 2026-11-05  
> **App Name:** Aether Browser (`aether`)  
> **Package ID:** `app.aether.browser`  

---

## 1. Phase Status Summary

| Phase | Title | Status | Deliverables & Exit Criteria |
|---|---|---|---|
| **PH-0** | Discovery, Decisions, Legal Gate | **DONE** | All 3 research docs, `LICENSES.md`, ADR-01..03 signed off. |
| **PH-1** | Reproducible Build Infrastructure | **DONE** | Build engine (`build.sh`, `patch.sh`, `sign.sh`), GN configs, branding, CI workflow, build guide. |
| **PH-2** | Patch Triage Ledger | **DONE** | 100% of Helium desktop patches triaged in `docs/PATCH_LEDGER.yaml` & `docs/PATCH_TRIAGE_SUMMARY.md`. |
| **PH-3** | Privacy & De-Googling Core | **DONE** | 5 core privacy patches, `docs/DEFAULTS.md`, `docs/NETWORK_ENDPOINTS.md` completed. |
| **PH-4** | Extensions Runtime & MV2 | **DONE** | Full Manifest V2 un-guarding, mobile Web Store install support, SAF picker, responsive popups, and 7-extension matrix verified. |
| **PH-5** | Built-in uBlock Origin | **DONE** | Build-time component extension, toolbar shield quick-toggle, touch element picker, privacy settings, and verification guide completed. |
| **PH-6** | Helium-Feel UI & Customization | **READY** | Java/XML compact toolbar, button customization, clean NTP, accent palettes. |
| **PH-7** | Hardening, Performance, QA | Pending | Awaiting PH-6 |
| **PH-8** | Release & Maintenance Automation | Pending | Awaiting PH-7 |
| **PH-9** | Optional Features (P2) | Backlog | Optional |

---

## 2. Phase 5 Task Reports

```
TASK: T-5.1 — Architecture Decision Record & Packaging Pipeline
STATE: DONE
FILES: docs/ADR/ADR-04-ublock-distribution.md, components/ublock/setup_ublock.py, build.sh
EVIDENCE: Established ADR-04 for upstream Raymond Hill uBO (1.75.0 MV2); created SHA-256 automated stager script; integrated build-time asset packaging into build.sh.
NEXT: T-5.2

TASK: T-5.2 — Android Component Loader Registration [SECURITY-REVIEW]
STATE: DONE
FILES: patches/aether/ublock/0012-register-builtin-ublock-component.patch
EVIDENCE: Registered uBlock Origin (ID: cjpalhdlnbpafiamejdnhcphjbkeiagm) in ComponentLoader::AddDefaultComponentExtensions and allowlist.cc; enforced immutability while preserving user settings toggling in standard_management_policy_provider.cc.
NEXT: T-5.3

TASK: T-5.3 — Mobile Quick-Toggle & Touch UI Adaptations
STATE: DONE
FILES: patches/aether/ublock/0013-ublock-mobile-ui-and-touch-actions.patch
EVIDENCE: Injected ublock_quick_button shield icon into toolbar_phone.xml; implemented 1-tap popup bottom-sheet launch and long-press active site origin toggle in ToolbarPhone.java; added "Ad Blocking" row to 3-dot overflow menu; adapted element picker for touchscreen gestures.
NEXT: T-5.4

TASK: T-5.4 — Filter Update Engine Integration & Privacy Settings
STATE: DONE
FILES: patches/aether/ublock/0014-ublock-filter-updates-and-privacy-settings.patch
EVIDENCE: Added user toggle for automatic filter-list updates in Android PrivacySettings; added deep-link to uBO dashboard; configured decentralized anonymized network fetching per ADR-03.
NEXT: T-5.5

TASK: T-5.5 — Built-in uBO Verification & Quality Assurance
STATE: DONE
FILES: docs/UBLOCK_INTEGRATION.md
EVIDENCE: Documented full integration lifecycle, acid test page results (100% ad slots collapsed, zero telemetry pings), touch element picker tests, and hardware performance metrics on Samsung Galaxy A15 5G.
NEXT: Phase 6 (Helium-Feel UI & Customization)
```

---

## 3. Phase 4 Task Reports

```
TASK: T-4.1 — Extension Runtime Enablement & Process Priority
STATE: DONE
FILES: patches/aether/extensions/0007-desktop-android-runtime-and-process-priority.patch, docs/EXTENSIONS.md
EVIDENCE: Enabled desktop Android extension feature overrides; elevated --extension-process importance to ChildProcessImportance.IMPORTANT to survive Android LMK.
NEXT: T-4.2

TASK: T-4.2 — Re-Enable Manifest V2 (MV2) on Android [SECURITY-REVIEW]
STATE: DONE
FILES: patches/aether/extensions/0008-mv2-support-and-deprecation-bypass.patch, docs/MV2.md
EVIDENCE: Restored browser_action/page_action uncompiled API declarations; bypassed kHardDisable to kNone in webstore_private_api.cc; forced g_allow_mv2_for_testing = true in manifest_v2_handler.cc. Completed full security review.
NEXT: T-4.3

TASK: T-4.3 — Chrome Web Store Mobile Detection Fix
STATE: DONE
FILES: patches/aether/extensions/0009-cws-mobile-install-support.patch
EVIDENCE: Automatically set ContentSetting.ALLOW for ContentSettingsType.REQUEST_DESKTOP_SITE on [*.]chromewebstore.google.com, rendering "Add to Chrome" button on phone viewports without manual toggles.
NEXT: T-4.4

TASK: T-4.4 — Off-Store Installation & SAF Folder Picker [SECURITY-REVIEW]
STATE: DONE
FILES: patches/aether/extensions/0010-off-store-and-saf-unpacked-install.patch
EVIDENCE: Allowed CRX downloads from chrome-extension:// schemes and Opera/Edge add-on repositories; fixed DocumentsContract tree URI fastId resolution in VirtualDocumentPath.java for unpacked extensions.
NEXT: T-4.5

TASK: T-4.5 — Mobile Extension UI & Action Popups
STATE: DONE
FILES: patches/aether/extensions/0011-mobile-extension-ui-and-popups.patch
EVIDENCE: Injected extensions_toolbar_container_stub into toolbar_phone.xml; implemented phone form factor auto-resize override in extension_action_popup_contents.cc and ExtensionActionPopup.java; made chrome://extensions responsive.
NEXT: T-4.6

TASK: T-4.6 — Run Extension Compatibility Matrix
STATE: DONE
FILES: docs/EXTENSION_COMPATIBILITY.md
EVIDENCE: Validated 7 key extensions (uBlock Origin full MV2, uBlock Origin Lite MV3, Bitwarden, Dark Reader, SponsorBlock, Violentmonkey, DeepL Translation); verified background execution, popup responsiveness, and restart persistence.
NEXT: Phase 5 (Built-in uBlock Origin)
```

---

## 4. Phase 3 Task Reports

```
TASK: T-3.1 — Port Core Platform-Agnostic Privacy Patches
STATE: DONE
FILES: patches/aether/privacy/0002-degoogle-unsolicited-requests.patch, patches/aether/core/0004-search-engine-defaults.patch
EVIDENCE: Blocked unsolicited SafeBrowsing telemetry pings, stripped X-Client-Data, set DuckDuckGo as default search engine.
NEXT: T-3.2

TASK: T-3.2 — Audit & Remove Android Google Entrypoints
STATE: DONE
FILES: patches/aether/privacy/0005-remove-android-google-entrypoints.patch
EVIDENCE: Suppressed Google Lens search by image from context menus, disabled educational promotional nags.
NEXT: T-3.3

TASK: T-3.3 — Implement Privacy Default Preferences (HOP Equivalent)
STATE: DONE
FILES: patches/aether/privacy/0003-privacy-default-preferences.patch, docs/DEFAULTS.md
EVIDENCE: Turned off search suggestions by default, disabled network prediction prefetching, enabled HTTPS-First auto-upgrade.
NEXT: T-3.4

TASK: T-3.4 — Network Silence Audit & Endpoints Registry
STATE: DONE
FILES: docs/NETWORK_ENDPOINTS.md, patches/aether/privacy/0006-anonymize-cws-extension-requests.patch
EVIDENCE: Registered 100% of allowed outbound traffic with explicit user toggles; audited zero-unprompted-request baseline.
NEXT: Phase 4 (Extensions Runtime & MV2)
```
