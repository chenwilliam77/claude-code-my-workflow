I am starting to work on [PROJECT NAME] in this repo. [Describe your project in 2–3 sentences — what you’re building, who it’s for, what tools you use (e.g., LaTeX/Beamer, R, Quarto).]

I want our collaboration to be structured, precise, and rigorous — even if it takes more time. When creating visuals, everything must be polished and publication-ready. I don’t want to repeat myself, so our workflow should be smart about remembering decisions and learning from corrections.

I’ve set up the Claude Code academic workflow (forked from pedrohcgs/claude-code-my-workflow). The configuration files are already in this repo (.claude/, CLAUDE.md, templates, programs, .gitignore). Please read them, understand the workflow, and then update all configuration files to fit my project:

1. **Understand the two-tier artifact system:** `quality_reports/` separates ephemeral LLM-generated working artifacts (plans, reports, handoffs, specs, checkpoints — .gitignored) from tracked decision documents (tracked_plans/, tracked_reports/, tracked_handoffs/, session_logs/, merges/, decisions/, preregistrations/ — committed to git). Use tracked folders when you want something to persist for the project record.

2. **Configure .gitignore:** Review `.gitignore` and adjust for your project type:
   - If you track compiled PDFs, uncomment `# *.pdf`
   - If you have large data files in `programs/`, add `programs/data/raw/*` or similar
   - Keep the `quality_reports/` two-tier structure (ephemeral ignored, tracked whitelisted)
   - Add any language-specific ignores your project needs (Julia caches, Python venvs, etc.)

3. **Fill placeholders in CLAUDE.md:**
   - Replace `[YOUR PROJECT NAME]`, `[YOUR INSTITUTION]`
   - Customize Beamer environments and Quarto CSS classes for your theme
   - Delete example rows once you’ve added your own
   - Update "Current Project State" table with your lectures/papers

4. **Document infrastructure:** Ensure CLAUDE.md lists all available agents and skills your project uses. The file includes an agent reference table and skills quick reference.

5. **Propose customizations:** If your project needs domain-specific rules, agents, or skills beyond the template, we’ll add them.

After that, use the plan-first workflow for all non-trivial tasks. Once I approve a plan, switch to contractor mode — coordinate everything autonomously and only come back to me when there’s ambiguity or a decision to make. For our first few sessions, check in with me a bit more often so I can learn how the workflow operates.

Enter plan mode and start by adapting the workflow configuration for this project.
