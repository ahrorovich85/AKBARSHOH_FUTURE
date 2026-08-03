param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"

$Orchestrator = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    Environment     = "Production"
    Systems         = @()
    Decision        = ""
    ProductionReady = $false
}


Push-Location $ProjectRoot

try {

    $Orchestrator.Branch = git branch --show-current
    $Orchestrator.Commit = git rev-parse --short HEAD

    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Orchestrator.CurrentTag = $Tags[-1]
    }


    $Systems = @(
        @{
            Name = "Automation Core"
            Path = "16_AUTOMATION"
            Status = Test-Path "16_AUTOMATION"
        },
        @{
            Name = "Modules Engine"
            Path = "16_AUTOMATION\Modules"
            Status = Test-Path "16_AUTOMATION\Modules"
        },
        @{
            Name = "Reports Engine"
            Path = "16_AUTOMATION\Reports"
            Status = Test-Path "16_AUTOMATION\Reports"
        },
        @{
            Name = "Git Version Control"
            Path = ".git"
            Status = Test-Path ".git"
        }
    )


    $Orchestrator.Systems = $Systems


    $FailedSystems = $Systems | Where-Object {
        $_.Status -eq $false
    }


    if($FailedSystems.Count -eq 0){

        $Orchestrator.Decision = "PRODUCTION_GO"
        $Orchestrator.ProductionReady = $true

    }
    else {

        $Orchestrator.Decision = "PRODUCTION_BLOCKED"
        $Orchestrator.ProductionReady = $false

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "PRODUCTION_ORCHESTRATOR.json"


$Orchestrator |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "PRODUCTION ORCHESTRATOR CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Orchestrator.Branch
Write-Host "Commit :" $Orchestrator.Commit
Write-Host "Tag    :" $Orchestrator.CurrentTag
Write-Host "Decision:" $Orchestrator.Decision
Write-Host "Output :" $Output