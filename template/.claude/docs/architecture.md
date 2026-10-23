# Architecture & Constraints

## Stack
- Stack: <FILL IN: e.g. Node.js / TypeScript / React / PostgreSQL>
- Pattern: strictly typed, modular, single responsibility.

## Standards
- Every async operation has explicit error handling and propagation.
- No implicit `any`.
- Solve in one pass; split into steps only when output limits force it.

## Prompt caching
- Keep static rules and reference docs at the top of the context; put variable input at the bottom.
- Do not edit static headers between requests (preserves cache hits).
