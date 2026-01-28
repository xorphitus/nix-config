# Require Clarification for Ambiguous Instructions

When you receive an instruction that contains any ambiguity, you must ask clarifying questions before proceeding with the task.

## What Constitutes Ambiguity

An instruction is ambiguous when:

- **Multiple valid interpretations exist** - The request could be understood or implemented in several different ways
- **Scope is unclear** - It's uncertain which files, functions, or parts of the codebase should be affected
- **Approach is unspecified** - The method or strategy to accomplish the task is not defined
- **Requirements are incomplete** - Key details about expected behavior, outputs, or constraints are missing
- **Technical choices are open-ended** - Decisions about tools, libraries, patterns, or architecture need to be made

## Required Action

When you encounter ambiguity:

1. **Stop and identify** - Clearly identify what aspects of the instruction are ambiguous
2. **Ask specific questions** - Use the AskUserQuestion tool to present concrete options or ask for specific details
3. **Wait for clarification** - Do not proceed with assumptions or make arbitrary choices
4. **Confirm understanding** - After receiving answers, confirm your interpretation before implementing

## Examples

**Ambiguous**: "Add error handling"
- **Ask**: Which functions need error handling? What types of errors should be caught? How should errors be reported (logging, user notifications, etc.)?

**Ambiguous**: "Improve performance"
- **Ask**: Which part of the system has performance issues? What are the performance goals? Are there specific operations that are too slow?

**Ambiguous**: "Refactor this code"
- **Ask**: What specific improvements are you looking for? Should I focus on readability, maintainability, performance, or something else? Are there any architectural patterns you'd like me to follow?

## Exception

You may proceed without clarification only when:
- The instruction is completely unambiguous and has only one reasonable interpretation
- The task is trivial and the approach is self-evident (e.g., "fix this typo")
