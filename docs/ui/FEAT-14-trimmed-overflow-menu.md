# Feature Specification: Trimmed Overflow Menu (`FEAT-14`)

> **Feature ID:** `FEAT-14`  
> **Phase:** `PH-6` (Task `T-6.3`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Stock Chromium's 3-dot overflow menu is heavily cluttered with Google promotional banners ("Turn on sync", "Sign in to Chrome"), Google service promotions ("Help & feedback", "What's new"), and redundant sub-rows. In contrast, Helium Desktop strips extraneous menu clutter, exposing only relevant browsing actions and first-class privacy controls.

### 1.2 User Story
> *"As a user, when I tap the 3-dot menu, I want a clean, fast, and unbloated list of essential actions without Google account nags or help upsells, with direct access to Extensions, Ad Blocking, and Settings."*

---

## 2. Menu Layout Comparison

```text
Stock Chromium Menu:                Aether Clean Menu:
┌───────────────────────────────┐   ┌───────────────────────────────┐
│ [Sign in to Chrome banner]    │   │ [Forward] [Reload] [Share]    │ (Compact quick actions row)
│ ───────────────────────────── │   │ ───────────────────────────── │
│ New tab                       │   │ New tab                       │
│ New Incognito tab             │   │ New incognito tab             │
│ History                       │   │ History                       │
│ Delete browsing data...       │   │ Downloads                     │
│ Downloads                     │   │ Bookmarks                     │
│ Bookmarks                     │   │ ───────────────────────────── │
│ Recent tabs                   │   │ Extensions >                  │ (First-class submenu)
│ Share...                      │   │ Ad Blocking (uBO) >           │ (Direct status indicator)
│ Find in page                  │   │ Find in page                  │
│ Translate...                  │   │ Desktop site [ ]              │
│ Add to Home screen            │   │ ───────────────────────────── │
│ Desktop site [ ]              │   │ Settings                      │
│ Settings                      │   └───────────────────────────────┘
│ Help & feedback               │   (Completely free of promo banners)
└───────────────────────────────┘
```

---

## 3. Affected Source Files

1. **`chrome/android/java/res/menu/main_menu.xml`:**
   - Remove or set `android:visible="false"` for:
     - `signin_promo_menu_id`
     - `help_id` ("Help & feedback")
     - `managed_by_menu_id`
   - Ensure clean IDs for:
     - `extensions_menu_id`
     - `ad_blocking_menu_id`
     - `preferences_id`
2. **`chrome/android/java/src/org/chromium/chrome/browser/app/appmenu/AppMenuPropertiesDelegateImpl.java`:**
   - In `prepareMenu()`:
     - Suppress Google sync promo card instantiation.
     - Conditionally show `ad_blocking_menu_id` displaying blocked count or toggle state.
     - Configure `extensions_menu_id` to render extension icons using `prepareMenuWithIcons()`.
   - Remove educational tooltips / in-product-help (IPH) triggers attached to menu items.

---

## 4. Verification & Acceptance Criteria

- [ ] Zero Google account prompts or sign-in avatar banners appear in the 3-dot menu.
- [ ] "Help & feedback" and promotional suggestions are absent.
- [ ] "Extensions" item opens the native extension list / manager.
- [ ] "Ad Blocking" item shows active protection status and links to uBO controls.
- [ ] Menu height is reduced, fitting comfortably on screen without excessive scrolling.
