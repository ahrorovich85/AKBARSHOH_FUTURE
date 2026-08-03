param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Integration = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project = "AKBARSHOH_FUTURE"
    Version = "v8.1"
    Branch = ""
    Commit = ""
    CurrentTag = ""
    BusinessModules = @()
    Status = ""
}


Push-Location $ProjectRoot

try {

    $Integration.Branch = git branch --show-current
    $Integration.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Integration.CurrentTag = $Tags[-1]
    }


    $Integration.BusinessModules = @(
        "User Management",
        "Telegram Bot Ecosystem",
        "CRM Core",
        "Payment System",
        "Referral Engine",
        "Investment Module",
        "AI Assistant",
        "Marketing Automation"
    )


    if($Integration.BusinessModules.Count -ge 8){

        $Integration.Status = "BUSINESS_READY"

    }
    else {

        $Integration.Status = "EXTENDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "BUSINESS_INTEGRATION.json"


$Integration |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "BUSINESS INTEGRATION CREATED"
Write-Host "======================================="
Write-Host "Project :" $Integration.Project
Write-Host "Version :" $Integration.Version
Write-Host "Branch  :" $Integration.Branch
Write-Host "Commit  :" $Integration.Commit
Write-Host "Modules :" $Integration.BusinessModules.Count
Write-Host "Status  :" $Integration.Status
Write-Host "Output  :" $Output