# Feature Specification: Theming & Accent Palettes (`FEAT-17`)

> **Feature ID:** `FEAT-17`  
> **Phase:** `PH-6` (Task `T-6.5`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Standard Chromium dark mode uses dark grey (`#202124` / `#1F1F1F`) rather than true OLED black, missing out on deep contrast and significant power savings on modern AMOLED phone screens. Furthermore, standard Chromium lacks user-selectable accent color palettes, leaving the browser feeling generic and uncustomizable. Helium Desktop features customizable accent palettes and dark frame geometry.

### 1.2 User Story
> *"As an Android user with an OLED screen, I want a true Pure Black (AMOLED `#000000`) dark theme that saves battery, alongside customizable accent colors and Material You dynamic color extraction, so my browser looks gorgeous and unique."*

---

## 2. Palette & Visual Theme Specifications

```text
Settings > Appearance > Theme & Accent
┌─────────────────────────────────────────────────────────────┐
│ Theme Mode                                                  │
│ ( ) System default                                          │
│ ( ) Light mode                                              │
│ ( ) Dark mode (Deep Charcoal)                               │
│ (*) Pure Black (AMOLED #000000)                             │
│                                                             │
│ Accent Color                                                │
│ (*) Helium Amber  (#F59E0B)  [ 🟡 ]                         │
│ ( ) Material You  (Dynamic)  [ 🎨 ] (Android 12+)           │
│ ( ) Neon Cyan     (#06B6D4)  [ 🔵 ]                         │
│ ( ) Deep Violet   (#8B5CF6)  [ 🟣 ]                         │
│ ( ) Emerald Green (#10B981)  [ 🟢 ]                         │
│                                                             │
│ [x] Tint toolbar with accent color in dark mode             │
└─────────────────────────────────────────────────────────────┘
```

### Color Token Mappings

| Token Name | Light Mode | Dark Mode | AMOLED Pure Black | Purpose |
|---|---|---|---|---|
| `color_surface_primary` | `#FFFFFF` | `#18181B` | **`#000000`** | Main window & toolbar background |
| `color_surface_secondary`| `#F4F4F5` | `#27272A` | **`#121212`** | Omnibox pill & card backgrounds |
| `color_text_primary` | `#09090B` | `#FAFAFA` | **`#FFFFFF`** | Main titles and URL text |
| `color_text_secondary` | `#71717A` | `#A1A1AA` | **`#A1A1AA`** | Subtitles and domain path hints |
| `color_border_subtle` | `#E4E4E7` | `#27272A` | **`#1C1C1E`** | Dividers and container outlines |

### Supported Accent Colors
- **Helium Amber (Default Brand):** `#F59E0B` (Warm, vibrant, signature Helium identity)
- **Dynamic Monet:** Extracted from Android 12+ wallpaper palette (`android.R.color.system_accent1_500`)
- **Cyber Cyan:** `#06B6D4`
- **Electric Violet:** `#8B5CF6`
- **Emerald Green:** `#10B981`

---

## 3. Affected Source Files

1. **`components/browser_ui/styles/android/java/res/values-night/colors.xml`:**
   - Define `@color/color_amoled_surface` (`#000000`) and `@color/color_amoled_container` (`#121212`).
2. **`components/browser_ui/theme/android/java/res/values/themes.xml`:**
   - Add theme variant `Theme.Chromium.Aether.AMOLED`.
3. **`chrome/android/java/src/org/chromium/chrome/browser/theme/ThemeUtils.java`:**
   - In `getTextBoxColorForToolbarBackground()` and `getToolbarBackgroundColor()`:
     - Check `isAmoledEnabled()`.
     - When active in dark mode, return pure black `#000000`.
4. **`chrome/android/java/src/org/chromium/chrome/browser/theme/TopUiThemeColorProvider.java`:**
   - Incorporate accent tinting into primary browser controls and tab switcher header.
5. **`chrome/android/java/src/org/chromium/chrome/browser/night_mode/settings/ThemeSettingsFragment.java`:**
   - Add "Pure Black (AMOLED)" radio option to the existing Theme Settings dialog.
   - Add accent color selection grid with live preview circles.

---

## 4. SharedPreferences Keys & Defaults

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.theme.mode` | `string` | `"system"` | Options: `"system"`, `"light"`, `"dark"`, `"amoled"`. |
| `aether.theme.accent` | `string` | `"helium_amber"` | Options: `"helium_amber"`, `"monet"`, `"cyan"`, `"violet"`, `"emerald"`. |
| `aether.theme.tint_toolbar` | `boolean` | `true` | Subtle accent tint on active toolbar elements. |

---

## 5. Verification & Acceptance Criteria

- [ ] AMOLED mode renders toolbar, New Tab Page, and settings background as pure `#000000` (measured with digital color meter on OLED screen).
- [ ] Text contrast complies with WCAG AA (minimum 4.5:1 contrast ratio) across all theme combinations.
- [ ] Selecting an accent color instantly tints the URL focus ring, active tab indicator, and toggles.
- [ ] Dynamic Material You color extraction functions properly on Android 12, 13, 14+.
- [ ] Theme changes take effect immediately without requiring app restart.
