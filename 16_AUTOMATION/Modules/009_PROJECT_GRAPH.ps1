param(
    [string]$AutomationRoot = $(if($PSScriptRoot){Split-Path $PSScriptRoot -Parent}else{Join-Path (Get-Location) "16_AUTOMATION"})
)

$Reports = Join-Path $AutomationRoot "Reports"

$DependencyFile = Join-Path $Reports "PROJECT_DEPENDENCY.json"

if(!(Test-Path $DependencyFile)){
    throw "PROJECT_DEPENDENCY.json not found."
}

$Dependency = Get-Content $DependencyFile -Raw | ConvertFrom-Json

$Graph = [ordered]@{
    Generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Nodes = @()
    Edges = @()
}

foreach($Module in $Dependency.Modules){

    $Graph.Nodes += [PSCustomObject]@{
        Id   = $Module.Module
        Type = "Module"
    }

    foreach($Dep in $Module.DependsOn){

        $Graph.Edges += [PSCustomObject]@{
            From = $Module.Module
            To   = $Dep
        }

    }

}

$Graph.Summary = [PSCustomObject]@{
    Nodes = $Graph.Nodes.Count
    Edges = $Graph.Edges.Count
}

$Output = Join-Path $Reports "PROJECT_GRAPH.json"

$Graph |
ConvertTo-Json -Depth 8 |
Set-Content $Output -Encoding UTF8

Write-Host ""
Write-Host "======================================="
Write-Host "PROJECT GRAPH CREATED"
Write-Host "======================================="
Write-Host "Nodes  : $($Graph.Summary.Nodes)"
Write-Host "Edges  : $($Graph.Summary.Edges)"
Write-Host "Output : $Output"