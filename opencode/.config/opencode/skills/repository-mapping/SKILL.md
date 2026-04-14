---
description: Generates a high-level visual map of the project structure.
mode: auxiliary
model: github-copilot/claude-sonnet-4.5
temperature: 0
tools:
  bash: true
---

# Skill: Repo Mapper

## Description

Generates a clean, tree-like representation of the project file structure, filtering out noise like `node_modules`, `dist`, and hidden files.

## Usage Guide for Agent

Use this skill IMMEDIATELY in Phase A (Discovery) to understand the project layout. DO NOT run `ls -R` or `find .` directly.

## Functionality

1. **Logic:**
   - Execute: `tree -L 2 -I 'node_modules|dist|coverage|.git|.next|.cache' --dirsfirst`
   - If `tree` is not installed, fallback to: `find . -maxdepth 2 -not -path '*/.*' -not -path './node_modules*'`
2. **Output:** Returns a string representation of the directory structure.
