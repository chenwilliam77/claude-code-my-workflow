---
name: contract-status
description: Read-only mid-contract progress digest. Reads the active plan, latest session log, latest checkpoint, decision records, recent quality reports, and git state; reports per-item plan status, open decisions, blockers, and a suggested next action on one screen. Makes no edits and dispatches no agents. Use when user says "contract status", "where's the contract at", "status of the plan", "how far along are we", "what's blocking", "where are we", or when resuming mid-contract in a fresh session.
author: Claude Code Academic Workflow
version: 1.0.0
argument-hint: "[plan-file | latest]"
allowed-tools: ["Read", "Grep", "Glob", "Bash"]
---

# /contract-status — Mid-Contract Progress Digest

Answer "where are we" during contractor-mode work without writing anything. This is the cheap, read-only sibling of `/checkpoint`: it *reads* the state that plans, session logs, and checkpoints already put on disk and synthesizes a one-screen digest. It never persists state, never edits files, and never dispatches agents.

## When to use

- Mid-contract, when you (or the user) want a progress read without paying for a full `/checkpoint`.
- Resuming work in a fresh session before deciding whether a full `/resume-handoff` is warranted.
- Before flushing open decisions to the user — the digest surfaces what's pending.
- As a sanity check that the plan on disk still matches what's actually been done.

## When NOT to use

- To *persist* state before stopping — that's `/checkpoint` (writes a snapshot).
- To transfer narrative context to a new session or collaborator — that's `/handoff` + `/resume-handoff`.
- To check context-window health — that's `/context-status`.

## Workflow

### Step 1 — Resolve the plan

- If `$ARGUMENTS` is a path, use it.
- If `$ARGUMENTS` is `latest` or empty: `ls -t quality_reports/plans/*.md 2>/dev/null | head -1`; if that directory is empty, fall back to `ls -t quality_reports/tracked_plans/*.md 2>/dev/null | head -1`.
- If no plan exists anywhere: report git state only (Step 2f) and recommend entering plan mode. Do not fabricate a plan.

Extract from the plan: status (DRAFT / APPROVED / COMPLETED / PARTIAL), title, and its checkable items or stage list.

### Step 2 — Gather evidence (all read-only; record "(none on disk)" for anything missing — never fabricate)

a. **Latest session log** — `ls -t quality_reports/session_logs/*.md 2>/dev/null | head -1`. Extract: incremental work-log lines, "Next Steps", "Open Questions / Blockers".
b. **Latest checkpoint** — `ls -t quality_reports/checkpoints/*.md 2>/dev/null | head -1`. Extract: "Where I am", "Next 1–3 actions", open questions.
c. **Decision records** — `ls -t quality_reports/decisions/*.md 2>/dev/null | head -5`, including any `pending.md` if present. Pending/unresolved items are the interesting ones.
d. **Recent review/QA reports** — glob `quality_reports/reports/*.md` and `quality_reports/*.md` (top level) for files whose name contains the plan slug or whose mtime is within the last 7 days. Extract verdict lines (PASS / FAIL / APPROVED / finding counts) from headers only — do not read full reports.
e. **Staleness check** — if a matched report predates the plan file, warn that it may belong to a previous contract; report it in a separate "possibly stale" line rather than as evidence.
f. **Git state** — `git branch --show-current`, `git status -s`, `git log --oneline -10`, ahead/behind upstream if set. All read-only.

### Step 3 — Cross-reference plan items against evidence

For each checkable item or stage in the plan, classify:

- **done** — checked off in the plan, or the session log / git log shows the corresponding change landed.
- **in-flight** — session log mentions it as started, or uncommitted changes touch its files.
- **not-started** — no evidence anywhere.

Cite the evidence (a commit subject, a session-log line, a file in `git status`) — one fragment per item, not a dump.

### Step 4 — Print the digest

Target under ~40 lines:

```
📋 Contract Status — <plan title>
─────────────────────────────────
Plan:    <path>   Status: <DRAFT|APPROVED|COMPLETED|PARTIAL>
Branch:  <branch>   Uncommitted: <n> files   Ahead of main: <n>

| Item | Status | Evidence |
|------|--------|----------|
| 1. <item> | done | commit abc1234 |
| 2. <item> | in-flight | session log 14:20 entry |
| 3. <item> | not-started | — |

Open decisions:  <DQ/ADR one-liners, or "(none)">
Blockers:        <from session log / checkpoint, or "(none)">
Possibly stale:  <reports predating the plan, or omit line>

→ Next action: <one line, e.g. "resume item 2" or "run /wrap-session and close">
```

The suggested next action is one line, imperative, and derived from the first non-done item — or, if everything is done, from the close-out ritual (`/wrap-session`, then `/commit`).

## Examples

### Example 1 — Mid-contract check

**User says:** "contract status"
**Actions:** resolve latest plan (APPROVED), read session log + checkpoint, cross-reference 5 plan items against git log, print digest showing 3 done / 1 in-flight / 1 not-started, next action "resume item 4".

### Example 2 — Fresh session, unknown state

**User says:** "/contract-status latest"
**Actions:** latest plan is COMPLETED, but git shows 4 uncommitted files. Digest flags the mismatch and suggests "review uncommitted changes, then /commit or /wrap-session".

## Troubleshooting

**No plan found.** Report git state only, recommend plan mode. A status digest without a plan is just `git status` with extra steps — say so.

**Stale artifacts.** If the newest session log or checkpoint predates the plan, they describe a previous contract. Include them under "possibly stale" with dates and lean on git evidence instead.

**Plan has no checkable items.** Derive a coarse stage list from the plan's section headings and say the item table is inferred, not authoritative.

## Cross-references

- `.claude/rules/orchestrator-protocol.md` — the contractor loop whose progress this digest reports.
- `.claude/rules/session-logging.md` — the artifact table this skill reads from (session log / checkpoint / handoff).
- `.claude/skills/checkpoint/SKILL.md` — writes the state this skill reads; use it when you need to *persist*, not just inspect.
- `.claude/skills/wrap-session/SKILL.md` — the close-out ritual this digest recommends when all items are done.
