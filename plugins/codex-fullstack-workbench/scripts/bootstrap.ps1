[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,
    [switch]$InstallSkills,
    [switch]$Apply,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$pluginRoot = Split-Path -Parent $PSScriptRoot
$agentsTemplate = Join-Path $pluginRoot 'assets\AGENTS.template.md'
$assetsSource = Join-Path $pluginRoot 'assets'
$skillsSource = Join-Path $pluginRoot 'skills'

if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "ProjectPath does not exist or is not a directory: $ProjectPath"
}

$projectRoot = (Resolve-Path -LiteralPath $ProjectPath).Path
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmssfff'
$backupRoot = Join-Path $projectRoot ".codex-workbench-backups\$timestamp"
$plannedWrites = [System.Collections.Generic.List[object]]::new()

function Add-PlanItem {
    param(
        [string]$Kind,
        [string]$Source,
        [string]$Destination
    )

    $exists = Test-Path -LiteralPath $Destination
    $action = if (-not $exists) { 'CREATE' } elseif ($Force) { 'BACKUP_AND_REPLACE' } else { 'SKIP_EXISTS' }
    $plannedWrites.Add([pscustomobject]@{
        Action = $action
        Kind = $Kind
        Source = $Source
        Destination = $Destination
    })
}

Add-PlanItem -Kind 'AGENTS' -Source $agentsTemplate -Destination (Join-Path $projectRoot 'AGENTS.md')

if ($InstallSkills) {
    $targetSkillsRoot = Join-Path $projectRoot '.agents\skills'
    Get-ChildItem -LiteralPath $skillsSource -Directory | Sort-Object Name | ForEach-Object {
        Add-PlanItem -Kind 'SKILL' -Source $_.FullName -Destination (Join-Path $targetSkillsRoot $_.Name)
    }

    $targetAssetsRoot = Join-Path $projectRoot '.agents\assets'
    Get-ChildItem -LiteralPath $assetsSource -File | Sort-Object Name | ForEach-Object {
        Add-PlanItem -Kind 'ASSET' -Source $_.FullName -Destination (Join-Path $targetAssetsRoot $_.Name)
    }
}

$mode = if ($Apply) { 'APPLY' } else { 'PREVIEW' }
Write-Host "Mode: $mode"
Write-Host "Project: $projectRoot"
$plannedWrites | Format-Table Action, Kind, Destination -AutoSize

if (-not $Apply) {
    Write-Host 'No files were changed. Re-run with -Apply after reviewing the plan.'
    return
}

foreach ($item in $plannedWrites) {
    if ($item.Action -eq 'SKIP_EXISTS') {
        Write-Host "Skipped existing path: $($item.Destination)"
        continue
    }

    $destinationParent = Split-Path -Parent $item.Destination
    if (-not (Test-Path -LiteralPath $destinationParent)) {
        New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
    }

    if ($item.Action -eq 'BACKUP_AND_REPLACE') {
        $backupPath = switch ($item.Kind) {
            'AGENTS' { Join-Path $backupRoot 'AGENTS.md' }
            'SKILL' { Join-Path (Join-Path $backupRoot 'skills') (Split-Path -Leaf $item.Destination) }
            'ASSET' { Join-Path (Join-Path $backupRoot 'assets') (Split-Path -Leaf $item.Destination) }
        }
        $backupParent = Split-Path -Parent $backupPath
        if (-not (Test-Path -LiteralPath $backupParent)) {
            New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
        }
        Move-Item -LiteralPath $item.Destination -Destination $backupPath
        Write-Host "Backed up: $backupPath"
    }

    if ($item.Kind -eq 'SKILL') {
        Copy-Item -LiteralPath $item.Source -Destination $item.Destination -Recurse
    } else {
        Copy-Item -LiteralPath $item.Source -Destination $item.Destination
    }
    Write-Host "Installed: $($item.Destination)"
}

Write-Host 'Workbench files installed. Start a new Codex task so skill discovery can refresh.'
