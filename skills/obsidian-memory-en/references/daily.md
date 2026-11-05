# Daily routine · checklist

> One note per day: what changed, the conclusion, the next step. Readable by you and any agent three months later.

## A. Gather input

1. Every non-folder file in `99-inbox/` (skip `_readme.md`, `_archive/`).
2. Decisions, versions, commit ids, amounts, dates, external feedback from this session.
3. If you use several agents (Claude Code / Codex / Cursor / Trae / DSH…), merge their session digests; one fact, one entry.
4. Read only the project notes touched today.

## B. Should you write at all?

| Situation | Action |
|---|---|
| A decision / progress / new todo | write |
| Small talk or already known | skip, reply "nothing new today" |
| Uncertain | write it, mark `(unverified)` |
| Mentions other people's privacy | abstract to "a colleague" |

## C. Skeleton

```markdown
---
tags: [journal]
date: YYYY-MM-DD
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# YYYY-MM-DD

## 📮 Talking points
- who, what, conclusion (one bullet each)

## 🔄 Project changes
- Project: deltas only (version / number / state change)

## ✅ Done / ⏳ Todos
- [x] done
- [ ] open (owner or deadline)

## 🧷 Notes
- Source: inbox file / session / other
```

## D. Appending (second pass same day)

- Do not create a new file; append under the right heading.
- Bump `updated` only; `created` never changes.
- If you overturn an earlier judgement, keep the old line and add "Correction: …".

## E. Sync into project notes

1. Read the project's "current state / timeline" section.
2. Add one timeline line: `- 11-05: v3.12.0 passed review, build 2026110501`.
3. Bump that note's `updated`.
4. Touch `_project-overview.md` only when the status changed.

## F. Archive

- `99-inbox/foo.md` → `99-inbox/_archive/YYYY-MM/foo.md` (month = **delivery** month).
- Archive only after the content is absorbed.

## G. "Remember this" captures

| Content | Write into | Or inbox |
|---|---|---|
| A preference, taboo, communication habit | `10-core-memory/preferences.md` or `red-lines.md` | — |
| A project fact / decision / todo | that `20-projects/` note | — |
| Cross-project, unclear origin | — | `99-inbox/YYYY-MM-DD-topic.md` |

Always reply "saved to `<path>`". **Never** answer just "got it".

## H. Reply template

```
Tidied 2026-11-05: new 30-journal/2026-11-05.md; updated two project notes; archived 2 inbox files; 1 item marked (unverified). Committed <sha>.
```

If git is unavailable, say "not committed (reason)".