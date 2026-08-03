$Root="E:\AKBARSHOH_FUTURE"

$Report="$Root\00_FOUNDATION\BUSINESS_READINESS_REPORT.md"

$Checks=@()

function Add-Check($Name,$Status,$Score)
{
    $script:Checks += [PSCustomObject]@{
        Name=$Name
        Status=$Status
        Score=$Score
    }
}


if(Get-ChildItem "$Root\02_PROJECTS" -Recurse -File -ErrorAction SilentlyContinue)
{
    Add-Check "Projects" "READY" 20
}
else
{
    Add-Check "Projects" "MISSING" 0
}


if(Test-Path "$Root\02_PROJECTS\FOYDAPRO_X\00_PRD")
{
    Add-Check "FOYDAPRO_X PRD" "READY" 20
}
else
{
    Add-Check "FOYDAPRO_X PRD" "MISSING" 0
}


if(Get-ChildItem "$Root\07_FINANCE" -Recurse -File -ErrorAction SilentlyContinue)
{
    Add-Check "Finance" "READY" 15
}
else
{
    Add-Check "Finance" "NEEDS WORK" 5
}


if(Get-ChildItem "$Root\05_BRAND" -Recurse -File -ErrorAction SilentlyContinue)
{
    Add-Check "Brand" "READY" 15
}
else
{
    Add-Check "Brand" "NEEDS WORK" 5
}


if(Get-ChildItem "$Root\08_SECURITY" -Recurse -File -ErrorAction SilentlyContinue)
{
    Add-Check "Security" "READY" 15
}
else
{
    Add-Check "Security" "NEEDS WORK" 5
}


if(Test-Path "$Root\16_AUTOMATION")
{
    Add-Check "Automation" "READY" 15
}
else
{
    Add-Check "Automation" "MISSING" 0
}


$Score=($Checks | Measure-Object Score -Sum).Sum


if($Score -ge 90)
{
    $Level="PRODUCTION READY"
}
elseif($Score -ge 70)
{
    $Level="BUSINESS READY"
}
elseif($Score -ge 50)
{
    $Level="DEVELOPMENT READY"
}
else
{
    $Level="EARLY STAGE"
}


@"
# AFPOS BUSINESS READINESS REPORT

Generated:
$(Get-Date)

==============================

Score:

$Score / 100

Level:

$Level


==============================

Checks:

$(
foreach($C in $Checks)
{
"
$($C.Name)
Status: $($C.Status)
Score: $($C.Score)

"
}
)

==============================

STATUS

COMPLETE

"@ | Set-Content $Report -Encoding UTF8


Write-Host ""
Write-Host "======================================="
Write-Host " AFPOS-031 FIXED"
Write-Host "======================================="
Write-Host ""

foreach($C in $Checks)
{
Write-Host $C.Name "->" $C.Status
}

Write-Host ""

Write-Host "BUSINESS SCORE:" $Score "/100"
Write-Host "LEVEL:" $Level

Write-Host ""

Write-Host "[OK] Report:"
Write-Host $Report
