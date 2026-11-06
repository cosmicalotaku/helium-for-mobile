# Feature Specification: Granular Zoom Presets & Default Zoom (`FEAT-25`)

> **Feature ID:** `FEAT-25`  
> **Phase:** `PH-6` (Task `T-6.7`)  
> **Priority:** `P1` (Post-Core Enhancement)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Android Chromium provides coarse text scaling under Accessibility settings, but lacks fine-grained page zoom controls (50% to 300%) with per-site memory or quick presets (e.g. 75%, 90%, 100%, 110%, 125%, 150%). Helium Desktop provides customizable zoom steps and default zoom configurations.

### 1.2 User Story
> *"As a user browsing on a high-density mobile or small tablet display, I want to set a global default page zoom level and quickly adjust per-site zoom in 10% steps, so text and page elements fit comfortably."*

---

## 2. Interaction & UI Mockup

```text
Settings > Accessibility > Page Zoom:
┌─────────────────────────────────────────────────────────────┐
│ Default Page Zoom                                           │
│ [ 50% ]  [ 75% ]  [ 90% ]  [*] 100%  [ 110% ]  [ 125% ]     │
│                                                             │
│ Slider:  ───[o]─────────────────────── 100%                 │
│                                                             │
│ [x] Remember zoom level per site                            │
│ [x] Show quick zoom indicator in omnibox when zoomed        │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Affected Source Files

1. **`chrome/browser/ui/android/page_zoom/java/src/org/chromium/chrome/browser/ui/page_zoom/PageZoomCoordinator.java`:**
   - Extend zoom range slider to step in 5% or 10% increments rather than coarse jumps.
2. **`components/browser_ui/accessibility/android/java/src/org/chromium/components/browser_ui/accessibility/PageZoomPreference.java`:**
   - Expose preset chips for common zoom levels: 75%, 90%, 100%, 110%, 125%, 150%.
3. **`content/public/android/java/src/org/chromium/content_public/browser/HostZoomMap.java`:**
   - Store per-host zoom levels persistently in Chromium's host zoom cache.

---

## 4. SharedPreferences Keys & Defaults

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.zoom.default_factor` | `float` | `1.0f` | Global default page zoom factor (1.0 = 100%). |
| `aether.zoom.remember_per_site` | `boolean` | `true` | Persist custom zoom per origin. |

---

## 5. Verification & Acceptance Criteria

- [ ] Changing default page zoom applies immediately to all newly opened tabs.
- [ ] Per-site zoom override persists across app restarts for that specific domain.
- [ ] Reset button restores default zoom factor in 1 tap.
