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

Enforced by `/commit` (halts + asks for override); not enforced by a git pre-commit hook.

---

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| `/compile-latex [file]` | 3-pass XeLaTeX + bibtex |
| `/deploy [LectureN]` | Render Quarto + sync to docs/ |
| `/extract-tikz [LectureN]` | TikZ → PDF → SVG |
| `/new-diagram [snippet] [output.tex]` | Scaffold a TikZ diagram from the gallery with prevention + review |
| `/proofread [file]` | Grammar/typo/overflow review |
| `/visual-audit [file]` | Slide layout audit |
| `/pedagogy-review [file]` | Narrative, notation, pacing review |
| `/review-r [file]` | R code quality review |
| `/qa-quarto [LectureN]` | Adversarial Quarto vs Beamer QA |
| `/slide-excellence [file]` | Combined multi-agent review |
| `/translate-to-quarto [file]` | Beamer → Quarto translation |
| `/validate-bib` | Cross-reference citations |
| `/devils-advocate` | Challenge slide design |
| `/create-lecture` | Full lecture creation |
| `/commit [msg]` | Stage, commit, PR, merge |
| `/lit-review [topic]` | Literature search + synthesis |
| `/research-ideation [topic]` | Research questions + strategies |
| `/interview-me [topic]` | Interactive research interview |
| `/review-paper [file]` | Manuscript review (single-pass / `--adversarial` / `--peer <journal>` simulated pipeline) |
| `/respond-to-referees [report] [manuscript]` | R&R cross-reference + response draft |
| `/data-analysis [dataset]` | End-to-end R analysis |
| `/audit-reproducibility [paper]` | Enforce replication tolerance thresholds on paper ↔ code |
| `/learn [skill-name]` | Extract discovery into persistent skill |
| `/context-status` | Show session health + context usage |
| `/deep-audit` | Repository-wide consistency audit |
| `/permission-check` | Diagnose permission layers when prompts fire unexpectedly |
| `/seven-pass-review` | Seven-pass adversarial manuscript review (parallel forked subagents) |
| `/verify-claims [file]` | Chain-of-Verification fact-check (forked verifier, fresh context) |
| `/checkpoint [topic]` | Save a structured state snapshot (active plan, decisions, file pointers, next actions) before stopping or handing off |
| `/handoff [description]` | Create a context-rich handoff doc (`quality_reports/handoffs/`) with current state, decisions, next actions, and reference file index |
| `/preregister [--style osf|aspredicted|aea-rct]` | Draft a preregistration document (OSF / AsPredicted / AEA RCT Registry) from a research spec |
| `/wrap-session [slug]` | One-command session close: session log + `/checkpoint` + `/handoff` + MEMORY.md check + git report |
| `/contract-status [plan\|latest]` | Read-only mid-contract progress digest (plan items vs. evidence, next action) |

---

## Available Agents

| Agent | Specialized For |
|-------|-----------------|
| `sonnet-beamer-translator` | Beamer → Quarto translation |
| `sonnet-claim-verifier` | Fact-checking with Chain-of-Verification |
| `sonnet-domain-referee` | Manuscript review (substantive) |
| `sonnet-domain-reviewer` | Lecture slides (domain correctness) |
| `sonnet-editor` | Journal editor (desk review + referee selection) |
| `sonnet-methods-referee` | Manuscript review (methodology) |
| `sonnet-pedagogy-reviewer` | Lecture slides (narrative, pacing, notation) |
| `sonnet-quarto-critic` | Quarto → Beamer QA (adversarial) |
| `sonnet-quarto-fixer` | Implements quarto-critic fixes |
| `sonnet-r-reviewer` | R code quality & reproducibility |
| `sonnet-slide-auditor` | Slide layout & visual consistency |
| `sonnet-tikz-reviewer` | TikZ diagram aesthetics & correctness |
| `sonnet-verifier` | End-to-end verification (compile, render, deploy) |
| `haiku-verifier` | End-to-end verification — Haiku tier for mechanical exit-code/grep checks |
| `haiku-proofreader` | Grammar/typo/overflow review — Haiku tier for mechanical pattern checks |
| `data-analysis-project-contractor` | Orchestrates a multi-stage, multi-language data-analysis project (delegates all coding/review/verification) |
| `data-analysis-coder` | Writes analysis code for a stage, in whichever language the task calls for |

*Note: Sonnet agents use Sonnet 5 model for higher quality on specialized tasks. Haiku agents trade judgment for cost on purely mechanical checks — see `.claude/rules/agent-model-selection.md`.*

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