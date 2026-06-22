1. **Create action molecules for each vertical slice.** For each approved task, run:
   ```
   vibmax create-action "<task-name>" <action-phase-id>
   ```

2. **Set the do issue description.** For each molecule, update the do issue with what needs to be implemented:
   ```
   bd update <do-issue-id> --stdin
   ```
   Write a clear description of what to implement for this specific slice.

3. **Set the test issue description.** For each molecule, update the test issue with what needs to be tested and how:
   ```
   bd update <test-issue-id> --stdin
   ```
   Write specific test instructions: what to verify, what commands to run, what the expected behavior is.

4. **Wire dependencies.** For each blocking relationship, run:
   ```
   vibmax dep-add <blocked-id> <blocker-id>
   ```

5. **Verify all molecules were created.** Check that each vertical slice has a corresponding vibmax-action molecule with do/test steps.

6. **Verify dependencies are wired correctly.** Ensure blocking relationships match the approved breakdown.

7. **Show the dependency graph** to the user. List each molecule and what it blocks/is blocked by.

8. **Do NOT claim the next step.** After closing, stop. Do not automatically claim any action tasks. Only claim if the user explicitly asks you to.
