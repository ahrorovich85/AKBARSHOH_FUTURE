param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Health = [ordered]@{
    Generated      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project        = "AKBARSHOH_FUTURE"
    Branch         = ""
    Commit         = ""
    CurrentTag     = ""
    HealthScore    = 0
    RiskLevel      = ""
    Checks         = @()
    Recommendation = @()
    Status         = ""
}


Push-Location $ProjectRoot

try {

    $Health.Branch = git branch --show-current
    $Health.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Health.CurrentTag = $Tags[-1]
    }


    $Checks = @(
        @{
            Name = "Git Repository"
            Passed = Test-Path ".git"
        },
        @{
            Name = "Automation Modules"
            Passed = Test-Path "16_AUTOMATION\Modules"
        },
        @{
            Name = "Reports Storage"
            Passed = Test-Path "16_AUTOMATION\Reports"
        },
        @{
            Name = "Version Tags"
            Passed = ($Tags.Count -gt 0)
        }
    )


    $Health.Checks = $Checks


    $Passed = ($Checks | Where-Object {$_.Passed}).Count
    $Total = $Checks.Count


    $Health.HealthScore = [math]::Round(($Passed / $Total) * 100)


    if($Health.HealthScore -eq 100){
        $Health.RiskLevel = "LOW"
        $Health.Status = "HEALTHY"
    }
    elseif($Health.HealthScore -ge 75){
        $Health.RiskLevel = "MEDIUM"
        $Health.Status = "MONITOR"
    }
    else {
        $Health.RiskLevel = "HIGH"
        $Health.Status = "ACTION_REQUIRED"
    }


    $Health.Recommendation = @(
        "Continue automation expansion",
        "Maintain Git version history",
        "Review detected changes regularly"
    )


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AUTONOMOUS_HEALTH_MONITOR.json"


$Health |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AUTONOMOUS HEALTH MONITOR CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Health.Branch
Write-Host "Commit :" $Health.Commit
Write-Host "Tag    :" $Health.CurrentTag
Write-Host "Health :" $Health.HealthScore
Write-Host "Risk   :" $Health.RiskLevel
Write-Host "Status :" $Health.Status
Write-Host "Output :" $Output