param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Decision = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    Intelligence    = ""
    Decision        = ""
    Priority        = ""
    Recommendations = @()
    ReportsAnalyzed = 0
}


Push-Location $ProjectRoot

try {

    $Decision.Branch = git branch --show-current
    $Decision.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Decision.CurrentTag = $Tags[-1]
    }


    $ReportFiles = @(Get-ChildItem $Reports -Filter "*.json")

    $Decision.ReportsAnalyzed = $ReportFiles.Count


    if($ReportFiles.Count -ge 10){

        $Decision.Intelligence = "HIGH"

        $Decision.Decision = "CONTINUE_AUTONOMOUS_EXPANSION"

        $Decision.Priority = "STRATEGIC"

    }
    elseif($ReportFiles.Count -ge 5){

        $Decision.Intelligence = "MEDIUM"

        $Decision.Decision = "IMPROVE_SYSTEM"

        $Decision.Priority = "NORMAL"

    }
    else {

        $Decision.Intelligence = "LOW"

        $Decision.Decision = "COLLECT_MORE_DATA"

        $Decision.Priority = "INITIAL"

    }


    $Decision.Recommendations = @(
        "Continue automation development",
        "Integrate real business modules",
        "Maintain monitoring cycle",
        "Review strategic priorities"
    )


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AI_DECISION_ENGINE.json"


$Decision |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AI DECISION ENGINE CREATED"
Write-Host "======================================="
Write-Host "Branch  :" $Decision.Branch
Write-Host "Commit  :" $Decision.Commit
Write-Host "Tag     :" $Decision.CurrentTag
Write-Host "Reports :" $Decision.ReportsAnalyzed
Write-Host "Level   :" $Decision.Intelligence
Write-Host "Decision:" $Decision.Decision
Write-Host "Output  :" $Output