# Wiring: make every AI see the vault

> Principle: **one memory, many doors.** The vault is the only copy; each tool gets a **door** (a pointer block in its global instructions) plus **the skill**.

## 1. The door

Add this block to each tool's global instruction file (create the file if absent), with your own path:

```markdown
<!-- memory:begin -->
# Long-term memory vault
- Location: `D:\vault` (Obsidian vault + git repo)
- When you need background (people, projects, preferences, history): look in the vault first — `00-home.md` → section `_index.md` → note. **Never bulk-read.**
- When I say "remember this": write it to disk (inbox or the right folder) and tell me where. A verbal "got it" is not memory.
- Routines and rules: skill `obsidian-memory-en`.
<!-- memory:end -->
```

Common locations (2026 vintage — verify the file exists before editing):

| Tool | Door file |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` |
| DSH / Zed / Qoder | `~/.agents/AGENTS.md` (shared agents root) |
| OpenClaw / Qclaw | `~/.qclaw/workspace/AGENTS.md` |
| VS Code Copilot | `~/.copilot/copilot-instructions.md` |
| WorkBuddy | `~/.workbuddy-ai/user-<id>/MEMORY.md` |
| Cursor / Trae and other GUIs | paste the same block into their global rules setting |

Tools with no file entry (web chat, desktop apps): paste the block into "custom instructions / system prompt".

## 2. The skill

Copy the whole skill folder into each tool's skills root, keeping the folder name `obsidian-memory-en`:

| Tool | Skills root |
|---|---|
| DSH / Zed / Qoder / OpenCode | `~/.agents/skills` |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Trae / Trae CN | `~/.trae/skills`, `~/.trae-cn/skills` |
| OpenClaw | `~/.openclaw/skills` |

**Pitfall**: the skill `name` must be ASCII with hyphens. A non-ASCII name fails silently — the skill is simply never registered.

Keep a single master copy; if you install to several tools, script the copy instead of editing duplicates.

## 3. Verify

- Ask any AI: "where is my memory vault? read the home page and tell me the sections."
- Ask: "what do you do when I say 'remember this'?" — it should answer "write to disk and tell you where".

## 4. Optional schedule

Automation needs a callable CLI plus a prompt. Start manual ("tidy up today") if unsure.

Windows (daily 22:00):

```powershell
$act = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument '-NoProfile -File "D:\vault\scripts\daily.ps1"'
$trg = New-ScheduledTaskTrigger -Daily -At 22:00
Register-ScheduledTask -TaskName 'Memory daily' -Action $act -Trigger $trg -Force
```

macOS / Linux (cron):

```cron
0 22 * * * cd /home/me/vault && /usr/bin/env bash scripts/daily.sh >> .memory/daily.log 2>&1
```

The safest script shape: build a prompt from today's input + inbox, hand it to any CLI (`claude -p`, `codex exec`, `opencode run`), and **skip when there is nothing new**.

## 5. Safety

- The door holds paths and protocol only — no privacy, no credentials.
- Back up any global config before editing (`*.bak-<date>`).
- `git init` the vault; push to a **private** remote if any.