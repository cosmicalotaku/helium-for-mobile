# Feature Specification: Compact Toolbar Layout (`FEAT-12`)

> **Feature ID:** `FEAT-12`  
> **Phase:** `PH-6` (Task `T-6.2`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Standard Android Chromium features an oversized top toolbar (`56dp` to `64dp` in Material 3) with excessive internal padding (`toolbar_edge_padding = 8dp`). On tall modern phone screens (20:9 aspect ratios), this vertical height encroaches significantly on web content reading area. 

### 1.2 User Story
> *"As a privacy-focused mobile user, I want the browser toolbar to take up as little vertical screen space as possible, maintaining high touch responsiveness while leaving maximum room for web content."*

---

## 2. Visual Mockup & Geometry Comparison

```text
Stock Chromium Phone Toolbar (64dp):
┌─────────────────────────────────────────────────────────────┐
│  [Home]   [   https://example.com/long-url...    ]  (4) [︙] │ (64dp height, bloated padding)
└─────────────────────────────────────────────────────────────┘

Aether Compact Toolbar (48dp):
┌─────────────────────────────────────────────────────────────┐
│ [Shield]  [  https://example.com/search...   ] [Ext] (4) [︙] │ (48dp height, 25% more screen space)
└─────────────────────────────────────────────────────────────┘
```

### Dimensional Specifications

| Dimension Key | Stock Chromium | Aether Compact Target | Rationale |
|---|:---:|:---:|---|
| `toolbar_height_no_shadow` | `56dp` / `64dp` | **`48dp`** | 25% reduction in vertical footprint. |
| `toolbar_button_width` | `48dp` | **`40dp`** | Allows more utility actions without horizontal squishing. |
| `toolbar_url_bar_min_height` | `44dp` | **`36dp`** | Slim pill shape matching Helium desktop omnibox. |
| `toolbar_edge_padding` | `8dp` | **`4dp`** | Tight, precise border spacing. |
| `url_bar_corner_radius` | `24dp` | **`18dp`** | Proportional rounding suited for 36dp pill height. |

---

## 3. Affected Source Files

All paths located in Chromium Android tree:

1. **`chrome/browser/ui/android/toolbar/java/res/values/dimens.xml`:**
   - Redefine `toolbar_height_no_shadow` to `48dp`.
   - Redefine `toolbar_button_width` and `toolbar_button_height` to `40dp`.
   - Adjust `toolbar_url_bar_min_height` to `36dp`.
2. **`chrome/browser/ui/android/toolbar/java/res/layout/toolbar_phone.xml`:**
   - Adjust margins and paddings for `location_bar` and icon containers.
   - Align button vertical centering.
3. **`chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/top/ToolbarPhone.java`:**
   - Update measurement and layout passes in `onMeasure()` and `onLayout()` to handle the 48dp height constraint smoothly without text truncation.
4. **`chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/top/TopToolbarCoordinator.java`:**
   - Ensure browser controls height supplier reports 48dp to the Blink renderer viewport coordinator, preventing bottom whitespace gaps.

---

## 4. SharedPreferences & Configuration

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.toolbar.compact_height` | `boolean` | `true` | When true, renders toolbar in 48dp mode; fallback to 56dp if disabled. |

---

## 5. Verification & Acceptance Criteria

- [ ] Top browser toolbar measures exactly `48dp` on phone portrait viewports.
- [ ] Omnibox text remains crisp, vertically centered, and easy to tap.
- [ ] No clipping or overlap between URL text and action buttons.
- [ ] Web page viewport dynamically fills the extra 8-16dp vertical space without layout glitches.
- [ ] Passes layout inspection on small phone (≤6.0") and large phone (6.7").
