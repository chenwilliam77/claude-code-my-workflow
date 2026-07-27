# CLAUDE.MD -- Academic Project Development with Claude Code

<!-- HOW TO USE: Replace [BRACKETED PLACEHOLDERS] with your project info.
     Customize Beamer environments and CSS classes for your theme.
     Keep this file under ~150 lines — Claude loads it every session.
     See the guide at docs/workflow-guide.html for full documentation. -->

**Project:** [YOUR PROJECT NAME]
**Institution:** [YOUR INSTITUTION]
**Branch:** main

---

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save important plans to `quality_reports/tracked_plans/`
- **Verify after** -- compile/render and confirm output at the end of every task
- **Single source of truth** -- Beamer `.tex` is authoritative; Quarto `.qmd` derives from it
- **Quality gates** -- nothing ships below 80/100 (unless there is no relevant quality gate to use)
- **[LEARN] tags** -- when corrected, save `[LEARN:category] wrong → right` to [MEMORY.md](MEMORY.md)

Cross-session context lives in [MEMORY.md](MEMORY.md); important decisions in [quality_reports/tracked_*](quality_reports/); ephemeral working artifacts in [quality_reports/](quality_reports/) (ignored by git).

---

## Folder Structure

```
[YOUR-PROJECT]/
├── CLAUDE.MD                    # This file
├── .claude/                     # Rules, skills, agents, hooks
├── Bibliography_base.bib        # Centralized bibliography
├── Figures/                     # Figures and images
├── Preambles/header.tex         # LaTeX headers
├── Slides/                      # Beamer .tex files
├── Quarto/                      # RevealJS .qmd files + theme
├── docs/                        # GitHub Pages (auto-generated)
├── claude_utilities/            # Claude Code infrastructure scripts (quality scoring, sync, checks)
├── claude_tasks/                # Folder for large tasks that the user writes for Claude to implement
├── programs/                    # Analysis and data cleaning code (R, Python, Stata, etc.)
├── quality_reports/             # Session artifacts
│   ├── tracked_plans/           # ✅ TRACKED — Important plans that form project record
│   ├── tracked_reports/         # ✅ TRACKED — Important reports that form project record
│   ├── tracked_handoffs/        # ✅ TRACKED — Important handoffs for next session
│   ├── plans/                   # Ephemeral LLM plans (ignored in .gitignore)
│   ├── reports/                 # Ephemeral LLM reports (ignored in .gitignore)
│   ├── handoffs/                # Ephemeral LLM handoffs (ignored in .gitignore)
│   ├── session_logs/            # Session logs (tracked)
│   ├── specs/                   # Ephemeral specs (ignored in .gitignore)
│   ├── merges/                  # Quality reports at merge time (tracked)
│   ├── decisions/               # Decision records (tracked)
│   ├── checkpoints/             # Technical state snapshots (ephemeral, ignored)
│   └── preregistrations/        # Preregistration documents (tracked)
├── explorations/                # Research sandbox (see rules)
├── templates/                   # Session log, quality report templates
└── master_supporting_docs/      # Papers and existing slides
```

**Two-tier system:**
- **Tracked** (`tracked_*`, `session_logs`, `merges`, `decisions`, `preregistrations`): Git-versioned decision documents. Use when you want a decision to persist.
- **Ephemeral** (`plans/`, `reports/`, `handoffs/`, `specs/`, `checkpoints/`): LLM-generated working artifacts. Disposable after the task completes. Ignored by .gitignore.

---

## Commands

```bash
# LaTeX (3-pass, XeLaTeX only)
cd Slides && TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode file.tex
BIBINPUTS=..:$BIBINPUTS bibtex file
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode file.tex
TEXINPUTS=../Preambles:$TEXINPUTS xelatex -interaction=nonstopmode file.tex

# Deploy Quarto to GitHub Pages
./claude_utilities/sync_to_docs.sh LectureN

# Quality score
python claude_utilities/quality_score.py Quarto/file.qmd

# Palette sync (LaTeX ↔ SCSS)
./claude_utilities/check-palette-sync.sh

# Surface-count sync (README ↔ CLAUDE.md ↔ guide ↔ landing page)
./claude_utilities/check-surface-sync.sh
```

