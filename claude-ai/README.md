# Claude.ai Project setup

🇬🇧 English · 🇹🇷 [Türkçe](README.tr.md)

1. claude.ai → **Projects → New project**.
2. Paste the contents of `project-instructions.md` into **Set project instructions**.
3. Add only short, frequently needed files to **Project knowledge** (architecture summary, API schema). Don't upload the whole repo: it bloats every message.
4. Start a **new chat** when the topic changes; in a long chat use the `compact-ctx` prompt (`template/.claude/commands/compact-ctx.md`).

> Note: Claude.ai Projects do not read the `.claude/` folder. That folder is for Claude Code. In Claude.ai, only the instructions text applies.
