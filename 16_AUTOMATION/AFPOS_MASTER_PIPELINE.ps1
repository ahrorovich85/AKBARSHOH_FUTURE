Clear-Host

$Root="E:\AKBARSHOH_FUTURE"

Write-Host ""
Write-Host "======================================="
Write-Host " AFPOS MASTER PIPELINE"
Write-Host "======================================="
Write-Host ""

Write-Host "[1] PROJECT AUDIT"
Write-Host "[2] HEALTH CHECK"
Write-Host "[3] INVENTORY CHECK"
Write-Host "[4] SECURITY CHECK"
Write-Host "[5] BACKUP VERIFY"
Write-Host "[6] RELEASE READY CHECK"

Write-Host ""

$Time=Get-Date

Write-Host "Pipeline Started:"
Write-Host $Time

Write-Host ""

$Files=(Get-ChildItem $Root -Recurse -File).Count
$Folders=(Get-ChildItem $Root -Recurse -Directory).Count

$Branch=git -C $Root branch --show-current
$Commits=git -C $Root rev-list --count HEAD
$Tags=(git -C $Root tag).Count

Write-Host "Project:"
Write-Host $Root

Write-Host ""

Write-Host "Folders:" $Folders
Write-Host "Files:" $Files

Write-Host ""

Write-Host "Git Branch:" $Branch
Write-Host "Commits:" $Commits
Write-Host "Tags:" $Tags

Write-Host ""

Write-Host "======================================="
Write-Host " PIPELINE COMPLETE"
Write-Host "======================================="
