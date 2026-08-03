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


$Workflow = [ordered]@{
    Generated     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project       = "AKBARSHOH_FUTURE"
    Branch        = ""
    Commit        = ""
    CurrentTag    = ""
    Pipeline      = @()
    ModulesCount  = 0
    Status        = ""
    Decision      = ""
}


Push-Location $ProjectRoot

try {

    $Workflow.Branch = git branch --show-current
    $Workflow.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Workflow.CurrentTag = $Tags[-1]
    }


    $ModuleFiles = @(Get-ChildItem $Modules -Filter "*.ps1")


    $Workflow.ModulesCount = $ModuleFiles.Count


    $Workflow.Pipeline = @(
        "Project Foundation",
        "Project Graph",
        "Project Release",
        "Project Deployment",
        "Production Orchestrator",
        "Continuous Intelligence",
        "Health Monitor",
        "Recovery Engine",
        "Security Intelligence",
        "Performance Optimization",
        "AI Decision Engine"
    )


    if($Workflow.ModulesCount -ge 19){

        $Workflow.Status = "FULL_PIPELINE_AVAILABLE"
        $Workflow.Decision = "AUTONOMOUS_EXECUTION_READY"

    }
    else {

        $Workflow.Status = "PARTIAL_PIPELINE"
        $Workflow.Decision = "CONTINUE_BUILD"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "AUTONOMOUS_WORKFLOW_ORCHESTRATOR.json"


$Workflow |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "AUTONOMOUS WORKFLOW ORCHESTRATOR CREATED"
Write-Host "======================================="
Write-Host "Branch :" $Workflow.Branch
Write-Host "Commit :" $Workflow.Commit
Write-Host "Tag    :" $Workflow.CurrentTag
Write-Host "Modules:" $Workflow.ModulesCount
Write-Host "Status :" $Workflow.Status
Write-Host "Decision:" $Workflow.Decision
Write-Host "Output :" $Output