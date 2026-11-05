# Phase 9: Optional Features & Extended Functionality (PH-9)

> **Phase ID:** `PH-9`  
> **Target Status:** P2 Optional Backlog  
> **Source Reference:** `plan.md` §7 (PH-9), §1.2, §6 (FEAT-28 to FEAT-30)  

---

## 1. Goal

Implement approved secondary (P2) features that enhance the desktop Helium feel on specialized form factors (foldables, tablets) or provide advanced navigation power-tools, without compromising core stability or performance.

---

## 2. Features in Scope (P2 Backlog)

| ID | Feature | Priority | Strategy | Description |
|---|---|---|---|---|
| `FEAT-28` | Native Omnibox !bangs | P2 | DEFER -> REIMPL | DuckDuckGo-style `!w`, `!yt`, `!g` offline shortcuts directly parsed in omnibox without remote redirects. |
| `FEAT-29` | Tablet / Foldable Split View | P2 | DEFER -> REIMPL | Side-by-side tab browsing on large screens and foldables using Android multi-window or Chromium's tablet dual-tab layout. |
| `FEAT-30` | Auto-hide Chrome ("Zen Mode") | P2 | DEFER -> REIMPL | Dynamic full-screen browsing where all toolbars auto-hide smoothly during downward scroll and re-appear on upward nudge. |

---

## 3. Explicitly Out of Scope (Do Not Work On)

As established in `plan.md` §1.2 and §6:
- **FEAT-31 Vertical Tabs:** Dropped. Mobile horizontal tab carousels and grids are already optimal for phone screens; vertical tab sidebars waste screen space.
- **FEAT-32 Sync:** Dropped for v1. Desktop Helium's decentralized sync backend is still in active development upstream.
- **Android System WebView Replacement:** Out of scope (high security surface, separate system-level binary).
- **iOS Port:** Impossible due to Apple WebKit engine restrictions.
- **DRM / Widevine L1 Certification:** Closed-source Google CDM licensing is out of scope for open-source builds.

---

## 4. Implementation Guidelines for P2 Features

1. **Prerequisite:** Each feature must have an approved spec document (`docs/ui/FEAT-xx.md`) signed off by the maintainer before any patch is authored.
2. **Feature Flags:** Every P2 feature must be guarded behind a runtime toggle or `base::Feature` so users can completely disable it.
3. **Patch Isolation:** Keep each P2 feature in its own clean patch inside `patches/{{app}}/ui/` to ensure effortless rebase during upstream version bumps.

---

## 5. Exit Criteria

- [ ] Each implemented P2 feature has a signed-off specification.
- [ ] No regression in cold start time or memory usage when features are enabled.
- [ ] Features work smoothly across phone, foldable, and tablet form factors.
