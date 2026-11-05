# Aether Browser — Extensions Architecture & Runtime (`docs/EXTENSIONS.md`)

> **Document:** `docs/EXTENSIONS.md`  
> **Status:** Active / Production  
> **Phase:** Phase 4 (Extensions Runtime and MV2 Support)  
> **Feature IDs:** `FEAT-04`, `FEAT-05`, `FEAT-06`, `FEAT-07`, `FEAT-08`  
> **Security Gate:** `SECURITY-REVIEW`  

---

## 1. Overview & Architectural Goal

Standard Chromium for Android historically lacked extension support entirely. Upstream Chromium recently introduced an experimental "desktop Android" build flag (`is_desktop_android = true`) intended to bring Manifest V3 (MV3) extensions to large-screen Android devices. However, this upstream implementation has three critical limitations:
1. **Manifest V3 Only:** It deliberately blocks and deprecates Manifest V2 (MV2), making it impossible to run the full, uncompromised version of **uBlock Origin** (`gorhill/uBlock`).
2. **Desktop Site Gate:** Visiting `chromewebstore.google.com` on mobile devices fails to present the "Add to Chrome" button unless the user manually forces "Desktop site".
3. **Desktop Popup Sizing:** Extension action popups are hardcoded to desktop window sizes (~350x500px), causing extreme layout distortion or offscreen clipping on phone form factors.
4. **Aggressive LMK Killing:** The Android Low Memory Killer (LMK) classifies background extension processes as low-priority cached renderers, terminating them prematurely.

**Aether Browser** solves all four constraints through a hybrid runtime architecture, combining Vanadium's security foundation with Titanium's proven extension orchestration and custom MV2 un-guarding.

---

## 2. GN Build Configuration & Compiler Flags

To compile the Chromium extensions subsystem for Android, the following build flags are configured in `args.gn`:

```gn
# Enable Desktop Android extension architecture on Android arm64
target_os = "android"
target_cpu = "arm64"
is_desktop_android = true

# Extension core subsystems
is_official_build = true
is_component_build = false
symbol_level = 1
disable_fieldtrial_testing_config = true
treat_warnings_as_errors = false
```

### Upstream Macro Interaction Matrix

| Build Flag / Macro | Upstream Purpose | Aether Behavior |
|---|---|---|
| `ENABLE_EXTENSIONS` | Historically desktop-only (Win/Mac/Linux/ChromeOS). | Guarded in upstream; replaced by `ENABLE_EXTENSIONS_CORE` where possible. |
| `ENABLE_EXTENSIONS_CORE` | Base extension infrastructure compiled across all platforms. | **Enabled** automatically by `is_desktop_android = true`. |
| `ENABLE_DESKTOP_ANDROID_EXTENSIONS` | Code running specifically on desktop Android targets. | **Enabled** automatically by `is_desktop_android = true`. |
| `BUILDFLAG(IS_DESKTOP_ANDROID)` | Runtime guards throughout `chrome/browser` and `components`. | Activated. Field trials explicitly force required subsystems. |

---

## 3. Desktop Android Feature Overrides

In `chrome/browser/chrome_browser_field_trials.cc`, Aether explicitly enables the following feature flags when `BUILDFLAG(IS_DESKTOP_ANDROID)` is active:

```cpp
#if BUILDFLAG(IS_DESKTOP_ANDROID)
feature_overrides.EnableFeature(chrome::android::kSubmenusInAppMenu);
feature_overrides.EnableFeature(features::kAndroidDevToolsFrontend);
feature_overrides.EnableFeature(kAndroidMediaPicker);
feature_overrides.EnableFeature(features::kUserMediaScreenCapturing);
feature_overrides.EnableFeature(media::kAndroidEnableBackgroundMediaCapturing);
feature_overrides.EnableFeature(media::kAutoPictureInPictureAndroid);
feature_overrides.EnableFeature(media::kContextMenuPictureInPictureAndroid);
feature_overrides.EnableFeature(chrome::android::kLoadAllTabsAtStartup);
feature_overrides.EnableFeature(chrome::android::kChromeNativeUrlOverriding);
#endif
```

### Justification of Specific Feature Flags:
- **`chrome::android::kSubmenusInAppMenu`:** Required for native Android 3-dot overflow menu hierarchy to display an "Extensions" submenu item with icons and nested actions.
- **`features::kAndroidDevToolsFrontend`:** Enables on-device extension inspection and debugging at `chrome://inspect`.
- **`kLoadAllTabsAtStartup` & `kChromeNativeUrlOverriding`:** Ensures internal `chrome-extension://` URL schemes and web content tabs correctly persist across cold application restarts.

