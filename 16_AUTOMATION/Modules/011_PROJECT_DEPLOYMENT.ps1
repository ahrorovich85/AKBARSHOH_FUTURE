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
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Branch          = ""
    Commit          = ""
    ReleaseTag      = ""
    Environment     = "Production"
    Checks          = @()
    Status          = ""
    Ready           = $false
}

Push-Location $ProjectRoot

try {

    $Deployment.Branch = git branch --show-current
    $Deployment.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Deployment.ReleaseTag = $Tags[-1]
    }

    $Checks = @(
        @{
            Name = "Git Repository"
            Passed = Test-Path ".git"
        },
        @{
            Name = "Automation Core"
            Passed = Test-Path "16_AUTOMATION"
        },
        @{
            Name = "Reports Directory"
            Passed = Test-Path "16_AUTOMATION\Reports"
        },
        @{
            Name = "Modules Directory"
            Passed = Test-Path "16_AUTOMATION\Modules"
        }
    )

    $Deployment.Checks = $Checks

    $Failed = $Checks | Where-Object {$_.Passed -eq $false}

    if($Failed.Count -eq 0){
        $Deployment.Status = "DEPLOYMENT_READY"
        $Deployment.Ready = $true
    }
    else {
        $Deployment.Status = "BLOCKED"
        $Deployment.Ready = $false
    }

}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "PROJECT_DEPLOYMENT.json"

$Deployment |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "PROJECT DEPLOYMENT CHECK CREATED"
Write-Host "======================================="
Write-Host "Branch  :" $Deployment.Branch
Write-Host "Commit  :" $Deployment.Commit
Write-Host "Release :" $Deployment.ReleaseTag
Write-Host "Status  :" $Deployment.Status
Write-Host "Output  :" $Output