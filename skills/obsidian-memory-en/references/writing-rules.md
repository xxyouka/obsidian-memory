# Writing rules

## 1. Frontmatter

```yaml
---
tags: [journal]          # journal / weekly / project / index / library / protocol
date: YYYY-MM-DD         # daily notes
week: YYYY-Www           # weekly reviews
created: YYYY-MM-DD      # never changes
updated: YYYY-MM-DD      # bump on every edit
---
```

- Keep field names consistent across the vault; never mix `updated` and `last_modified`.
- Templates and indexes may omit `updated` until you edit them.

## 2. Links

- `[[20-projects/my-project|My project]]` — path relative to the vault root, alias for humans.
- Inside tables escape the pipe: `[[20-projects/my-project\|My project]]`.
- Targets must exist; the health check catches dead ones.
- Reference external material by path; do not copy it in.

## 3. Deltas only

- ✅ `v3.12.0 passed review, build 2026110501`
- ❌ `v3.12.0 is the latest version with feedback loop, dashboard, permissions…`
- Every number must be traceable: version, commit, file size, amount, test count.

## 4. Unverified

- Mark anything without evidence as `(unverified)` and list it in the review.
- Contradictions: present both, cite each, do not pick one.

## 5. Corrections

- **Never rewrite history.** Old daily notes and reviews keep what was known then.
- Record a correction in three places: the new daily note ("Correction: …"), the home changelog, and the affected project/role note.

## 6. Privacy and credentials

- Do not distil or share other people's private matters; abstract names ("a colleague", "a classmate").
- Never store: passwords, tokens, keys, ID numbers, phone numbers, addresses.
- From chats, keep "who asked for what in which context", never the transcript.

## 7. Files and naming

- Journal: `30-journal/YYYY-MM-DD.md` (one per day)
- Weekly: `40-weekly/YYYY-Www.md`
- Library: `50-library/topic.md`
- Project: `20-projects/project.md`
- Inbox: `99-inbox/YYYY-MM-DD-topic.md` → `_archive/YYYY-MM/`
- No `Untitled`, `New note`, `copy` files.

## 8. Commits

```powershell
git -C D:\vault add -A
git -C D:\vault commit -m "Daily 2026-11-05"
git -C D:\vault commit -m "Weekly 2026-W45"
```

- One tidy-up, one commit.
- If it fails (identity, permissions, remote conflict), say so — never fail silently.