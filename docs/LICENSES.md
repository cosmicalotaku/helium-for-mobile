# Open Source License Matrix & Legal Gate Audit (T-0.4)

> **Document:** `docs/LICENSES.md`  
> **Status:** Legal Gate Review  
> **Requirement:** Mandatory sign-off prior to code integration  

---

## 1. Upstream Donor License Inventory

| Project / Component | Primary License | Permissive vs. Copyleft | Upstream Copyright Holder | Notes |
|---|---|---|---|---|
| **Chromium** | `BSD-3-Clause` | Permissive | The Chromium Authors | Permissible in GPL-2.0 and GPL-3.0 derivative works. |
| **Vanadium** | `GPL-2.0-only` | Strong Copyleft (v2 only) | Copyright © 2016–2026 GrapheneOS | Base submodule. Explicitly GPLv2-only with WebView exceptions. |
| **Titanium Browser** | `GPL-2.0` | Strong Copyleft (v2) | Copyright © jqssun, Vanadium contributors | Extension layer and Android build foundation. |
| **Helium Desktop** | `GPL-3.0` | Strong Copyleft (v3) | Copyright © imputnet | Desktop browser patch series and services. |
| **ungoogled-chromium** | `BSD-3-Clause` | Permissive | ungoogled-chromium contributors | Donor for de-Googling patches and domain lists. |
| **Inox Patchset** | `MIT` / `BSD-2-Clause` | Permissive | Inox browser contributors | Donor for network & privacy patches. |
| **uBlock Origin** | `GPL-3.0` | Strong Copyleft (v3) | Copyright © Raymond Hill (gorhill) | Component extension; packaged as standalone web assets. |

---

## 2. In-Depth Compatibility Analysis: GPL-2.0-only vs. GPL-3.0

### The Core Conflict
Under software licensing law (and Free Software Foundation guidance), code licensed strictly as **GPL-2.0-only** cannot be directly merged, statically compiled, or linked into the same binary with code licensed strictly as **GPL-3.0**, due to conflicting requirements regarding DRM/anti-tivoization and patent termination clauses.

Because our base layer (**Vanadium**) is explicitly licensed as **GPL-2.0-only**, we must strictly govern how upstream code is integrated:

### Legal Rules for Integration:

1. **Permissive Donors (Chromium, ungoogled-chromium, Inox):**
   - Code from these projects is BSD-3-Clause or MIT.
   - *Status:* **100% Compatible.** Permissive code can be incorporated into our GPL-2.0 base without restriction, provided original copyright notices are retained.

2. **Titanium Browser Patches:**
   - Licensed under GPL-2.0.
   - *Status:* **100% Compatible.** Can be adopted and adapted directly into our repository.

3. **Helium Desktop GPL-3.0 Patches:**
   - *Rule:* **NO direct copy-pasting of GPL-3.0-only proprietary C++ code from Helium into our GPL-2.0 codebase.**
   - *Resolution / Safe Harbor:*
     - All UI features (toolbar customization, compact layout, clean menus, settings) are rewritten from scratch in **Android Java and XML** (`REIMPL`), creating an original work under GPL-2.0.
     - Core privacy logic derived from ungoogled-chromium or Inox is sourced from the original BSD/MIT upstreams rather than Helium's GPL-3.0 modifications.
     - Where Helium's C++ logic is unique, we perform a clean-room implementation conforming to standard Chromium internal APIs.

4. **uBlock Origin (GPL-3.0) Component Extension:**
   - uBlock Origin is written entirely in HTML, CSS, and JavaScript. It communicates with the browser strictly through standard Chromium extension IPC APIs (`chrome.webRequest`, `chrome.storage`, `chrome.runtime`).
   - Under Section 2 of GPLv2 and Section 5 of GPLv3, packaging and shipping an extension alongside the browser binary is treated as **mere aggregation on a storage volume**. The extension runs in an isolated WebAssembly/JS sandbox and is not linked into the native C++ binary.
   - *Status:* **Permitted and Legally Sound.** (Mirrors established industry precedents set by Titanium, Brave, and Helium Desktop).

---

## 3. Patch Attribution Requirements

Every patch authored or adapted in this repository must contain valid provenance in its commit header:
```text
Subject: [<area>] <Short description>
Feature: FEAT-xx
Origin: original | adapted-from:<url-or-patch-path>
License: GPL-2.0 | BSD-3-Clause
```
Original copyright banners must never be deleted from upstream files.

---

## 4. Conclusion & Legal Gate Exit

No legal blocker prevents the execution of the project, provided the clean-room re-implementation of Helium's UI in Java is maintained and BSD upstreams are utilized for core privacy logic.
