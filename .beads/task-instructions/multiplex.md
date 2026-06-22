1. **Read the PRD** from the issue description. Understand the full scope of what needs to be built.

2. **Explore the codebase** (optional). If you haven't already, understand the current state of the code. Respect existing patterns and architecture.

3. **Decompose into vertical slices.** Break the PRD into independently-grabbable action tasks. Each task should be:
   - A thin vertical slice cutting through ALL layers end-to-end (not a horizontal slice of one layer)
   - Independently demoable or verifiable on its own
   - Small enough to complete in a do/test cycle

4. **Analyze dependencies.** For each task, determine:
   - Does this block any other tasks?
   - Is this blocked by any other tasks?
   - Which tasks can run in parallel?

5. **Present the breakdown** to the user as a numbered list. For each task, show:
   - **Title**: short descriptive name
   - **Blocked by**: which other tasks (if any) must complete first
   - Ask: "Does the granularity feel right? Are the dependencies correct?"
