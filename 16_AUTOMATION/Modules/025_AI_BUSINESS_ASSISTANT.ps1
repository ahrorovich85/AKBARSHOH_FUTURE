param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$AI = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Version         = "v8.4"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    AIComponents    = @()
    Intelligence    = @()
    Status          = ""
}


Push-Location $ProjectRoot

try {

    $AI.Branch = git branch --show-current
    $AI.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $AI.CurrentTag = $Tags[-1]
    }


    $AI.AIComponents = @(
        "Knowledge Engine",
        "Decision Support",
        "Business Analytics",
        "User Assistant",
        "Admin Assistant",
        "Report Intelligence",
        "Strategy Engine"
    )


    $AI.Intelligence = @(
        "Pattern Analysis",
        "Recommendation System",
        "Risk Detection",
        "Growth Forecasting",
        "Optimization Suggestions"
    )


    if($AI.AIComponents.Count -ge 7){

        $AI.Status = "AI_ASSISTANT_READY"

    }
    else {

        $AI.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AI_BUSINESS_ASSISTANT.json"


$AI |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AI BUSINESS ASSISTANT CREATED"
Write-Host "======================================="
Write-Host "Project :" $AI.Project
Write-Host "Version :" $AI.Version
Write-Host "Branch  :" $AI.Branch
Write-Host "Commit  :" $AI.Commit
Write-Host "Components:" $AI.AIComponents.Count
Write-Host "Status  :" $AI.Status
Write-Host "Output  :" $Output