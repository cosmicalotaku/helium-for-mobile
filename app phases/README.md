# App Development Phases Index

This directory contains standalone execution guides for each development phase of the project, derived from the master specification in [`plan.md`](../plan.md).

---

## Roadmap & Phase Directory

| Phase Document | Title & Focus | Milestone Type | Status |
|---|---|---|---|
| [**Phase 0**](phase-0-discovery-decisions-legal-gate.md) | **Discovery, Decisions, & Legal Gate**<br>Audit upstreams, resolve GPL licenses, write ADR-01..03 | Prerequisite Gate | **DONE** |
| [**Phase 1**](phase-1-reproducible-build-infrastructure.md) | **Reproducible Build Infrastructure**<br>Sync, build scripts, branding, CI workflow, testable APK | **First Testable APK** | **DONE** |
| [**Phase 2**](phase-2-patch-triage-ledger.md) | **Patch Triage Ledger**<br>Classify all Helium desktop patches in `PATCH_LEDGER.yaml` | Triage & Planning | **DONE** |
| [**Phase 3**](phase-3-privacy-and-degoogling-core.md) | **Privacy & De-Googling Core**<br>Eliminate tracking, promos, telemetry; zero network requests | Core Privacy | **DONE** |
| [**Phase 4**](phase-4-extensions-runtime-and-mv2.md) | **Extensions Runtime & MV2 Support**<br>Chrome Web Store install, Manifest V2, bottom-sheet popups | **P0 Critical Path** | **DONE** |
| [**Phase 5**](phase-5-builtin-ublock-origin.md) | **Built-in uBlock Origin**<br>Bundle full MV2 uBO as a pre-installed component extension | Core Feature | **DONE** |
| [**Phase 6**](phase-6-helium-feel-ui-and-customization.md) | **Helium-Feel UI & Customization**<br>Compact toolbar, custom buttons, clean NTP, accent colors | Visual & UX | **Ready to start** |
| [**Phase 7**](phase-7-hardening-performance-qa.md) | **Hardening, Performance, & QA**<br>Memory benchmarks, privacy leak audits, security review | Quality Gate | Planned |
| [**Phase 8**](phase-8-release-and-maintenance-automation.md) | **Release & Maintenance Automation**<br>Automated builds, SLSA attestation, monthly rebase bot | Sustainability | Planned |
| [**Phase 9**](phase-9-optional-features.md) | **Optional Features (P2 Backlog)**<br>Omnibox !bangs, tablet split-view, auto-hide Zen chrome | Extended Backlog | Deferred |

---

## How to Work Through the Phases

1. **Strict Linear Progression:** Each phase has documented **Exit Criteria**. Complete all exit criteria before advancing to the next phase, unless the maintainer authorizes parallel execution.
2. **Task Cards (`T-n.m`):** Always execute work one task card at a time.
3. **Patch Ledger & Status:** Keep `docs/PATCH_LEDGER.yaml` and `docs/STATUS.md` up to date as tasks transition from `todo` to `done`.
