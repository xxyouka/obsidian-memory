# Building the vault (first run)

> Trigger: no `.memory/config.json`, or the user says "build me a memory vault / a vault that remembers me".
> Goal: a vault that is **usable within ten minutes**, not an empty folder.

## 0. Ask three things first

1. **What should I call you?** (goes into the home page, in-vault AGENTS.md, preferences)
2. **Where should the vault live?** (default `~/memory-vault`; avoid spaces in the path; any plain folder Obsidian can open)
3. **Which AI tools do you use?** (Claude Code / Codex / Cursor / Trae / DSH / OpenCode… decides step 5; if unsure, start manual)

Ask these together, once. Everything else comes from the interview.

## 1. Scaffold (one command)

```powershell
pwsh -NoProfile -File '<skill-dir>\scripts\init-vault.ps1' -Vault 'D:\vault' -Owner 'Alex'
```

Produces 8 folders and 15 files:

```
<vault>/
├─ 00-home.md                   # entry point (MOC)
├─ 01-protocol.md               # rules
├─ AGENTS.md                    # in-vault rules for any agent
├─ .memory/config.json          # owner / path / layout / routine
├─ 10-core-memory/  _index + about-me + preferences + red-lines
├─ 20-projects/     _project-overview
├─ 30-journal/      _index
├─ 40-weekly/       _index
├─ 50-library/      _index
├─ 90-templates/    daily / weekly / project
└─ 99-inbox/        _readme + _archive/
```

- Refuses to overwrite an existing vault unless `-Force`; `-NoGit` skips git.
- **No PowerShell?** Create the same folders by hand and copy `assets/templates/*`, replacing `{{OWNER}}` / `{{VAULT}}` / `{{DATE}}` / `{{TZ}}`.

## 2. Interview (8 questions, 2–3 at a time)

| Ask | Write into |
|---|---|
| What do you do? What are you working on now? | `10-core-memory/about-me.md` → identity |
| What do you want done within a year? | `about-me.md` → goals |
| How should I address you, in what tone, how long? | `preferences.md` → communication |
| Which tools / systems / languages? | `preferences.md` → working habits |
| Finished deliverables or option lists? Naming? | `preferences.md` → delivery |
| Anything I must never do? | `red-lines.md` → never |
| What privacy or company data is off-limits? | `red-lines.md` → privacy |
| Which long-term projects do you have? | `20-projects/_project-overview.md` + one note each |

**Three rules**: turn the user's words into durable facts (don't quote the chat); mark guesses `(unverified)`; write after each batch.

## 3. First memory (close the loop)

Ask for one thing they want remembered, then demonstrate: pick the folder → write it → reply "saved to `<path>`". This is what earns trust in the vault.

## 4. Verify

- `check-vault.ps1` is all clear (a fresh vault reports no gaps);
- Open the folder in Obsidian: notes and graph visible;
- Open another AI session and ask "where is my memory vault?" — if it can't answer, wiring isn't done (step 5).

## 5. Wiring

See `wiring.md`: global instruction pointer, skill install, optional scheduled routine.

## 6. Hand-off line

> Vault is at `<path>`, committed to git. From now on, "remember this" writes to disk, and I can tidy it daily/weekly. Want me to wire it into the AI tools you use?