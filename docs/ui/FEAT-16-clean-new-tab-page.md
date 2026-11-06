# Feature Specification: Minimalist New Tab Page (`FEAT-16`)

> **Feature ID:** `FEAT-16`  
> **Phase:** `PH-6` (Task `T-6.4`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Standard Chromium's New Tab Page (NTP) on Android is dominated by Google's "Discover" content feed (algorithmic clickbait news), promotional doodle carousels, and search tracking chips. Helium Desktop offers a tranquil start page with zero feeds and distraction-free navigation.

### 1.2 User Story
> *"As a user, when I open a new tab, I want a clean, instant, distraction-free start surface with just an omnibox and optional local shortcut tiles, without news feeds or advertising suggestions."*

---

## 2. Visual Mockup & Layout Structure

```text
Aether Minimalist New Tab Page (Portrait Mobile):
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                                                             │
│                            [ 🛡️ ]                           │
│                            AETHER                           │
│                                                             │
│         ┌─────────────────────────────────────────┐         │
│         │ 🔍  Search DuckDuckGo or enter URL      │         │
│         └─────────────────────────────────────────┘         │
│                                                             │
│             [+]      [GitHub]    [Wikipedia]   [Reddit]     │
│          Add tile                                           │
│                                                             │
│                                                             │
│                                                             │
│                                                             │
│                    (100% Free of Feeds)                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Affected Source Files

1. **`chrome/android/java/src/org/chromium/chrome/browser/ntp/NewTabPageLayout.java`:**
   - In `onFinishInflate()` and layout bindings:
     - Suppress instantiation of `ExploreSitesViewCoordinator` and `FeedSurfaceCoordinator`.
     - Center the Aether logo vector and compact search bar vertically.
     - Provide a clean 2x4 grid for user-pinned top-site shortcuts.
2. **`chrome/android/java/src/org/chromium/chrome/browser/feed/FeedSurfaceCoordinator.java`:**
   - Force `isFeedExpanded()` and feed visibility suppliers to return `false` unconditionally.
   - Prevent background network pre-fetching of news articles.
3. **`chrome/android/java/res/layout/new_tab_page_layout.xml`:**
   - Eliminate unused feed containers and placeholder card views, reducing inflate time and memory footprint.
4. **`chrome/android/java/src/org/chromium/chrome/browser/ntp/NewTabPage.java`:**
   - Hook user preference for showing/hiding top shortcuts.

---

## 4. SharedPreferences Keys & Defaults

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.ntp.show_shortcuts` | `boolean` | `true` | When true, renders user shortcut tiles; when false, renders purely search box. |
| `aether.ntp.custom_background` | `string` | `"default"` | Optional pure black or themed gradient background. |

---

## 5. Verification & Acceptance Criteria

- [ ] New Tab Page opens instantly with zero network pings to Google Discover or article APIs.
- [ ] No news articles, trending queries, or promo banners appear on swipe-up.
- [ ] Omnibox on NTP focuses smoothly and accepts typing immediately.
- [ ] Pinned top-site tiles can be added, renamed, or deleted locally via long-press.
