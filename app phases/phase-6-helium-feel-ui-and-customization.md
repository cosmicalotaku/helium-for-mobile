# Phase 6: Helium-Feel UI and Customization (PH-6)

> **Phase ID:** `PH-6`  
> **Target Status:** Visual & User Experience Milestone  
> **Source Reference:** `plan.md` §7 (PH-6), §1.3, §6 (FEAT-12 to FEAT-18, FEAT-23 to FEAT-26)  

---

## 1. Goal

Re-create the distinct, minimalist, and user-empowered visual language of Helium Desktop in Chromium Android’s native Java/XML UI layer: compact chrome, customizable toolbars, clean menus, zero promotional noise, and flat settings.

---

## 2. Features Implemented in this Phase

### P0 (Must Ship in v1)
| ID | Feature | Priority | Strategy | Description |
|---|---|---|---|---|
| `FEAT-12` | Compact toolbar layout | P0 | REIMPL | Reduced vertical height, minimal padding, clean aesthetic. |
| `FEAT-13` | Customizable toolbar | P0 | REIMPL | Reorder or toggle visible buttons (Home, Share, Extensions, uBO, Tabs). |
| `FEAT-14` | Trimmed overflow menu | P0 | REIMPL | Remove promotional items; keep only essential browser actions. |
| `FEAT-15` | Simplified context menus | P0 | REIMPL | Clean link/image/text menus without Google Lens or search upsells. |
| `FEAT-16` | Clean New Tab Page (NTP) | P0 | REIMPL | Pure minimalist NTP: omnibox, optional user shortcuts, no Discover feed. |
| `FEAT-17` | Theming & accent palettes | P0 | REIMPL | Light / Dark / AMOLED black / System themes + custom accent colors / Material You. |
| `FEAT-18` | Flat, honest Settings | P0 | REIMPL | Streamlined settings hierarchy with a dedicated "{{APP_NAME}} Services" page. |

### P1 (Post-Core Enhancements)
| ID | Feature | Priority | Strategy | Description |
|---|---|---|---|---|
| `FEAT-23` | Tab hibernation (discard tabs) | P1 | REIMPL | Manually or automatically discard inactive background tabs to save RAM. |
| `FEAT-24` | Copy URL(s) from tab switcher | P1 | REIMPL | Copy single or all open tab links directly from the tab grid. |
| `FEAT-25` | Extra zoom presets / Default zoom | P1 | REIMPL | Per-site and global zoom controls mapped cleanly to Android display scaling. |
| `FEAT-26` | Offline First-Run Onboarding | P1 | REIMPL | First-run wizard: choose search engine, theme, and initial ad-block lists (100% offline). |

---

## 3. Tasks Breakdown

### `T-6.1` — UI Feature Specifications (`docs/ui/FEAT-xx.md`)
- **Goal:** Write precise design specs for each feature before touching Java files.
- **Specification Template:**
  - User story & screen mockups.
  - Affected Java classes and XML resource files (located via `rg`).
  - Preference keys and default values.
  - Maintainer review and sign-off.

---

### `T-6.2` — Compact & Customizable Toolbar
- **Goal:** Redesign the top/bottom browser toolbar.
- **Implementation:**
  - Reduce vertical height and horizontal paddings in Android toolbar layouts.
  - Create a "Customize Toolbar" screen where users toggle items:
    - [x] Omnibox (always present)
    - [ ] Home button
    - [ ] Share button
    - [ ] Extensions menu
    - [ ] uBlock Origin shield
    - [ ] Tab counter
    - [ ] New tab (+) button
  - Store configuration in `SharedPreferences`.

---

### `T-6.3` — Simplified Overflow & Context Menus
- **Goal:** Eliminate noise from Chromium's sprawling 3-dot and long-press menus.
- **Changes:**
  - Strip: "Help & feedback", "What's new", "Turn on sync", "Search with Google Lens".
  - Add: "Extensions", "Ad Blocking", "Copy URL".

---

### `T-6.4` — Minimalist New Tab Page (NTP)
- **Goal:** Build an uncluttered, distraction-free start surface.
- **Implementation:**
  - Completely suppress `ExploreSites` / `FeedSurfaceCoordinator`.
  - Display search bar, optional top sites grid (user toggleable), and clean background.

---

### `T-6.5` — Color Palettes & Theming Engine
- **Goal:** Deliver customizable visual themes.
- **Themes Supported:**
  - Light mode
  - Dark mode
  - Pure Black (AMOLED)
  - Dynamic Material You (Android 12+)
  - Custom accent colors (Helium Orange, Cyan, Violet, Emerald).

---

### `T-6.6` — Settings Restructure & "{{APP_NAME}} Services" Page
- **Goal:** Transparent, flat settings interface.
- **Dedicated Page:**
  - Lists every network-active feature with an explicit toggle (Filter list updates, search suggestions, safe browsing, extension updates).

---

### `T-6.7` — P1 Feature Cards (`FEAT-23` through `FEAT-26`)
- **Execution:** Individual task cards for tab hibernation, multi-URL copy, zoom controls, and offline onboarding.

---

## 4. Exit Criteria

- [ ] Passes UI QA checklist across 3 device form factors:
  - Small phone (≤ 6.0")
  - Large phone (≥ 6.7")
  - Tablet or Foldable (unfolded)
- [ ] Both Light, Dark, and AMOLED themes render with correct contrast and no unreadable text.
- [ ] Toolbar customization persists across app restarts and updates.
- [ ] TalkBack accessibility labels are present on all custom toolbar buttons.
