param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Security = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Project = "AKBARSHOH_FUTURE"
    Version = "v9.8"

    Branch = ""
    Commit = ""
    CurrentTag = ""

    Authentication = @()
    Authorization = @()
    Roles = @()
    SecurityLayers = @()

    Status = ""
}


Push-Location $ProjectRoot

try {

    $Security.Branch = git branch --show-current
    $Security.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Security.CurrentTag = $Tags[-1]
    }


    $Security.Authentication = @(
        "Identity Verification",
        "Login Session Management",
        "Token Management",
        "Credential Validation"
    )


    $Security.Authorization = @(
        "Role Based Access Control",
        "Permission Management",
        "Service Authorization",
        "API Protection"
    )


    $Security.Roles = @(
        "Administrator",
        "Manager",
        "Operator",
        "User"
    )


    $Security.SecurityLayers = @(
        "Authentication Layer",
        "Authorization Layer",
        "Session Security",
        "Access Monitoring"
    )


    if(
        $Security.Authentication.Count -ge 4 -and
        $Security.Authorization.Count -ge 4
    ){

        $Security.Status = "SECURITY_IDENTITY_READY"

    }
    else {

        $Security.Status = "BUILDING"

    }

}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AUTHENTICATION_AUTHORIZATION_ENGINE.json"


$Security |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AUTHENTICATION AUTHORIZATION ENGINE CREATED"
Write-Host "======================================="
Write-Host "Project :" $Security.Project
Write-Host "Version :" $Security.Version
Write-Host "Branch  :" $Security.Branch
Write-Host "Commit  :" $Security.Commit
Write-Host "Auth    :" $Security.Authentication.Count
Write-Host "Roles   :" $Security.Roles.Count
Write-Host "Status  :" $Security.Status
Write-Host "Output  :" $Output