**Palette contract:** color names in `Preambles/header.tex` must match SCSS variables in `Quarto/theme-template.scss`. See [`Preambles/README.md`](Preambles/README.md).

---

## Quality Thresholds (advisory)

| Score | Checkpoint | Meaning |
|-------|------|---------|
| 80 | Commit | Good enough to save |
| 90 | PR | Ready for deployment |
| 95 | Excellence | Aspirational |

Enforced by `/commit` (halts + asks for override) **and** — once you run `./scripts/install-hooks.sh` — by a real git pre-commit hook (`.githooks/pre-commit`) that runs the surface-sync + quality (≥80) gates on every commit. Bypass sparingly with `SKIP_QUALITY_GATE=1` or `--no-verify`.

---

## Skills Quick Reference

The full table of all skills lives in [README.md](README.md#skills-claudeskills). Most-used, by workflow:

- **Slides / teaching:** `/create-lecture` `/compile-latex` `/deploy` `/qa-quarto` `/slide-excellence` `/syllabus` `/teach-from-paper` `/scaffold-exercises`
- **Papers / review:** `/review-paper` (`--peer`) `/seven-pass-review` `/respond-to-referees` `/verify-claims` `/proofread` `/humanize` `/submission-disclosures`
- **Data / reproducibility:** `/data-analysis` `/did-event-study` `/simulation-study` `/audit-reproducibility` `/diagnose` `/replication-package` `/capture-environment` `/power-analysis` `/disclosure-check`
- **Research / writing:** `/interview-me` `/lit-review` `/research-ideation` `/preregister` `/grant-proposal` `/data-management-plan`
- **Meta / workflow:** `/commit` `/learn` `/new-skill` `/checkpoint` `/context-status` `/deep-audit` `/coauthor-brief` `/triage-inbox` `/wrap-session` `/contract-status`

Stata (`/stata-replication`), R packages (`/r-package-check`), TikZ (`/extract-tikz`, `/new-diagram`), and more — see the README for the complete index.

---

<!-- CUSTOMIZE: Replace placeholder rows ([your-env], [.your-class]) with your own.
     Delete the rows marked "(example — delete)" once you've added yours. -->

## Beamer Custom Environments

| Environment | Effect | Use Case |
| --- | --- | --- |
| `[your-env]` | [Description] | [When to use] |
| `keybox` | Gold background box | Key points *(example — delete)* |
| `definitionbox[Title]` | Blue-bordered titled box | Formal definitions *(example — delete)* |

## Quarto CSS Classes

| Class | Effect | Use Case |
| --- | --- | --- |
| `[.your-class]` | [Description] | [When to use] |
| `.smaller` | 85% font | Dense content *(example — delete)* |
| `.positive` | Green bold | Good annotations *(example — delete)* |

---

## Current Project State

| Lecture | Beamer | Quarto | Key Content |
| --- | --- | --- | --- |
| HelloWorld *(sample — delete when ready)* | `HelloWorld.tex` | `HelloWorld.qmd` | Minimal deck to verify setup |
| 1: [Topic] | `Lecture01_Topic.tex` | `Lecture1_Topic.qmd` | [Brief description] |

---

### Tracking Progress Across Sessions

**Ephemeral working artifacts** (auto-generated by Claude during tasks):
1. Session logs go in `quality_reports/session_logs/` with a date stamp (auto-created during tasks)
2. Working plans go in `quality_reports/plans/` (overwritten or discarded as work progresses)
3. Handoff documents go in `quality_reports/handoffs/` (working copies to resume next session)

**Important decision documents** (should be committed to git):
1. When you explicitly want a plan to be part of the project record → save to `quality_reports/tracked_plans/`
2. When you want to archive an important report → save to `quality_reports/tracked_reports/`
3. When a handoff captures critical context for future sessions → move to `quality_reports/tracked_handoffs/`

To promote an artifact from ephemeral to tracked: copy/rename the file into the corresponding `tracked_*` folder and commit it. This signals "this decision matters for the project record."