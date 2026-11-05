# Weekly review · checklist

> Compress seven days into "threads + net change + blockers + next week's P0". The value is in the **cutting**, not the collecting.

## A. Week and window

- ISO 8601, Monday-based. Example: `2026-W43` = 2026-10-19 (Mon) – 10-25 (Sun).
- File name `40-weekly/YYYY-Www.md`; zero-pad the week number.
- PowerShell: `[System.Globalization.ISOWeek]::GetWeekOfYear((Get-Date))`.

## B. What to read

- This week's seven daily notes (required).
- Last week's review — only its "next week" section, to check what actually happened.
- Project notes only when you need a number.

## C. Writing order

1. **Main threads**: 3–5 bullets, each a judgement plus a number.
2. **Net change table**: project / net change / next week. Write "from X to Y", not "currently Y".
3. **Blockers**: hard deadline > real risk > stalled; state the consequence.
4. **Next week**: P0 (dated or with a consequence, ≤3) / P1 / P2.
5. **Distillation candidates**.
6. **Health check** (see D).
7. **Backfill** for missed weeks: one "📎 backfill" section, not twenty notes.

## D. Health check

Run the script first:

```powershell
pwsh -NoProfile -File '<skill-dir>\scripts\check-vault.ps1' -Vault '<vault>' -Days 7
```

It reports broken links, frontmatter, daily gaps, weekly gaps, index gaps. `-Json` for machines, `-Strict` for exit code 1.

Then judge by hand:

- **Stale**: home todos, project "current version", deadlines.
- **Duplicates**: one fact in daily + project + library → keep the authoritative one, link the rest.
- **Conflicts**: list both, label each source, `(unverified)`.
- **To fill in**: project backlogs — fill or defer explicitly.

## E. Distillation decision tree

```
Will I still use this in three months?
├─ no  → leave it in the daily note
└─ yes → verified (actually ran, has results)?
    ├─ no  → queue it under "candidates" in the index
    └─ yes → same topic already exists?
        ├─ yes → merge, bump updated
        └─ no  → new 50-library/topic.md, first line states the source
```

## F. Close out

- Update `40-weekly/_index.md`.
- Append a line to the home page changelog; refresh its todo block from P0.
- Add a one-paragraph weekly summary to each touched project note.
- `git -C <vault> commit -m "Weekly review 2026-W45"`.

## G. Anti-patterns

- ❌ Every commit and version in "main threads" → readers lose the point.
- ❌ "Keep pushing project X" as next week → write "submit v3.12.0 for review, backfill the build number".
- ❌ The same blocker two weeks running with no action → promote to P0 or say "not this week".