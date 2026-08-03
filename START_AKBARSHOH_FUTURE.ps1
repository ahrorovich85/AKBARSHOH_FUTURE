Write-Host ""
Write-Host "======================================="
Write-Host " AKBARSHOH FUTURE OS START"
Write-Host "======================================="
Write-Host ""

$Root = Get-Location

Write-Host "[1] Running Health Monitor..."

& ".\16_AUTOMATION\Modules\014_AUTONOMOUS_HEALTH_MONITOR.ps1"

Write-Host ""
Write-Host "[2] Running Production Check..."

& ".\16_AUTOMATION\Modules\028_PRODUCTION_LAUNCH_CONTROL.ps1"

Write-Host ""
Write-Host "[3] System Status"

$Modules = @(Get-ChildItem ".\16_AUTOMATION\Modules\" -Filter "*.ps1").Count
$Reports = @(Get-ChildItem ".\16_AUTOMATION\Reports\" -Filter "*.json").Count

Write-Host "Modules :" $Modules
Write-Host "Reports :" $Reports

Write-Host ""

if($Modules -ge 30 -and $Reports -ge 25){

    Write-Host "STATUS : AKBARSHOH FUTURE OS READY"

}
else{

    Write-Host "STATUS : REVIEW REQUIRED"

}

Write-Host ""

Write-Host "======================================="
Write-Host " START COMPLETE"
Write-Host "======================================="