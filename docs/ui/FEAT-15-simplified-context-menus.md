# Feature Specification: Simplified Context Menus (`FEAT-15`)

> **Feature ID:** `FEAT-15`  
> **Phase:** `PH-6` (Task `T-6.3`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
When long-pressing links, images, or selected text in standard Android Chromium, users are presented with bloated menus pushing Google services (e.g. "Search inside image with Google Lens", "Translate with Google", promotional sharing chips). Helium Desktop simplifies context menus (`browser-window-context-menu.patch`), removing telemetry entry points and keeping menus focused on core navigation.

### 1.2 User Story
> *"As a user, when I long-press a link or image, I want a clean, fast context menu containing only direct clipboard and tab operations, without Google Lens or cloud search telemetry."*

---

## 2. Context Menu Mockups

### 2.1 Link Long-Press
```text
Stock Chromium Menu:                Aether Clean Menu:
┌───────────────────────────────┐   ┌───────────────────────────────┐
│ https://example.com/item      │   │ https://example.com/item      │
│ ───────────────────────────── │   │ ───────────────────────────── │
│ Open in new tab in group      │   │ Open in new tab               │
│ Open in new tab               │   │ Open in incognito tab         │
│ Open in Incognito tab         │   │ Copy link address             │
│ Copy link address             │   │ Copy clean link (no tracking) │
│ Copy link text                │   │ Copy link text                │
│ Save link                     │   │ Share link                    │
│ Share link                    │   └───────────────────────────────┘
│ Read later                    │
└───────────────────────────────┘
```

### 2.2 Image Long-Press
```text
Stock Chromium Menu:                Aether Clean Menu:
┌───────────────────────────────┐   ┌───────────────────────────────┐
│ image.jpg                     │   │ image.jpg                     │
│ ───────────────────────────── │   │ ───────────────────────────── │
│ Search inside image with Lens │   │ Open image in new tab         │
│ Open image in new tab         │   │ Save image                    │
│ Copy image                    │   │ Copy image link               │
│ Save image                    │   │ Share image                   │
│ Share image                   │   └───────────────────────────────┘
└───────────────────────────────┘   (No Google Lens upload endpoint)
```

---

## 3. Affected Source Files

1. **`chrome/android/java/src/org/chromium/chrome/browser/contextmenu/ChromeContextMenuPopulator.java`:**
   - In `isSearchByImageAvailable()`: Return `false` unconditionally (neutralizes Google Lens telemetry).
   - In `isTranslateAvailable()`: Disable auto-translate popup prompts.
   - Streamline link menu items:
     - Retain: `R.id.contextmenu_open_in_new_tab`, `R.id.contextmenu_open_in_incognito_tab`, `R.id.contextmenu_copy_link_address`, `R.id.contextmenu_copy_link_text`, `R.id.contextmenu_share_link`.
     - Suppress: `contextmenu_open_in_new_tab_group`, `contextmenu_read_later`.
2. **`chrome/browser/contextmenu/java/src/org/chromium/chrome/browser/contextmenu/ChromeContextMenuItem.java`:**
   - Expose optional "Copy Clean Link" action (stripping tracking parameters like `utm_*`, `fbclid`, `gclid`).

---

## 4. Verification & Acceptance Criteria

- [ ] Long-pressing an image never displays "Search inside image with Google Lens".
- [ ] Long-pressing a link displays a clean 5-item menu without redundant tab group nesting.
- [ ] Tapping "Copy link address" copies the URL to the Android system clipboard with toast confirmation.
- [ ] Zero network requests generated upon opening or interacting with context menus.
