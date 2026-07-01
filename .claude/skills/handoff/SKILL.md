---
name: handoff
description: Create a handoff document for a new session to continue this work. Writes to `quality_reports/handoffs/handoff_YYYYMMDD_short_description.md`. Focuses on the context a fresh session needs — goal, current state, key decisions — plus a short-form index of reference files so the new session can dig deeper without reading everything. Use when user says "create a handoff", "write a handoff doc", "handoff to next session", "prepare handoff", or "document current state for handoff".
argument-hint: "<short_description>"
allowed-tools: ["Read", "Write", "Bash"]
---

# /handoff — Session Handoff Document

Produce a handoff document that lets a fresh session (or collaborator) reach productive speed in under 2 minutes. Unlike `/checkpoint` (which captures structured state for a technical resume), a handoff prioritizes *context*: why this work matters, what decisions were made, and where to look for more detail.

## Key distinction from /checkpoint

- **`/checkpoint`** = "resume exactly where I stopped" (file pointers, next actions, git state)
- **`/handoff`** = "here's everything you need to understand and continue this work" (context, rationale, reference map)

Use both together for a complete session close: `/checkpoint` for technical state, `/handoff` for context.

## When to use

- At the end of a working session you expect to continue later.
- Before handing work to a collaborator.
- Before a context switch where you'll lose the mental model.
- When the session log is long and a new session shouldn't have to read all of it.

## Workflow

### PHASE 1 — Gather context

Read, in this order:

1. **Most recent plan** — `ls -t quality_reports/plans/*.md | head -1`. Extract: goal, approach, status (DRAFT/APPROVED/COMPLETED), remaining steps.
2. **Most recent session log** — `ls -t quality_reports/session_logs/*.md | head -1`. Extract: objective, key decisions, open questions, next steps.
3. **Most recent checkpoint** (if any) — `ls -t quality_reports/checkpoints/*.md 2>/dev/null | head -1`. Extract file pointers and next actions if present.
4. **Git state** — `git log --oneline -10`, `git status -s`, `git branch --show-current`. Note: current branch, how far ahead of main, any uncommitted files.
5. **Reference inventory** — scan the following for files relevant to this work:
   - `quality_reports/plans/` (last 3 files)
   - `quality_reports/specs/` (last 2 files, if directory exists)
   - `quality_reports/decisions/` (last 2 files, if directory exists)
   - `quality_reports/session_logs/` (last 3 files)
   - `CLAUDE.md` (project state table at the bottom)
   - `MEMORY.md` (any `[LEARN]` entries that bear on current work)
   - Any files heavily modified this session (`git diff --stat HEAD`)

For each reference file found, capture: filename, one-sentence purpose, and whether it's essential (must-read) or optional (dig-deeper).

If any read fails (missing file), record "(none found)" rather than fabricating.

### PHASE 2 — Write the handoff document

Output filename: `quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md`
- Date: today's date in YYYYMMDD format.
- Slug: from `$ARGUMENTS` if provided; otherwise derive from the active plan title (strip date, lowercase, hyphens). If neither available, prompt the user for a slug.

Use this template:

```markdown
---
date: YYYY-MM-DD
branch: <current branch>
status: <in_progress | paused | ready-to-merge>
plan: <path to active plan, or "(none)">
---

# Handoff: <short description>

## What this work is about (1-2 sentences)
<Goal: what problem we're solving and why it matters. No jargon. A fresh session should understand this without reading anything else.>

## Current state
<Where things stand right now. 3-6 bullet points. What's done, what's in-flight, what's blocked. Be specific — vague summaries ("some progress made") are useless.>
- ✅ [completed item]
- 🔄 [in-progress item]
- ⏳ [not yet started]
- ❌ [blocked / problem]

## Key decisions made this session
<2-5 bullet points on WHY we did what we did. Things not obvious from the code or files. Skip if nothing non-obvious was decided — do not pad.>
- [Decision]: [rationale in one sentence]

## What to do next
<Ordered list of the next 1-4 concrete actions. Imperative form. Specific enough that a fresh session can start immediately without re-deriving the plan.>
1. [Action]
2. [Action]
3. [Action]

## Open questions / blockers
<Specific unresolved questions. Mark priority: [HIGH] / [LOW]. Empty if none — do not fabricate.>
- [HIGH/LOW] [Question]

## Reference file index
<Short-form index of files the new session may want to consult. Two tiers: must-read and optional. One line per file: path → purpose.>

### Must-read
- `<path>` — <one-sentence purpose>

### Dig deeper (optional)
- `<path>` — <one-sentence purpose, and what specific question it answers>

## Resume prompt
> Read `quality_reports/handoffs/<this-filename>`, then begin with action 1 above.
```

**Length target:** 40–70 lines. If you need more, the plan file (not the handoff) is the right place. The handoff is a gateway to other files, not a dump of them.

### PHASE 3 — Output summary

Print to chat:

```
Handoff saved: quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md
  Branch: <branch>    Status: <status>
  Reference files indexed: <N>
  Next action: <action 1 from the handoff>

Paste this into your next session to resume:
> Read quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md, then begin with action 1.
```

## Cross-references

- `.claude/skills/checkpoint/SKILL.md` — technical complement; `/checkpoint` captures file pointers and git state, `/handoff` captures context and rationale. Use both at session close.
- `.claude/rules/session-logging.md` — narrative record; the handoff references the session log by path, does not retell the story.
- `.claude/rules/plan-first-workflow.md` — the active plan is the primary artifact; the handoff is an index pointing back to it.
- `quality_reports/handoffs/` — output directory for all handoff documents.

## Troubleshooting

**No active plan.** Write the handoff with `plan: (none)` and include a warning in "Open questions": the new session should enter plan mode before proceeding.

**Slug not provided and plan title is ambiguous.** Ask the user for a short slug (3-5 words, hyphenated). Do not fabricate one.

**Session is very early / little has happened.** Still write the handoff, but keep "Current state" and "Key decisions" sections brief — one or two bullets is fine. The reference index is still valuable.
