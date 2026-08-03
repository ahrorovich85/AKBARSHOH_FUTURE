param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"
$Modules = Join-Path $AutomationRoot "Modules"


$Platform = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Version         = "v8.0"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    Engines         = 0
    Reports         = 0
    Tags            = 0
    Status          = ""
    Architecture    = @()
}


Push-Location $ProjectRoot

try {

    $Platform.Branch = git branch --show-current
    $Platform.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Platform.CurrentTag = $Tags[-1]
    }


    $Platform.Engines = @(Get-ChildItem $Modules -Filter "*.ps1").Count
    $Platform.Reports = @(Get-ChildItem $Reports -Filter "*.json").Count
    $Platform.Tags = $Tags.Count


    $Platform.Architecture = @(
        "Automation Foundation",
        "Project Intelligence",
        "Release Management",
        "Deployment Automation",
        "Production Control",
        "Continuous Intelligence",
        "Autonomous Monitoring",
        "Recovery System",
        "Security Layer",
        "Performance Layer",
        "AI Decision Layer",
        "Workflow Orchestration",
        "Enterprise Control"
    )


    if($Platform.Engines -ge 20 -and $Platform.Reports -ge 15){

        $Platform.Status = "INTEGRATED_AUTONOMOUS_PLATFORM_READY"

    }
    else {

        $Platform.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "INTEGRATED_AUTONOMOUS_PLATFORM.json"


$Platform |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "INTEGRATED AUTONOMOUS PLATFORM CREATED"
Write-Host "======================================="
Write-Host "Project :" $Platform.Project
Write-Host "Version :" $Platform.Version
Write-Host "Branch  :" $Platform.Branch
Write-Host "Commit  :" $Platform.Commit
Write-Host "Engines :" $Platform.Engines
Write-Host "Reports :" $Platform.Reports
Write-Host "Status  :" $Platform.Status
Write-Host "Output  :" $Output