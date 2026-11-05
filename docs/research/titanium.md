# Titanium Browser Research & Analysis (T-0.1)

> **Document:** `docs/research/titanium.md`  
> **Source Repository:** [`jqssun/android-titanium-browser`](https://github.com/jqssun/android-titanium-browser)  
> **License:** GNU General Public License v2.0 (GPL-2.0)  
> **Base Upstream:** GrapheneOS Vanadium  

---

## 1. Executive Summary

Titanium Browser for Android (formerly known as "Helium Browser for Android", renamed to avoid confusion with desktop Helium) is the primary open-source reference for compiling Chromium on Android with full extension capabilities and Manifest V2 support. It is built as an extension layer directly on top of GrapheneOS's Vanadium submodule.

---

## 2. Repository Structure

| Path | Purpose & Function |
|---|---|
| `vanadium/` | Git submodule pointing to pinned GrapheneOS Vanadium release. |
| `.gclient` | Gclient solution configuration targeting Chromium `src`. |
| `args.gn` | GN flags for release builds (`is_desktop_android = true`, `is_official_build = true`, `target_cpu = "arm"` / `"arm64"`). |
| `common.sh` | Utility functions: path exports, string replacement (`replace`), key setup (`set_keys`), and APK/AAB signing (`sign_apk`, `sign_aab`). |
| `build.sh` | Complete orchestration script: environment setup, depot_tools clone, Vanadium patch filtering & application, gclient sync, patch.sh execution, GN generation, autoninja compilation, and signing. |
| `patch.sh` | Main patch driver script applying in-line `sed` substitutions and asset copies across Chromium source tree. |
| `res/` | Custom drawables, themed launcher icons, and branding assets. |
| `extensions/` | Stage bundled extensions tooling (`bundle.py`, `stage_bundled_extensions.inc`, `BUILD.gn`). |
| `.github/workflows/build.yml` | GitHub Actions workflow building on self-hosted or `ubuntu-latest`, generating signed APKs/AABs with SLSA build attestation. |

---

## 3. Detailed Patch Categorization & Analysis (`patch.sh`)

Titanium's patch modifications are organized into clear functional areas in `patch.sh`:

### 3.1 Feature & Desktop-Android Overrides
- **Build Flag Enablement:** In `chrome/browser/chrome_browser_field_trials.cc`, forcibly enables key features under `BUILDFLAG(IS_DESKTOP_ANDROID)`:
  - `chrome::android::kSubmenusInAppMenu` (enables nested submenus in Android 3-dot menu).
  - `features::kAndroidDevToolsFrontend` (in-browser DevTools inspection).
  - `kAndroidMediaPicker`, `features::kUserMediaScreenCapturing`, `media::kAndroidEnableBackgroundMediaCapturing`.
  - `media::kAutoPictureInPictureAndroid`, `media::kContextMenuPictureInPictureAndroid`.
  - `chrome::android::kLoadAllTabsAtStartup`, `chrome::android::kChromeNativeUrlOverriding`.
- **Search & Omnibox:**
  - Enables `OmniboxFeatureList.OMNIBOX_SITE_SEARCH` in production.
  - Aligns desktop Android omnibox behavior in `components/omnibox/browser/zero_suggest_verbatim_match_provider.cc` and `autocomplete_result.cc`.

### 3.2 Manifest V2 (MV2) Re-Enablement
- **API Declarations:** Restores `"browser_action.json"` and `"page_action.json"` into `chrome/common/extensions/api/api_sources.gni`.
- **Deprecation Bypass:**
  - Overrides `api::webstore_private::MV2DeprecationStatus::kHardDisable` to `kNone` in `extensions/browser/api/webstore_private/webstore_private_api.cc`.
  - Sets `g_allow_mv2_for_testing = true` in `extensions/browser/manifest_v2_handler.cc`, allowing MV2 extensions to load and register background pages without blocking.

### 3.3 Off-Store & Chrome Web Store Mobile Installs
- **Off-Store Whitelisting:** Modifies `chrome/browser/download/download_crx_util.cc` to allow CRX installs initiated by `chrome-extension://` schemes and store domains (`addons.opera.com`, `microsoftedge.microsoft.com`).
- **Web Store Mobile Spoofing:** In `DesktopSiteUtils.java`, forces `ContentSetting.ALLOW` for `REQUEST_DESKTOP_SITE` on `[*.]chromewebstore.google.com`. This ensures the "Add to Chrome" button is rendered by Google's store scripts without requiring the user to manually toggle desktop mode.
- **Unpacked SAF Picker:** Modifies `VirtualDocumentPath.java` to support tree URI resolution with `com.android.externalstorage.documents` for loading unpacked extensions from the Android Storage Access Framework.

### 3.4 Mobile Extension UI & Action Popups
- **Toolbar Container:** Injects `<ViewStub android:id="@+id/extensions_toolbar_container_stub">` into `toolbar_phone.xml` and renders extension action icons directly onto the phone toolbar via `ToolbarPhone.java`.
- **Action Popups on Phone:**
  - In `extension_action_popup_contents.cc`, checks `ui::GetDeviceFormFactor() == ui::DEVICE_FORM_FACTOR_PHONE` and disables desktop fixed autowindow sizing, resizing popups to fill the mobile container.
  - In `ExtensionActionPopup.java`, anchors popup windows to the decor view and matches full display width.
- **WebUI Extensions Management:** Injects responsive viewport tags (`<meta name="viewport" content="width=device-width">`) and custom CSS into `chrome://extensions` (`extensions.html`, `item_list.css`, `shared_vars.css`, `toggle_row.css`).

### 3.5 Extension Process Management & Incognito
- **Process Priority:** In `ChildProcessLauncherHelperImpl.java`, checks if command-line args include `--extension-process` and elevates its priority to `ChildProcessImportance.IMPORTANT` to prevent the Android Low Memory Killer (LMK) from prematurely terminating background extension scripts.
- **Incognito Isolation:** Enables extensions in off-the-record profiles via `extensions/browser/process_manager.cc` and `IncognitoUtils.java`.
- **Crash Fixes:** Guards against User-After-Free (UAF) crashes in `tabs_api.cc` and `profile_destroyer.cc` when incognito tabs close while extensions are active.

---

## 4. Key Takeaways for Our Implementation

1. **Re-use Foundation:** Titanium solves the hardest problem on Android: bringing up the Chromium extension runtime, fixing popup anchoring on phone viewports, and re-enabling MV2.
2. **Refactoring Sed into Clean Patches:** Titanium uses in-line `sed` commands in `patch.sh`. For our project, we should convert these modifications into clean, modular `.patch` files tracked in `patches/series` so they can be reviewed and tested cleanly.
3. **Component Bundling Pattern:** Titanium bundles its companion extension using `stage_bundled_extensions.inc` and `bundle.py`, which provides the exact template we can adapt for pre-installing uBlock Origin.
