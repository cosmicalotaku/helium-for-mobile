# Feature Specification: Offline First-Run Onboarding (`FEAT-26`)

> **Feature ID:** `FEAT-26`  
> **Phase:** `PH-6` (Task `T-6.7`)  
> **Priority:** `P1` (Post-Core Enhancement)  
> **Strategy:** `REIMPL` (Clean-room Android implementation)  
> **Target Status:** Approved Specification

---

## 1. User Story & Problem Statement

### 1.1 Context
Standard Chromium's first-run experience (FRE) forces users to accept Google terms, prompts them to link or create a Google account, and enables cloud telemetry synchronization by default. Helium Desktop introduces a custom offline onboarding wizard where users choose their search provider, theme, and ad-blocking preferences without making network pings.

### 1.2 User Story
> *"As a new user launching Aether for the first time, I want a beautiful, privacy-centric onboarding wizard that operates 100% locally with zero cloud sign-in prompts, allowing me to pick my search engine and visual theme before I start browsing."*

---

## 2. Onboarding Flow & Screen Mockups

```text
Screen 1: Welcome to Aether
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                            [ 🛡️ ]                           │
│                     Welcome to Aether                       │
│           Fast. De-Googled. Built-in Ad Blocking.           │
│                                                             │
│   • Built-in uBlock Origin (MV2) enabled                    │
│   • Zero tracking or unsolicited network requests           │
│   • First-class extension support                           │
│                                                             │
│                      [ Get Started → ]                      │
└─────────────────────────────────────────────────────────────┘

Screen 2: Choose Your Search Engine (100% Offline)
┌─────────────────────────────────────────────────────────────┐
│ Choose Your Default Search Provider                         │
│                                                             │
│ (*) DuckDuckGo   (Privacy by default, no profiling)         │
│ ( ) Brave Search (Independent index, zero telemetry)        │
│ ( ) Kagi Search  (Premium fast ad-free search)              │
│ ( ) SearXNG      (Decentralized metasearch engine)          │
│ ( ) Google       (Standard search engine)                   │
│                                                             │
│                      [ Continue → ]                         │
└─────────────────────────────────────────────────────────────┘

Screen 3: Choose Visual Theme
┌─────────────────────────────────────────────────────────────┐
│ Appearance & Color                                          │
│                                                             │
│ (*) Pure Black (AMOLED #000000)                             │
│ ( ) Deep Charcoal (Dark)                                    │
│ ( ) Clean Light Mode                                        │
│                                                             │
│ Accent Color:                                               │
│ [🟡 Helium Amber]  [🎨 Monet Dynamic]  [🔵 Neon Cyan]       │
│                                                             │
│                      [ Start Browsing ]                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Affected Source Files

1. **`chrome/android/java/src/org/chromium/chrome/browser/firstrun/FirstRunActivity.java`:**
   - Intercept standard FRE coordinator.
   - Suppress `TosAndEngagementFragment` and `SigninFirstRunFragment`.
   - Launch `AetherOnboardingCoordinator`.
2. **`chrome/android/java/src/org/chromium/chrome/browser/firstrun/AetherOnboardingCoordinator.java` (New):**
   - 3-step ViewPager2 carousel presenting Welcome, Search Provider Selection, and Theme Selection.
   - Saves choices directly into local `SharedPreferences`.
   - Never triggers any outbound HTTP network requests.
3. **`chrome/android/java/res/layout/aether_onboarding_*.xml`:**
   - Lightweight vector graphics and Material 3 cards.

---

## 4. SharedPreferences Keys & Defaults

| Preference Key | Type | Default | Description |
|---|---|---|---|
| `aether.onboarding.completed` | `boolean` | `false` | Set to true upon completing onboarding flow. |

---

## 5. Verification & Acceptance Criteria

- [ ] First app launch displays the clean Aether onboarding wizard.
- [ ] Absolutely zero network pings occur during the onboarding flow (verifiable via packet capture).
- [ ] User selections (Search Engine, Theme Mode, Accent Color) take effect immediately on the New Tab Page.
- [ ] On subsequent launches, onboarding is skipped and browser opens directly to the New Tab Page.