---

## 4. Extension Process Priority & Low Memory Killer (LMK)

### Problem
Desktop extensions often run persistent background scripts or long-lived event dispatchers (e.g. uBlock Origin's rule compilation worker, Bitwarden's cryptographic vault cache). Under Android's standard process model, Chromium launches renderer and extension processes as `ChildProcessImportance.NORMAL` or `MODERATE`. When memory pressure increases, Android's `lowmemorykiller` terminates these processes, breaking ad-blocking filtering and logging the user out of password vaults.

### Implementation (`ChildProcessLauncherHelperImpl.java`)
Aether inspects command-line arguments passed to each spawned child process. If the process is invoked with `--extension-process`, Aether elevates its process importance:

```java
// content/public/android/java/src/org/chromium/content/browser/ChildProcessLauncherHelperImpl.java
private final boolean mIsExtensionProcess;

// In constructor:
mIsExtensionProcess = Arrays.asList(commandLine).contains("--extension-process");
if (mIsExtensionProcess) {
    mEffectiveImportance = ChildProcessImportance.IMPORTANT;
}

// In setPriority():
if (mIsExtensionProcess) {
    importance = ChildProcessImportance.IMPORTANT;
}
```

### Result
Extension background processes receive foreground-service-equivalent priority (`ChildProcessImportance.IMPORTANT`), protecting them from premature reclamation while the browser UI is in the foreground.

---

## 5. Mobile Extension UI & Action Popups

### 5.1 Phone Toolbar Action Button
Desktop Chromium places extension action icons on the browser frame. On mobile, space is constrained. Aether injects a dedicated container stub into `toolbar_phone.xml`:

```xml
<!-- chrome/browser/ui/android/toolbar/java/res/layout/toolbar_phone.xml -->
<ViewStub
    android:id="@+id/extensions_toolbar_container_stub"
    android:inflatedId="@+id/extensions_toolbar_container"
    android:layout_width="wrap_content"
    android:layout_height="?attr/toolbarButtonHeight"
    android:layout_marginVertical="?attr/toolbarButtonMarginVertical" />
```

`ToolbarManager.java` and `ToolbarPhone.java` inflate this stub, drawing extension icons adjacent to the tab switcher and overflow menu.

### 5.2 Responsive Action Popups
Desktop extension popups assume fixed window coordinates. On mobile phones, this results in unreadable micro-popups. Aether adjusts popup sizing in `extension_action_popup_contents.cc` and `ExtensionActionPopup.java`:
1. Checks device form factor using `ui::GetDeviceFormFactor() == ui::DEVICE_FORM_FACTOR_PHONE`.
2. Disables desktop `EnableAutoResize(kMinSize, kMaxSize)`.
3. Sets popup container dimensions to match the Android Activity's decor view (`decor.getWidth()`, `decor.getHeight()`).
4. Renders the popup content inside a full-width Material bottom sheet.

### 5.3 WebUI Management (`chrome://extensions`)
Responsive CSS adjustments are applied to `chrome://extensions`:
- Viewport meta tag added: `<meta name="viewport" content="width=device-width">`.
- Extension cards set to fluid responsive width: `--extensions-card-width: 96%`.
- Search field set to fluid width: `--cr-toolbar-field-width: 96%`.
- Touch scrolling enabled on toggle switches: `touch-action: pan-y`.

---

## 6. Phase 4 Patch Inventory

All extension functionality is maintained as isolated unified diffs in `patches/aether/extensions/`:

| Patch | Area | Description | Security Flag |
|---|---|---|---|
| `0007-desktop-android-runtime-and-process-priority.patch` | Runtime | Enables desktop Android field trials and elevates `--extension-process` priority to `IMPORTANT`. | Standard |
| `0008-mv2-support-and-deprecation-bypass.patch` | MV2 | Restores `browser_action`/`page_action` APIs, bypasses `kHardDisable`, and sets `g_allow_mv2_for_testing = true`. | `SECURITY-REVIEW` |
| `0009-cws-mobile-install-support.patch` | Web Store | Auto-allows `REQUEST_DESKTOP_SITE` for `chromewebstore.google.com` to render "Add to Chrome". | Standard |
| `0010-off-store-and-saf-unpacked-install.patch` | Installers | Whitelists CRX installs from extension schemes/stores and fixes SAF document tree URI parsing. | `SECURITY-REVIEW` |
| `0011-mobile-extension-ui-and-popups.patch` | UI | Injects phone toolbar container stub, responsive popups, and mobile WebUI layout. | Standard |
