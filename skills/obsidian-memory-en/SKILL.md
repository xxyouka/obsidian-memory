---
name: obsidian-memory-en
description: Turn an Obsidian vault into an AI's long-term memory — scaffold it (folders, templates, indexes, home page, git), run daily capture and weekly reviews, capture "remember this" on the spot, health-check the vault, and wire it into every agent. Use when the user says "build me a memory vault / a vault that remembers me", "tidy up today", "weekly review", "remember this", "where is my memory vault", or mentions Obsidian, second brain, memory vault, long-term memory. If no vault exists yet, scaffold one first; otherwise follow the vault's own protocol.
---

# Obsidian memory vault (English)

**What this is**: a copyable "AI long-term memory" setup. The memory itself is one **Obsidian vault + git repo** — readable by any agent, by the user, and by Obsidian.

**Two phases**:

- **First run** → scaffold (section 1): folders, templates, indexes, interview, wiring.
- **Every run after** → maintain (sections 2–5): daily capture, weekly review, immediate capture, health check.

**Principle**: memory is worth what its **deltas and conclusions** are worth, not its transcripts. One clear decision beats a hundred pasted messages.

---

## 0. Thirty-second check

1. Look for `.memory/config.json` in the current folder or the path the user gave.
2. **Found** → read `00-home.md` and `01-protocol.md`, follow them (the vault's protocol wins on any conflict).
3. **Not found** → ask three questions (name / where / which AI tools), then scaffold.

---

## 1. Scaffold (first run)

```powershell
pwsh -NoProfile -File '<skill-dir>\scripts\init-vault.ps1' -Vault '<vault>' -Owner '<name>'
```

Creates 8 folders and 15 files (home / protocol / three templates / four indexes / three core-memory notes / inbox readme / in-vault AGENTS.md / `.memory/config.json`) and makes the first git commit.

Then run the **8-question interview** in `references/init.md` and fill `10-core-memory/` — **skip it and the vault stays an empty shell**.

No PowerShell: build the folders by hand per `references/init.md`, copy `assets/templates/*`, replace `{{OWNER}}` / `{{VAULT}}` / `{{DATE}}` / `{{TZ}}`.

---

## 2. Daily capture

Seven steps (details in `references/daily.md`):

1. Read the project notes touched today only;
2. Create or **append** `30-journal/YYYY-MM-DD.md` (four sections: talking points / project changes / done-todos / notes);
3. Sync deltas into `20-projects/*.md`, bump `updated`;
4. Touch the overview status column only when it changed;
5. Archive handled inbox files to `99-inbox/_archive/YYYY-MM/`;
6. Queue distillation candidates in `50-library/_index.md` (don't write the article today);
7. Close out and commit.

**Nothing new → skip**, reply "nothing new today". Never manufacture a note.

---

## 3. Weekly review

1. Read this week's seven daily notes (last week's review only for its "next week" list);
2. Write `40-weekly/YYYY-Www.md` (ISO week): 3–5 threads / net-change table / ranked blockers / P0-P1-P2;
3. Merge net changes into project notes (one paragraph);
4. Distil what qualifies into `50-library/`, update its index;
5. Health check + close out.

**Net change is "from X to Y"**, never "currently Y"; next week's items must be verifiable actions, not "keep pushing".

---

## 4. "Remember this" = write now

1. **Route it**: preference → `10-core-memory/`; project fact → `20-projects/`; unsure → `99-inbox/YYYY-MM-DD-topic.md`;
2. **Write it**, bump `updated`, bullets not transcripts;
3. **Reply with the path**: "saved to `<path>`";
4. Only facts, decisions, preferences; no private data, no credentials.

**A verbal "got it" is not memory — the file is.**

---

## 5. Health check

```powershell
pwsh -NoProfile -File '<skill-dir>\scripts\check-vault.ps1' -Vault '<vault>' -Days 7
```

Five checks: broken links, missing `updated`, daily gaps, weekly gaps, unlisted notes.

- `-Json` for machines; `-Strict` exits 1 (good for cron).
- Without `-Vault` it walks up from the current directory to `.memory/config.json`.
- Read-only. Gaps are **missed-run signals**: backfill by date (daily ≤7 days, weekly ≤21 days) and mark "(backfill)".

---

## 6. Writing rules (essentials)

- Frontmatter: `created` / `updated`; bump `updated` on every edit.
- Links `[[path|alias]]`, escape pipes in tables (`\|`); register every new note in an index.
- **Deltas only**; numbers must be traceable.
- Mark uncertainty `(unverified)`; contradictions side by side.
- **Never rewrite history**: corrections go into the new note and the changelog.
- Privacy: no other people's private matters; no passwords, tokens, ID numbers.
- Don't touch `.obsidian/`; rename notes from inside Obsidian.

Details in `references/writing-rules.md`; good/bad samples in `references/examples.md`.

---

## 7. Anti-patterns

| Don't | Do |
|---|---|
| Bulk-read the vault | home → index → note (L0→L1→L2) |
| Paste transcripts | bullets + source |
| Several notes per day / backfill into today | one per day, dated, append same day |
| Rewrite old daily notes with new facts | keep history, write a correction |
| Write a note with nothing new | skip; density beats volume |
| Scaffold without the interview | the interview is part of setup |
| Put privacy in the door block | doors hold paths and protocol only |
| Say "noted" without a file | write, then reply with the path |

---

## 8. Wiring

One memory, many doors: a pointer block in each tool's global instructions, plus this skill in each tool's skills root.

- **Pitfall**: the skill name must be ASCII with hyphens; a non-ASCII name is skipped silently.

Paths, the door template and scheduling samples are in `references/wiring.md`.

---

## 9. Pre-delivery self-check

1. Does every delta have a home in a project note?
2. Any number without a source?
3. Anything written as "done" that is only "should be"?
4. One fact, one place?
5. Index / home / todos updated?
6. Committed — or did you say why not?

---

## 10. Resources

- `scripts/init-vault.ps1` — scaffold (folders + templates + config + git)
- `scripts/check-vault.ps1` — health check
- `assets/templates/` — home, protocol, three templates, indexes
- `references/init.md` — scaffold flow + interview
- `references/daily.md` / `weekly.md` — routine checklists
- `references/writing-rules.md` — conventions
- `references/wiring.md` — doors, skills, schedules
- `references/examples.md` — good/bad samples