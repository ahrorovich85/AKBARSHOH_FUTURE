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
    Generated      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project        = "AKBARSHOH_FUTURE"
    Branch         = ""
    Commit         = ""
    CurrentTag     = ""
    SecurityScore  = 0
    RiskLevel      = ""
    Checks         = @()
    Recommendations = @()
    Status         = ""
}


Push-Location $ProjectRoot

try {

    $Security.Branch = git branch --show-current
    $Security.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Security.CurrentTag = $Tags[-1]
    }


    $Checks = @(
        @{
            Name = "Git Repository Protection"
            Passed = Test-Path ".git"
        },
        @{
            Name = "Automation Core"
            Passed = Test-Path "16_AUTOMATION"
        },
        @{
            Name = "Modules Security"
            Passed = Test-Path "16_AUTOMATION\Modules"
        },
        @{
            Name = "Reports Integrity"
            Passed = Test-Path "16_AUTOMATION\Reports"
        },
        @{
            Name = "Version Control"
            Passed = ($Tags.Count -gt 0)
        }
    )


    $Security.Checks = $Checks


    $Passed = ($Checks | Where-Object {$_.Passed}).Count
    $Total = $Checks.Count


    $Security.SecurityScore = [math]::Round(($Passed / $Total) * 100)


    if($Security.SecurityScore -ge 90){

        $Security.RiskLevel = "LOW"
        $Security.Status = "SECURE"

    }
    elseif($Security.SecurityScore -ge 70){

        $Security.RiskLevel = "MEDIUM"
        $Security.Status = "MONITOR"

    }
    else {

        $Security.RiskLevel = "HIGH"
        $Security.Status = "ACTION_REQUIRED"

    }


    $Security.Recommendations = @(
        "Maintain regular backups",
        "Protect sensitive configuration files",
        "Review permissions periodically",
        "Keep version history clean"
    )


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "SECURITY_INTELLIGENCE.json"


$Security |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "SECURITY INTELLIGENCE CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Security.Branch
Write-Host "Commit :" $Security.Commit
Write-Host "Tag    :" $Security.CurrentTag
Write-Host "Score  :" $Security.SecurityScore
Write-Host "Risk   :" $Security.RiskLevel
Write-Host "Status :" $Security.Status
Write-Host "Output :" $Output