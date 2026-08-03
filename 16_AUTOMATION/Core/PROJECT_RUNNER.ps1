param(
    [string]$AutomationRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Continue"

$Modules = Join-Path $AutomationRoot "Modules"
$Logs    = Join-Path $AutomationRoot "Logs"

New-Item -ItemType Directory -Force -Path $Logs | Out-Null

$Log = Join-Path $Logs ("RUN_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log")

function Log($Text){

    $Line = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"),$Text

    Write-Host $Line

    Add-Content $Log $Line

}

Log "========================================"
Log "AFPOS AUTOMATION FRAMEWORK"
Log "========================================"

$Files = Get-ChildItem $Modules -Filter *.ps1 | Sort-Object Name

$Success = 0
$Failed = 0

foreach($File in $Files){

    $Start = Get-Date

    Log "Running $($File.Name)"

    try{

        & $File.FullName

        $Seconds = [math]::Round(((Get-Date)-$Start).TotalSeconds,2)

        Log "SUCCESS ($Seconds sec)"

        $Success++

    }
    catch{

        Log "FAILED"

        Log $_.Exception.Message

        $Failed++

    }

}

Log "========================================"

Log "Successful : $Success"

Log "Failed     : $Failed"

Log "========================================"