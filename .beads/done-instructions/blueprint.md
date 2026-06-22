1. **Write a PRD (Product Requirements Document).** Use this format:

   ## Problem Statement
   What is the problem this is solving. The elevator pitch for the idea. Answering the "WHAT?" question. What are we doing?

   ## Proposed Solution
   The solution to the problem. A short explanation of what we are going to DO to solve the problem.

   ## Why
   The reasoning behind picking this solution. The crucial context required to understand why the solution is what it currently is. The thought process behind solving the problem in this way.

   ## User Stories
   A LONG, numbered list of stories explaining the plan in a narrative driven way, from the perspective of actors that are involved. Examples:
   - As an <actor>, I want a <feature>, so that <benefit>
   - As an <actor> when <situation/context>, I want to <motivation/action>, so I can <expected outcome>
   - As an <actor> I want <feature/experience> because <measurable outcome>. We will know we are successful when <test>
   - The <system/component> must <action/behavior>, so that <non-functional requirement / business constraint / desired output>

   pick which ever style makes sense for the current plan.

   This list should be extremely extensive and cover all aspects of the feature.

   ## Implementation Decisions
   A list of implementation decisions that were made. This can include:
   - The modules that will be built/modified
   - The interfaces of those modules that will be modified
   - Technical clarifications from the developer
   - Architectural decisions
   - Schema changes
   - API contracts
   - Specific interactions

   Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.
   Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

   ## Testing Decisions
   A list of testing decisions that were made. Include:
   - A description of what makes a good test (only test external behavior, not implementation details)
   - Which modules will be tested
   - Prior art for the tests (i.e. similar types of tests in the codebase)
   - How will agents test their work. What decision was made for the agentic feedback loop

   ## Out of Scope
   A description of the things that are out of scope for this PRD.

   ## Further Notes
   Any further notes about the feature.

2. **Ask the user for confirmation.** Simply and literally ask "Is this good?" Wait for the user to say yes, confirm, or approve before proceeding.

3. **Close the blueprint task.** Only after explicit user confirmation, pipe the PRD to:
   use a heredoc:
   ```
   vibmax close blueprint <issue-id> <<'EOF'
   <PRD content>
   EOF
   ```

4. **Do NOT claim the next step.** After closing, stop. Do not automatically claim the multiplex task. Only claim it if the user explicitly asks you to.
