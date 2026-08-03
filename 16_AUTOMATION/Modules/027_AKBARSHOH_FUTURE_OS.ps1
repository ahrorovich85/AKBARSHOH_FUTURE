param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$OS = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project = "AKBARSHOH_FUTURE"
    Version = "v9.0"
    Branch = ""
    Commit = ""
    CurrentTag = ""

    Systems = @()
    Engines = 0
    Reports = 0
    Status = ""
}


Push-Location $ProjectRoot

try {

    $OS.Branch = git branch --show-current
    $OS.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $OS.CurrentTag = $Tags[-1]
    }


    $ModulesPath = Join-Path $AutomationRoot "Modules"
    $ReportsPath = Join-Path $AutomationRoot "Reports"


    $OS.Engines = @(Get-ChildItem $ModulesPath -Filter "*.ps1").Count
    $OS.Reports = @(Get-ChildItem $ReportsPath -Filter "*.json").Count


    $OS.Systems = @(
        "Autonomous Core",
        "Business Integration",
        "User Identity",
        "Payment Finance",
        "AI Business Intelligence",
        "Marketing Automation",
        "Security Management",
        "Recovery Management",
        "Workflow Orchestration",
        "Enterprise Control"
    )


    if($OS.Engines -ge 25 -and $OS.Reports -ge 20){

        $OS.Status = "AKBARSHOH_FUTURE_OS_READY"

    }
    else {

        $OS.Status = "EXPANDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AKBARSHOH_FUTURE_OS.json"


$OS |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AKBARSHOH FUTURE OS CREATED"
Write-Host "======================================="
Write-Host "Project :" $OS.Project
Write-Host "Version :" $OS.Version
Write-Host "Branch  :" $OS.Branch
Write-Host "Commit  :" $OS.Commit
Write-Host "Engines :" $OS.Engines
Write-Host "Reports :" $OS.Reports
Write-Host "Status  :" $OS.Status
Write-Host "Output  :" $Output