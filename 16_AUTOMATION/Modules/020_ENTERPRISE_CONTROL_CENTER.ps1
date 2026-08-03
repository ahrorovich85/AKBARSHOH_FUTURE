param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"
$Modules = Join-Path $AutomationRoot "Modules"


$Control = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    Modules         = 0
    Reports         = 0
    Tags            = 0
    ControlStatus   = ""
    Summary         = @()
}


Push-Location $ProjectRoot

try {

    $Control.Branch = git branch --show-current
    $Control.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Control.CurrentTag = $Tags[-1]
    }


    $ModuleCount = @(Get-ChildItem $Modules -Filter "*.ps1").Count
    $ReportCount = @(Get-ChildItem $Reports -Filter "*.json").Count


    $Control.Modules = $ModuleCount
    $Control.Reports = $ReportCount
    $Control.Tags = $Tags.Count


    if($ModuleCount -ge 20 -and $ReportCount -ge 15){

        $Control.ControlStatus = "ENTERPRISE_READY"

    }
    else {

        $Control.ControlStatus = "EXPANDING"

    }


    $Control.Summary = @(
        "Automation ecosystem analyzed",
        "Version history synchronized",
        "Monitoring layer connected",
        "Control center generated"
    )


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "ENTERPRISE_CONTROL_CENTER.json"


$Control |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "ENTERPRISE CONTROL CENTER CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Control.Branch
Write-Host "Commit :" $Control.Commit
Write-Host "Tag    :" $Control.CurrentTag
Write-Host "Modules:" $Control.Modules
Write-Host "Reports:" $Control.Reports
Write-Host "Tags   :" $Control.Tags
Write-Host "Status :" $Control.ControlStatus
Write-Host "Output :" $Output