[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "ProjectPath does not exist or is not a directory: $ProjectPath"
}

$projectRoot = (Resolve-Path -LiteralPath $ProjectPath).Path
$agentsPath = Join-Path $projectRoot 'AGENTS.md'
$skillsRoot = Join-Path $projectRoot '.agents\skills'
$assetsRoot = Join-Path $projectRoot '.agents\assets'
$failures = [System.Collections.Generic.List[string]]::new()
$expectedSkills = @(
    'setup-workbench',
    'project-onboard',
    'requirements-architecture',
    'frontend-quality',
    'backend-api',
    'database-auth',
    'testing-debugging',
    'security-review',
    'delivery-deploy',
    'context-headroom',
    'document-ingest',
    'daily-toolbox',
    'skill-lifecycle'
)
$requiredAssets = @(
    'capability-routing-policy.json',
    'config.headroom.example.toml',
    'maintenance-policy.json',
    'plugin-profiles.json',
    'source-registry.template.json',
    'skill-profiles.json'
)

if (-not (Test-Path -LiteralPath $agentsPath -PathType Leaf)) {
    $failures.Add("Missing: $agentsPath")
}

$workbenchSkillCount = 0
foreach ($skillName in $expectedSkills) {
    $skillFile = Join-Path (Join-Path $skillsRoot $skillName) 'SKILL.md'
    if (Test-Path -LiteralPath $skillFile -PathType Leaf) {
        $workbenchSkillCount += 1
    } else {
        $failures.Add("Missing: $skillFile")
    }
}

foreach ($assetName in $requiredAssets) {
    $assetPath = Join-Path $assetsRoot $assetName
    if (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
        $failures.Add("Missing: $assetPath")
    }
}

Write-Host "Project: $projectRoot"
Write-Host "Workbench skills present: $workbenchSkillCount/$($expectedSkills.Count)"

if ($failures.Count -gt 0) {
    throw ($failures -join [Environment]::NewLine)
}

Write-Host 'Workbench skills and project assets verified.'
