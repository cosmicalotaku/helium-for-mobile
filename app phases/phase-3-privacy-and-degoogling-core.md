# Phase 3: Privacy and De-Googling Core (PH-3)

> **Phase ID:** `PH-3`  
> **Target Status:** Core Privacy Engine  
> **Source Reference:** `plan.md` §7 (PH-3), §1.3, §6 (FEAT-01, 02, 03, 11, 19, 20)  

---

## 1. Goal

Eliminate all Google tracking, unsolicited network pings, account sign-in prompts, promotional telemetry, and Google AI services from the Android build, establishing Helium's core "zero noise, zero surprise network requests, privacy-by-default" guarantee.

---

## 2. Features Implemented in this Phase

| ID | Feature | Priority | Strategy | Description |
|---|---|---|---|---|
| `FEAT-01` | Remove Google services, promos, sign-in, feed/Discover, AI entry points | P0 | ADOPT + REIMPL | Audit & excise all Android-specific Google entry points. |
| `FEAT-02` | Zero unsolicited network requests | P0 | PORT + ADOPT | The browser sends no network requests not initiated by user. |
| `FEAT-03` | Privacy-first default prefs (HOP equivalent) | P0 | PORT | Disable telemetry, crash uploads, metrics, prefetching by default. |
| `FEAT-11` | Anonymized CWS / extension update requests | P0 | PORT | Strip client tokens/identifiers from extension store requests. |
| `FEAT-19` | Search engines: privacy defaults & no suggestions | P0 | PORT | DuckDuckGo/Brave/SearXNG defaults; search suggestions disabled by default. |
| `FEAT-20` | WebRTC IP handling policy setting | P0 | ADOPT | Prevent private IP leaks over WebRTC; expose toggle in Privacy settings. |

---

## 3. Tasks Breakdown

### `T-3.1` — Port Platform-Agnostic Core Privacy Patches
- **Goal:** Port the high-value C++ privacy patches identified in Phase 2 ledger.
- **Scope:**
  - Disable domain-based telemetry, metrics services, and Omaha update checks.
  - Disable Google Safe Browsing telemetry (or configure local-only lists if user-enabled).
  - Strip Google client headers (`X-Client-Data`, device IDs).
- **Patch Area:** `patches/{{app}}/privacy/` and `patches/{{app}}/core/`.

---

### `T-3.2` — Android-Specific Google Services Audit & Removal
- **Goal:** Neutralize Google features that only exist in Android Chromium (`chrome/android/java/`).
- **Targets for Removal / Disabling:**
  - Google Account Sign-In / sync buttons and bottom sheets.
  - New Tab Page Discover / Interest feed and trending searches.
  - Google Lens image search buttons in omnibox and context menus.
  - Google Translate automatic popups / remote server submissions.
  - "Chrome Tips", onboarding promotional cards, and AI Innovation promos.
- **Constraint:** Use resource overrides and preference defaults wherever possible before editing Java code directly.

---

### `T-3.3` — Helium Opinionated Policies (HOP) & Default Preferences
- **Goal:** Port Helium's privacy defaults to Android Chromium's preference registry.
- **Key Preferences Configured:**
  - Search suggestions (`search_suggest_enabled = false`).
  - Network prediction & prefetching (`network_prediction_enabled = false`).
  - WebRTC IP policy (`default_local_candidate_only`).
  - Third-party cookies / tracking protection default state.
  - Hyperlink auditing (`pings = false`).
- **Deliverable:** `docs/DEFAULTS.md` documenting every changed preference and its justification.

---

### `T-3.4` — Network Silence Audit & Traffic Capture
- **Goal:** Empirically verify that the browser is completely silent on the network.
- **Testing Protocol:**
  1. Fresh install of the app on a test device / emulator.
  2. Route all device traffic through a proxy (e.g., mitmproxy / Wireshark).
  3. Perform test scenarios:
     - Launch fresh and idle for 10 minutes.
     - Open New Tab Page.
     - Open Settings menu.
     - Navigate to `about:blank`.
  4. Verify that **zero unprompted requests** occur.
- **Deliverable:** `docs/NETWORK_ENDPOINTS.md` listing every allowed endpoint (e.g. user-initiated navigation, uBO list updates) with user toggles.

---

## 4. Deliverables

1. Patch series in `patches/{{app}}/privacy/` and `patches/{{app}}/core/`.
2. Documentation: `docs/DEFAULTS.md`.
3. Network registry: `docs/NETWORK_ENDPOINTS.md`.
4. Verification logs from mitmproxy / packet capture.

---

## 5. Exit Criteria

- [x] App launches and idles without generating any unexpected network packets.
- [x] No Google sign-in prompts, Discover feeds, or Lens promos appear in the UI.
- [x] Privacy leak tests (WebRTC IP leak, DNS leak) pass cleanly.
- [x] `docs/NETWORK_ENDPOINTS.md` accurately accounts for 100% of outbound connections.
