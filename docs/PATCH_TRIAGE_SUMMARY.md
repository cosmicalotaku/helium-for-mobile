# Helium Patch Triage Summary (T-2.3)

> **Document:** `docs/PATCH_TRIAGE_SUMMARY.md`  
> **Source Series:** Helium Desktop 346 patches  
> **Target App:** Aether Browser for Android  

--- 

## 1. Strategy Breakdown

| Strategy | Count | Percentage | Description |
|---|---|---|---|
| **PORT** | 249 | 72.0% | Platform-agnostic C++ patches to adapt directly to Android |
| **ADOPT** | 12 | 3.5% | Already covered by Vanadium hardening or Titanium extension layer |
| **REIMPL** | 29 | 8.4% | Desktop UI/WebUI features to newly implement in Android Java & XML |
| **DROP** | 51 | 14.7% | Desktop-only features (sync, vertical tabs, desktop window geometry) |
| **DEFER** | 5 | 1.4% | Optional P2 backlog (!bangs, tablet split view, zen auto-hide) |
| **TOTAL** | **346** | **100%** | All active patches evaluated |

--- 

## 2. Top 15 High-Value PORT Candidates (For Phase 3)

| ID | Patch Path | Feature | Effort | Summary |
|---|---|---|---|---|
| `HL-0010` | `ungoogled-chromium/disable-untraceable-urls.patch` | FEAT-02 | M | disable untraceable urls |
| `HL-0026` | `ungoogled-chromium/block-requests.patch` | FEAT-02 | L | block requests |
| `HL-0036` | `inox-patchset/modify-default-prefs.patch` | FEAT-03 | L | modify default prefs |
| `HL-0064` | `ungoogled-chromium/prepopulated-search-engines.patch` | FEAT-19 | S | prepopulated search engines |
| `HL-0101` | `helium/core/search/restore-google.patch` | FEAT-19 | S | restore google |
| `HL-0102` | `helium/core/search/engine-defaults.patch` | FEAT-19 | S | engine defaults |
| `HL-0103` | `helium/core/search/fix-search-engine-icons.patch` | FEAT-19 | S | fix search engine icons |
| `HL-0104` | `helium/core/search/force-eu-search-features.patch` | FEAT-19 | M | force eu search features |
| `HL-0105` | `helium/core/search/remove-description-snippet-deps.patch` | FEAT-19 | M | remove description snippet deps |
| `HL-0106` | `helium/core/search/break-favicons.patch` | FEAT-19 | S | break favicons |
| `HL-0107` | `helium/core/search/omnibox-default-search-icon.patch` | FEAT-19 | S | omnibox default search icon |
| `HL-0108` | `helium/core/search/add-kagi-image-search.patch` | FEAT-19 | S | add kagi image search |
| `HL-0109` | `helium/core/search/fix-brave-name.patch` | FEAT-19 | S | fix brave name |
| `HL-0129` | `helium/core/update-default-browser-prefs.patch` | FEAT-03 | S | update default browser prefs |
| `HL-0131` | `helium/core/proxy-extension-downloads.patch` | FEAT-11 | L | proxy extension downloads |

---

## 3. Key REIMPL Groups (For Phase 5 & Phase 6)

1. **Toolbar & Chrome Customization (`FEAT-12`, `FEAT-13`):** Rewrite Helium's compact toolbar dimensions and customizable action button layout in Java (`ToolbarPhone.java`, `toolbar_phone.xml`).
2. **Clean New Tab Page (`FEAT-16`):** Replace NTP with clean, non-feed minimalist UI without Google Discover or Explore tiles.
3. **Theming & Color Palettes (`FEAT-17`):** Android Material You dynamic color integration + Helium dark/AMOLED themes.
4. **Built-in uBlock Origin Component (`FEAT-09`):** Register uBO as a build-time component extension on Android.
5. **Settings Hierarchy (`FEAT-18`):** Dedicated 'Aether Services' preference screen in Java.
