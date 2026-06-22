---
description: Put down a task and write a handoff note for the next agent.
---

```
$ARGUMENTS
```

Put down the current task. You already know the issue ID from the session.

1. **Summarize from conversation.** Review what was done, what was discussed, key decisions, and current progress. If user comment is provided, use it as guidance for what to focus on.

2. **Show summary to user for confirmation.** Present what you will write as a handoff note. Ask: "Is this good?"

3. **Only after confirmation**, run:
   ```
   vibmax putdown <issue-id> <<'EOF'
   <summary>
   EOF
   ```
   If user says no, revise and ask again.

If no summary is needed, just run `vibmax putdown <issue-id>` without the heredoc.
