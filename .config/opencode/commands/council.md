---
description: Consult the Council of Experts
---

### 🔔 Consulting The Council

Summon the Council President to get perspectives of experts on the current session.

User Comment:
```
$ARGUMENTS
```

If the user has comment section above is empty analyze the current conversation and summarize the *relevant parts*—specifically the core problem being solved, the technical constraints, any blockers, and the current state of the code/thinking. If the user has provided a comment take it into account. forward the user comment to the council president as well.



1.  **Formulate the Prompt for the Council:** 
    You must construct a clear, standalone prompt to send to the Council President. The Council President will forward this *exactly as is* to the experts, so it must contain all necessary context. Formulate the prompt as a clear question, problem, topic.

2.  **Summon the Council President:**
    Use the `task` tool to delegate to the council. 
    *   **Subagent/Agent Name:** `council`
    *   **Prompt:** The formulated prompt from Step 1.
    *   **User Comment**: if the user has provided a comment in the user comment block above include it here as is.

3.  **Process the Council's Report:**
    Once the Council President returns the Synthesized Report, review the diverse perspectives provided by the experts. think about the perspectives and continue discussing the topic with the user.