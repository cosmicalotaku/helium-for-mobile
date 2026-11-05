# ADR-01: Base Architecture & Upstream Selection

> **Status:** Accepted (Recommended)  
> **Date:** 2026-11-04  
> **Author:** Antigravity AI & Maintainer  
> **Deciders:** Project Maintainer  

---

## 1. Context & Problem Statement

To ship a privacy-respecting, de-Googled Android browser with first-class Manifest V2 extension support and built-in uBlock Origin, we must choose an architectural base. Chromium on Android does not natively support extensions or MV2, meaning building from raw upstream Chromium requires solving complex extension runtime challenges.

We have three primary architectural options (§4.2):
- **Option A (Recommended):** Use GrapheneOS's **Vanadium** as the core submodule, adopt **Titanium's** extension runtime and MV2 patches, and build our own Helium-feel privacy, UI, and uBO layers on top.
- **Option B:** Start from Vanadium and build a 100% original Android extension runtime and MV2 re-enablement layer from scratch.
- **Option C:** Contribute directly upstream to the Titanium repository instead of creating an independent downstream project.

---

## 2. Decision Matrix

| Criteria | Option A (Vanadium + Titanium Foundation) | Option B (Vanadium + Original Extensions) | Option C (Upstream to Titanium) |
|---|---|---|---|
| **Time to Working Prototype** | **Fast (Weeks)** | Very Slow (Months) | Fast |
| **Extension Reliability** | **High** (Battle-tested by Titanium users) | High Risk of regressions | High |
| **Control Over "Helium Feel" & UI** | **Total Control** | Total Control | Low (Titanium delegates UI to external extension) |
| **Maintenance Burden** | **Moderate** (Follows Vanadium/Titanium monthly tags) | Extremely High (Sole maintainer of Chromium internals) | Low |
| **Built-in uBO Integration** | **Direct & Native** (Custom component packaging) | Direct & Native | Dependent on upstream approvals |

---

## 3. Decision

We choose **Option A**:
1. Pinned **GrapheneOS Vanadium** as a git submodule for compiler hardening, memory protections, and base de-Googling.
2. Adopt Titanium's proven extension framework:
   - Manifest V2 deprecation bypasses (`webstore_private_api.cc`, `manifest_v2_handler.cc`).
   - Chrome Web Store mobile detection and off-store CRX installs.
   - Mobile popup anchoring and process importance boosting.
3. Build our own modular patch series (`patches/{{app}}/`) on top, providing:
   - Built-in uBlock Origin component extension.
   - Helium-style compact toolbar and user customization in Java/XML.
   - Honest, flat settings and privacy defaults.

---

## 4. Consequences & Mitigations

- **GPL-2.0 Obligations:** By adopting Vanadium and Titanium patches, our project is distributed under the GNU General Public License v2.0. Source code must remain completely open.
- **Monthly Sync:** We track both Vanadium's upstream releases and Titanium's fixes during monthly Chromium updates.
