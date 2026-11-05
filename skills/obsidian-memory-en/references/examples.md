# Good / bad examples

> Generic samples — swap in your own project.

## 1. Daily note · good

```markdown
## 🔄 Project changes
- **Auth: switched to SMS one-time codes.**
  - Why: users forget passwords; support handles ~20 resets/week.
  - Where: `src/auth/` rewritten, `v2.3.0` on staging; production still on passwords.
  - Numbers: delivery rate 98.2% (n=1,000).
```

Why: a decision, a reason, a location, a number. Three months later you can reproduce or roll it back.

## 2. Daily note · bad

```markdown
## 🔄 Project changes
- Worked on auth today, changed some code, seems to work, will look again later.
```

No path, no verification, "seems to work" records nothing, and "later" is not a todo.

## 3. Todos

- ✅ `- [ ] Run a 1,000-message delivery test on staging before the demo.`
- ❌ `- [ ] Keep improving auth.`

## 4. Weekly net change

| Style | Content |
|---|---|
| ✅ | Signup conversion 41% → 53%; API P95 820ms → 210ms; production bugs 3 → 0 |
| ❌ | Iterated on the product this week, experience is better |

Net change is two numbers you can verify, not adjectives.

## 5. Blocker

- ✅ `**Release blocked in review**: the store wants a privacy-policy URL; rejected twice; miss it and the 11-20 launch slips.`
- ❌ `Review has some issues, needs handling.`

## 6. "Remember this" capture

User: "Remember: always give me finished deliverables, not menus of options."

1. Open `10-core-memory/preferences.md`, under Delivery:
   `- Finished deliverables over option menus: ship a usable version; mention alternatives in one line at most.`
2. Bump `updated: 2026-11-05`.
3. Reply: "Saved to `10-core-memory/preferences.md` (Delivery). The daily tidy will re-check it tonight."

Counter-example: replying "got it" — the next session has no memory of it.

## 7. Data stays outside, conclusions go in

- ✅ `37 refunds / $4,820 this month, clustered on sizing`
- ❌ pasting 37 rows of refund records

Totals, conclusions and the source file name are enough.