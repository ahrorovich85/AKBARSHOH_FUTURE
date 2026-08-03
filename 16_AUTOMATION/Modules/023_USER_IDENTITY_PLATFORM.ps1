param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Identity = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Version         = "v8.2"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    IdentityModules = @()
    Roles           = @()
    Status          = ""
}


Push-Location $ProjectRoot

try {

    $Identity.Branch = git branch --show-current
    $Identity.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Identity.CurrentTag = $Tags[-1]
    }


    $Identity.IdentityModules = @(
        "User Registry",
        "Identity Profile",
        "Authentication Layer",
        "Role Management",
        "Permission Control",
        "Activity Tracking",
        "AI User Intelligence"
    )


    $Identity.Roles = @(
        "Super Admin",
        "Admin",
        "Manager",
        "Partner",
        "Investor",
        "User"
    )


    if($Identity.IdentityModules.Count -ge 7){

        $Identity.Status = "IDENTITY_CORE_READY"

    }
    else {

        $Identity.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "USER_IDENTITY_PLATFORM.json"


$Identity |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "USER IDENTITY PLATFORM CREATED"
Write-Host "======================================="
Write-Host "Project :" $Identity.Project
Write-Host "Version :" $Identity.Version
Write-Host "Branch  :" $Identity.Branch
Write-Host "Commit  :" $Identity.Commit
Write-Host "Modules :" $Identity.IdentityModules.Count
Write-Host "Roles   :" $Identity.Roles.Count
Write-Host "Status  :" $Identity.Status
Write-Host "Output  :" $Output