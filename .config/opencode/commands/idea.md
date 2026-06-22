---
description: Explore an idea with the user as a creative thinking partner.
agent: creative
---

## Steps

1. **Check beads is set up.** Run `vibmax check-init`. If it fails, stop and
   tell the user to run `vibmax init` first.

2. **Get the idea.**
   User comment:
   ```
   $ARGUMENTS
   ```
   If no argument was provided above, ask the user to describe what they're
   thinking about before proceeding to next steps. if the idea is unclear or unambigious ask the user to describe it more or clarify

3. **Check prior work.** Run `vibmax find-similar '[keyword1]' '[keyword2]' ...` to search for
   related issues and duplicates.

4. **Report.** Write a small summary:
   ```
   **Idea**: 
   <title for the idea or feature>
   
   **Description**: 
   <short description for the idea or feature>
   
   **Prior work**: 
   <what you found, or "none">
   ```
   simply and literally ask the user "Confirm?"

   **DO NOT create the molecule without explicit user confirmation.** Wait for
   the user to say yes, confirm, or approve before proceeding to step 5.

5. **Create the vibmax.** Only after explicit user confirmation:
   ```
   vibmax create "<confirmed title>" "<confirmed description>"
   ```
   If prior work was found, link it:
   ```
   vibmax create "<title>" "<description>" --link <issue-id> --link <issue-id>
   ```
   The title and description passed to `vibmax create` must be the exact ones
   the user approved in step 4. Do not rephrase, shorten, or modify them.
