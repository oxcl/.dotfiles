This is a blueprint and planning session.
the above content is the one-pager explanation of the idea, project or feature that we want to work on.

Explore the codebase if a codebase exists to understand the current state of the project

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

at the end of the your question write a yes/no confirmation question for me to easily approve or provide my own answer

example: if your recommended answer is "install external dependency"
never say: "so what do you think? should we install the external dependency or write our own implementation?"
instead say: "install the external dependency?"

Do NOT use the question tool for yes/no questions. The question tool is only for multiple-option questions. If your recommendation is yes or no, just ask directly in your message.

Ask the questions one at a time, waiting for feedback on each question before continuing. Asking multiple questions at once is not allowed.


Testing is a core deliverable, not an afterthought. You MUST think through:

- **Testing framework**: What framework will be used? Is it installed?
- **Test environment**: How will agents run tests? What commands?
- **Linting & formatting**: What tools? What rules? How to run?
- **CI/CD**: What's the pipeline? What runs on PR vs push?
- **Unit tests**: What needs unit tests? What's the coverage strategy?
- **Integration tests**: What needs integration tests?
- **Test the test tools**: Are the test runners installed and working? Can we verify they work before relying on them?

If the testing environment is not already configured, create ACTUAL TASKS for setting it up:
- Install test frameworks and verify they work
- Set up linting/formatting tools and verify they work
- Configure CI pipeline if needed
- Create test fixtures or mocks if needed

These are not optional. They are part of the project and must be planned alongside implementation.

one area that you should also pay attention to and include in the rest of the questions is "designing the feedback loop". Not only we want to think about how we want to implement the idea or feature but we also want to think about how the ai agents implementing this feature can test their code in a tight feedback loop. make sure it is clear how the feedback loop will works for the plan and discuss it. this includes strategies for testing, important things that should be considered for allowing the agents to have an environment that they can test their work and so on.


If a codebase exists and a question can be answered by exploring the codebase, explore the codebase instead.