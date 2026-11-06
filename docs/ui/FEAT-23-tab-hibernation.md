# Feature Specification: Tab Hibernation (`FEAT-23`)

> **Feature ID:** `FEAT-23`  
> **Phase:** `PH-6` (Task `T-6.7`)  
> **Priority:** `P1` (Post-Core Enhancement)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Running multiple background tabs on Android mobile devices with 4 GB to 6 GB of RAM can cause significant memory pressure, particularly when active extensions (uBlock Origin, Bitwarden) are loaded. Helium Desktop features a "Hibernate other tabs" option that immediately discards inactive renderer processes while retaining tab state in the switcher.

### 1.2 User Story
> *"As a mobile user with multiple open tabs, I want an option to hibernate background tabs on demand or automatically after a timeout, so that my phone's RAM and battery are conserved without losing my browsing position."*

---

## 2. Interaction & UI Mockup

```text
Tab Switcher Menu:
┌───────────────────────────────┐
│ Select tabs                   │
│ Close all tabs                │
│ ───────────────────────────── │
│ 💤 Hibernate other tabs       │ (Instantly discards inactive renderers)
│ 📋 Copy all tab URLs          │
└───────────────────────────────┘
```

When a hibernated tab is tapped in the tab switcher:
- The tab header displays a subtle sleep indicator (`💤`).
- Upon selection, the tab restores from frozen serialized state without a full network reload (using cached DOM state).

---

## 3. Affected Source Files

1. **`chrome/android/java/src/org/chromium/chrome/browser/tabmodel/TabModelUtils.java`:**
   - Implement `discardOtherTabs(TabModel model, Tab activeTab)`.
   - Invokes Chromium's native `TabState` freezer: `tab.freezeAndDiscardWebContents()`.
2. **`chrome/android/java/src/org/chromium/chrome/browser/tasks/tab_management/TabGridDialogMenuCoordinator.java`:**
   - Injects "Hibernate other tabs" into the tab switcher toolbar menu.
3. **`chrome/android/java/src/org/chromium/chrome/browser/settings/AetherServicesSettings.java`:**
   - Expose optional "Auto-Hibernate Inactive Tabs" timeout selector (e.g., 30 mins, 1 hour, Never).

---

## 4. SharedPreferences Keys & Defaults

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.tabs.auto_hibernate_minutes` | `int` | `60` | Auto-hibernate inactive background tabs after N minutes (0 = Disabled). |

---

## 5. Verification & Acceptance Criteria

- [ ] Tapping "Hibernate other tabs" instantly reclaims RAM from background renderers (verified via `adb shell dumpsys meminfo app.aether.browser`).
- [ ] Active tab remains running smoothly without any stutter.
- [ ] Tapping a hibernated tab restores it cleanly with its scroll position intact.
