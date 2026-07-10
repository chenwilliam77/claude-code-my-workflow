# Agent Model Selection

Which model tier a sub-agent runs on is a cost/quality tradeoff, not a style choice. Pick the cheapest tier that can be trusted with the judgment the task requires.

## The tiers

| Tier | When | Examples in this repo |
|---|---|---|
| Haiku | Deterministic pass/fail checks — exit codes, grep for known strings, file-exists/size checks. No domain judgment involved. | `haiku-verifier`, `haiku-proofreader` |
| Sonnet (default / `inherit`) | Standard domain review requiring judgment — code quality tradeoffs, pedagogy, editorial calls, substantive correctness. | `r-reviewer` / `sonnet-r-reviewer`, `domain-reviewer`, `editor`, referee agents |
| Opus | Novel computation or hard numerical/mathematical work with no off-the-shelf solver — the kind of task where a wrong answer is easy to produce and hard to notice. | Reserved. No agent in this repo needs it yet; escalate to it explicitly when a task crosses this line (see `data-analysis-project-contractor.md` for the escalation trigger). |

## How to decide

Ask: **does completing this task require a judgment call, or just checking a fact?**

- "Did the script exit 0 and did the RDS file get written?" → fact-check → Haiku.
- "Is this regression specification defensible given the identification strategy?" → judgment → Sonnet.
- "Does this custom MLE estimator converge to the right answer with no closed-form check available?" → high-stakes novel computation → Opus.

Most agents in `.claude/agents/` should stay at Sonnet (`inherit`) by default — this tier list is deliberately narrow. Only mechanical, pattern-matching agents get a Haiku variant; only genuinely hard numerical work escalates to Opus. Don't create a Haiku variant of a judgment-heavy agent just to save cost — a wrong "PASS" from an under-powered review agent is more expensive than the tokens it saved.

## How skills should expose tier choice

A skill that dispatches one of these agents should default to the agent's own `model:` frontmatter (usually `inherit`/Sonnet) and accept an explicit override — either a `--model=haiku|sonnet|opus` flag or a natural-language instruction ("use haiku for the verifier pass") — that selects the corresponding agent variant (e.g. `verifier` → `haiku-verifier`). Do not hardcode a single tier into a skill when both a mechanical-check variant and a judgment variant exist; let the caller pick.

## Cross-references

- `.claude/agents/haiku-verifier.md`, `.claude/agents/haiku-proofreader.md` — the current Haiku-tier agents.
- `.claude/agents/data-analysis-project-contractor.md` — dynamically dispatches across all three tiers per analysis stage.
- `.claude/rules/meta-governance.md` — generic vs. project-specific classification (this rule is generic; commit it).
