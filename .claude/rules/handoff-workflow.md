# Handoff Workflow

**Commands:** `/handoff` ↔ `/resume-handoff`

A complementary pair for transferring session context across time and collaborators.

---

## The Pair

### `/handoff` — Create a Handoff Document

**Purpose:** Capture narrative context at session close so a fresh session can pick up without re-reading everything.

**When to use:**
- At the end of a working session you expect to continue later
- Before handing work to a collaborator
- Before a long context switch

**Output:** `quality_reports/handoffs/handoff_YYYYMMDD_<slug>.md`

**Contents:**
- Goal (1–2 sentences, no jargon)
- Current state (3–6 bullets: done, in-flight, blocked)
- Key decisions and rationale (2–5 bullets on WHY, not what)
- Next actions (ordered, concrete, 1–4 items)
- Open questions / blockers (specific, marked HIGH/LOW)
- Reference file index (must-read + optional dig-deeper)
- Resume prompt (one-liner for next session)

**Complements:**
- `/checkpoint` — use both at session close for complete state capture

### `/resume-handoff` — Resume Work from a Handoff

**Purpose:** Read a handoff document, verify the codebase hasn't drifted, review referenced files, and create an action plan.

**When to use:**
- Starting a new session after a previous session created a handoff
- Continuing work after a context switch
- Taking over a project from a collaborator
- Checking whether a handoff's assumptions still hold

**Invocation:**
```bash
/resume-handoff quality_reports/handoffs/handoff_YYYYMMDD_slug.md
/resume-handoff ENG-XXXX  # searches thoughts/shared/handoffs/ENG-XXXX/
```

**Workflow:**
1. Read handoff completely
2. Read referenced files (must-read tier)
3. Check current git state vs. handoff assumptions
4. Verify all referenced files still exist
5. Synthesize findings into an analysis
6. Present: original goal, current state, decisions, issues, action plan
7. Get user confirmation on approach
8. Create task list and begin with action 1

**Output:** Analysis + action plan + next step ready to execute

---

## Common Usage Pattern

### Session Closure

```bash
# At end of session:
/checkpoint [description]       # Technical state (file pointers, git)
/handoff [description]          # Narrative context (goal, decisions)
# Commit and/or push
```

`/wrap-session [description]` runs this checklist (plus the session-log update and MEMORY.md check) in one command.

### Session Start

```bash
# In new session:
/resume-handoff quality_reports/handoffs/handoff_YYYYMMDD_slug.md
# Read analysis, confirm approach
# Execute action 1
```

---

## What They Do NOT Do

- **`/handoff` is not a git commit summary.** Git log tells you WHAT changed; handoff tells you WHY it matters and what comes next.
- **`/handoff` is not a detailed plan.** Use the `plan:` field to point to the active plan (stored in `quality_reports/plans/`) for implementation details.
- **`/resume-handoff` does not auto-execute.** It analyzes and proposes; you approve the approach before work begins.
- **`/resume-handoff` does not auto-merge or rebase.** It checks git state but leaves merges to you.

---

## Integration with Other Commands

| Command | When to Use | Output Saved To |
|---------|------------|-----------------|
| `/handoff` | Session end | `quality_reports/handoffs/` |
| `/checkpoint` | Session end (technical state) | `quality_reports/checkpoints/` |
| `/resume-handoff` | Session start | (proposes action plan, you execute) |
| Session log | Throughout session (incremental) | `quality_reports/session_logs/` |
| Active plan | Before implementation | `quality_reports/plans/` (reference via handoff) |

---

## Handoff Checklist (For Session Close)

Before creating a handoff, ensure:

- [ ] Session log is current (updated in last 10 minutes)
- [ ] Active plan is saved to disk in `quality_reports/plans/`
- [ ] MEMORY.md has any `[LEARN]` entries from this session
- [ ] Git state is clean or intentional (staged/committed/pushed as appropriate)
- [ ] Reference files are identifiable (know which 3–5 files matter most)

Then:
```bash
/checkpoint [description]
/handoff [description]
```

---

## Handoff Quality Markers

A good handoff:

- ✅ Answers "What is this work about?" in 1–2 sentences without jargon
- ✅ Lists concrete next actions (not vague goals like "keep working")
- ✅ Explains WHY decisions were made, not just what was decided
- ✅ Includes specific blockers or open questions (not "there might be issues")
- ✅ Points to reference files by relative path (not "read everything")
- ✅ Is 40–70 lines long (gateway, not dump)
- ❌ Does not duplicate the session log (references it instead)
- ❌ Does not include implementation details (plan file's job)
- ❌ Does not make vague assertions ("some progress made")

---

## When `/resume-handoff` Discovers Drift

If the codebase has changed since the handoff was written:

1. **Minor drift** (a file was edited, commit history moved forward): Continue with updated context.
2. **Moderate drift** (branch merged, new files created): Reassess action plan, confirm whether it's still valid.
3. **Major drift** (referenced files deleted, plan no longer in repo): Flag as issue, ask whether to continue or re-plan.

Trust, but verify: `/resume-handoff` always checks current state before presenting the action plan.

---

## Cross-references

- `.claude/rules/session-logging.md` — incremental logging during sessions
- `.claude/rules/plan-first-workflow.md` — planning before implementation
- `.claude/skills/checkpoint/SKILL.md` — technical state capture
