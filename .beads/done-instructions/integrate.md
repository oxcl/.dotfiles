1. **Write a Revised One-Pager.** Take the one-pager you received and refine it based on the integration session decisions. Apply scope cuts, MVP definition, phase breakdowns, and hacks identified. Keep the same template structure:

   # Revised One-Pager

   ## 1. Idea Title:
   <title>

   ## 2. The Problem Statement:
   What are we trying to solve?

   ### 2.1. Target Audience (if product):
   Who is this useful for?

   ## 3. The Proposed Solution:
   What is the MVP? What is the leanest way to get this built?

   ## 4. Why:
   The reasoning behind the idea. Why we should do it? What is the point?

   ## 5. Stories:
   Explains how the idea is supposed to work in a narrative driven way.

   ## 6. Out Of Scope:
   What is explicitly NOT in this vibmax.

   ## 9. Extra Details:
   Anything that the above sections missed.

2. **Write "Extracted into separate Vibmax" section.** If parts of the idea should be separated into their own vibmaxes (because they are too large, too complex, or not core to Phase 1), list them with title and description for each.

3. **Ask the user for confirmation.** Simply and literally ask "Is this good?" Wait for the user to say yes, confirm, or approve before proceeding.

4. **Close the integrate task.** Only after explicit user confirmation, pipe a JSON object to:
   use a heredoc:
   ```
   vibmax close integrate <issue-id> <<'EOF'
   {
     "revised_one_pager": "<the revised one-pager content>",
     "extracted_vibmaxes": [
       {"title": "Title 1", "description": "Description 1"},
       {"title": "Title 2", "description": "Description 2"}
     ]
   }
   EOF
   ```
   If there are no extracted vibmaxes, use an empty array: `"extracted_vibmaxes": []`
