---
description: Initialize beads (bd) for the current project
---

Initialize beads (bd) issue tracking for the current project.

## Steps

1. **Check if beads is already initialized:**
   - Run `vibmax check-init`
   - If it succeeds, inform the user that beads is already initialized and don't do anything.

2. **Initialize beads:**
   - If the user passed "stealth" as an argument, run: `vibmax init --stealth`
   - Otherwise, run: `vibmax init`

In case of any errors, inconsistencies or issues happening not according to the plan. raise the issue and notify the user. don't try to solve them yourself. you are only explicitly allowed to only do the things that are listed in the steps nothing extra
