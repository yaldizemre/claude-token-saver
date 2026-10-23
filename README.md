<div align="center">

# claude-token-saver

**Make Claude faster, shorter and cheaper to run — with one command.**

A drop-in rules, commands and safety template for **Claude Code** and **Claude.ai Projects**.

🇬🇧 English · 🇹🇷 [Türkçe](README.tr.md)

![license](https://img.shields.io/badge/license-MIT-blue) ![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey) ![languages](https://img.shields.io/badge/docs-EN%20%7C%20TR-green)

</div>

---

## Table of contents

1. [Why this exists](#why-this-exists)
2. [Features](#features)
3. [Quick start](#quick-start)
4. [What gets installed](#what-gets-installed)
5. [Slash commands](#slash-commands)
6. [How the token savings work](#how-the-token-savings-work)
7. [Safety rules and permissions](#safety-rules-and-permissions)
8. [Customizing](#customizing)
9. [Claude.ai Projects setup](#claudeai-projects-setup)
10. [Installer reference](#installer-reference)
11. [FAQ](#faq)
12. [Troubleshooting](#troubleshooting)
13. [Uninstall](#uninstall)
14. [Roadmap](#roadmap)
15. [Contributing](#contributing)
16. [License](#license)

---

## Why this exists

Every Claude message carries context: your rules, the files it reads, the chat history and its own previous output. Cost and speed grow with that context. Typical waste:

- **Chatty replies:** greetings, restating the question, closing offers ("Let me know if…").
- **Whole-file output:** reprinting a 400-line file to change three lines.
- **Blind reading:** opening lock files, `node_modules`, build output or whole directories.
- **Bloated rule files:** a huge `CLAUDE.md` is loaded on *every* session.
- **Conflicting rules:** "never ask questions" next to "confirm destructive actions" makes the model hesitate or over-explain.
- **Wrong model for the job:** a heavy model doing formatting work.

`claude-token-saver` is a small, tested template that removes these habits at the source, so you don't have to repeat the same instructions in every chat.

> It does not promise a fixed percentage. Savings depend on your project and habits. The goal is fewer wasted tokens, not fewer useful ones.

## Features

- **One-command install** for macOS, Linux, WSL, Git Bash and Windows PowerShell.
- **Safe installer:** never overwrites existing files unless you pass `--force`, which keeps a `.bak` backup. Includes `--dry-run`.
- **Lean `CLAUDE.md`:** short, conflict-free core rules written in English (fewer tokens than Turkish or other languages) while replies still follow *your* language.
- **Six ready slash commands:** `/review`, `/refactor`, `/lint`, `/test`, `/audit`, `/compact-ctx`.
- **Read protection:** `settings.json` denies reads of dependencies, lock files, build output, coverage and `.env` files.
- **Destructive-command guard:** denies `rm -rf`, `git push --force`, `git reset --hard`.
- **Model routing:** cheap/fast model for simple commands, stronger model guidance for hard work.
- **Just-in-time docs:** architecture and error notes are read only when relevant.
- **Claude.ai support:** a paste-ready Project instruction set.
- **Bilingual docs:** English and Turkish.

## Quick start

Run inside the project folder where you use Claude.

**macOS / Linux / WSL / Git Bash**

```bash
curl -fsSL https://raw.githubusercontent.com/yaldizemre/claude-token-saver/main/install.sh | bash
```

**Windows PowerShell**

```powershell
irm https://raw.githubusercontent.com/yaldizemre/claude-token-saver/main/install.ps1 | iex
```

**Or clone and run**

```bash
git clone https://github.com/yaldizemre/claude-token-saver.git
cd claude-token-saver
bash install.sh --dry-run --dir /path/to/your/project   # preview
bash install.sh --dir /path/to/your/project             # install
```

Then:

1. Open `.claude/docs/architecture.md` and replace the `<FILL IN>` stack line.
2. Run `claude` in your project. The rules load automatically.
3. Try `/review` or `/compact-ctx`.

> Tip: read `install.sh` before piping any script into `bash`. It is short and has no hidden steps.

## What gets installed

```
your-project/
├── CLAUDE.md                      # core rules, loaded every session
└── .claude/
    ├── settings.json              # permission denies (reads and risky commands)
    ├── docs/
    │   ├── architecture.md        # stack and standards (fill in your stack)
    │   └── error-handbook.md      # anti-patterns and your project-specific bug registry
    ├── security/
    │   └── guardrails.md          # secrets and destructive-action rules
    └── commands/
        ├── review.md              # /review
        ├── refactor.md            # /refactor
        ├── lint.md                # /lint
        ├── test.md                # /test
        ├── audit.md               # /audit
        └── compact-ctx.md         # /compact-ctx
```

The repository itself also contains `claude-ai/` (Claude.ai Project instructions and notes). That folder is documentation, not installed into your project.

## Slash commands

| Command | What it does | Model | Output |
|---|---|---|---|
| `/review [path]` | Reviews a path, or your current `git diff` if empty. Checks leaks, security flaws, missing types, stubs. | session model | Critical / Improvements / Fix, nothing else |
| `/refactor <path>` | Improves performance, typing, readability following your docs. Edits in place. | session model | At most 3 summary bullets |
| `/lint <path>` | Removes unused imports/variables, dead code and debug logs. | Haiku | No explanation |
| `/test <path>` | Writes meaningful tests (edge cases, async failures, boundaries), runs them, fixes failures. | session model | Test file |
| `/audit <path>` | Red-team pass: hostile inputs, first production failure point, dependency existence check. | session model | Only actionable bugs and fixes |
| `/compact-ctx` | Summarizes the session in under 300 words so you can start a fresh chat. | Haiku | One Markdown block |

Commands are plain Markdown files in `.claude/commands/`. Edit them freely or add your own.

## How the token savings work

| Technique | Where | Effect |
|---|---|---|
| No filler, no recaps, no closing offers | `CLAUDE.md` | Shorter output every turn |
| Diff-style edits instead of whole files | `CLAUDE.md` | Large saving on edits to big files |
| Search first, read only needed lines | `CLAUDE.md` | Less input context |
| Deny reads of lock files, deps, builds | `settings.json` | Prevents accidental huge reads |
| English rule text | all rule files | Fewer tokens per rule than Turkish |
| Short core file, details in `.claude/docs` | structure | Small always-loaded context; details only when needed |
| Cheap model for mechanical tasks | `/lint`, `/compact-ctx` | Lower cost per task |
| Compact and restart long chats | `/compact-ctx` | Stops history from snowballing |
| Static rules first, variable input last | `architecture.md` guidance | Better prompt-cache hits |

## Safety rules and permissions

- **Secrets:** Claude is told never to print keys, tokens or passwords; use `process.env.NAME` or `<PLACEHOLDER>`.
- **Confirmation required** for destructive actions: `rm -rf`, `DROP DATABASE/TABLE`, `git reset --hard`, `git push --force`, deleting core files, changing global security logic.
- **Hard denies** in `settings.json`:
  - Reads: `.env`, `.env.*`, `secrets/**`, `node_modules/**`, `dist/**`, `build/**`, `.next/**`, `coverage/**`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`
  - Commands: `rm -rf`, `git push --force`, `git reset --hard`

> **Honest limits:** permission rules are a guardrail, not a sandbox. Pattern-based denies can be sidestepped by indirect commands (for example reading a file through another tool). Keep real secrets out of the repo and use proper OS and git permissions for anything critical.

## Customizing

- **Your stack:** edit `.claude/docs/architecture.md`.
- **Your recurring bugs:** add one-line entries to `.claude/docs/error-handbook.md` ("symptom → cause → rule"). Keep it short; every line costs tokens when read.
- **Reply language:** Claude answers in the language you write in. Force one by adding a line to `CLAUDE.md`, e.g. `Always reply in Turkish.`
- **Allow a denied path:** remove the matching line from `.claude/settings.json`.
- **Add a command:** create `.claude/commands/name.md` with front matter:

  ```markdown
  ---
  description: What it does
  model: haiku
  ---
  Task for: $ARGUMENTS
  ```
- **Other languages' rules:** keep rule files in English even for non-English teams; only the replies need to match your language.

## Claude.ai Projects setup

Claude.ai does **not** read `.claude/`. Use the instruction text instead:

1. claude.ai → **Projects → New project**.
2. Paste `claude-ai/project-instructions.md` into the project instructions.
3. Add only short, frequently needed files to project knowledge. Avoid uploading whole repos.
4. Start a new chat when the topic changes.

Details: [`claude-ai/README.md`](claude-ai/README.md).

## Installer reference

| Option | Meaning |
|---|---|
| *(none)* | Install into the current folder; skip files that already exist |
| `--dir <path>` | Install into another folder |
| `--dry-run` | Print what would happen, change nothing |
| `--force` | Overwrite differing files; each gets a `<file>.bak` backup |

Environment variables: `CT_REPO` (default `yaldizemre/claude-token-saver`) and `CT_BRANCH` (default `main`) let you install from a fork or branch.

Identical files are left untouched, so re-running is safe.

## FAQ

**Does this work with other AI tools?** It targets Claude Code and Claude.ai. The rule text is plain Markdown and can be adapted.

**Will it break my existing `CLAUDE.md`?** No. Existing files are skipped unless you use `--force`, and then a `.bak` copy is kept. You can also merge the rules by hand.

**Why English rules in a Turkish project?** Rule text is loaded often; English usually takes fewer tokens. Replies still follow your language.

**Is the Claude Code part usable on Claude.ai?** No. `.claude/` is read only by Claude Code. See the Projects section.

**Are the savings measured?** Not with a fixed benchmark. Compare your own usage before and after.

**A command's `model: haiku` is ignored.** Model aliases depend on your Claude Code version and plan. Remove the line or set a full model name.

## Troubleshooting

| Problem | Fix |
|---|---|
| `curl: (22)` / 404 on install | The repo must be public and the `main` branch must exist |
| `template/ not found` | You are using a fork or branch without the `template/` folder |
| Files skipped on re-run | They already exist; use `--force` (backups are made) |
| Slash commands missing | Restart `claude` in the project root; check `.claude/commands/*.md` exists |
| Claude can't read a file you need | It matches a deny in `.claude/settings.json`; remove that line |
| PowerShell blocks the script | Run in a normal PowerShell window; use the clone method if policy forbids `iex` |

## Uninstall

Delete what the installer created:

```bash
rm -rf .claude CLAUDE.md
```

Restore any `.bak` files if you used `--force`.

## Roadmap

- Optional hooks (warn before large reads, auto-lint)
- Stack presets: `--stack node|python|go`
- `install.sh --check` to validate an install
- More languages for docs

## Contributing

Issues and pull requests are welcome. Please keep rules short and conflict-free: every added line is loaded into context and costs tokens. Test changes with `bash install.sh --dry-run`.

## License

MIT. See [LICENSE](LICENSE).
