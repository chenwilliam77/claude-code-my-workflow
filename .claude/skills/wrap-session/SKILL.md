---
name: wrap-session
description: Run the full session-close ritual in one command — update or create the session log, run /checkpoint, run /handoff, verify MEMORY.md captured this session's [LEARN] entries, and report git state. Composes the existing checkpoint and handoff skills; does NOT commit. Use ONLY when the user explicitly says "wrap session", "wrap up the session", "close out the session", "end of day ritual", or invokes /wrap-session — vague end-of-task phrases like "we're done" are NOT a trigger.
author: Claude Code Academic Workflow
version: 1.0.0
argument-hint: "[short-topic-slug] [--no-memory] [--skip-handoff]"
disable-model-invocation: true
allowed-tools: ["Read", "Write", "Edit", "Bash"]
---

# /wrap-session — One-Command Session Close

Mechanize the session-close checklist from `.claude/rules/handoff-workflow.md` and the artifact table in `.claude/rules/session-logging.md`. One invocation produces (or verifies) all three close-out artifacts — **session log** (narrative), **checkpoint** (technical state), **handoff** (context gateway) — plus a MEMORY.md verification and a read-only git report.

This skill *composes* the existing `/checkpoint` and `/handoff` workflows rather than re-implementing them: read each delegate's definition (`.claude/skills/checkpoint/SKILL.md`, `.claude/commands/handoff.md`) and follow its workflow verbatim. Their file formats live in their own definitions and are not duplicated here. (Direct Skill-tool invocation is not used — `/checkpoint` carries `disable-model-invocation: true`, which blocks model-initiated skill calls even from inside another skill.)

## When to use

- End of a working day or before a long break.
- Before handing the repo to a collaborator or switching machines.
- After completing a significant chunk of a multi-session plan.

## When NOT to use

- **Not a commit.** This skill never stages, commits, or pushes — it recommends `/commit` when the tree is dirty.
- **Not a mid-session save.** For a quick state snapshot between tasks, a bare `/checkpoint` is enough.
- **Not a substitute for incremental logging.** The session log should be written throughout the session per `.claude/rules/session-logging.md`; this skill only appends the end-of-session block.

## Flags

| Flag | Effect |
|------|--------|
| `--no-memory` | Forwarded to `/checkpoint` — skips the [LEARN]-proposal phase, and Phase 4 below is skipped too. |
| `--skip-handoff` | Skips Phase 3 — session log + checkpoint only. Use for short breaks where the same person resumes soon. |

## Workflow

### Phase 1 — Session log (end-of-session block)

1. Find today's log: `ls -t quality_reports/session_logs/*.md 2>/dev/null | head -1`.
2. If the newest log matches today's date, append the end-of-session material per session-logging trigger 3: high-level summary, quality scores (if any were produced), open questions, blockers, and set **Status** to COMPLETED if the session's objective is met.
3. If no log exists for today, create `quality_reports/session_logs/YYYY-MM-DD_<slug>.md` from `templates/session-log.md`, fill it retrospectively from the conversation, and **tell the user incremental logging was missed this session** — that is a process smell to surface, not hide.

### Phase 2 — Checkpoint

Read `.claude/skills/checkpoint/SKILL.md` and execute its workflow verbatim with `<slug>` as the argument, honoring `--no-memory` if given. After it completes, confirm a new file exists in `quality_reports/checkpoints/` dated today. If confirmation fails, stop and report — do not proceed to the handoff with a missing checkpoint.

### Phase 3 — Handoff (skipped with `--skip-handoff`)

Read `.claude/commands/handoff.md` and execute its workflow verbatim with `<slug>` as the argument. Ordering matters: the checkpoint is written first so the handoff's reference file index can point at it. Confirm the file landed in `quality_reports/handoffs/`.

### Phase 4 — MEMORY.md verification (skipped with `--no-memory`)

`/checkpoint`'s Phase 3 *proposes* [LEARN] entries; this phase *verifies* the outcome:

1. Run `git diff MEMORY.md` and compare against the proposals the user accepted in Phase 2.
2. If the user accepted a proposal that never landed on disk, append it now — this is the one direct write this skill performs itself.
3. If zero [LEARN] candidates surfaced all session, report "(none this session)" — a valid outcome; do not pad.

### Phase 5 — Git state report (read-only)

Run `git branch --show-current`, `git status -s`, `git log --oneline -5`, and ahead/behind vs. upstream. Classify the tree:

- **clean** — nothing to do.
- **uncommitted, intentional** — user said work-in-progress stays local; note it in the summary.
- **uncommitted, possibly forgotten** — changes that look finished but uncommitted; recommend `/commit`.

**Never run `/commit`.** Per `.claude/rules/orchestrator-protocol.md`, commits require an explicit user invocation — wrapping a session is not commit authorization.

### Final output

Print a one-screen checklist:

```
✓ Session close — <slug>
─────────────────────────────────
  [✓] Session log:  quality_reports/session_logs/YYYY-MM-DD_<slug>.md
  [✓] Checkpoint:   quality_reports/checkpoints/YYYY-MM-DD_<slug>.md
  [✓] Handoff:      quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md   (or "skipped")
  [✓] MEMORY.md:    <n> [LEARN] entries this session   (or "(none this session)" / "skipped")
  [—] Git:          <branch>, <clean | n uncommitted files → recommend /commit>

Resume prompt:
> Read quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md, then begin with action 1.
```

Use ✗ for any phase that failed, with a one-line reason.

## Examples

### Example 1 — End-of-day full ritual

**User says:** "/wrap-session v19-skills"
**Actions:** append end-of-session block to today's log → `/checkpoint v19-skills` → `/handoff v19-skills` → verify 1 accepted [LEARN] entry landed in MEMORY.md → git report shows 6 uncommitted files, recommend `/commit`.
**Result:** three artifacts on disk, resume prompt printed.

### Example 2 — Quick break, same person resumes

**User says:** "/wrap-session tikz-fixes --skip-handoff --no-memory"
**Actions:** session-log block + `/checkpoint tikz-fixes --no-memory` + git report. No handoff, no memory pass.

## Troubleshooting

**No slug provided.** Derive from the active plan filename (strip the date prefix), as `/checkpoint` does. If there is no active plan either, ask the user for a 3–5 word hyphenated slug — do not fabricate.

**Tempted to improvise the artifact format.** The checkpoint and handoff templates live in their delegate files — always read and follow them verbatim; do not reconstruct the formats from memory or invent new ones.

**No session log all day.** Create one retrospectively (Phase 1 step 3) and flag the miss. The Stop hook (`log-reminder.py`) should have caught this earlier; mention if it apparently didn't fire.

**Dirty git tree.** Report and recommend; never commit. If the user replies "commit it", that is an explicit request — hand off to `/commit`, which runs its own quality gate.

## Cross-references

- `.claude/rules/session-logging.md` — the three-artifact table this skill produces in one pass.
- `.claude/rules/handoff-workflow.md` — the session-close checklist this skill mechanizes.
- `.claude/skills/checkpoint/SKILL.md` — Phase 2 delegate (structured state).
- `.claude/commands/handoff.md` — Phase 3 delegate (narrative context).
- `.claude/skills/commit/SKILL.md` — the explicit next step when the tree is dirty.
- `.claude/skills/contract-status/SKILL.md` — read-only "where are we" check; use *during* the session, this skill at its close.
