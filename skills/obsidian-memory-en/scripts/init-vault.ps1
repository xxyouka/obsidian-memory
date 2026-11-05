<#
.SYNOPSIS
  初始化一个 Obsidian 记忆库：目录、模板、索引、首页、配置、git。

.DESCRIPTION
  把技能自带模板（assets/templates）整棵复制到目标目录，替换 {{OWNER}} / {{VAULT}} / {{DATE}} / {{TZ}}。
  文件名以 .tpl 结尾的，复制时去掉后缀（例如 AGENTS.md.tpl → AGENTS.md）。

  语言：默认按技能目录名判断（*‑en 用英文提示，其它用中文），也可用 -Lang 覆盖。
  访谈填实由调用方（AI）按 references/init.md 完成。

.EXAMPLE
  pwsh -NoProfile -File init-vault.ps1 -Vault 'D:\记忆库' -Owner '小王'

.EXAMPLE
  pwsh -NoProfile -File init-vault.ps1 -Vault 'D:\Vault' -Owner 'Alex' -Lang en -NoGit
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Vault,
  [Parameter(Mandatory = $true)][string]$Owner,
  [switch]$Force,
  [switch]$NoGit,
  [string]$Timezone = '',
  [ValidateSet('auto', 'zh', 'en')][string]$Lang = 'auto'
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { }

$skillRoot = Split-Path -Parent $PSScriptRoot
if ($Lang -eq 'auto') {
  $Lang = if ((Split-Path -Leaf $skillRoot) -match '-en$') { 'en' } else { 'zh' }
}

$M = @{
  zh = @{
    noTpl  = '找不到模板目录：{0}'
    exists = '目标目录已有 {0} 个 .md 文件：{1}（确认要覆盖请加 -Force）'
    next   = '按 references/init.md 做访谈填实 10-核心记忆，再跑 check-vault.ps1'
    commit = '初始化记忆库：结构 + 模板 + 索引'
  }
  en = @{
    noTpl  = 'Template directory not found: {0}'
    exists = 'Target already has {0} .md files: {1} (add -Force to overwrite)'
    next   = 'Run the interview in references/init.md, then run check-vault.ps1'
    commit = 'Initialize memory vault: structure + templates + indexes'
  }
}
$m = $M[$Lang]

if ([string]::IsNullOrWhiteSpace($Timezone)) {
  try {
    $Timezone = (Get-TimeZone).Id
    if ($Lang -eq 'en' -and $Timezone) { $Timezone = (Get-TimeZone).Id }
  } catch { $Timezone = 'UTC' }
}

$templateRoot = Join-Path $skillRoot 'assets\templates'
if (-not (Test-Path -LiteralPath $templateRoot)) { throw ($m.noTpl -f $templateRoot) }

$root = [System.IO.Path]::GetFullPath($Vault)
$today = (Get-Date).ToString('yyyy-MM-dd')

if ((Test-Path -LiteralPath $root) -and -not $Force) {
  $existing = @(Get-ChildItem -LiteralPath $root -Filter *.md -File -ErrorAction SilentlyContinue)
  if ($existing.Count -gt 0) {
    throw ($m.exists -f $existing.Count, $root)
  }
}

# 目录布局：写进 config，体检脚本据此识别（中英文版目录名不同）
$layout = if ($Lang -eq 'en') {
  [ordered]@{
    core = '10-core-memory'; projects = '20-projects'; journal = '30-journal'
    weekly = '40-weekly'; library = '50-library'; templates = '90-templates'
    inbox = '99-inbox'; archive = '_archive'; index = '_index.md'; updatedField = 'updated'
  }
} else {
  [ordered]@{
    core = '10-核心记忆'; projects = '20-项目'; journal = '30-每日记录'
    weekly = '40-周复盘'; library = '50-沉淀库'; templates = '90-模板'
    inbox = '99-收件箱'; archive = '_已处理'; index = '_索引.md'; updatedField = '更新'
  }
}

# 建库时要有的空目录（归档目录是空的，模板复制不出来）
$empties = @(
  $layout.core, $layout.projects, $layout.journal, $layout.weekly, $layout.library,
  $layout.templates, $layout.inbox, (Join-Path $layout.inbox $layout.archive), '.memory'
)
foreach ($d in $empties) {
  New-Item -ItemType Directory -Force -Path (Join-Path $root $d) | Out-Null
}

function Expand-Placeholders([string]$text) {
  return $text.Replace('{{OWNER}}', $Owner).Replace('{{VAULT}}', $root).
    Replace('{{DATE}}', $today).Replace('{{TZ}}', $Timezone)
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
$copied = 0
Get-ChildItem -LiteralPath $templateRoot -Recurse -File | ForEach-Object {
  $rel = $_.FullName.Substring($templateRoot.Length).TrimStart('\')
  $rel = $rel -replace '\.tpl$', ''
  $target = Join-Path $root $rel
  $parent = Split-Path -Parent $target
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }
  $text = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
  [System.IO.File]::WriteAllText($target, (Expand-Placeholders $text), $utf8)
  $copied++
}

# 入库配置：让技能和体检脚本能找到库、知道规矩
$config = [ordered]@{
  owner     = $Owner
  vault     = $root
  createdAt = $today
  timezone  = $Timezone
  locale    = if ($Lang -eq 'en') { 'en' } else { 'zh-CN' }
  routine   = if ($Lang -eq 'en') { [ordered]@{ daily = '22:00'; weekly = 'Sunday 22:30' } }
  else { [ordered]@{ daily = '22:00'; weekly = '周日 22:30' } }
  layout    = $layout
  skill     = Split-Path -Leaf $skillRoot
}
$json = $config | ConvertTo-Json -Depth 4
[System.IO.File]::WriteAllText((Join-Path $root '.memory\config.json'), $json, $utf8)

# git：没有身份时补一份**仅本仓库**的身份，避免首次提交失败
$gitState = 'skipped'
if (-not $NoGit) {
  try {
    if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) {
      git -C $root init --quiet 2>&1 | Out-Null
    }
    $mail = git -C $root config user.email 2>$null
    if ([string]::IsNullOrWhiteSpace($mail)) {
      git -C $root config user.email 'memory@local' | Out-Null
      git -C $root config user.name $Owner | Out-Null
    }
    git -C $root add -A 2>&1 | Out-Null
    git -C $root commit -m $m.commit --quiet 2>&1 | Out-Null
    $gitState = 'committed'
  } catch {
    $gitState = "failed: $($_.Exception.Message)"
  }
}

Write-Output "VAULT=$root"
Write-Output "OWNER=$Owner"
Write-Output "LANG=$Lang"
Write-Output "TEMPLATES=$copied"
Write-Output "GIT=$gitState"
Write-Output "NEXT=$($m.next)"
exit 0