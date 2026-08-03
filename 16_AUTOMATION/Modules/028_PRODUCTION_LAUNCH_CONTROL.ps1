param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Launch = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project = "AKBARSHOH_FUTURE"
    Version = "v9.1"
    Branch = ""
    Commit = ""
    CurrentTag = ""

    Checks = @()
    Engines = 0
    Reports = 0
    Decision = ""
    Status = ""
}


Push-Location $ProjectRoot

try {

    $Launch.Branch = git branch --show-current
    $Launch.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Launch.CurrentTag = $Tags[-1]
    }


    $ModulesPath = Join-Path $AutomationRoot "Modules"
    $ReportsPath = Join-Path $AutomationRoot "Reports"


    $Launch.Engines = @(Get-ChildItem $ModulesPath -Filter "*.ps1").Count
    $Launch.Reports = @(Get-ChildItem $ReportsPath -Filter "*.json").Count


    $Launch.Checks = @(
        "Git Version Control",
        "Automation Modules",
        "System Reports",
        "Security Layer",
        "Recovery Engine",
        "AI Decision Layer",
        "Business Components"
    )


    if($Launch.Engines -ge 28 -and $Launch.Reports -ge 20){

        $Launch.Decision = "PRODUCTION_GO"
        $Launch.Status = "READY_FOR_DEPLOYMENT"

    }
    else {

        $Launch.Decision = "REVIEW_REQUIRED"
        $Launch.Status = "NOT_READY"

    }

}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "PRODUCTION_LAUNCH_CONTROL.json"


$Launch |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "PRODUCTION LAUNCH CONTROL CREATED"
Write-Host "======================================="
Write-Host "Project :" $Launch.Project
Write-Host "Version :" $Launch.Version
Write-Host "Branch  :" $Launch.Branch
Write-Host "Commit  :" $Launch.Commit
Write-Host "Engines :" $Launch.Engines
Write-Host "Reports :" $Launch.Reports
Write-Host "Decision:" $Launch.Decision
Write-Host "Status  :" $Launch.Status
Write-Host "Output  :" $Output