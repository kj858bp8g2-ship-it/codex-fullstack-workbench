[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,
    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $InputPath -PathType Leaf)) {
    throw "Input file does not exist: $InputPath"
}

$inputFile = (Resolve-Path -LiteralPath $InputPath).Path
$outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
if ([string]::Equals($inputFile, $outputFullPath, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'InputPath and OutputPath must be different.'
}

$outputParent = Split-Path -Parent $outputFullPath
if (-not (Test-Path -LiteralPath $outputParent -PathType Container)) {
    throw "Output directory does not exist: $outputParent"
}
if (Test-Path -LiteralPath $outputFullPath) {
    throw "Output file already exists: $outputFullPath"
}

$markitdown = Get-Command markitdown -ErrorAction SilentlyContinue
if ($null -eq $markitdown) {
    throw "MarkItDown was not found. Install it with: pip install 'markitdown[all]'"
}

& $markitdown.Source $inputFile -o $outputFullPath
if ($LASTEXITCODE -ne 0) {
    throw "MarkItDown exited with code $LASTEXITCODE"
}
Write-Host "Converted: $inputFile -> $outputFullPath"
