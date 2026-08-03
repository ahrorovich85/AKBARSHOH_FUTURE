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


$Performance = [ordered]@{
    Generated        = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project          = "AKBARSHOH_FUTURE"
    Branch           = ""
    Commit           = ""
    CurrentTag       = ""
    PerformanceScore = 0
    Status           = ""
    Metrics          = @{}
    Recommendations  = @()
}


Push-Location $ProjectRoot

try {

    $Performance.Branch = git branch --show-current
    $Performance.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Performance.CurrentTag = $Tags[-1]
    }


    $ModuleCount = @(Get-ChildItem $Modules -Filter "*.ps1").Count
    $ReportCount = @(Get-ChildItem $Reports -Filter "*.json").Count
    $ProjectSize = (Get-ChildItem $ProjectRoot -Recurse -File | Measure-Object Length -Sum).Sum


    $Metrics = @{
        Modules = $ModuleCount
        Reports = $ReportCount
        ProjectSizeBytes = $ProjectSize
        GitTags = $Tags.Count
    }


    $Performance.Metrics = $Metrics


    $Score = 100


    if($ProjectSize -gt 50000000){
        $Score -= 20
    }

    if($ModuleCount -gt 100){
        $Score -= 10
    }

    if($ReportCount -gt 200){
        $Score -= 10
    }


    $Performance.PerformanceScore = $Score


    if($Score -ge 90){
        $Performance.Status = "OPTIMAL"
    }
    elseif($Score -ge 70){
        $Performance.Status = "GOOD"
    }
    else {
        $Performance.Status = "OPTIMIZATION_REQUIRED"
    }


    $Performance.Recommendations = @(
        "Keep modules organized",
        "Archive unnecessary reports",
        "Monitor project growth",
        "Optimize heavy processes"
    )


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "PERFORMANCE_OPTIMIZATION.json"


$Performance |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "PERFORMANCE OPTIMIZATION CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Performance.Branch
Write-Host "Commit :" $Performance.Commit
Write-Host "Tag    :" $Performance.CurrentTag
Write-Host "Score  :" $Performance.PerformanceScore
Write-Host "Status :" $Performance.Status
Write-Host "Output :" $Output