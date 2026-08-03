param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Database = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Project = "AKBARSHOH_FUTURE"
    Version = "v9.6"

    Branch = ""
    Commit = ""
    CurrentTag = ""

    Databases = @()
    DataLayers = @()
    Security = @()
    Status = ""
}


Push-Location $ProjectRoot

try {

    $Database.Branch = git branch --show-current
    $Database.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Database.CurrentTag = $Tags[-1]
    }


    $Database.Databases = @(
        "User Database",
        "Project Database",
        "Finance Database",
        "CRM Database",
        "AI Memory Database",
        "Audit Database"
    )


    $Database.DataLayers = @(
        "Storage Layer",
        "Query Layer",
        "Backup Layer",
        "Migration Layer",
        "Cache Layer",
        "Analytics Layer"
    )


    $Database.Security = @(
        "Access Control",
        "Data Encryption",
        "Backup Protection"
    )


    if(
        $Database.Databases.Count -ge 6 -and
        $Database.DataLayers.Count -ge 6
    ){

        $Database.Status = "DATABASE_RUNTIME_READY"

    }
    else {

        $Database.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "DATABASE_RUNTIME_ENGINE.json"


$Database |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "DATABASE RUNTIME ENGINE CREATED"
Write-Host "======================================="
Write-Host "Project :" $Database.Project
Write-Host "Version :" $Database.Version
Write-Host "Branch  :" $Database.Branch
Write-Host "Commit  :" $Database.Commit
Write-Host "DBs     :" $Database.Databases.Count
Write-Host "Layers  :" $Database.DataLayers.Count
Write-Host "Security:" $Database.Security.Count
Write-Host "Status  :" $Database.Status
Write-Host "Output  :" $Output