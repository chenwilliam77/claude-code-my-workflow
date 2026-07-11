# Report Format: Figures Over Tables

**Default:** when assembling an HTML summary report (per the "Reporting results for major task completions" workflow, `quality_reports` outputs, or `/data-analysis` Phase 4 output), prefer plots/figures over tables.

**Exception:** non-event-study regression tables are fine as tables — a standard coefficient table (estimate, SE, stars, N, R²) is clearer as a table than as a plot.

## Default to a figure

- **Outcomes as a function of time** — equilibrium trajectories, simulated paths, time series — line plot, not a table of values at selected periods.
- **Comparative statics** — how an equilibrium outcome varies with a parameter — line/curve plot over the parameter grid, not a table of outcome-per-parameter-value.
- **Event-study estimates** — coefficient-by-event-time plot with CI bands (e.g. `fixest::iplot()`), not a table of per-period coefficients. This is the one regression case that does NOT get the table exception below.
- **Bivariate correlation** — scatter plot + fitted line, not a correlation-coefficient table.
- **Distributional / group comparisons** — box, violin, or bar plots rather than a table of group means/SDs.

## Table is still fine

- **Standard (non-event-study) regression tables** — coefficients, SEs, significance stars, N, R² via `modelsummary`/`stargazer`. This is the carve-out: don't force a coefficient plot on a routine specification table.
- **Small lookup/calibration tables** where exact numeric precision is the point (e.g. a short parameter-calibration table), not a relationship to visualize.

Any table that does get used must still be generated, not hand-typed — see `content-invariants.md` INV-13.

## Why

Tables of numbers make the reader do the pattern-matching a plot does for free — especially for anything indexed by time, a continuous parameter, or an event-time window. Regression tables are the exception because the audience needs exact coefficients/SEs/stars for citation, not a shape.

## Cross-references

- `.claude/skills/data-analysis/SKILL.md` Phase 4 (Publication-Ready Output) — applies this rule when choosing table vs. figure output.
- `.claude/rules/r-code-conventions.md` — figure export conventions (`ggsave`, transparent bg, project theme; INV-11/INV-12 in `content-invariants.md`).
- `.claude/agents/data-analysis-coder.md`, `.claude/agents/data-analysis-project-contractor.md` — apply this rule when deciding a stage's output artifact.
