[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
$pluginRoot = Split-Path -Parent $PSScriptRoot
$knowledgeSource = Join-Path $pluginRoot 'assets\knowledge'
$policySource = Join-Path $pluginRoot 'assets\maintenance-policy.json'
$registrySource = Join-Path $pluginRoot 'assets\source-registry.template.json'

if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "ProjectPath does not exist or is not a directory: $ProjectPath"
}

$projectRoot = (Resolve-Path -LiteralPath $ProjectPath).Path
$knowledgeTarget = Join-Path $projectRoot '.codex-workbench\knowledge'
$policyTarget = Join-Path $projectRoot '.codex-workbench\maintenance-policy.json'
$registryTarget = Join-Path $projectRoot '.codex-workbench\source-registry.json'
$plannedWrites = [System.Collections.Generic.List[object]]::new()

Get-ChildItem -LiteralPath $knowledgeSource -File | Sort-Object Name | ForEach-Object {
    $destination = Join-Path $knowledgeTarget $_.Name
    $plannedWrites.Add([pscustomobject]@{
        Action = if (Test-Path -LiteralPath $destination) { 'SKIP_EXISTS' } else { 'CREATE' }
        Source = $_.FullName
        Destination = $destination
    })
}

$plannedWrites.Add([pscustomobject]@{
    Action = if (Test-Path -LiteralPath $policyTarget) { 'SKIP_EXISTS' } else { 'CREATE' }
    Source = $policySource
    Destination = $policyTarget
})
$plannedWrites.Add([pscustomobject]@{
    Action = if (Test-Path -LiteralPath $registryTarget) { 'SKIP_EXISTS' } else { 'CREATE' }
    Source = $registrySource
    Destination = $registryTarget
})

$mode = if ($Apply) { 'APPLY' } else { 'PREVIEW' }
Write-Host "Mode: $mode"
Write-Host "Project: $projectRoot"
$plannedWrites | Format-Table Action, Destination -AutoSize

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
    Copy-Item -LiteralPath $item.Source -Destination $item.Destination
    Write-Host "Initialized: $($item.Destination)"
}

Write-Host 'Knowledge loop initialized. Existing files were never overwritten.'
