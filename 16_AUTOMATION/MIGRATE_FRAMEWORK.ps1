$Root = Join-Path (Get-Location) "16_AUTOMATION"

$Folders = @(
    "Core",
    "Modules",
    "Reports",
    "Logs",
    "Config"
)

foreach($Folder in $Folders){

    New-Item -ItemType Directory -Force `
        -Path (Join-Path $Root $Folder) | Out-Null

}

# ----------------------------
# MOVE SCRIPTS
# ----------------------------

Get-ChildItem $Root -Filter *.ps1 | ForEach-Object{

    if($_.Name -eq "MIGRATE_FRAMEWORK.ps1"){ return }

    Move-Item $_.FullName `
        (Join-Path $Root "Modules\$($_.Name)") `
        -Force

}

# ----------------------------
# MOVE REPORTS
# ----------------------------

Get-ChildItem $Root -Filter *.json | ForEach-Object{

    Move-Item $_.FullName `
        (Join-Path $Root "Reports\$($_.Name)") `
        -Force

}

Write-Host ""
Write-Host "===================================="
Write-Host "FRAMEWORK MIGRATION COMPLETED"
Write-Host "===================================="