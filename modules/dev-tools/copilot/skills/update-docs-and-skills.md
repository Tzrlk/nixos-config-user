---
name: update-docs-and-skills
description: >
  Interactively updates project documentation and existing Copilot skills by
  reading current files, asking focused clarifying questions to resolve gaps or
  recent changes, and proposing reviewed edits before applying them. Use when
  updating docs, READMEs, runbooks, architecture notes, or SKILL.md files.
---

# Update Project Documentation and Skills

## Workflow

1. **Inspect current state**
   - Identify the target project documentation files and/or `SKILL.md` files referenced by the user or relevant to the topic.
   - Read the existing files and note outdated assumptions, missing steps, broken references, or unclear triggers.

2. **Ask focused questions before editing**
   - Do **not** guess undocumented decisions, new workflows, or changed requirements.
   - Ask at most **4 concise questions per turn**.
   - Prioritize questions that change what gets written (scope, new behavior, edge cases, owners, or naming/trigger rules).
   - Provide a brief default or best-practice option where helpful so the user can reply fast.

3. **Draft and confirm changes**
   - Once enough answers are gathered, summarize the exact updates planned for each document or skill.
   - For skills, check that the `name` uses lowercase hyphens and the `description` clearly states *when* to trigger the skill.
   - Ask for confirmation before modifying files if destructive rewrites or multiple files are involved.

4. **Apply and verify**
   - Update the approved files cleanly while preserving existing structure and tone.
   - List every updated file and flag any remaining open questions or follow-up items.

