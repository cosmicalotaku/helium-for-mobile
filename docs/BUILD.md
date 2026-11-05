# Aether Browser Build & Developer Guide (T-1.3, T-1.6)

> **Document:** `docs/BUILD.md`  
> **Target OS:** Android (`target_os = "android"`)  
> **Primary ABI:** `arm64-v8a` (`target_cpu = "arm64"`)  
> **Package ID:** `app.aether.browser`  

---

## 1. Hardware & Host Prerequisites

Compiling Chromium for Android requires substantial host resources:

- **Operating System:** Ubuntu 22.04 / 24.04 LTS (or Debian 12 / WSL2 on Windows).
- **CPU:** 8+ cores (16+ threads recommended).
- **RAM:** Minimum 32 GB RAM (64 GB or swap space strongly recommended to avoid OOM during linking).
- **Disk:** Minimum 300 GB free high-speed SSD space.
- **Tools:** Python 3.10+, Git, curl, Java 17+ (provided by Chromium `depot_tools`).

---

## 2. GN Configuration & Build Targets

### 2.1 Release Profile (`args.gn`)
```gn
chrome_public_manifest_package = "app.aether.browser"
is_desktop_android = true
target_os = "android"
target_cpu = "arm64"
is_component_build = false
is_debug = false
is_official_build = true
symbol_level = 1
disable_fieldtrial_testing_config = true
use_login_database_as_backend = true
ffmpeg_branding = "Chrome"
proprietary_codecs = true
```

### 2.2 Debug Profile (`args.debug.gn`)
For rapid incremental development:
```gn
chrome_public_manifest_package = "app.aether.browser"
is_desktop_android = true
target_os = "android"
target_cpu = "arm64"
is_component_build = true
is_debug = true
is_official_build = false
symbol_level = 1
use_login_database_as_backend = true
```

### 2.3 Build Targets
- **APK Target:** `chrome_public_apk` (generates standalone APK for direct installation).
- **Bundle Target:** `chrome_public_bundle` (generates `.aab` for Play Store distribution).

---

## 3. Automated Local Build

To run the end-to-end sync, patch, compile, and sign process:

```bash
chmod +x *.sh
./build.sh
```

Artifacts will be output to:
- `chromium/src/out/release/aether-<version>-arm64-v8a.apk`
- `chromium/src/out/release/aether-<version>-arm64-v8a.aab`

---

## 4. Rapid Developer Loop (Incremental Builds)

Once the source is synced and patched, rebuild only modified Java or C++ files without re-running the full script:

```bash
cd chromium/src
autoninja -C out/Default chrome_public_apk
```

Then push the updated build directly to your connected device:
```bash
adb install -r -d out/Default/apks/ChromePublic.apk
```

---

## 5. Testing Over Wireless Debugging

You can test Aether Browser completely wirelessly without needing a USB cable.

### 5.1 Pairing on Android 11+ (Native Wireless ADB)
1. On your phone, connect to the same Wi-Fi network as your workstation.
2. Open **Settings > Developer options > Wireless debugging** and switch it **ON**.
3. Tap **Pair device with pairing code**. Note the IP, pairing port, and 6-digit code.
4. On your PC:
   ```bash
   adb pair <PHONE_IP>:<PAIRING_PORT> <6_DIGIT_CODE>
   ```
5. Connect using the main IP & port shown on the main Wireless Debugging screen:
   ```bash
   adb connect <PHONE_IP>:<CONNECT_PORT>
   ```
6. Verify connection:
   ```bash
   adb devices
   ```

### 5.2 Legacy Wireless Setup (Android 10 and below)
1. Connect via USB cable once:
   ```bash
   adb tcpip 5555
   ```
2. Unplug the cable and connect over your phone's local IP:
   ```bash
   adb connect <PHONE_IP>:5555
   ```

### 5.3 Installing the App Wirelessly
```bash
adb install -r -d chromium/src/out/release/aether-*.apk
```

### 5.4 Live Logging & Inspection
- **Filter Chromium Logcat:**
  ```bash
  adb logcat -s chromium
  ```
- **Inspect Web Pages & Extension Popups:**
  1. Open Chrome/Chromium on your PC.
  2. Navigate to `chrome://inspect/#devices`.
  3. Your phone running Aether will appear under "Remote Target", allowing real-time DevTools inspection of any open tab or active extension popup.
