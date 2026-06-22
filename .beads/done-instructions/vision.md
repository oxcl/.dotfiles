1. **Write a one-pager** of the idea in its final form discussed. Not the process itself but the final baked idea after the brainstorming. Use this template:

   # One-Pager

   ## 1. Idea Title:
   <title>

   ## 2. The Problem Statement:
   What are we trying to solve?

   ### 2.1. Target Audience (if product):
   Who is this useful for?

   ## 3. The Proposed Solution:
   What is your grand vision for the solution? Tell the story of how the product/project works in a perfect world.

   ## 4. Why:
   The reasoning behind the idea. Why we should do it? What is the point?

   ## 5. Stories:
   Explains how the idea is supposed to work in a narrative driven way. If it's a product it should be from user perspective. Otherwise it should be a narrative driven format stories from whoever this change affects.

   ## 6. Out Of Scope:
   What is explicitly NOT part of the idea or project.

   ## 7. Extra Details:
   Anything that the above sections missed. The one-pager should be dense but include everything that is needed to implement the final version of the idea in its full form. It's not a summary of the idea. It's the full spec explaining the full vision for the idea.

2. **Ask the user for confirmation.** Simply and literally ask "Is this good?" Wait for the user to say yes, confirm, or approve before proceeding.

3. **Close the vision task.** Only after explicit user confirmation, pipe the one-pager to:
   use a heredoc:
   ```
   vibmax close vision <issue-id> <<'EOF'
   <one-pager content>
   EOF
   ```
