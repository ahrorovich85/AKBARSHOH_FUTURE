param(
    [string]$AutomationRoot = (Split-Path $PSScriptRoot -Parent)
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"

$Summary = [ordered]@{
    Project        = Split-Path $ProjectRoot -Leaf
    Generated      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    TotalFiles     = 0
    TotalFolders   = 0
    MarkdownFiles  = 0
    JsonFiles      = 0
    PowerShell     = 0
    ReadmeFiles    = @()
    AIReports      = @()
    LastModified   = ""
}

$Files = Get-ChildItem $ProjectRoot -Recurse -File

$Summary.TotalFiles = $Files.Count
$Summary.TotalFolders = (Get-ChildItem $ProjectRoot -Recurse -Directory).Count
$Summary.MarkdownFiles = ($Files | Where-Object Extension -eq ".md").Count
$Summary.JsonFiles = ($Files | Where-Object Extension -eq ".json").Count
$Summary.PowerShell = ($Files | Where-Object Extension -eq ".ps1").Count

$Summary.ReadmeFiles = $Files |
    Where-Object Name -match "^README" |
    Select-Object -ExpandProperty FullName

$Summary.AIReports = $Files |
    Where-Object {
        $_.Name -match "AI|ORCHESTRATOR|DIGITAL|SIMULATION|BUSINESS|REPORT"
    } |
    Select-Object -ExpandProperty FullName

$Summary.LastModified =
(
    $Files |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
).LastWriteTime

$Summary |
ConvertTo-Json -Depth 5 |
Set-Content (Join-Path $Reports "PROJECT_SUMMARY.json") -Encoding UTF8

Write-Host ""
Write-Host "PROJECT SUMMARY CREATED"
Write-Host "Files      : $($Summary.TotalFiles)"
Write-Host "Folders    : $($Summary.TotalFolders)"
Write-Host "Markdown   : $($Summary.MarkdownFiles)"
Write-Host "JSON       : $($Summary.JsonFiles)"
Write-Host "PowerShell : $($Summary.PowerShell)"