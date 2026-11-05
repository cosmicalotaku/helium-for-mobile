# Phase 2: Patch Triage Ledger (PH-2)

> **Phase ID:** `PH-2`  
> **Target Status:** Analysis & Planning Phase  
> **Source Reference:** `plan.md` §7 (PH-2), §8  

---

## 1. Goal

Classify every single patch in Helium Desktop's repository (`imputnet/helium`), along with relevant ungoogled-chromium and Bromite patches, to determine its exact applicability to Chromium on Android, producing an exhaustive and auditable patch ledger.

---

## 2. Strategy Taxonomy

Every patch evaluated must be assigned exactly one strategy:

| Strategy | Meaning | Heuristic / Criteria |
|---|---|---|
| `PORT` | Apply or adapt directly to Android | Platform-agnostic C++ (`net/`, `services/network`, non-UI `components/`, default prefs). Compiles on Android. |
| `ADOPT` | Reuse from existing base | Feature already implemented in Vanadium or Titanium. |
| `REIMPL` | Re-implement from scratch | Desktop Views UI (`chrome/browser/ui/views`), WebUI settings, desktop tabs. Must be rewritten in Android Java & XML. |
| `DROP` | Discard entirely | Desktop-specific concepts (split view desktop windows, vertical tabs desktop sidebars, Mac/Win specific code). |
| `DEFER` | Postpone to later phase | Non-essential P2 features (!bangs, advanced multi-window splits). |

---

## 3. Patch Ledger YAML Schema (`docs/PATCH_LEDGER.yaml`)

Every evaluated upstream patch must follow this schema:

```yaml
- id: HL-0001                      # Stable ledger ID
  source: helium                   # helium | ungoogled | bromite | vanadium | titanium | own
  upstream_path: patches/helium/core/example.patch
  summary: "One line: what it does."
  touched_paths:
    - chrome/browser/ui/views/...
  compiles_on_android: no          # yes | no | partial (with reason)
  android_reason: "Views UI is desktop-only"
  covered_by_base: none            # none | vanadium | titanium (+ which patch)
  strategy: REIMPL                 # PORT | ADOPT | REIMPL | DROP | DEFER
  feature: FEAT-13                 # Maps to feature matrix (§6)
  effort: M                        # S | M | L
  security_review: false           # Mandatory true for network, permissions, IPC
  status: todo                     # todo | in_progress | done | dropped
  our_patch: patches/{{app}}/ui/toolbar-customization.patch
  notes: ""
```

---

## 4. Triage Heuristics & Rules

1. **Desktop Views UI:**
   - Paths matching `ui/views`, `chrome/browser/ui/views`, `chrome/browser/ui/webui/side_panel` are desktop-only -> Mark **`REIMPL`** or **`DROP`**.
2. **C++ Core & Network:**
   - Paths matching `net/`, `services/network/`, `components/*` (non-UI), `chrome/browser/*` (non-UI), and `third_party/blink/` -> Mark **`PORT`**.
3. **Preference & Flag Defaults:**
   - Changes to `chrome/browser/prefs/` or `components/*/pref_names.cc` -> Mark **`PORT`** (often trivial).
4. **Settings UI:**
   - WebUI settings pages (`chrome/browser/resources/settings`) do not exist on Android -> Mark **`REIMPL`** (needs Java `PreferenceFragmentCompat`).

---

## 5. Tasks Breakdown

### `T-2.1` — Patch Ingestion into Ledger
- **Goal:** Traverse Helium’s `patches/series` and create a stub entry in `docs/PATCH_LEDGER.yaml` for each patch.
- **Scope:** All core, privacy, UI, and branding patches from `imputnet/helium`.

---

### `T-2.2` — Path & Build Condition Analysis
- **Goal:** Inspect each patch file and check `BUILD.gn` conditions.
- **Verification Method:**
  - For each touched path, check if it is included when `target_os == "android"`.
  - Check whether Vanadium or Titanium has an equivalent patch already addressing the problem.
  - Determine `strategy`, `feature` mapping, `effort` (S/M/L), and flag `security_review` if touching network/IPC/permissions.

---

### `T-2.3` — Triage Summary & Prioritization
- **Goal:** Synthesize the ledger into high-level action groups.
- **Deliverables:**
  - `docs/PATCH_TRIAGE_SUMMARY.md`:
    - Total patch count by strategy (`PORT`, `ADOPT`, `REIMPL`, `DROP`, `DEFER`).
    - Top 15 high-value `PORT` candidates for Phase 3.
    - Full list of `REIMPL` candidates for Phase 6.

---

## 6. Exit Criteria

- [ ] 100% of Helium desktop patches ingested and categorized in `docs/PATCH_LEDGER.yaml`.
- [ ] Maintainer has formally reviewed and approved all `DROP` and `REIMPL` decisions.
- [ ] `docs/PATCH_TRIAGE_SUMMARY.md` is published and signed off.
