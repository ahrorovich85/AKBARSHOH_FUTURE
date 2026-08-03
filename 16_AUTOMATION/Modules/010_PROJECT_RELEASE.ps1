param(
    [string]$AutomationRoot = $(if($PSScriptRoot){Split-Path $PSScriptRoot -Parent}else{Join-Path (Get-Location) "16_AUTOMATION"})
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports     = Join-Path $AutomationRoot "Reports"

$Release = [ordered]@{
    Generated     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Branch        = ""
    Commit        = ""
    Tags          = @()
    LatestTag     = ""
    Commits       = @()
    WorkingTree   = ""
    Reports       = @()
}

Push-Location $ProjectRoot

try{

    $Release.Branch = (git branch --show-current)

    $Release.Commit = (git rev-parse --short HEAD)

    $Release.Tags = @(git tag | Sort-Object)

    if($Release.Tags.Count -gt 0){

        $Release.LatestTag = $Release.Tags[-1]

    }

    $Release.Commits = @(git log --oneline -10)

    $Release.WorkingTree = (git status --short)

}
finally{

    Pop-Location

}

Get-ChildItem $Reports -Filter *.json |
Sort-Object Name |
ForEach-Object{

    $Release.Reports += [PSCustomObject]@{
        Name = $_.Name
        SizeKB = [math]::Round($_.Length/1KB,2)
        Modified = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    }

}

$Release.Summary = [PSCustomObject]@{
    ReportCount = $Release.Reports.Count
    TagCount    = $Release.Tags.Count
    Commit      = $Release.Commit
    LatestTag   = $Release.LatestTag
}

$Output = Join-Path $Reports "PROJECT_RELEASE.json"

$Release |
ConvertTo-Json -Depth 8 |
Set-Content $Output -Encoding UTF8

Write-Host ""
Write-Host "======================================="
Write-Host "PROJECT RELEASE CREATED"
Write-Host "======================================="
Write-Host "Branch   : $($Release.Branch)"
Write-Host "Commit   : $($Release.Commit)"
Write-Host "Tags     : $($Release.Tags.Count)"
Write-Host "Reports  : $($Release.Reports.Count)"
Write-Host "Output   : $Output"