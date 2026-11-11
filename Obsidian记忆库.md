# Obsidian记忆库

> 把 AI 的长期记忆放进你自己的 Obsidian 库：偏好、项目、每日记录、周复盘、沉淀库全部落成 Markdown + 双链，任何 Agent 进来都能读，你自己也能直接看。

**目录**：`obsidian-memory`　·　**形态**：Agent Skill（中 / 英双版）+ Obsidian 库脚手架　·　**最近提交**：2026-11-05

## 它解决什么

- 换一次会话，AI 就把你的偏好、项目进度、上次的决定全忘了
- 记忆散在各家工具里（Claude Code、Codex、Cursor…），互相不通
- 你说「记住这件事」，只换来一句「好的，记住了」——其实什么都没存

## 两个 Skill

| 版本 | 路径 | 用途 |
| --- | --- | --- |
| 中文 | `skills/obsidian-memory/` | 中文场景的读取 / 写入 / 整理协议 |
| English | `skills/obsidian-memory-en/` | 面向英文 Agent，内容等价 |

两个都带 `SKILL.md`、`references/`、`scripts/`、`assets/`。

## 怎么用

1. 把对应 Skill 目录复制进你的 skills 根目录（例如 `~/.agents/skills/`）；
2. 初始化库：

```powershell
pwsh -NoProfile -File obsidian-memory-en/scripts/init-vault.ps1 -Vault 'D:\vault' -Owner 'Your Name'
```

3. 体检：

```powershell
pwsh -NoProfile -File obsidian-memory-en/scripts/check-vault.ps1 -Vault 'D:\vault'
```

4. 跑 `references/init.md` 里的 **8 问访谈**——跳过它，库就只是个空壳。

## 本机现状

官潇本机实际在用的库在 `/Users/xx/memory-vault`（Obsidian + git 私有仓），**和本仓库分开**：本仓库是通用方法 / 脚手架，那个库是个人记忆本体。日常用 `guanxiao-memory` / `guanxiao-memory-keeper` 技能按区读写。

## 目录

| 路径 | 内容 |
| --- | --- |
| `skills/obsidian-memory/` | 中文版 Skill |
| `skills/obsidian-memory-en/` | 英文版 Skill |
| `docs/` | 截图等文档资源 |
| `README.md` | 完整说明（含例程与隐私边界） |

## 注意

- 只读必要分区，不要全库通读——建库的目的就是减少冗余读取。
- 隐私红线：他人隐私不提炼、不外传；密码 / token / 证件号不写进笔记。

## 延伸阅读

[README.md](README.md) · [skills/obsidian-memory/SKILL.md](skills/obsidian-memory/SKILL.md) · [skills/obsidian-memory-en/SKILL.md](skills/obsidian-memory-en/SKILL.md)

---

<sub>2026-11-11 据仓库 README 整理；有变化请直接改本文件。</sub>
