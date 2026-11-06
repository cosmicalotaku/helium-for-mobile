# Feature Specification: Flat Settings & Aether Services Page (`FEAT-18`)

> **Feature ID:** `FEAT-18`  
> **Phase:** `PH-6` (Task `T-6.6`)  
> **Priority:** `P0` (Must Ship)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Standard Chromium settings are deeply nested, opaque, and prioritize Google account management ("Google Services", "Safety Check", "Autofill with Google"). Features that make network requests are hidden across multiple sub-menus. Helium Desktop introduces "Helium Services" and flattened, transparent settings where all network-active features are exposed with clear toggles.

### 1.2 User Story
> *"As a privacy-conscious user, I want a flat, honest settings hierarchy with a dedicated 'Aether Services' page where I can see and control every single feature that could touch the network, without Google upsells or nested obfuscation."*

---

## 2. Information Architecture & Screen Mockups

### 2.1 Main Settings Hierarchy (`SettingsActivity`)

```text
Settings
┌─────────────────────────────────────────────────────────────┐
│ [🛡️ Aether Services]                                        │ (Prominent top item)
│    Ad blocking, updates, and network privacy controls       │
│                                                             │
│ Basics                                                      │
│    Search engine                [DuckDuckGo]                │
│    Passwords & Autofill         [Local SQLite Database]     │
│    Payment methods              [Local Only]                │
│    Addresses and more                                       │
│                                                             │
│ Appearance & Interface                                      │
│    Theme & Accent               [Pure Black / Amber]        │
│    Customize Toolbar            [Compact / 3 buttons]       │
│    New Tab Page                 [Minimalist / Shortcuts]    │
│                                                             │
│ Privacy & Security                                          │
│    Clear browsing data                                      │
│    Site settings                                            │
│    WebRTC IP handling policy    [Public interface only]     │
│                                                             │
│ Advanced                                                    │
│    Extensions                   [Manage active extensions]  │
│    Accessibility                                            │
│    Downloads                                                │
│    About Aether                                             │
└─────────────────────────────────────────────────────────────┘
(Completely stripped of "You and Google", "Sync", "Safety Hub")
```

### 2.2 Dedicated Sub-Page: "Aether Services" (`AetherServicesSettings`)

```text
Settings > Aether Services
┌─────────────────────────────────────────────────────────────┐
│ Content Blocking                                            │
│    Ad Blocking (uBlock Origin)             [ ENABLED ]      │
│    Open uBlock Origin Dashboard >                           │
│    Automatic Filter List Updates           [   ON    ]      │
│    Filter Update Frequency                 [ Daily   ]      │
│                                                             │
│ Extension Maintenance                                       │
│    Automatic Extension Updates             [   ON    ]      │
│    Anonymize Extension Requests            [   ON    ]      │
│                                                             │
│ Network Privacy & Lookups                                   │
│    Search Suggestions                      [   OFF   ]      │
│    Network Prediction (Prefetch)           [   OFF   ]      │
│    HTTPS-First Mode (Auto-upgrade)         [   ON    ]      │
│    SafeBrowsing Offline Protection         [   ON    ]      │
│    SafeBrowsing Cloud Reporting (Telemetry)[   OFF   ]      │
│                                                             │
│ Advanced Routing                                            │
│    WebRTC IP Handling                      [ Local only ]   │
│    Custom Proxy / DoH Resolver             [ Disabled ]     │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Affected Source Files

1. **`chrome/android/java/res/xml/main_preferences.xml`:**
   - Remove Google sync account header card (`account_management`).
   - Add `<Preference android:key="aether_services" android:title="@string/aether_services_title" android:summary="@string/aether_services_summary" android:fragment="org.chromium.chrome.browser.settings.AetherServicesSettings" android:icon="@drawable/ic_shield_24dp" />` at the top of the preference list.
   - Reorder categories: Basics, Appearance, Privacy & Security, Advanced.
2. **`chrome/android/java/src/org/chromium/chrome/browser/settings/MainSettings.java`:**
   - Suppress `updateAccountManagementHeader()` and Google promo cards.
   - Register `AetherServicesSettings` navigation fragment.
3. **`chrome/android/java/src/org/chromium/chrome/browser/settings/AetherServicesSettings.java` (New):**
   - New `PreferenceFragmentCompat` handling bindings for all network-active features registered in `docs/NETWORK_ENDPOINTS.md`.
4. **`chrome/android/java/res/xml/aether_services_preferences.xml` (New):**
   - Preference schema containing categorized toggles and direct dashboard deep-link.

---

## 4. SharedPreferences Keys & Mappings

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.ublock_filter_updates_enabled` | `boolean` | `true` | Anonymized direct filter updates per ADR-03. |
| `aether.extension_updates_enabled` | `boolean` | `true` | Anonymized CWS extension update checks. |
| `aether.anonymize_store_requests` | `boolean` | `true` | Strips `X-Client-Data` and Omaha IDs. |
| `search.suggest_enabled` | `boolean` | `false` | Keystroke search suggestions (default off). |
| `net.network_prediction_options` | `int` | `2` | Network prefetching (2 = Never). |

---

## 5. Verification & Acceptance Criteria

- [ ] "Aether Services" is positioned at the top of the primary Settings list with a custom shield icon.
- [ ] No Google account avatar, sync prompt, or Google services banner appears in Settings.
- [ ] Toggling any item in "Aether Services" instantly updates the underlying Chromium C++ pref or Java service without restart.
- [ ] Tapping "Open uBlock Origin Dashboard" opens `chrome-extension://cjpalhdlnbpafiamejdnhcphjbkeiagm/dashboard.html` in an active browser tab.
- [ ] Settings layout complies with Android Material 3 spacing and looks consistent in both Light and AMOLED themes.
