# Obsidian 记忆库 · 给 AI 的长期记忆

> 一个可以复制给别人的「AI 长期记忆」方案：**记忆本体是一个 Obsidian 库 + git 仓库**，AI、你自己、Obsidian 都能直接读。

## 它解决什么

- 换一次会话，AI 就把你的偏好、项目进度、上次的决定全忘了；
- 记忆散在各家工具里（Claude Code 一份、Codex 一份、Cursor 一份），互相不通；
- 想「记住这件事」，结果只换来一句「好的，记住了」。

## 它给你什么

一条命令建出一个能用的库：

```
00-home.md            入口（分区地图 + 读取协议）
01-protocol.md        读取 / 每日 / 每周 / 写入规范
AGENTS.md             库内给任意 Agent 的规矩
.memory/config.json   库配置（路径、布局、例程）
10-core-memory/       偏好、身份、红线（访谈填实）
20-projects/          项目总览 + 单篇
30-journal/           每日记录
40-weekly/            周复盘
50-library/           沉淀库（方法、经验）
90-templates/         三套模板
99-inbox/             收件箱（先记后整理）
```

外加两个脚本：`init-vault.ps1`（建库）、`check-vault.ps1`（体检：断链 / 缺字段 / 记录缺口 / 索引漏登记）。

## 三步上手

```powershell
# 1. 把本目录复制进你的 skills 目录，例如 ~/.agents/skills/obsidian-memory
# 2. 建库
pwsh -NoProfile -File obsidian-memory\scripts\init-vault.ps1 -Vault 'D:\记忆库' -Owner '你的名字'
# 3. 体检
pwsh -NoProfile -File obsidian-memory\scripts\check-vault.ps1 -Vault 'D:\记忆库'
```

建完库，让 AI 按 `references/init.md` 做 **8 问访谈**，把 `10-core-memory/` 填实——**不填，库就是个空壳**。

## 日常怎么跑

- **每天**：「整理一下今天」→ 写 `30-journal/`、同步项目变化点、归档收件箱；
- **每周**：「做这周复盘」→ 写 `40-weekly/`、净变化回写项目、够格的沉淀进 `50-library/`；
- **随时**：「记住……」→ 立刻落盘，并告诉你写在哪；
- **定期**：跑一次体检，缺口就是漏跑信号。

## 五条设计原则

1. **按区读取**：首页 → 索引 → 单篇，绝不全库通读（省 token）；
2. **只写变化点**：结论 + 数字 + 出处，不抄聊天原文；
3. **一天一篇、按日期归位**：漏跑就补，标「（补整理）」；
4. **不改写历史**：口径变了就在新记录里写「更正」；
5. **隐私红线**：他人隐私不提炼不透传，凭证一律不落盘。

## 要求

- PowerShell 7（Windows）；macOS / Linux 可手工建目录 + 复制模板；
- git（首次提交；不想要加 `-NoGit`）；
- Obsidian（可选，纯粹为了看图谱和双链）。

## 不做什么

- 不会自动监听你的对话——要么你说一声，要么自己挂定时任务（见 `references/wiring.md`）；
- 不替你决定什么值得记——它只保证「记下来的能被找到、不重复、不过期」；
- 不含任何云端服务，全部落在你自己的磁盘。

## 目录

```
SKILL.md                技能主文件（AI 读这个）
references/             建库 / 每日 / 每周 / 写入规范 / 接线 / 样例
scripts/                init-vault.ps1 · check-vault.ps1
assets/templates/       15 个库模板
```

英文版：见同级 `obsidian-memory-en/`。