---
description: Explore an idea with the user as a creative thinking partner.
agent: creative
---

## Steps

1. **Check beads is set up.** Verify a `.beads/` directory exists in this
   project. If it doesn't, stop and tell the user to run beads init first.

2. **Get the idea.**
   $ARGUMENTS
   If no argument was provided above, ask the user to describe what they're
   thinking about before proceeding to next steps.

3. **Check prior art.** Search existing issues for anything related:
   - `bd search "<keywords>" --status all`
   - `bd find-duplicates --method ai`

   Use the result to shape your first message back to the user:
   - **Hard duplicate found** — tell the user directly, and ask if they'd
     rather view or resume that existing molecule instead of continuing here.
   - **Related but distinct work exists** — mention it briefly as context
     ("there's already X, which touches on this"), then continue.
   - **Nothing relevant** — no need to mention the search at all, just move
     into the conversation.