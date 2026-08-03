param(
    [string]$AutomationRoot = $(if($PSScriptRoot){Split-Path $PSScriptRoot -Parent}else{Join-Path (Get-Location) "16_AUTOMATION"})
)

$Reports = Join-Path $AutomationRoot "Reports"
$Modules = Join-Path $AutomationRoot "Modules"

$Output = Join-Path $Reports "PROJECT_DEPENDENCY.json"

$Result = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Modules = @()
    Summary = @{}
}

$Files = Get-ChildItem $Modules -Filter *.ps1 | Sort-Object Name

foreach($File in $Files){

    $Text = Get-Content $File.FullName -Raw

    $Depends = @()

    if($Text -match "PROJECT_MEMORY"){ $Depends += "PROJECT_MEMORY.json" }
    if($Text -match "PROJECT_KNOWLEDGE"){ $Depends += "PROJECT_KNOWLEDGE.json" }
    if($Text -match "PROJECT_HEALTH"){ $Depends += "PROJECT_HEALTH.json" }
    if($Text -match "PROJECT_SUMMARY"){ $Depends += "PROJECT_SUMMARY.json" }
    if($Text -match "PROJECT_CONTEXT"){ $Depends += "PROJECT_CONTEXT.json" }
    if($Text -match "PROJECT_STATUS"){ $Depends += "PROJECT_STATUS.json" }

    $Result.Modules += [PSCustomObject]@{
        Module = $File.Name
        DependsOn = ($Depends | Sort-Object -Unique)
        DependencyCount = ($Depends | Sort-Object -Unique).Count
    }

}

$Result.Summary = [PSCustomObject]@{
    TotalModules = $Result.Modules.Count
    TotalDependencies = ($Result.Modules | Measure-Object DependencyCount -Sum).Sum
}

$Result |
ConvertTo-Json -Depth 6 |
Set-Content $Output -Encoding UTF8

Write-Host ""
Write-Host "======================================="
Write-Host "PROJECT DEPENDENCY CREATED"
Write-Host "======================================="
Write-Host "Modules      : $($Result.Summary.TotalModules)"
Write-Host "Dependencies : $($Result.Summary.TotalDependencies)"
Write-Host "Output       : $Output"