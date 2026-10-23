# Known Errors & Anti-Patterns

## 1. Partial code / missing imports
- Rule: new files are complete with all imports. Edits to existing files show the changed block with enough context to place it.

## 2. Silent failures
- Violation: `catch (e) {}`.
- Rule: log, rethrow, or map to a domain error.

## Project-specific registry
<!-- Add recurring bugs here: "symptom -> cause -> rule". Keep entries to one line each. -->
