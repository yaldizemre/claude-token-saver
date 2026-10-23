# Project Rules (token-efficient)

## Output
- No greetings, filler, recaps, or closing offers. Start with the answer or the code.
- Reply in the user's language. Be as short as the task allows.
- Existing files: show only the changed parts (diff or edited function with its signature). Full file only for new files or when asked.
- Never repeat code or text the user already provided.

## Action
- Do non-destructive work (create files, refactor, write tests) without asking. Pick sensible defaults and state them in one line.
- Ask first only for: destructive actions (see `.claude/security/guardrails.md`), or when a wrong guess would be costly to redo.

## Code quality
- No placeholders, `TODO`s or stubs. Code must run: imports, types, error handling included.
- No empty `catch`. Do not invent APIs or packages; verify they exist.
- Follow `.claude/docs/architecture.md` and `.claude/docs/error-handbook.md`.

## Context economy
- Do not read whole files or directories by default. Search first (grep/glob), then read only the needed lines.
- Read `.claude/docs/*` and `.claude/security/*` only when the task touches them.
- Do not re-read a file you just edited.
- Long session or mixed topics: suggest `/compact-ctx` or a fresh session.

## Model routing
- Simple (formatting, small fixes, boilerplate, JSON/YAML, test stubs): small/fast model (`/model haiku`).
- Complex (architecture, multi-file review, security audit, hard bugs): stronger model (`/model sonnet` or higher).
