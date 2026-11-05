# Phase 8: Release and Maintenance Automation (PH-8)

> **Phase ID:** `PH-8`  
> **Target Status:** Automation & Long-Term Sustainability  
> **Source Reference:** `plan.md` §7 (PH-8), §12, §13  

---

## 1. Goal

Establish an automated release pipeline and a resilient **monthly rebase bot loop** that allows the project to stay synchronized with upstream Chromium / Vanadium security releases within a strict 7-day SLA without breaking custom patches.

---

## 2. Release & Versioning Strategy

- **Version Number Scheme:** `<chromium_major>.<app_revision>` (e.g., `132.1`, `132.2`).
- **Distribution Channels:**
  - **Primary:** GitHub Releases + Obtainium (direct APK download, auto-updater compatible).
  - **Secondary:** F-Droid / IzzyOnDroid repo (if build criteria met).
  - **Optional:** Google Play Store (requires AAB and store policy audit; task T-8.4).
- **Security SLA:** Ship a release within **≤ 7 days** of an upstream Chromium security announcement.

> [!WARNING]
> **Hard Rebase Rule:** If upstream changes break the MV2 patch and it cannot be cleanly resolved within the 7-day security window, **ship the security release anyway** (falling back to MV3 or disabled MV2 with prominent user notice), rather than holding security fixes hostage.

---

## 3. Tasks Breakdown

### `T-8.1` — Automated Release Pipeline
- **Goal:** Trigger full release packaging on Git tag push.
- **Workflow:** `.github/workflows/release.yml`
  - Compile arm64-v8a, armeabi-v7a, x86_64 release APKs and AAB bundles.
  - Sign artifacts using GitHub Actions secrets (`apksigner`).
  - Generate SHA-256 checksums and GitHub build attestation (SLSA provenance).
  - Generate automated changelog from commit messages and publish GitHub Release.

---

### `T-8.2` — Upstream Watcher & Rebase Bot Workflow
- **Goal:** Automate detection of new Chromium/Vanadium releases and initial patch rebase.
- **Workflow:** `.github/workflows/rebase-bot.yml`
  - Runs on schedule (e.g. daily) checking for new tags in `GrapheneOS/Vanadium`.
  - On new release:
    1. Bump `versions.lock`.
    2. Run `patch.sh` to apply `patches/series`.
    3. If all patches apply cleanly: trigger test build and open a PR.
    4. If any patch fails: open a detailed issue listing conflicting files and upstream diffs.

---

### `T-8.3` — AI-Assisted Patch Conflict Resolution
- **Goal:** Standardized workflow for resolving patch conflicts.
- **Agent Protocol:**
  - Read upstream git diff for the conflicting files.
  - Explain the semantic change introduced upstream.
  - Generate a rebased replacement patch with tag `Subject: [REBASE-FIX] ...`.
  - Re-verify against test suite and submit for maintainer approval.

---

### `T-8.4` — App Store Metadata & Policy Review (Optional)
- **Goal:** Prepare store assets if publishing on Google Play Store.
- **Artifacts:**
  - Fastlane metadata structure (`metadata/android/...`).
  - Privacy policy document reflecting zero-data-collection.
  - Google Play policy review (ensuring extension sideloading adheres to store terms).

---

## 4. Exit Criteria

- [ ] Complete upstream version bump executed end-to-end through the automated pipeline.
- [ ] Signed release APKs published with verified checksums and provenance attestations.
- [ ] Rebase bot successfully detects and reports upstream tag changes.
