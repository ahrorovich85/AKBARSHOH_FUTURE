param(
    [string]$AutomationRoot = (Split-Path $PSScriptRoot -Parent)
)

$Reports = Join-Path $AutomationRoot "Reports"

$Required = @(
    "PROJECT_INDEX.json",
    "PROJECT_MEMORY.json",
    "PROJECT_KNOWLEDGE.json",
    "PROJECT_HEALTH.json",
    "PROJECT_SUMMARY.json",
    "PROJECT_CONTEXT.json"
)

$Status = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Reports = @()
    Healthy = $true
}

foreach($Name in $Required){

    $Path = Join-Path $Reports $Name

    $Exists = Test-Path $Path

    $Size = if($Exists){
        (Get-Item $Path).Length
    }else{
        0
    }

    if(-not $Exists){
        $Status.Healthy = $false
    }

    $Status.Reports += [PSCustomObject]@{
        Name   = $Name
        Exists = $Exists
        Size   = $Size
    }
}

$Status.TotalReports = $Status.Reports.Count
$Status.AvailableReports = ($Status.Reports | Where-Object Exists).Count
$Status.MissingReports = ($Status.Reports | Where-Object { -not $_.Exists }).Count

$Out = Join-Path $Reports "PROJECT_STATUS.json"

$Status |
ConvertTo-Json -Depth 5 |
Set-Content $Out -Encoding UTF8

Write-Host ""
Write-Host "======================================="
Write-Host "PROJECT STATUS CREATED"
Write-Host "======================================="
Write-Host "Available : $($Status.AvailableReports)"
Write-Host "Missing   : $($Status.MissingReports)"
Write-Host "Healthy   : $($Status.Healthy)"
Write-Host "Output    : $Out"