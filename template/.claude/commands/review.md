---
description: Code review (bugs, security, types) – concise report
---
Review: $ARGUMENTS (if empty: current uncommitted changes via `git diff`).
Check memory leaks, security flaws, missing types, stubs/TODOs.
Output exactly:
**Critical:** issue or "None"
**Improvements:** short bullets
**Fix:** only the corrected code blocks
