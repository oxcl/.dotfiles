---
description: Initialize beads (bd) for the current project
---

Initialize beads (bd) issue tracking for the current project.

## Steps

1. **Check if beads is already initialized:**
   - If `.beads/` directory exists, inform the user that beads is already initialized and don't do anything.

2. **Initialize beads:**
   - If the user passed "stealth" as an argument, run: `bd init --skip-agents --stealth`
   - Otherwise, run: `bd init --skip-agents`

3. **Clean up:**
   - Remove `.beads/README.md` if it exists
   - Remove `.claude/` directory if it exists
   - Remove `.beads/hooks/prepare-commit-msg` if it exists

4. **Amend the commit:**
   - Beads automatically commits its changes to git
   - After cleaning up, add the cleanup changes to git and amend the commit: `git commit --amend --no-edit`

5. **Verify:**
   - Confirm `.beads/` directory exists
   - Confirm beads changes are commited to git
   - Confirm AGENTS.md and CLAUDE.md were not created or modified by beads
