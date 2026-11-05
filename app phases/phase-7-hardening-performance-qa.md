# Phase 7: Hardening, Performance, and QA (PH-7)

> **Phase ID:** `PH-7`  
> **Target Status:** Quality & Security Validation  
> **Source Reference:** `plan.md` §7 (PH-7), §11, §13  

---

## 1. Goal

Conduct comprehensive performance benchmarking, privacy leak audits, security review verifications, and stress testing across devices to ensure the browser meets production release standards with zero regressions.

---

## 2. Hardening & Performance Budgets

| Metric | Budget Target | Comparison Baseline |
|---|---|---|
| **Cold Start Time** | ≤ 15% delta vs base | Vanadium baseline build |
| **RAM Usage (0 extensions)** | Equal or lower than base | Vanadium baseline build |
| **RAM Usage (with uBO)** | ≤ 15% increase over base | Base build |
| **RAM Usage (5 extensions)** | No Out-Of-Memory (OOM) kills on 4 GB RAM devices | Test device |
| **Battery Consumption** | ≤ 10% delta over 30-min active browsing session | Base build |
| **Crash Rate** | 0 reproducible crashes in smoke suite | Clean logcat |

---

## 3. Tasks Breakdown

### `T-7.1` — Security Review Sign-Off
- **Goal:** Line-by-line review of all patches tagged `SECURITY-REVIEW`.
- **Focus Areas:**
  - `patches/{{app}}/extensions/` (MV2 re-enablement, permission bypasses, off-store install).
  - Networking patches (URL request modifications, header stripping).
  - Subprocess sandboxing & IPC boundary changes.
- **Deliverable:** Signed maintainer audit in `docs/SECURITY_SIGNOFF.md`.

---

### `T-7.2` — Performance & Memory Profiling
- **Goal:** Benchmark performance on real hardware.
- **Scenarios to Profile:**
  1. Cold app launch to New Tab Page interactive state.
  2. Memory footprint with 0, 3, and 10 active extensions.
  3. Continuous 30-minute scroll/navigation test to evaluate battery drain and thermal throttling.
- **Deliverable:** Benchmark results documented in `docs/qa/PERFORMANCE.md`.

---

### `T-7.3` — Privacy Leak & Fingerprinting Verification
- **Goal:** Rigorous verification against standard privacy audit suites.
- **Audit Targets:**
  - **DNS Leaks:** Ensure all lookups respect system / private DNS configurations.
  - **WebRTC Leaks:** Verify private LAN IP addresses are never exposed to remote WebRTC peers.
  - **Referrer Policy:** Validate strict cross-origin referrer trimming.
  - **Fingerprinting Suites:** Run against Cover Your Tracks (EFF), BrowserLeaks, and amiunique.org.
- **Deliverable:** Audit report in `docs/qa/PRIVACY_AUDIT.md`.

---

### `T-7.4` — Local Crash Triage & Stability Smoke Tests
- **Goal:** Run automated stability scripts without sending telemetry anywhere.
- **Automated ADB Smoke Script:**
  1. Install APK on physical device / emulator.
  2. Launch browser and open 20 top web pages sequentially.
  3. Install, enable, disable, and uninstall extensions repeatedly.
  4. Rotate screen orientation, switch to background, and bring back to foreground.
  5. Inspect `adb logcat -s chromium` for fatal exceptions, SIGSEGV, or memory leaks.

---

## 4. Exit Criteria

- [ ] Zero unresolved P0 issues or crashes in the issue tracker.
- [ ] Maintainer has formally signed off on all `SECURITY-REVIEW` patches.
- [ ] Memory and cold-start performance stay strictly within the +15% budget.
- [ ] 100% pass on WebRTC, DNS, and privacy audit checklists.
