# Aether Opinionated Policies & Privacy Defaults (T-3.3)

> **Document:** `docs/DEFAULTS.md`  
> **Feature:** `FEAT-03` (Helium Opinionated Policies equivalent)  
> **Status:** Phase 3 Core Specification  

---

## 1. Core Principles

By default, stock Chromium trades user privacy for speculative speed gains and Google ecosystem integration (keystroke suggestion logging, prefetching, cloud sync, telemetry). 

Aether Browser inverts these defaults:
1. **No Keystroke Telemetry:** The omnibox only queries the network when the user explicitly presses Enter or selects a suggestion.
2. **Zero Speculative Connections:** No background pre-resolving of DNS or pre-fetching of web pages without user action.
3. **Encrypted Navigation by Default:** Automatic HTTPS upgrades for all plain HTTP endpoints.
4. **Local Data Stays Local:** Passwords, bookmarks, and browsing history are stored in local device SQLite databases, completely isolated from Google accounts.

---

## 2. Preference Registry Alterations

| Preference Key | Stock Chrome Default | Aether Default | Rationale & Protection |
|---|---|---|---|
| `search.suggest_enabled` | `true` | `false` | Prevents real-time keystroke streaming to search engines. |
| `net.network_prediction_options` | `0` (Always) | `2` (Never) | Disables speculative DNS pre-resolution and TCP pre-connecting. |
| `features.kHttpsFirstBalancedModeAutoEnable` | `DISABLED` | `ENABLED` | Automatically upgrades all non-secure HTTP navigation to HTTPS. |
| `safebrowsing.scout_reporting_enabled` | `true` | `false` | Blocks sending URLs and telemetry samples to remote servers. |
| `profile.password_manager_leak_detection` | `true` | `false` | Stops hashing and uploading passwords to Google servers. |
| `webrtc.ip_handling_policy` | `default` | `default_public_interface_only` | Prevents WebRTC from leaking local private LAN IP addresses. |
| `default_search_provider_data.template_url_data` | `google` | `duckduckgo` | Privacy-respecting default search engine with zero user profiling. |
| `alternate_error_pages.enabled` | `true` | `false` | Disables sending mistyped domain names to Google navigation servers. |
| `pings` (Hyperlink Auditing) | `true` | `false` | Blocks HTML `<a ping>` tracking beacons when links are clicked. |
| `signin.allowed` | `true` | `false` | Completely eliminates Google Account sign-in prompts and sync nags. |

---

## 3. User Customization & Toggles

Every altered preference remains fully controllable by the user:
- Search suggestions can be re-enabled under **Settings > Search engine**.
- WebRTC policy can be customized under **Settings > Privacy and security > WebRTC IP handling policy**.
- Ad-blocking and filter update intervals are controlled under **Settings > Aether Services**.
