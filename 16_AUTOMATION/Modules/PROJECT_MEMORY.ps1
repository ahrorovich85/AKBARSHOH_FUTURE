param(
    [string]$ProjectRoot = (Get-Location)
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================="
Write-Host " AKBARSHOH PROJECT MEMORY ENGINE v1.0"
Write-Host "========================================="
Write-Host ""

# Output directory
$OutputDir = Join-Path $ProjectRoot "16_AUTOMATION"

if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
}

$OutputFile = Join-Path $OutputDir "PROJECT_MEMORY.json"

# Folders to ignore
$IgnoreFolders = @(
    "\.git\",
    "\node_modules\",
    "\bin\",
    "\obj\",
    "\dist\",
    "\build\",
    "\PROJECT_DNA\"
)

# Extensions to scan
$Extensions = @(
    "*.md",
    "*.txt",
    "*.json"
)

$Memory = @()

foreach ($Pattern in $Extensions) {

    Write-Host "Scanning $Pattern ..."

    $Files = Get-ChildItem -Path $ProjectRoot -Recurse -File -Filter $Pattern

    foreach ($File in $Files) {

        $Skip = $false

        foreach ($Folder in $IgnoreFolders) {
            if ($File.FullName -like "*$Folder*") {
                $Skip = $true
                break
            }
        }

        if ($Skip) { continue }

        try {

            $Content = Get-Content $File.FullName -Raw -Encoding UTF8

        }
        catch {

            try {
                $Content = Get-Content $File.FullName -Raw
            }
            catch {
                $Content = ""
            }

        }

        if ($Content.Length -gt 10000) {
            $Content = $Content.Substring(0,10000)
        }

        $Hash = (Get-FileHash $File.FullName -Algorithm SHA256).Hash

        $Memory += [PSCustomObject]@{

            Name = $File.Name
            Path = $File.FullName.Replace($ProjectRoot,"").TrimStart("\")
            Extension = $File.Extension
            Size = $File.Length
            LastModified = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
            SHA256 = $Hash
            Preview = $Content

        }

    }

}

$Project = [PSCustomObject]@{

    Project = Split-Path $ProjectRoot -Leaf
    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    TotalFiles = $Memory.Count
    Memory = $Memory

}

$Project |
ConvertTo-Json -Depth 6 |
Set-Content -Encoding UTF8 $OutputFile

Write-Host ""
Write-Host "========================================="
Write-Host "PROJECT MEMORY CREATED"
Write-Host "========================================="
Write-Host "Files Indexed : $($Memory.Count)"
Write-Host "Output        : $OutputFile"
Write-Host "========================================="