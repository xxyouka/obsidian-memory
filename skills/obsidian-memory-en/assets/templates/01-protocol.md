---
tags: [protocol]
created: {{DATE}}
updated: {{DATE}}
---
# 📐 Read & update protocol

> Goal: **less redundant reading** — read only the section a task needs, then write the new conclusion back.

## 0. Memory rules (highest)

- This vault is the **long-term memory {{OWNER}} entrusted to AI**: whenever you need background (people, projects, preferences, history), **look here first**, never guess.
- When {{OWNER}} says **"remember this" / "note it down"**: you **must write it to disk** (inbox or the right folder) and say where; a verbal "got it" is not memory.
- Keep the vault tidy: dates, links, structure. Fix stale info when you see it.
- Unsure whether it matters? Capture it in the inbox first, filter during triage.

## 1. Read by task

| Task | Read | Skip |
|---|---|---|
| Conversation / personalisation | `10-core-memory/preferences.md`, `red-lines.md` | projects, journal |
| Work on a project | `20-projects/_project-overview.md` → that project note | other projects, source code |
| "What happened recently?" | last 3–7 days of `30-journal/` | the whole journal |
| Phase review | last 2–4 `40-weekly/` | daily detail |
| Method / background | relevant `50-library/` note | raw material |
| New information arrives | drop into `99-inbox/` first | editing formal notes directly |

**Layers**: home (L0) → section index (L1) → single note (L2) → external source (L3).
**Discipline**: one fact in one place; read before editing; stamp the `updated` date; never bulk-read the vault.

## 2. Daily routine

**Input**: today's inbox drops + anything project-related from today's conversation.

1. Read today's inbox + the current state of affected project notes (only those);
2. Create or append `30-journal/YYYY-MM-DD.md` (template `90-templates/daily-template.md`): talking points / project changes / todos / sources;
3. Sync **changes** into the matching `20-projects/` note, update its `updated`;
4. Update `20-projects/_project-overview.md` status column (only if changed);
5. Move handled inbox files to `99-inbox/_archive/YYYY-MM/`;
6. Anything worth distilling → queue it in `50-library/_index.md`.

## 3. Weekly routine

1. Read the week's 7 daily notes;
2. Write `40-weekly/YYYY-Www.md`: main threads, per-project net change, blockers, next week, distillation candidates;
3. Merge net changes into project notes (one paragraph);
4. Write generally useful lessons into `50-library/` (one topic per note);
5. Health check: broken links, stale info, duplicates, todo lists.

## 4. Writing rules

- Frontmatter always carries `updated: YYYY-MM-DD`;
- Links use `[[path|alias]]`; escape pipes inside tables as `\|`;
- **Never paste long transcripts** — bullet points plus the source;
- Privacy: do not distil other people's private matters; never store passwords, tokens or ID numbers.

## 5. Machine side

- Skill: `obsidian-memory-en` (init / daily / weekly / check).
- Health check: `scripts/check-vault.ps1`.
- This vault is a git repo: commit meaningful updates.