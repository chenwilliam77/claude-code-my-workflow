---
name: resume-handoff
description: Resume work from a handoff document. Reads the handoff, verifies current state, reviews all referenced artifacts, presents analysis with findings, and creates an action plan.
usage: /resume-handoff <path-to-handoff.md> | <ticket-number>
---

# /resume-handoff — Resume Work from a Handoff Document

Resume a session using context captured in a handoff document. Reads the handoff, verifies the codebase has not drifted, reviews all referenced files, synthesizes findings, and creates an action plan.

## When to use

- Starting a new session after `/handoff` created a handoff document
- Continuing work after a context switch
- Taking over a project from a collaborator
- Checking whether a handoff's assumptions still hold

## Invocation

**With a handoff path:**
```
/resume-handoff quality_reports/handoffs/handoff_20260703_feature-x.md
```

**With a ticket number (searches `thoughts/shared/handoffs/ENG-XXXX/`):**
```
/resume-handoff ENG-2124
```

**With no argument:**
Interactive prompt to select a handoff.

## Workflow

### Phase 1 — Load and Analyze the Handoff

1. **Read handoff completely** — extract all sections (goal, state, decisions, actions, blockers, references)
2. **Read referenced files** — must-read files from the handoff's reference index
3. **Check current state** — `git log`, `git status`, `git branch` to see if codebase has drifted
4. **Read recent plan (if exists)** — from handoff's `plan:` field
5. **Read recent session log (if exists)** — to understand what happened since handoff was written

### Phase 2 — Verify and Synthesize

Present comprehensive analysis:

```
I've read the handoff from <date> (<status>).

**Original Goal:**
<goal from handoff, 1-2 sentences>

**State at Handoff Time:**
- [Item 1] [status]
- [Item 2] [status]
- …

**Current State vs. Handoff:**
[What changed? Files modified? Branches merged?]

**Key Decisions from Handoff:**
- [Decision 1]: [rationale]
- [Decision 2]: [rationale]
- …

**Open Questions / Blockers:**
[Specific items from handoff with priority]

**Recommended Next Actions:**
Based on the handoff's action list and current state:
1. [Most logical next step]
2. [Second priority]
3. [Additional tasks discovered]

**Potential Issues Identified:**
[Conflicts, regressions, broken code, missing dependencies]

Shall I proceed with action 1, or would you like to adjust the approach?
```

### Phase 3 — Create Action Plan

Convert handoff action items into a task list:
- Reference handoff's "What to do next" section
- Add any new tasks discovered during analysis
- Prioritize based on dependencies
- Show estimated effort if not trivial

### Phase 4 — Begin Implementation

Start with the first approved task, referencing learnings from the handoff throughout.

## Behavior

**If handoff is current (no drift):**
- Proceed directly to Phase 2
- Confirm the action plan
- Start work

**If codebase has drifted (files missing, branches merged):**
- Flag the specific changes
- Assess impact on the original plan
- Propose adjustments before proceeding
- Ask for confirmation on approach

**If handoff references a non-existent file:**
- Note in the analysis: "Reference file `path` no longer exists"
- Determine if it's critical (blocks action plan) or optional (context only)
- Ask user whether to proceed or investigate

## Interactive Handoff Resolution

**Single handoff found:** Proceed automatically

**Multiple handoffs in directory:** Use most recent (by timestamp in filename)

**No handoff found:** Print error message with path searched; ask user to provide path

## Output

Summary of:
- Handoff date and status
- Current code state vs. handoff state
- Issues discovered (if any)
- Proposed action plan
- First concrete next step ready to execute

## Complementary Commands

- **`/handoff`** — creates a handoff document. Use at session close to prepare context for next session.
- **`/checkpoint`** — captures technical state. Use with `/handoff` for complete session close.

## Notes

- **Don't assume handoff state matches current state.** Always verify file existence, check git history, scan recent changes.
- **Reference learnings from handoff.** The decision section documents WHY choices were made; apply that wisdom.
- **Document any deviations.** If you deviate from the original plan, note it in the session log.
