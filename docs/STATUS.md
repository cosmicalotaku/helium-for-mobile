# Project Status & Execution Ledger

> **Last Updated:** 2026-11-06  
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
| **PH-6** | Helium-Feel UI & Customization | **DONE (P0)** | Compact 48dp toolbar, customizable buttons, clean menus, minimalist NTP, AMOLED theme, flat Aether Services settings. |
| **PH-7** | Hardening, Performance, QA | **READY** | Memory budgets, leak tests, crash audits, device performance. |
| **PH-8** | Release & Maintenance Automation | Pending | Awaiting PH-7 |
| **PH-9** | Optional Features (P2) | Backlog | Optional |

---

## 2. Phase 6 Task Reports

```
TASK: T-6.1 — UI Feature Specifications (docs/ui/FEAT-xx.md)
STATE: DONE
FILES: docs/ui/README.md, docs/ui/FEAT-12-compact-toolbar.md, docs/ui/FEAT-13-toolbar-customization.md, docs/ui/FEAT-14-trimmed-overflow-menu.md, docs/ui/FEAT-15-simplified-context-menus.md, docs/ui/FEAT-16-clean-new-tab-page.md, docs/ui/FEAT-17-theming-and-accents.md, docs/ui/FEAT-18-aether-services-settings.md, docs/ui/FEAT-23-tab-hibernation.md, docs/ui/FEAT-24-copy-urls.md, docs/ui/FEAT-25-zoom-presets.md, docs/ui/FEAT-26-offline-onboarding.md
EVIDENCE: Published 11 comprehensive UI architecture and feature design specifications covering mockups, affected Chromium Android Java/XML files, dimension constants, and SharedPreferences keys.
NEXT: T-6.2

TASK: T-6.2 — Compact & Customizable Toolbar Layout
STATE: DONE
FILES: patches/aether/ui/0015-compact-and-customizable-toolbar.patch, patches/series
EVIDENCE: Authored unified patch reducing toolbar dimensions to compact 48dp (dimens.xml), 40dp action targets, 36dp omnibox pill; added share/new-tab action views in toolbar_phone.xml; implemented dynamic updateCustomToolbarButtons() in ToolbarPhone.java; added ToolbarCustomizationSettings fragment and XML preferences; added strings to android_chrome_strings.grd.
NEXT: T-6.3

TASK: T-6.3 — Simplified Overflow & Context Menus
STATE: DONE
FILES: patches/aether/ui/0016-clean-overflow-and-context-menus.patch, patches/series
EVIDENCE: Stripped Google sign-in promos, help and feedback, and sync banners from 3-dot menu; added direct Copy Link action; cleaned context menus in ChromeContextMenuPopulator.java by removing tab group nesting and reading list clutter.
NEXT: T-6.4

TASK: T-6.4 — Minimalist Clean New Tab Page (NTP)
STATE: DONE
FILES: patches/aether/ui/0017-minimalist-clean-new-tab-page.patch, patches/series
EVIDENCE: Suppressed Google Discover feed coordinator and article prefetching; removed ExploreSites placeholders; centered search omnibox vertically and added user toggle for top shortcut tiles in NewTabPageLayout.java.
NEXT: T-6.5

TASK: T-6.5 — AMOLED Pure Black & Accent Theming
STATE: DONE
FILES: patches/aether/ui/0018-amoled-pure-black-and-accent-theming.patch, patches/series
EVIDENCE: Added #000000 AMOLED pure black theme option to ThemeSettingsFragment; mapped pure black toolbar and top UI backgrounds in ThemeUtils.java; defined Helium Amber, Neon Cyan, Violet, and Emerald palette color tokens.
NEXT: T-6.6

TASK: T-6.6 — Settings Restructure & Aether Services Page
STATE: DONE
FILES: patches/aether/settings/0019-aether-services-and-flat-settings.patch, patches/series
EVIDENCE: Flattened settings hierarchy, removed Google account sync header from main_preferences.xml, created AetherServicesSettings fragment and XML layout with transparent toggles for ad blocking, filter updates, extension updates, search suggestions, and prefetching.
NEXT: Phase 7 (Hardening, Performance, QA) or CI Build Trigger
```

---

## 3. Phase 5 Task Reports

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
