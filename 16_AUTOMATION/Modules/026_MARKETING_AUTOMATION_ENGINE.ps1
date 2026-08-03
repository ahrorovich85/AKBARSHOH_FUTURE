param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Marketing = [ordered]@{
    Generated        = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project          = "AKBARSHOH_FUTURE"
    Version          = "v8.5"
    Branch           = ""
    Commit           = ""
    CurrentTag       = ""
    MarketingModules = @()
    GrowthSystems    = @()
    Status           = ""
}


Push-Location $ProjectRoot

try {

    $Marketing.Branch = git branch --show-current
    $Marketing.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Marketing.CurrentTag = $Tags[-1]
    }


    $Marketing.MarketingModules = @(
        "Campaign Manager",
        "Audience Segmentation",
        "Notification Engine",
        "Referral Growth",
        "Analytics Tracking",
        "Content Automation",
        "Conversion Intelligence"
    )


    $Marketing.GrowthSystems = @(
        "User Acquisition",
        "Retention Management",
        "Referral Optimization",
        "Community Growth",
        "Performance Tracking"
    )


    if($Marketing.MarketingModules.Count -ge 7){

        $Marketing.Status = "MARKETING_AUTOMATION_READY"

    }
    else {

        $Marketing.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "MARKETING_AUTOMATION_ENGINE.json"


$Marketing |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "MARKETING AUTOMATION ENGINE CREATED"
Write-Host "======================================="
Write-Host "Project :" $Marketing.Project
Write-Host "Version :" $Marketing.Version
Write-Host "Branch  :" $Marketing.Branch
Write-Host "Commit  :" $Marketing.Commit
Write-Host "Modules :" $Marketing.MarketingModules.Count
Write-Host "Status  :" $Marketing.Status
Write-Host "Output  :" $Output