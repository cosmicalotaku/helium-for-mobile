# Aether Browser for Android

[![License: GPL-2.0](https://img.shields.io/badge/License-GPLv2-blue.svg)](docs/LICENSES.md)
[![Target: Chromium](https://img.shields.io/badge/Chromium-157.0.8103.38-green.svg)](versions.lock)
[![Build Status](https://img.shields.io/badge/CI-GitHub%20Actions-orange.svg)](.github/workflows/build.yml)

A de-Googled, minimalist, privacy-first Chromium browser for Android featuring **first-class extension support** (Manifest V2 and V3) and **built-in uBlock Origin**, reproducing the clean desktop "Helium feel" on mobile.

---

## Key Highlights

- **Zero Noise:** No Google account sign-in prompts, Discover feeds, promotional notifications, or AI upsells.
- **First-Class Extension Support:** Install directly from the **Chrome Web Store** without switching to desktop mode, sideload from local `.crx`/`.zip` archives, or load unpacked extensions via the Android Storage Access Framework (SAF).
- **Manifest V2 (MV2) Preserved:** Full support for MV2 extension APIs (`webRequestBlocking`), enabling the complete, uncompromised edition of uBlock Origin.
- **Built-in uBlock Origin:** Pre-installed component extension operating immediately on first launch with dedicated touch controls.
- **Minimal Chrome & User Control:** Compact toolbar, user-customizable button layout, clean New Tab Page, and pure AMOLED / Material You theming.
- **Hardened Foundation:** Built on top of [GrapheneOS Vanadium](https://github.com/GrapheneOS/Vanadium) compiler security mitigations and origin-keyed process isolation.

---

## Getting Started & Building

Detailed build instructions, GN argument configurations, and wireless debugging guides are available in [**`docs/BUILD.md`**](docs/BUILD.md).

```bash
# Clone the repository with submodules
git clone --recurse-submodules https://github.com/<owner>/aether-android.git
cd aether-android

# Run the complete build and signing pipeline
chmod +x *.sh
./build.sh
```

---

## Documentation & Architecture

- [**Execution Plan & Brief**](plan.md): Comprehensive project roadmap and technical constraints.
- [**Phase Guides**](app%20phases/README.md): Step-by-step implementation manuals for all 10 project phases.
- [**Research & Upstream Audits**](docs/research/): Deep dives into Titanium, Vanadium, and Helium desktop codebases.
- [**Architecture Decision Records (ADRs)**](docs/ADR/):
  - [ADR-01: Base Selection](docs/ADR/ADR-01-base-selection.md)
  - [ADR-02: App Name, Package ID, & Branding](docs/ADR/ADR-02-branding-and-identity.md)
  - [ADR-03: Filter-List & Extension Update Network Paths](docs/ADR/ADR-03-network-paths.md)
- [**License & Legal Matrix**](docs/LICENSES.md): GPL-2.0, BSD-3-Clause, and copyleft audit.
- [**Project Status Ledger**](docs/STATUS.md): Current task tracker.

---

## Credits & Upstream Projects

Aether Browser is made possible by the incredible work of the open-source community:
- [**GrapheneOS / Vanadium**](https://github.com/GrapheneOS/Vanadium) — Android security hardening and base privacy patches.
- [**Titanium Browser for Android**](https://github.com/jqssun/android-titanium-browser) (`jqssun`) — Android extension runtime and MV2 re-enablement foundation.
- [**Helium Browser**](https://github.com/imputnet/helium) (`imputnet`) — Desktop design philosophy, privacy defaults, and component uBO model.
- [**uBlock Origin**](https://github.com/gorhill/uBlock) (`gorhill`) — Gold standard ad-blocking and content filtering.
- [**ungoogled-chromium**](https://github.com/ungoogled-software/ungoogled-chromium) — De-Googling patches and domain lists.
