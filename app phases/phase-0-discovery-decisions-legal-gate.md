# Phase 0: Discovery, Decisions, and Legal Gate (PH-0)

> **Phase ID:** `PH-0`  
> **Target Status:** Mandatory Prerequisite  
> **Source Reference:** `plan.md` §7 (PH-0), §2, §3, §4.2  

---

## 1. Goal

Gain a deep, authoritative understanding of all upstream codebases (Titanium, Vanadium, Helium Desktop, ungoogled-chromium, uBlock Origin) and resolve all foundational architectural and legal decisions before writing any production code or patch sets.

---

## 2. Hard Rules & Constraints for this Phase

- **R-NO-INVENT:** Quote exact file paths, commit hashes, licenses, and config lines from upstream repos.
- **Legal Gate:** Do not proceed with patch adoption until licenses are fully audited in `docs/LICENSES.md`. Identify and resolve any GPL-2.0 vs. GPL-3.0 compatibility issues.
- **No Unapproved Decisions:** Base architecture options (ADR-01), branding identity (ADR-02), and update channels (ADR-03) must be formally written and approved by the maintainer.

---

## 3. Tasks Breakdown

### `T-0.1` — Titanium Codebase Deep Dive & Analysis
- **Goal:** Analyze the primary reference for running extensions on Android Chromium.
- **Upstream:** `jqssun/android-titanium-browser` (GPL-2.0).
- **Steps:**
  1. Inspect the repo layout: `vanadium` submodule, `.gclient`, `args.gn`, `build.sh`, `common.sh`, `patch.sh`, `res/`, `extensions/`.
  2. Read every patch across its categories:
     - Feature Overrides
     - UI Overrides
     - Manifest V2 + Secure Off Store Install Support
     - Miscellaneous Fixes
  3. Study extension installation flows: Chrome Web Store (mobile desktop-site spoof/button fix), Edge Add-ons, Opera Add-ons, local CRX/ZIP, SAF unpacked picker.
- **Deliverable:** `docs/research/titanium.md` summarizing each patch in 1–2 lines grouped by category.

---

### `T-0.2` — Vanadium Security & Privacy Audit
- **Goal:** Inventory Vanadium’s hardening and privacy patches to know what comes for "free".
- **Upstream:** `GrapheneOS/Vanadium`.
- **Steps:**
  1. Audit Vanadium’s patch series (`patches/*.patch` and `subprojects_patches/**`).
  2. Categorize patches into: security hardening (memory tags, CFI, JIT toggles), de-Googling/privacy, and build/upstream sync adjustments.
  3. Identify potential overlaps or conflicts with Helium's desktop privacy patches.
- **Deliverable:** `docs/research/vanadium.md`.

---

### `T-0.3` — Helium Desktop Patch Inventory
- **Goal:** Inventory all patches from Helium desktop (`imputnet/helium` / `helium-chromium`).
- **Steps:**
  1. Inspect `patches/series` and patch grouping (upstream backports, Inox, Iridium, ungoogled-chromium, Bromite, Brave, Helium-specific).
  2. Inventory Helium Services integration (extension/filter proxies, onboarding).
  3. Inventory uBO component extension integration (`third_party/ublock`).
- **Deliverable:** `docs/research/helium.md` (inventory only; deep triage happens in PH-2).

---

### `T-0.4` — Legal Gate & License Matrix
- **Goal:** Ensure full legal compliance across all donor projects.
- **Steps:**
  1. Record the SPDX license identifier and copyright for:
     - Chromium (BSD-3-Clause)
     - Vanadium (GPL-2.0-only / BSD)
     - Titanium Browser for Android (GPL-2.0)
     - Helium desktop (GPL-3.0)
     - ungoogled-chromium (BSD-3-Clause)
     - uBlock Origin (GPL-3.0)
     - imput's uBlock fork (if applicable)
  2. Check license compatibility: Analyze interaction between GPL-2.0 (Titanium base) and GPL-3.0 (Helium / uBO patches).
  3. Define patch attribution requirements (preserving copyright headers, `Origin:` field in patch headers).
- **Deliverable:** `docs/LICENSES.md`.

---

### `T-0.5` — Architecture Decision Records (ADRs)
- **Goal:** Produce foundational decision documents for maintainer sign-off.
- **Deliverables:**
  1. `docs/ADR/ADR-01-base-selection.md`: Choose between:
     - **Option A (Recommended):** Vanadium as submodule + Titanium patch layers + Helium privacy/UI layers.
     - **Option B:** Vanadium submodule + original extensions/MV2 implementation.
     - **Option C:** Direct upstream contributions to Titanium.
  2. `docs/ADR/ADR-02-branding-and-identity.md`: Define `{{APP_NAME}}` (MUST NOT be "Helium" or "Titanium"), package ID `{{PACKAGE_ID}}`, app icon concept, and visual theme.
  3. `docs/ADR/ADR-03-network-paths.md`: Architecture for filter-list and extension updates (direct gorhill/Chrome Web Store, self-hosted proxy, or partner endpoints).

---

## 4. Exit Criteria

- [ ] `docs/research/titanium.md` complete and reviewed.
- [ ] `docs/research/vanadium.md` complete and reviewed.
- [ ] `docs/research/helium.md` complete and reviewed.
- [ ] `docs/LICENSES.md` finalized with no license blockers.
- [ ] ADR-01, ADR-02, and ADR-03 approved and signed off by the maintainer.
