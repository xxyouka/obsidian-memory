<#
.SYNOPSIS
  Memory vault health check (read-only): broken links, missing "updated", daily/weekly gaps, unlisted notes.

.DESCRIPTION
  Prints a report and never edits the vault. Checks the last 7 days by default.
  -Strict exits 1 when anything is wrong, so it can gate a scheduled job.
  Without -Vault, walks up from the current directory looking for .memory/config.json.

  Layout (folder names, index file name, "updated" field) comes from config.json,
  so the same script serves a Chinese vault and an English one.

.EXAMPLE
  pwsh -NoProfile -File check-vault.ps1 -Vault 'D:\记忆库'

.EXAMPLE
  pwsh -NoProfile -File check-vault.ps1 -Days 14 -Strict

.EXAMPLE
  pwsh -NoProfile -File check-vault.ps1 -Json
#>
[CmdletBinding()]
param(
  [string]$Vault = '',
  [int]$Days = 7,
  [switch]$Strict,
  [switch]$Json,
  [ValidateSet('auto', 'zh', 'en')][string]$Lang = 'auto'
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { }

$skillRoot = Split-Path -Parent $PSScriptRoot
if ($Lang -eq 'auto') {
  $Lang = if ((Split-Path -Leaf $skillRoot) -match '-en$') { 'en' } else { 'zh' }
}

$T = @{
  zh = @{
    noVault = '没找到记忆库：请用 -Vault 指定路径，或在库内（有 .memory/config.json）执行。'
    missing = '记忆库不存在：{0}'
    header  = '=== 记忆库体检 · {0} · {1} 篇 ==='
    broken  = '[断链] {0}'
    fm      = '[frontmatter] {0}'
    daily   = '[每日记录缺口 · 最近 {0} 天] {1}'
    weekly  = '[周复盘缺口] {0}'
    index   = '[索引漏登记] {0}'
    ok      = 'SUMMARY 全部通过'
    summary = 'SUMMARY 断链 {0} · frontmatter {1} · 每日缺口 {2} · 周缺口 {3} · 索引 {4}'
    idxItem = '  {0} 未登记进 {1}'
  }
  en = @{
    noVault = 'No vault found: pass -Vault, or run inside a vault that has .memory/config.json.'
    missing = 'Vault not found: {0}'
    header  = '=== Vault check · {0} · {1} files ==='
    broken  = '[Broken links] {0}'
    fm      = '[Frontmatter] {0}'
    daily   = '[Daily gaps · last {0} days] {1}'
    weekly  = '[Weekly gaps] {0}'
    index   = '[Index gaps] {0}'
    ok      = 'SUMMARY all clear'
    summary = 'SUMMARY broken {0} · frontmatter {1} · daily gaps {2} · weekly gaps {3} · index gaps {4}'
    idxItem = '  {0} not listed in {1}'
  }
}
$t = $T[$Lang]

function Find-VaultFromConfig {
  param([string]$Start)
  $dir = [System.IO.Path]::GetFullPath($Start)
  while ($dir) {
    $cfg = Join-Path $dir '.memory\config.json'
    if (Test-Path -LiteralPath $cfg) {
      try { return (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).vault } catch { }
    }
    $parent = Split-Path -Parent $dir
    if (-not $parent -or $parent -eq $dir) { break }
    $dir = $parent
  }
  return $null
}

if ([string]::IsNullOrWhiteSpace($Vault)) {
  $Vault = Find-VaultFromConfig (Get-Location).Path
  if (-not $Vault) { throw $t.noVault }
}
if (-not (Test-Path -LiteralPath $Vault)) { throw ($t.missing -f $Vault) }
$root = (Resolve-Path -LiteralPath $Vault).Path.TrimEnd('\')

# ---- 目录布局：先按语言取默认，再被 config.json 的 layout 覆盖
$lay = if ($Lang -eq 'en') {
  @{
    core = '10-core-memory'; projects = '20-projects'; journal = '30-journal'
    weekly = '40-weekly'; library = '50-library'; templates = '90-templates'
    inbox = '99-inbox'; index = '_index.md'; updatedField = 'updated'
  }
} else {
  @{
    core = '10-核心记忆'; projects = '20-项目'; journal = '30-每日记录'
    weekly = '40-周复盘'; library = '50-沉淀库'; templates = '90-模板'
    inbox = '99-收件箱'; index = '_索引.md'; updatedField = '更新'
  }
}

$cfgPath = Join-Path $root '.memory\config.json'
$cfg = $null
$createdAt = $null
if (Test-Path -LiteralPath $cfgPath) {
  try {
    $cfg = Get-Content -LiteralPath $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($cfg.layout) {
      foreach ($k in @('core', 'projects', 'journal', 'weekly', 'library', 'templates', 'inbox', 'index', 'updatedField')) {
        if ($cfg.layout.PSObject.Properties.Name -contains $k) { $lay[$k] = $cfg.layout.$k }
      }
    }
    if ($cfg.createdAt -match '^\d{4}-\d{2}-\d{2}$') { $createdAt = $cfg.createdAt }
  } catch { }
}

# 不参与检查：Obsidian 配置、git、第三方目录、配置目录、迁移备份
$skipPattern = '\\(\.obsidian|\.git|\.workbuddy-ai|\.memory)(\\|$)|\\assets\\templates(\\|$)|\\05-系统接入\\_备份(\\|$)'

$mdFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File -Filter *.md |
  Where-Object { $_.FullName -notmatch $skipPattern })

function Get-Rel([string]$full) {
  $rel = $full.Substring($root.Length).TrimStart('\')
  return ($rel -replace '\\', '/')
}

# 相对路径（不含 .md）与文件名（不含 .md）两套索引，双链两种写法都能解析
$pathSet = @{}
$nameSet = @{}
foreach ($f in $mdFiles) {
  $rel = Get-Rel $f.FullName
  $noExt = $rel -replace '\.md$', ''
  $pathSet[$noExt.ToLowerInvariant()] = $rel
  $base = ($noExt -replace '.*/', '').ToLowerInvariant()
  $nameSet[$base] = $true
}

$broken = New-Object System.Collections.Generic.List[object]
$missingUpdate = New-Object System.Collections.Generic.List[object]

foreach ($f in $mdFiles) {
  $rel = Get-Rel $f.FullName
  $lines = @(Get-Content -LiteralPath $f.FullName -Encoding UTF8)

  # ---- frontmatter：00-/01- 与五个分区里的笔记必须有 updated 字段
  $needUpdate = ($rel -match '^(00-|01-|10-|20-|30-|40-|50-)')
  if ($needUpdate -and $lines.Count -gt 0 -and $lines[0].Trim() -eq '---') {
    $end = -1
    for ($i = 1; $i -lt [Math]::Min($lines.Count, 20); $i++) {
      if ($lines[$i].Trim() -eq '---') { $end = $i; break }
    }
    $fm = if ($end -gt 0) { $lines[1..($end - 1)] } else { @() }
    $upd = $fm | Where-Object { $_ -match ('^' + [regex]::Escape($lay.updatedField) + '\s*:\s*(\S+)') } | Select-Object -First 1
    if (-not $upd) {
      $missingUpdate.Add([pscustomobject]@{ file = $rel; reason = "missing '$($lay.updatedField)'" })
    } else {
      $val = ($upd -replace ('^' + [regex]::Escape($lay.updatedField) + '\s*:\s*'), '').Trim()
      if ($val -notmatch '^\d{4}-\d{2}-\d{2}$') {
        $missingUpdate.Add([pscustomobject]@{ file = $rel; reason = "'$($lay.updatedField)' is not YYYY-MM-DD: $val" })
      }
    }
  }

  # ---- 双链：跳过代码块与行内代码，避免把文档里的示例当成真链接
  $inFence = $false
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match '^\s*```') { $inFence = -not $inFence; continue }
    if ($inFence) { continue }
    $clean = [regex]::Replace($line, '`[^`]*`', '')
    foreach ($m in [regex]::Matches($clean, '\[\[([^\[\]\|]+?)(\|[^\[\]]*)?\]\]')) {
      $target = $m.Groups[1].Value.Trim()
      $target = $target -replace '#.*$', ''
      $target = ($target -replace '\\', '/').Trim().TrimEnd('/')
      if (-not $target) { continue }
      $key = $target.ToLowerInvariant()
      $base = ($key -replace '.*/', '')
      $ok = $false
      if ($pathSet.ContainsKey($key)) { $ok = $true }
      elseif ($nameSet.ContainsKey($base)) { $ok = $true }
      elseif (Test-Path -LiteralPath (Join-Path $root ($target -replace '/', '\'))) { $ok = $true }
      if (-not $ok) {
        $broken.Add([pscustomobject]@{ file = $rel; line = ($i + 1); link = $target })
      }
    }
  }
}

# ---- 每日记录缺口（从昨天往前数 Days 天；今天没写不算缺；早于建库日不算）
$today = Get-Date
$dailyGaps = New-Object System.Collections.Generic.List[object]
for ($d = 1; $d -le $Days; $d++) {
  $day = $today.AddDays(-$d).ToString('yyyy-MM-dd')
  if ($createdAt -and $day -lt $createdAt) { continue }
  if (-not (Test-Path -LiteralPath (Join-Path $root "$($lay.journal)\$day.md"))) {
    $dailyGaps.Add([pscustomobject]@{ date = $day; reason = 'missing daily note' })
  }
}

# ---- 周复盘缺口（只看已经结束的周：上周及更早）
$weeklyMissing = New-Object System.Collections.Generic.List[object]
for ($w = 1; $w -le 2; $w++) {
  $probe = $today.AddDays(-7 * $w)
  if ($createdAt -and $probe.ToString('yyyy-MM-dd') -lt $createdAt) { continue }
  $isoYear = [System.Globalization.ISOWeek]::GetYear($probe)
  $isoWeek = [System.Globalization.ISOWeek]::GetWeekOfYear($probe)
  $weekKey = '{0}-W{1:D2}' -f $isoYear, $isoWeek
  if (-not (Test-Path -LiteralPath (Join-Path $root "$($lay.weekly)\$weekKey.md"))) {
    $weeklyMissing.Add([pscustomobject]@{ week = $weekKey; reason = 'missing weekly review' })
  }
}

# ---- 索引漏登记：索引里要有指向该篇的双链
$indexGaps = New-Object System.Collections.Generic.List[object]
$dailyIndex = Join-Path $root "$($lay.journal)\$($lay.index)"
if (Test-Path -LiteralPath $dailyIndex) {
  $idxText = Get-Content -LiteralPath $dailyIndex -Raw -Encoding UTF8
  foreach ($f in $mdFiles) {
    $rel = Get-Rel $f.FullName
    if ($rel -notmatch ('^' + [regex]::Escape($lay.journal) + '/(\d{4}-\d{2}-\d{2})\.md$')) { continue }
    $day = $Matches[1]
    if ($idxText -notmatch ('\[\[' + [regex]::Escape($lay.journal) + '/' + [regex]::Escape($day))) {
      $indexGaps.Add([pscustomobject]@{ file = $rel; index = "$($lay.journal)/$($lay.index)" })
    }
  }
}
$weeklyIndex = Join-Path $root "$($lay.weekly)\$($lay.index)"
if (Test-Path -LiteralPath $weeklyIndex) {
  $idxText = Get-Content -LiteralPath $weeklyIndex -Raw -Encoding UTF8
  foreach ($f in $mdFiles) {
    $rel = Get-Rel $f.FullName
    if ($rel -notmatch ('^' + [regex]::Escape($lay.weekly) + '/(\d{4}-W\d{2})\.md$')) { continue }
    $wk = $Matches[1]
    if ($idxText -notmatch ('\[\[' + [regex]::Escape($lay.weekly) + '/' + [regex]::Escape($wk))) {
      $indexGaps.Add([pscustomobject]@{ file = $rel; index = "$($lay.weekly)/$($lay.index)" })
    }
  }
}

$total = $broken.Count + $missingUpdate.Count + $dailyGaps.Count + $weeklyMissing.Count + $indexGaps.Count
$summary = [pscustomobject]@{
  vault       = $root
  checkedAt   = $today.ToString('yyyy-MM-dd HH:mm')
  files       = $mdFiles.Count
  brokenLinks = $broken.Count
  frontmatter = $missingUpdate.Count
  dailyGaps   = $dailyGaps.Count
  weeklyGaps  = $weeklyMissing.Count
  indexGaps   = $indexGaps.Count
  ok          = ($total -eq 0)
}

if ($Json) {
  [pscustomobject]@{
    summary = $summary
    broken  = $broken
    fm      = $missingUpdate
    daily   = $dailyGaps
    weekly  = $weeklyMissing
    indexes = $indexGaps
  } | ConvertTo-Json -Depth 4
} else {
  Write-Output ($t.header -f $summary.checkedAt, $summary.files)

  Write-Output ''
  Write-Output ($t.broken -f $broken.Count)
  $broken | ForEach-Object { Write-Output ('  {0}:{1} -> [[{2}]]' -f $_.file, $_.line, $_.link) }

  Write-Output ''
  Write-Output ($t.fm -f $missingUpdate.Count)
  $missingUpdate | ForEach-Object { Write-Output ('  {0} —— {1}' -f $_.file, $_.reason) }

  Write-Output ''
  Write-Output ($t.daily -f $Days, $dailyGaps.Count)
  $dailyGaps | ForEach-Object { Write-Output ('  {0}' -f $_.date) }

  Write-Output ''
  Write-Output ($t.weekly -f $weeklyMissing.Count)
  $weeklyMissing | ForEach-Object { Write-Output ('  {0}' -f $_.week) }

  Write-Output ''
  Write-Output ($t.index -f $indexGaps.Count)
  $indexGaps | ForEach-Object { Write-Output ($t.idxItem -f $_.file, $_.index) }

  Write-Output ''
  if ($summary.ok) {
    Write-Output $t.ok
  } else {
    Write-Output ($t.summary -f $summary.brokenLinks, $summary.frontmatter,
      $summary.dailyGaps, $summary.weeklyGaps, $summary.indexGaps)
  }
}

if ($Strict -and -not $summary.ok) { exit 1 }
exit 0