# Aether Browser — UI Design Specifications Index (`docs/ui/`)

> **Phase Reference:** `PH-6` (Helium-Feel UI & Customization)  
> **Source Task:** `T-6.1` (UI Feature Specifications)  
> **Target Package:** `app.aether.browser`  
> **Status:** Active / Approved Specification

---

## 1. Design Philosophy: The Helium Feel on Mobile

Helium Desktop is recognized for its distraction-free, minimalist aesthetic, user sovereignty over the browser frame, and absence of Google promotional noise. 

Porting this to Android requires replacing Chromium's default bloated phone UI with a clean, ergonomic, and customizable interface:

1. **Maximum Viewport Real Estate:** Modern phone aspect ratios (19.5:9, 20:9) lose excessive space to oversized toolbars. Aether introduces a **compact 48dp toolbar** (vs. standard 56dp/64dp), minimizing chrome overhead.
2. **User Layout Sovereignty:** Users decide exactly which buttons occupy the toolbar (Home, Share, New Tab, Extensions, uBO Shield).
3. **Zero Promotional Noise:** Total eradication of Google account sign-in banners, Discover feeds, Google Lens nags, and educational tooltips.
4. **OLED Ergonomics:** True **Pure Black (AMOLED `#000000`)** dark theme alongside dynamic **Material You (Android 12+)** and signature **Helium Amber** accent palettes.
5. **Honest, Flat Settings:** A transparent "Aether Services" settings screen exposing every single network-active feature with a granular toggle.

---

## 2. Specification Directory

### P0 (Core Milestone Specifications)

| Spec Document | Feature ID | Title | Key Implementation Classes |
|---|:---:|---|---|
| [**`FEAT-12-compact-toolbar.md`**](FEAT-12-compact-toolbar.md) | `FEAT-12` | **Compact Toolbar Layout** | `ToolbarPhone.java`, `toolbar_phone.xml`, `dimens.xml` |
| [**`FEAT-13-toolbar-customization.md`**](FEAT-13-toolbar-customization.md) | `FEAT-13` | **Customizable Toolbar Buttons** | `ToolbarPhone.java`, `ToolbarCustomizationSettings.java` |
| [**`FEAT-14-trimmed-overflow-menu.md`**](FEAT-14-trimmed-overflow-menu.md) | `FEAT-14` | **Trimmed 3-Dot Overflow Menu** | `AppMenuPropertiesDelegateImpl.java`, `main_menu.xml` |
| [**`FEAT-15-simplified-context-menus.md`**](FEAT-15-simplified-context-menus.md) | `FEAT-15` | **Simplified Context Menus** | `ChromeContextMenuPopulator.java`, `ContextMenuHelper.java` |
| [**`FEAT-16-clean-new-tab-page.md`**](FEAT-16-clean-new-tab-page.md) | `FEAT-16` | **Minimalist New Tab Page (NTP)** | `NewTabPageLayout.java`, `FeedSurfaceCoordinator.java` |
| [**`FEAT-17-theming-and-accents.md`**](FEAT-17-theming-and-accents.md) | `FEAT-17` | **AMOLED Black & Material You Theming** | `ThemeUtils.java`, `TopUiThemeColorProvider.java` |
| [**`FEAT-18-aether-services-settings.md`**](FEAT-18-aether-services-settings.md) | `FEAT-18` | **Flat Settings & Aether Services Page** | `MainSettings.java`, `AetherServicesSettings.java` |

### P1 (Post-Core Enhancements)

| Spec Document | Feature ID | Title | Target Subsystem |
|---|:---:|---|---|
| [**`FEAT-23-tab-hibernation.md`**](FEAT-23-tab-hibernation.md) | `FEAT-23` | **Tab Hibernation (RAM Saver)** | `TabModelSelectorTabModelObserver.java`, `TabState.java` |
| [**`FEAT-24-copy-urls.md`**](FEAT-24-copy-urls.md) | `FEAT-24` | **Copy URL(s) from Tab Switcher** | `TabGridDialogCoordinator.java`, `TabListMediator.java` |
| [**`FEAT-25-zoom-presets.md`**](FEAT-25-zoom-presets.md) | `FEAT-25` | **Granular Zoom Presets & Default Zoom** | `PageZoomPreference.java`, `HostZoomMap.java` |
| [**`FEAT-26-offline-onboarding.md`**](FEAT-26-offline-onboarding.md) | `FEAT-26` | **100% Offline First-Run Onboarding** | `FirstRunActivity.java`, `AetherOnboardingCoordinator.java` |

---

## 3. Implementation Workflow

For each specification:
1. Locate target Java/XML source paths using `rg` in Chromium tree.
2. Produce targeted patch unified diffs under `patches/aether/ui/` or `patches/aether/settings/`.
3. Add to `patches/series` in order.
4. Verify layout on small phone (≤6"), large phone (6.7"), and tablet viewports.
5. Record completion evidence in `docs/STATUS.md`.
