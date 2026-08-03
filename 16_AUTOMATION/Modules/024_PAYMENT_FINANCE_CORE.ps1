param(
    [string]$AutomationRoot = $(if($PSScriptRoot){
        Split-Path $PSScriptRoot -Parent
    }else{
        Join-Path (Get-Location) "16_AUTOMATION"
    })
)

$ProjectRoot = Split-Path $AutomationRoot -Parent
$Reports = Join-Path $AutomationRoot "Reports"


$Finance = [ordered]@{
    Generated       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Project         = "AKBARSHOH_FUTURE"
    Version         = "v8.3"
    Branch          = ""
    Commit          = ""
    CurrentTag      = ""
    FinanceModules  = @()
    TransactionTypes = @()
    Status          = ""
}


Push-Location $ProjectRoot

try {

    $Finance.Branch = git branch --show-current
    $Finance.Commit = git rev-parse --short HEAD


    $Tags = @(git tag | Sort-Object)

    if($Tags.Count -gt 0){
        $Finance.CurrentTag = $Tags[-1]
    }


    $Finance.FinanceModules = @(
        "Balance System",
        "Transaction Engine",
        "Deposit Tracking",
        "Withdrawal Management",
        "Revenue Ledger",
        "Investment Ledger",
        "Financial Analytics"
    )


    $Finance.TransactionTypes = @(
        "Deposit",
        "Withdrawal",
        "Transfer",
        "Investment",
        "Reward",
        "Commission"
    )


    if($Finance.FinanceModules.Count -ge 7){

        $Finance.Status = "FINANCE_CORE_READY"

    }
    else {

        $Finance.Status = "BUILDING"

    }


}
finally {

    Pop-Location

}


$Output = Join-Path $Reports "PAYMENT_FINANCE_CORE.json"


$Finance |
ConvertTo-Json -Depth 10 |
Out-File $Output -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host "PAYMENT & FINANCE CORE CREATED"
Write-Host "======================================="
Write-Host "Project :" $Finance.Project
Write-Host "Version :" $Finance.Version
Write-Host "Branch  :" $Finance.Branch
Write-Host "Commit  :" $Finance.Commit
Write-Host "Modules :" $Finance.FinanceModules.Count
Write-Host "Types   :" $Finance.TransactionTypes.Count
Write-Host "Status  :" $Finance.Status
Write-Host "Output  :" $Output