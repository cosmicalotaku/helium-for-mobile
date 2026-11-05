# ADR-02: App Name, Package Identifier, and Visual Identity

> **Status:** Accepted (Recommended)  
> **Date:** 2026-11-04  
> **Author:** Antigravity AI & Maintainer  
> **Deciders:** Project Maintainer  

---

## 1. Context & Trademark Requirements

Per `plan.md` §2.4 (Legal and Branding Rules):
- The product **MUST NOT** use the name, logo, or icon of "Helium" (trademark of imputnet) or "Titanium" (used by jqssun).
- The product must have its own unique, recognizable identity that reflects the browser's core character: lightweight, de-Googled, fast, and protective.

---

## 2. Branding Choices

### 2.1 Product Name & Slug
- **Recommended App Name:** **Aether Browser**  
- **Short Name / Title:** `Aether`  
- **Internal Slug (`{{app}}`):** `aether`  
- *Etymology & Spirit:* "Aether" (the clear sky, pure upper air breathed by the gods) represents clean, unpolluted, zero-noise digital space—a direct thematic parallel to the lightness of Helium without infringing on trademarks.

*(Alternative options considered: `Caelum Browser`, `Aura Browser`, `Helios Browser`)*.

### 2.2 Android Package Identifier (`{{PACKAGE_ID}}`)
- **Primary Package ID:** `app.aether.browser`  
- **Fallback / Alternative:** `io.github.aetherbrowser.android`  
- **GN Arg Assignment:**
  ```gn
  chrome_public_manifest_package = "app.aether.browser"
  ```
- *Properties:* Free from collision with `com.android.chrome`, `org.chromium.chrome`, `io.github.imputnet`, or `io.github.jqssun.helium`. Can be installed side-by-side with stock Chrome and Vanadium.

### 2.3 Visual Identity & Iconography
- **Concept:** Minimalist geometric shield formed by subtle glowing or intersecting arcs (representing privacy, lightness, and speed).
- **Android Adaptive Icon:**
  - Foreground: Stylized geometric shield glyph (White / Neon Teal / Helium Amber accent).
  - Background: Deep matte charcoal (`#121214`) for dark mode / pure black for AMOLED.
  - Monochrome Layer: Dedicated XML vector drawable for Android 13+ Material You themed icons.

---

## 3. Decision

1. Adopt **Aether Browser** (`aether`) as the concrete application name.
2. Adopt **`app.aether.browser`** as the default Android application package ID.
3. Place all branding assets in `res/` and brand patches in `patches/aether/branding/`.
