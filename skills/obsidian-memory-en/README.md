# Obsidian Memory Vault — long-term memory for AI

> A copyable "AI long-term memory" setup: the memory itself is **one Obsidian vault + git repo** that any agent, you, and Obsidian can read directly.

## The problem

- Every new session, the AI forgets your preferences, project state, and last decisions.
- Memory is scattered across tools (Claude Code, Codex, Cursor…) with no shared source.
- You say "remember this" and get a cheerful "got it" — and nothing is stored.

## What you get

One command scaffolds a working vault:

```
00-home.md            entry point (map + read protocol)
01-protocol.md        read / daily / weekly / writing rules
AGENTS.md             in-vault rules for any agent
.memory/config.json   owner, path, layout, routines
10-core-memory/       identity, preferences, red lines (from the interview)
20-projects/          overview + one note per project
30-journal/           daily notes
40-weekly/            weekly reviews
50-library/           distilled methods and lessons
90-templates/         three templates
99-inbox/             capture now, triage later
```

Plus two scripts: `init-vault.ps1` (scaffold) and `check-vault.ps1` (broken links, missing fields, gaps, unlisted notes).

## Quick start

```powershell
# 1. copy this folder into a skills root, e.g. ~/.agents/skills/obsidian-memory-en
# 2. scaffold
pwsh -NoProfile -File obsidian-memory-en\scripts\init-vault.ps1 -Vault 'D:\vault' -Owner 'Your Name'
# 3. check
pwsh -NoProfile -File obsidian-memory-en\scripts\check-vault.ps1 -Vault 'D:\vault'
```

Then run the **8-question interview** in `references/init.md` and fill `10-core-memory/`. **Skip it and the vault stays an empty shell.**

## Day to day

- **Daily**: "tidy up today" → write `30-journal/`, sync project deltas, archive the inbox.
- **Weekly**: "weekly review" → write `40-weekly/`, fold net changes into projects, distil into `50-library/`.
- **Anytime**: "remember this" → written to disk immediately, with the path reported back.
- **Periodically**: run the check; gaps are missed-run signals.

## Five principles

1. **Read by section** — home → index → note; never bulk-read.
2. **Deltas only** — conclusions, numbers, sources; no transcripts.
3. **One note per day, dated** — backfill by date and mark it "(backfill)".
4. **Never rewrite history** — record corrections in the new note.
5. **Privacy red lines** — no other people's private matters, no credentials.

## Requirements

- PowerShell 7 on Windows; on macOS/Linux create the folders by hand and copy `assets/templates/*`.
- git (first commit; pass `-NoGit` to skip).
- Obsidian (optional — for graph view and backlinks).

## What it does not do

- It does not listen to your conversations — you ask, or you schedule a job (`references/wiring.md`).
- It does not decide what matters — it guarantees what *is* recorded stays findable, deduplicated and current.
- No cloud, no service: everything stays on your disk.

## Layout

```
SKILL.md                the skill (this is what the AI reads)
references/             init / daily / weekly / writing rules / wiring / examples
scripts/                init-vault.ps1 · check-vault.ps1
assets/templates/       15 vault templates
```

Chinese edition: sibling folder `obsidian-memory/`.