param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Recovery = [ordered]@{
    Generated        = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project          = "AKBARSHOH_FUTURE"
    Branch           = ""
    Commit           = ""
    CurrentTag       = ""
    RecoveryPoint    = ""
    Risk             = ""
    Status           = ""
    Actions          = @()
}


Push-Location $ProjectRoot

try {

    $Recovery.Branch = git branch --show-current
    $Recovery.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){

        $Recovery.CurrentTag = $Tags[-1]
        $Recovery.RecoveryPoint = $Tags[-1]

    }


    $Changes = @(git status --short)


    if($Changes.Count -eq 0){

        $Recovery.Risk = "LOW"
        $Recovery.Status = "SAFE_STATE"

    }
    else {

        $Recovery.Risk = "MEDIUM"
        $Recovery.Status = "CHANGES_DETECTED"

    }


    $Recovery.Actions = @(
        "Validate current project state",
        "Keep latest stable tag",
        "Prepare rollback reference",
        "Monitor future changes"
    )


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AUTONOMOUS_RECOVERY.json"


$Recovery |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AUTONOMOUS RECOVERY ENGINE CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Recovery.Branch
Write-Host "Commit :" $Recovery.Commit
Write-Host "Tag    :" $Recovery.CurrentTag
Write-Host "Point  :" $Recovery.RecoveryPoint
Write-Host "Risk   :" $Recovery.Risk
Write-Host "Status :" $Recovery.Status
Write-Host "Output :" $Output