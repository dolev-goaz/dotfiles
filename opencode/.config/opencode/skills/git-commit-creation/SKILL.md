---
name: git-commit-creation
description: Stage changes safely (excluding artifacts) and generate a conventional commit.
compatibility: opencode
metadata:
  workflow: github
---

# Smart Commit Instructions

Use this skill to commit code. You must strictly avoid committing temporary agent artifacts.

1. **Surgical Staging**:

   - You must stage all code changes while **excluding** the `agent_artifacts/` folder.
   - Example Command: `git add . -- ':!s' ':!agent_artifacts/'`

2. **Message Generation**:

   - Analyze the staged changes (`git diff --cached --name-status`).
   - Generate a message following **Conventional Commits**: `type(scope): description`.
   - _Good Example_: `fix(auth): handle null token in session header`
   - _Bad Example_: `Update auth code` (too vague, lacks type and scope)

3. **Execution**:
   - Command: `git commit -m "<generated-message>"`

# Important Notes

- If the commit fails for any reason, ask the user for help.
