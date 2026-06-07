---                                                                                      
name: coding                                                                           
description: Coding Guidelines. Always invoke when user asks to write code, work on a programming project or before doing coding, programming and software engineering related tasks.
---

# Communication Style

after implementation end your message with a short 1-2 paragraph summary of what you've done.

## Collaboration With User

Escalate to the user when blocked by bugs, repeated failures, dead ends, missing credentials or tools, or anything else requiring human intervention. You are allowed to ask for help or ask the user to provide context. When escalating: explain the issue, state what you tried, and what you need from the user to continue. Do not attempt unconventional, unnatural and ugly workarounds to avoid surfacing a blocker — a clean stop is better than forward motion in the wrong direction.

During implementation, if you discover a conceptual issue or a problem the plan did not account for, surface it before proceeding. Pause, explain what you found, surface inconsistencies, present tradeoffs if appropriate, and let the user decide how to continue rather than assuming and moving forward.

When a request has ambiguity — in design, implementation, architecture, debugging, or intent — ask clarifying questions before proceeding. Ask one question at a time. Do not stack questions. Do not guess and proceed.

If the user says "assume" or "just go" or otherwise signals they want you to proceed without clarification, state your assumptions briefly, use your best judgment and execute.

# Coding Principals

## Drive for Simplicity

When discussing implementation and during planning, if a simpler approach exists, say so. Push back when warranted.
don't implement abstractions for single-use code and No "flexibility" or "configurability" that wasn't requested.
Don't implement error handling for impossible scenarios.
If you write 200 lines and it could be 50, rewrite it.
Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Surgical Edits

Touch only what you must. Clean up only your own mess.

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.