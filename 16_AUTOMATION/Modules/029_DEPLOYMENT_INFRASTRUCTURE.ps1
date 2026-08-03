param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Deployment = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project = "AKBARSHOH_FUTURE"
    Version = "v9.2"

    Branch = ""
    Commit = ""
    CurrentTag = ""

    InfrastructureLayers = @()
    Environments = @()
    DeploymentSteps = @()

    Status = ""
}


Push-Location $ProjectRoot

try {

    $Deployment.Branch = git branch --show-current
    $Deployment.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Deployment.CurrentTag = $Tags[-1]
    }


    $Deployment.InfrastructureLayers = @(
        "Environment Manager",
        "Configuration Registry",
        "Service Mapping",
        "Deployment Pipeline",
        "Rollback Strategy",
        "Operations Readiness"
    )


    $Deployment.Environments = @(
        "Development",
        "Testing",
        "Production"
    )


    $Deployment.DeploymentSteps = @(
        "Validation",
        "Build",
        "Release",
        "Deploy",
        "Monitor"
    )


    if($Deployment.InfrastructureLayers.Count -ge 6){

        $Deployment.Status = "DEPLOYMENT_INFRASTRUCTURE_READY"

    }
    else {

        $Deployment.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "DEPLOYMENT_INFRASTRUCTURE.json"


$Deployment |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "DEPLOYMENT INFRASTRUCTURE CREATED"
Write-Host "======================================="
Write-Host "Project :" $Deployment.Project
Write-Host "Version :" $Deployment.Version
Write-Host "Branch  :" $Deployment.Branch
Write-Host "Commit  :" $Deployment.Commit
Write-Host "Layers  :" $Deployment.InfrastructureLayers.Count
Write-Host "Status  :" $Deployment.Status
Write-Host "Output  :" $Output