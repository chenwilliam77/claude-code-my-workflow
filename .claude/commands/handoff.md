---
name: handoff
description: Create a handoff document for a new session. Writes a context-rich summary to `quality_reports/handoffs/handoff_YYYYMMDD_slug.md` with goal, current state, decisions made, next steps, and a reference file index.
usage: /handoff <short_description>
---

# /handoff — Create a Handoff Document

Produce a handoff document that transfers context from this session to the next. Unlike `/checkpoint` (structured file pointers, git state), a handoff prioritizes narrative: why this work matters, what was decided, and where to look for detail.

## When to use

- At the end of a working session you expect to continue later
- Before handing work to a collaborator
- Before a context switch where mental model will be lost
- When the session log is long and a new session shouldn't read all of it

## Output

Handoff saved to: `quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md`

The document includes:
- **Metadata** (date, branch, status)
- **What this work is about** (1-2 sentences, no jargon)
- **Current state** (3-6 bullets on done/in-flight/blocked)
- **Key decisions** (2-5 bullets on why, not what)
- **What to do next** (ordered list of concrete actions)
- **Open questions / blockers** (specific unresolved items with priority)
- **Reference file index** (must-read and optional dig-deeper files)
- **Resume prompt** (one-line instruction for next session)

## Workflow

**Phase 1 — Gather context** (automated)
- Read most recent plan, session log, checkpoint, and git state
- Scan reference files (plans/, specs/, decisions/, session_logs/, CLAUDE.md, MEMORY.md, git diff --stat)
- Compile list of relevant files

**Phase 2 — Write handoff document**
- Filename: `quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md`
- Slug from argument or derived from active plan title; if neither, prompt user
- Fill template (see Template section below)
- Length target: 40–70 lines (gateway, not dump)

**Phase 3 — Output summary**
- Print: saved path, branch, status, file count, next action
- Include one-liner resume prompt for next session

## Template

```markdown
---
date: YYYY-MM-DD
branch: <branch>
status: <in_progress | paused | ready-to-merge>
plan: <path or "(none)">
---

# Handoff: <short description>

## What this work is about
<1-2 sentences. Goal and why it matters. No jargon.>

## Current state
<3-6 bullets. What's done (✅), in-flight (🔄), blocked (❌).>

## Key decisions made this session
<2-5 bullets. WHY, not what. Non-obvious rationale only.>

## What to do next
<Ordered list of 1-4 concrete actions. Imperative form.>

## Open questions / blockers
<Specific unresolved items with priority: [HIGH]/[LOW]. Empty if none.>

## Reference file index

### Must-read
- `<path>` — <one-sentence purpose>

### Dig deeper (optional)
- `<path>` — <purpose and question it answers>

## Resume prompt
> Read `quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md`, then begin with action 1.
```

## Complementary Commands

- **`/checkpoint`** — captures technical state (file pointers, git, next actions). Use at session close with `/handoff`.
- **`/resume-handoff`** — reads a handoff document, verifies current state, and creates an action plan for the next session.

## Troubleshooting

**No active plan:** Write with `plan: (none)` and warn in "Open questions" that next session should enter plan mode.

**No slug provided:** Ask user for 3-5 word hyphenated slug. Do not fabricate.
