<#
.SYNOPSIS
    Creates a new Azure Monitoring Kit module from a template.

.DESCRIPTION
    - Replaces hyphens in the module name with spaces
    - Capitalises each word for display name
    - Copies template folder structure
    - Updates placeholders in README, .psm1, and Terraform files
    - Ensures template exists (auto-creates if missing)
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ModuleName
)

# --- Paths ---
$ScriptRoot     = $PSScriptRoot
$TemplateFolder = Join-Path $ScriptRoot "_template-module"
$TargetFolder   = Join-Path $ScriptRoot $ModuleName

# --- Ensure template exists ---
if (-not (Test-Path $TemplateFolder)) {
    Write-Warning "Template folder not found. Creating a minimal template at: $TemplateFolder"
    New-Item -ItemType Directory -Path $TemplateFolder | Out-Null

    # Minimal placeholder files
    Set-Content -Path (Join-Path $TemplateFolder "README.md") "# Module Template`n`nDescribe your module here."
    Set-Content -Path (Join-Path $TemplateFolder "module.psm1") "# PowerShell module code goes here"
    Set-Content -Path (Join-Path $TemplateFolder "main.tf") "# Terraform for <module-name>`n"
    New-Item -ItemType Directory -Path (Join-Path $TemplateFolder "tests") | Out-Null
}

# --- Prepare display name ---
$DisplayName = (
    ($ModuleName -replace '-', ' ') -split ' ' |
    ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }
) -join ' '

# --- Create target folder ---
if (Test-Path $TargetFolder) {
    Write-Error "Target module folder already exists: $TargetFolder"
    exit 1
}
Copy-Item -Path $TemplateFolder -Destination $TargetFolder -Recurse

# --- Update README ---
$ReadmePath = Join-Path $TargetFolder "README.md"
if (Test-Path $ReadmePath) {
    (Get-Content $ReadmePath) -replace "Module Template", $DisplayName |
        Set-Content $ReadmePath
}

# --- Update module manifest or .psm1 ---
$Psm1Path = Join-Path $TargetFolder "$ModuleName.psm1"
if (Test-Path $Psm1Path) {
    (Get-Content $Psm1Path) -replace "Module Template", $DisplayName |
        Set-Content $Psm1Path
}

# --- Replace <module-name> in Terraform files ---
Get-ChildItem -Path $TargetFolder -Recurse -Include *.tf |
    ForEach-Object {
        (Get-Content $_.FullName) -replace "<module-name>", $ModuleName |
            Set-Content $_.FullName
    }

Write-Host "✅ Module '$DisplayName' created at: $TargetFolder" -ForegroundColor Green
Write-Host "   All <module-name> placeholders in .tf files replaced with '$ModuleName'" -ForegroundColor Yellow
