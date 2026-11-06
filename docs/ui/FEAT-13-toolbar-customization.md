# Feature Specification: Customizable Toolbar Buttons (`FEAT-13`)

> **Feature ID:** `FEAT-13`  
> **Phase:** `PH-6` (Task `T-6.2`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
In standard Chrome, the phone toolbar layout is rigid: users cannot choose which buttons are visible, and unused buttons (such as Home or voice search) consume precious horizontal space. Helium Desktop's standout feature is toolbar customizability (`toolbar-button-prefs.patch`), allowing users to toggle buttons on and off.

### 1.2 User Story
> *"As an active user, I want full control over which shortcut icons appear in my mobile toolbar (such as uBO Shield, Extensions, Share, or New Tab), so that my browser surface reflects my specific daily workflow."*

---

## 2. Visual Mockups

### 2.1 Toolbar Configurations

```text
Default Layout (Balanced Power User):
┌─────────────────────────────────────────────────────────────┐
│ [Shield]  [  https://duckduckgo.com...       ] [Ext] (3) [︙] │
└─────────────────────────────────────────────────────────────┘

Minimalist Layout (Zen Mode):
┌─────────────────────────────────────────────────────────────┐
│           [  https://duckduckgo.com...               ]   [︙] │
└─────────────────────────────────────────────────────────────┘

Full Utility Layout:
┌─────────────────────────────────────────────────────────────┐
│ [⌂] [Shield] [  https://duckduckgo.com...  ] [Share] (+) (3) │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Settings Screen: "Customize Toolbar"

```text
Settings > Appearance > Customize Toolbar
┌─────────────────────────────────────────────────────────────┐
│ Visible Buttons                                             │
│                                                             │
│ [x] Ad Blocking Shield (uBlock Origin)                      │
│     Quick access to filter counts and site toggles          │
│                                                             │
│ [x] Extensions Menu                                         │
│     Opens active extension actions and popups               │
│                                                             │
│ [x] Tab Switcher Button                                     │
│     Shows open tab counter and grid switcher                │
│                                                             │
│ [ ] Share Button                                            │
│     Quickly share active web page link                      │
│                                                             │
│ [ ] Home Button                                             │
│     Navigate directly to your designated homepage           │
│                                                             │
│ [ ] New Tab Button (+)                                      │
│     Open a blank tab in one tap                             │
│                                                             │
│ [Reset to Defaults]                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Affected Source Files

1. **`chrome/browser/ui/android/toolbar/java/res/layout/toolbar_phone.xml`:**
   - Define canonical IDs for customizable toolbar items:
     - `home_button` (`@+id/home_button`)
     - `ublock_quick_button` (`@+id/ublock_quick_button`)
     - `extensions_toolbar_container` (`@+id/extensions_toolbar_container`)
     - `share_button` (`@+id/share_button`)
     - `new_tab_button` (`@+id/new_tab_button`)
     - `tab_switcher_button` (`@+id/tab_switcher_button`)
     - `menu_button` (`@+id/menu_button_wrapper` — always visible)
2. **`chrome/browser/ui/android/toolbar/java/src/org/chromium/chrome/browser/toolbar/top/ToolbarPhone.java`:**
   - Add `updateCustomToolbarButtons()` called on initialization, resumed visibility, and when `SharedPreferences` change.
   - Dynamically set `setVisibility(View.VISIBLE | View.GONE)` based on stored preferences.
3. **`chrome/android/java/src/org/chromium/chrome/browser/settings/ToolbarCustomizationSettings.java`:**
   - Dedicated `PreferenceFragmentCompat` allowing users to toggle switch preferences.
4. **`chrome/android/java/res/xml/toolbar_customization_preferences.xml`:**
   - Preference schema containing switches for each button.

---

## 4. SharedPreferences Keys & Defaults

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.toolbar.show_ublock` | `boolean` | `true` | Pre-installed uBO shield quick-button. |
| `aether.toolbar.show_extensions` | `boolean` | `true` | Extensions action icon container. |
| `aether.toolbar.show_tab_switcher` | `boolean` | `true` | Tab switcher counter icon. |
| `aether.toolbar.show_share` | `boolean` | `false` | Web page share action. |
| `aether.toolbar.show_home` | `boolean` | `false` | Homepage button. |
| `aether.toolbar.show_new_tab` | `boolean` | `false` | Direct New Tab (+) button. |

---

## 5. Verification & Acceptance Criteria

- [ ] Toggling any button in Settings immediately updates the live toolbar without requiring app restart.
- [ ] If all optional buttons are hidden, the omnibox expands to occupy all available horizontal width.
- [ ] Omnibox typing and suggestion dropdowns remain fully functional regardless of button configuration.
- [ ] Toolbar state persists across cold app reboot.
