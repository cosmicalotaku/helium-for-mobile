# Network Endpoints Registry & Traffic Audit (T-3.4)

> **Document:** `docs/NETWORK_ENDPOINTS.md`  
> **Rule Reference:** `plan.md` §2.1 (`R-PRIVACY`), §7 (`PH-3`, `T-3.4`)  
> **Last Audit:** 2026-11-04  

---

## 1. Network Policy Guarantee

Aether Browser guarantees **zero unsolicited network requests**. 

The browser generates **no network activity** when:
- Launched fresh for the first time.
- Idling on the New Tab Page or `about:blank`.
- Opening browser menus, settings, or history.
- Typing into the omnibox (with default search suggestion settings).

---

## 2. Permitted Network Connections Registry

Every outbound network connection permitted by Aether Browser must be registered below with an explicit user toggle:

| Endpoint Host / Domain | Purpose & Protocol | Trigger Condition | User Control / Settings Toggle |
|---|---|---|---|
| `*` (Any destination) | Web Navigation (HTTP/HTTPS) | User explicitly types URL or taps a link | Normal browsing |
| `duckduckgo.com` (or user-chosen engine) | Search Query (HTTPS) | User types query and presses Enter / Go | **Settings > Search engine** (Choose provider) |
| `chromewebstore.google.com` | Extension browsing & install | User visits store and taps "Add to Chrome" | Manual user action |
| `clients2.google.com/service/update2/crx` | Extension update checks | Scheduled background interval for active extensions | **Settings > Aether Services > Extension Updates** |
| `easylist.to`, `github.com/gorhill` | uBlock Origin filter list updates | Periodic scheduled refresh of ad-blocking rules | **Settings > Aether Services > Filter List Updates** |

---

## 3. Explicitly Neutralized / Blocked Google Endpoints

The following upstream Chromium network features are disabled or stripped by Vanadium and Aether patches:

| Upstream Feature | Blocked Domain / Host | Neutralizing Patch |
|---|---|---|
| **Google Variations (Field Trials)** | `clients4.google.com/chrome-variations/seed` | `vanadium/0072-disable-seed-based-field-trials.patch` |
| **UMA Metrics & Telemetry** | `clients2.google.com/cr/report` | `vanadium/0079-disable-metrics-by-default.patch` |
| **Google SafeBrowsing Reporting** | `safebrowsing.google.com` | `patches/aether/privacy/0002-degoogle-unsolicited-requests.patch` |
| **Discover / Interest Feed** | `www.google.com/async/newtab_promos` | `vanadium/0082-disable-article-suggestions.patch` |
| **Google Account Sync** | `accounts.google.com`, `googleapis.com/auth` | `vanadium/0070`, `patches/aether/privacy/0005` |
| **Google Lens Image Search** | `lens.google.com` | `patches/aether/privacy/0005-remove-android-google-entrypoints.patch` |
| **Omnibox Keystroke Suggestions** | `www.google.com/complete/search` | `patches/aether/privacy/0003-privacy-default-preferences.patch` |
| **Hyperlink Auditing (Pings)** | `<a ping="...">` endpoints | `vanadium/0080-disable-hyperlink-auditing-by-default.patch` |
| **Navigation Error Suggestions** | `navigation.google.com` | `vanadium/0076-disable-navigation-error-correction.patch` |

---

## 4. Verification & Audit Protocol

To reproduce the network audit:
1. Route test device traffic through a dedicated intercepting proxy (e.g. `mitmproxy` / Wireshark).
2. Freshly install Aether APK on device.
3. Launch app and remain idle for 10 minutes.
4. Navigate to `about:blank`, open Settings, open Bookmarks, and open Tab Switcher.
5. Inspect packet log: **Zero outbound requests must occur** prior to user navigation.
