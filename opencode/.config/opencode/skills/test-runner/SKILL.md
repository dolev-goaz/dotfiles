---
name: test-runner
description: Guidelines for running project tests and capturing logs.
compatibility: opencode
metadata:
  workflow: github
---

# Skill: Test Suite Runner

## Description

Executes the project's testing framework and captures logs.

## Functionality

1. **Command:** Detects package manager (`npm`, `pnpm`, `cargo`) and runs the test script (e.g., `pnpm test`).
2. **Optimization:** If possible, pass a filename to run _only_ relevant tests (e.g., `pnpm test src/auth/login.test.ts`).
3. **Test Scope:** If testing a monorepo, ensure tests are run in the correct package context.
4. **Error Handling:** Capture the last 50 lines of `stderr` on failure.
