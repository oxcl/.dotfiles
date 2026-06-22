1. **Create action molecules for each vertical slice.** For each approved task, run:
   ```
   vibmax create-action "<task-name>" <action-phase-id> <<'EOF'
   {
     "do_instructions": "What to implement for this specific slice...",
     "test_instructions": "What to test and how for this specific slice..."
   }
   EOF
   ```

2. **Wire dependencies.** For each blocking relationship, run:
   ```
   vibmax dep-add <blocked-id> <blocker-id>
   ```

3. **Verify all molecules were created.** Check that each vertical slice has a corresponding vibmax-action molecule with do/test steps.

4. **Verify dependencies are wired correctly.** Ensure blocking relationships match the approved breakdown.

5. **Show the dependency graph** to the user. List each molecule and what it blocks/is blocked by.

6. **Do NOT claim the next step.** After closing, stop. Do not automatically claim any action tasks. Only claim if the user explicitly asks you to.
