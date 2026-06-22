---
description: Show available tasks and help the user pick one to work on.
---

Run `vibmax next` and handle the result:

- **0 tasks**: Tell the user no tasks are available.
- **1 task**: Show the task. Ask the user to confirm they want to work on it. If confirmed, run `vibmax claim <issue-id>` and follow its output.
- **2-4 tasks**: Use the question tool to let the user pick one. Then run `vibmax claim <issue-id>` and follow its output.
- **5+ tasks**: Output the list, ask the user which one to work on. Then run `vibmax claim <issue-id>` and follow its output.
