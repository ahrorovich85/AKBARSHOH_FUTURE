param(
    [string]$AutomationRoot = (Split-Path $PSScriptRoot -Parent)
)

$Reports = Join-Path $AutomationRoot "Reports"

$SummaryFile   = Join-Path $Reports "PROJECT_SUMMARY.json"
$KnowledgeFile = Join-Path $Reports "PROJECT_KNOWLEDGE.json"
$HealthFile    = Join-Path $Reports "PROJECT_HEALTH.json"

if(!(Test-Path $SummaryFile)){ throw "PROJECT_SUMMARY.json not found." }
if(!(Test-Path $KnowledgeFile)){ throw "PROJECT_KNOWLEDGE.json not found." }
if(!(Test-Path $HealthFile)){ throw "PROJECT_HEALTH.json not found." }

$Summary   = Get-Content $SummaryFile   -Raw | ConvertFrom-Json
$Knowledge = Get-Content $KnowledgeFile -Raw | ConvertFrom-Json
$Health    = Get-Content $HealthFile    -Raw | ConvertFrom-Json

$Context = [ordered]@{

    Project = $Summary.Project
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Statistics = [ordered]@{
        Files       = $Summary.TotalFiles
        Folders     = $Summary.TotalFolders
        Markdown    = $Summary.MarkdownFiles
        Json        = $Summary.JsonFiles
        PowerShell  = $Summary.PowerShell
    }

    Versions = $Knowledge.Versions

    AIReports = $Knowledge.AIReports

    TelegramModules = $Knowledge.Telegram

    ApiFiles = $Knowledge.Api

    Health = $Health.Summary

    ImportantReports = @(
        "PROJECT_INDEX.json",
        "PROJECT_MEMORY.json",
        "PROJECT_KNOWLEDGE.json",
        "PROJECT_HEALTH.json",
        "PROJECT_SUMMARY.json"
    )

    NextModules = @(
        "PROJECT_STATUS",
        "PROJECT_DEPENDENCY",
        "PROJECT_RELEASE",
        "PROJECT_DASHBOARD"
    )

}

$Out = Join-Path $Reports "PROJECT_CONTEXT.json"

$Context |
ConvertTo-Json -Depth 8 |
Set-Content $Out -Encoding UTF8

Write-Host ""
Write-Host "======================================="
Write-Host "PROJECT CONTEXT CREATED"
Write-Host "======================================="
Write-Host "Project : $($Context.Project)"
Write-Host "Files   : $($Context.Statistics.Files)"
Write-Host "Reports : $($Context.ImportantReports.Count)"
Write-Host "Output  : $Out"