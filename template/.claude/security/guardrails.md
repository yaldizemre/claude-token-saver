# Security Guardrails

## Secrets
- Never print API keys, tokens, passwords or private env values.
- Use `process.env.NAME` or `<PLACEHOLDER>`.

## Destructive actions require explicit confirmation
- `rm -rf`, `DROP DATABASE/TABLE`, `git reset --hard`, `git push --force`, deleting core files, changing global security logic.
