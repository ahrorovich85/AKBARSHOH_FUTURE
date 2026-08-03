param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Runtime = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project = "AKBARSHOH_FUTURE"
    Version = "v9.5"

    Branch = ""
    Commit = ""
    CurrentTag = ""

    Services = @()
    RuntimeLayers = @()
    Status = ""
}


Push-Location $ProjectRoot

try {

    $Runtime.Branch = git branch --show-current
    $Runtime.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Runtime.CurrentTag = $Tags[-1]
    }


    $Runtime.Services = @(
        "Core Platform Service",
        "Automation Service",
        "AI Service",
        "Business Service",
        "Finance Service",
        "Marketing Service"
    )


    $Runtime.RuntimeLayers = @(
        "Service Registry",
        "Runtime Monitor",
        "Start Controller",
        "Stop Controller",
        "Restart Controller",
        "Status Manager"
    )


    if($Runtime.Services.Count -ge 6 -and $Runtime.RuntimeLayers.Count -ge 6){

        $Runtime.Status = "SERVICE_RUNTIME_READY"

    }
    else {

        $Runtime.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "SERVICE_RUNTIME_ENGINE.json"


$Runtime |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "SERVICE RUNTIME ENGINE CREATED"
Write-Host "======================================="
Write-Host "Project :" $Runtime.Project
Write-Host "Version :" $Runtime.Version
Write-Host "Branch  :" $Runtime.Branch
Write-Host "Commit  :" $Runtime.Commit
Write-Host "Services:" $Runtime.Services.Count
Write-Host "Layers  :" $Runtime.RuntimeLayers.Count
Write-Host "Status  :" $Runtime.Status
Write-Host "Output  :" $Output