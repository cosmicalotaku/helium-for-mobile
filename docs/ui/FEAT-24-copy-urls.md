# Feature Specification: Copy URL(s) from Tab Switcher (`FEAT-24`)

> **Feature ID:** `FEAT-24`  
> **Phase:** `PH-6` (Task `T-6.7`)  
> **Priority:** `P1` (Post-Core Enhancement)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Users frequently need to export or share open tabs (for research, bookmarking, or transferring to another device). Standard Android Chrome requires opening each tab individually and copying its URL. Helium Desktop features a "Copy URL(s)" utility in the tab frame.

### 1.2 User Story
> *"As a researcher or power user, I want to copy the URL of any tab from the tab grid, or copy all open tab URLs at once as a formatted list, directly to my clipboard."*

---

## 2. Interaction & UI Mockup

```text
Tab Grid Individual Card Context (Long-Press):
┌───────────────────────────────┐
│ Copy URL                      │ -> Copies single URL to clipboard
│ Share tab                     │
│ Close tab                     │
└───────────────────────────────┘

Tab Switcher Overflow Menu (3-Dots):
┌───────────────────────────────┐
│ Select tabs                   │
│ Close all tabs                │
│ Hibernate other tabs          │
│ ───────────────────────────── │
│ 📋 Copy all open URLs (8)     │ -> Copies newline-separated list of URLs
└───────────────────────────────┘
```

Clipboard output format for "Copy all open URLs":
```text
https://example.com/page1
https://example.com/page2
https://github.com/imputnet/helium
```

---

## 3. Affected Source Files

1. **`chrome/android/java/src/org/chromium/chrome/browser/tasks/tab_management/TabListMediator.java`:**
   - Add long-press context menu item to tab grid cards: "Copy URL".
   - Extracts `tab.getUrl().getSpec()` and writes to `ClipboardManager`.
2. **`chrome/android/java/src/org/chromium/chrome/browser/tasks/tab_management/TabGridDialogMenuCoordinator.java`:**
   - Adds "Copy all open URLs" item to the menu.
   - Iterates through `TabModel`, gathers valid URLs, and copies newline-delimited string.
3. **Android Toast:** Shows feedback toast: *"Copied X URLs to clipboard"*.

---

## 4. Verification & Acceptance Criteria

- [ ] Long-pressing any card in the tab switcher offers "Copy URL", copying the single URL immediately.
- [ ] Selecting "Copy all open URLs" copies all non-incognito open tab links separated by newlines.
- [ ] Toast notification confirms the count of copied links.
