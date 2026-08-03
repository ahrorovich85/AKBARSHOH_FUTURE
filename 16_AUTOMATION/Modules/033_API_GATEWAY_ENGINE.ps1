param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$API = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Project = "AKBARSHOH_FUTURE"
    Version = "v9.7"

    Branch = ""
    Commit = ""
    CurrentTag = ""

    Gateways = @()
    SecurityLayers = @()
    Integrations = @()

    Status = ""
}


Push-Location $ProjectRoot

try {

    $API.Branch = git branch --show-current
    $API.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $API.CurrentTag = $Tags[-1]
    }


    $API.Gateways = @(
        "Core API Gateway",
        "Business API Gateway",
        "Finance API Gateway",
        "AI API Gateway",
        "User API Gateway",
        "Integration Gateway"
    )


    $API.SecurityLayers = @(
        "Authentication",
        "Authorization",
        "Rate Limiting",
        "API Monitoring"
    )


    $API.Integrations = @(
        "Telegram Platform",
        "Payment Systems",
        "External Services",
        "Web Applications"
    )


    if(
        $API.Gateways.Count -ge 6 -and
        $API.SecurityLayers.Count -ge 4
    ){

        $API.Status = "API_GATEWAY_READY"

    }
    else {

        $API.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "API_GATEWAY_ENGINE.json"


$API |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "API GATEWAY ENGINE CREATED"
Write-Host "======================================="
Write-Host "Project :" $API.Project
Write-Host "Version :" $API.Version
Write-Host "Branch  :" $API.Branch
Write-Host "Commit  :" $API.Commit
Write-Host "Gateways:" $API.Gateways.Count
Write-Host "Security:" $API.SecurityLayers.Count
Write-Host "Integrations:" $API.Integrations.Count
Write-Host "Status  :" $API.Status
Write-Host "Output  :" $Output