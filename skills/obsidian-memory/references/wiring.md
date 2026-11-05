# 接线：让每个 AI 都读得到这个库

> 原则：**记忆本体只有一份**（库），每家工具只装两样东西——**一扇门**（全局指令里的一小段指针）+ **一个技能**（本技能）。
> 指针只放路径和读取协议，**不放隐私内容**；隐私只留在库文件里。

## 1. 门：全局指令文件

按你用的工具，找到它的全局规则文件（不存在就新建），把下面这段放进去。**一次只放一段，路径换成你的**：

```markdown
<!-- memory:begin -->
# 永久记忆库
- 位置：`D:\记忆库`（Obsidian 库 + git 仓库）
- 需要任何背景（人、项目、偏好、历史）时：先去库里找 —— `00-首页.md` → 分区 `_索引.md` → 单篇；**不要全库通读**。
- 用户说「记住 / 记一下」时：必须落盘（`99-收件箱/` 或对应分区），并回复记在哪；口头答应不算。
- 例程与规范：技能 `obsidian-memory`（建库 / 每日整理 / 周复盘 / 体检）。
<!-- memory:end -->
```

常见位置（2026 年时点，版本升级可能变，装之前先确认文件是否存在）：

| 工具 | 门文件 |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` |
| DSH / Zed / Qoder | `~/.agents/AGENTS.md`（共享 agents 根） |
| OpenClaw / Qclaw | `~/.qclaw/workspace/AGENTS.md` |
| VS Code Copilot | `~/.copilot/copilot-instructions.md` |
| WorkBuddy | `~/.workbuddy-ai/user-<id>/MEMORY.md` |
| Cursor / Trae 等 GUI | 全局规则在设置界面里，粘贴同一段 |

没有文件入口的（豆包、CherryStudio 等）：把这段贴进「自定义指令 / 系统提示」。

**只读不写的工具**：光有门就够了，它会自己去读库。

## 2. 技能：装到各家的 skills 目录

把本技能整个目录（`obsidian-memory/`）复制进对应目录，目录名保持 `obsidian-memory`：

| 工具 | 技能根 |
|---|---|
| DSH / Zed / Qoder / OpenCode | `~/.agents/skills` |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Trae / Trae CN | `~/.trae/skills`、`~/.trae-cn/skills` |
| OpenClaw | `~/.openclaw/skills` |

**坑（务必看）**：技能 `name` 必须是 **ASCII 短横线名**（`obsidian-memory`）。写成中文不会报错，但会被静默跳过，等于没装。装完确认它出现在技能目录里。

如果你维护多份副本（每个工具一份），写个同步脚本一次分发，别手改第二份——**母版只留一份**在库里或某个固定目录。

## 3. 验证

- 随便开一家 AI 问：「我的永久记忆库在哪？读一下首页说说里面有什么」→ 能报出路径和分区结构。
- 再问：「我说『记住』的时候你会怎么做」→ 应回答「落盘并告诉你路径」。

## 4. 定时整理（可选）

自动跑需要：能调用的 AI CLI + 一段提示词。**没把握就先手动**，每天喊一句「整理一下今天」。

Windows（计划任务，每天 22:00）：

```powershell
$act = New-ScheduledTaskAction -Execute 'pwsh.exe' `
  -Argument '-NoProfile -File "D:\记忆库\scripts\daily.ps1"'
$trg = New-ScheduledTaskTrigger -Daily -At 22:00
Register-ScheduledTask -TaskName '每日记忆整理' -Action $act -Trigger $trg -Force
```

macOS / Linux（crontab）：

```cron
0 22 * * * cd /home/me/记忆库 && /usr/bin/env bash scripts/daily.sh >> .memory/daily.log 2>&1
```

脚本里最稳的写法：把「今天的新信息 + 收件箱」拼成提示词，交给任意 CLI（`claude -p` / `codex exec` / `opencode run`），**没有新内容就跳过**（别每天造一篇空笔记）。

## 5. 安全

- 门文件里**不要写**隐私、项目细节、凭证——只写路径和协议。
- 改别人的全局配置前先备份（`*.bak-<日期>`）。
- 库建议 `git init`；有远端就推私有仓，**不要公开**。