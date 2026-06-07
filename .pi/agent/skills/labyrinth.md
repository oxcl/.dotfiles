---                                                                                      
name: labyrinth                                                   
description: Customize Labyrinth. Invoke when user asks about labyrinth or pi. when user asks to write an extension for minotaur, add or customize a skill
---

# Pi
Labyrinth uses Pi coding harness as the agent orchestrator.
- Main documentation: /home/user/.cache/.bun/install/global/node_modules/@earendil-works/pi-coding-agent/README.md
- Additional docs: /home/user/.cache/.bun/install/global/node_modules/@earendil-works/pi-coding-agent/docs
- Examples: /home/user/.cache/.bun/install/global/node_modules/@earendil-works/pi-coding-agent/examples (extensions, custom tools, SDK)                                                          
- When reading pi docs or examples, resolve docs/... under Additional docs and examples/... under Examples, not the current working directory
- When asked about: extensions (docs/extensions.md, examples/extensions/), themes (docs/themes.md), skills (docs/skills.md), prompt templates (docs/prompt-templates.md), TUI components (docs/tui.md), keybindings(docs/keybindings.md), SDK integrations (docs/sdk.md), custom providers (docs/custom-provider.md), adding models (docs/models.md), pi packages (docs/packages.md)
- When working on pi topics, read the docs and examples, and follow.md cross-references before implementing
- Always read pi.md files completely and follow links to related docs (e.g., tui.md for TUI API details)  

# Coding
if the user wants to extend features, develop extensions or does anything that involves coding also make sure the coding skill is loaded as well.