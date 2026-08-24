<#
.SYNOPSIS
    Day 08 - Automated FSRM Installation and 100MB Hard Quota Enforcement.
.DESCRIPTION
    Installs File Server Resource Manager and configures a 100MB Hard Quota on C:\CentralStorage.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$QuotaPath = "C:\CentralStorage",
    [string]$TemplateName = "100 MB Limit"
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 08: File Server Resource Manager (FSRM) Hard Quota Setup   " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Install FSRM Role and RSAT Administration Tools
Write-Host "[*] Installing File Server Resource Manager role feature..." -ForegroundColor Yellow
$InstallState = Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools

if ($InstallState.Success) {
    Write-Host "[+] FSRM feature installed successfully." -ForegroundColor Green
} else {
    Write-Host "[=] FSRM role already present." -ForegroundColor Green
}

# 2. Verify Target Directory Path
if (-not (Test-Path $QuotaPath)) {
    Write-Host "[*] Target directory $QuotaPath not found, creating..." -ForegroundColor Yellow
    New-Item -Path $QuotaPath -ItemType Directory -Force | Out-Null
}

# 3. Apply Hard Quota Policy
Write-Host "[*] Applying 100MB Hard Quota to '$QuotaPath' using template '$TemplateName'..." -ForegroundColor Yellow

$ExistingQuota = Get-FsrmQuota -Path $QuotaPath -ErrorAction SilentlyContinue

if (-not $ExistingQuota) {
    New-FsrmQuota `
        -Path $QuotaPath `
        -Template $TemplateName `
        -ErrorAction Stop
    Write-Host "[+] Hard Quota (100 MB Limit) successfully created on $QuotaPath." -ForegroundColor Green
} else {
    Write-Host "[*] Updating existing quota configuration to template '$TemplateName'..." -ForegroundColor Yellow
    Set-FsrmQuota -Path $QuotaPath -Template $TemplateName
    Write-Host "[+] Existing quota updated to enforce 100MB Hard Limit." -ForegroundColor Green
}

# 4. Display Applied Quota Verification
Write-Host "[*] Verifying Quota Policy Parameters..." -ForegroundColor Yellow
$VerifiedQuota = Get-FsrmQuota -Path $QuotaPath
Write-Host "    [Path]         : $($VerifiedQuota.Path)" -ForegroundColor Cyan
Write-Host "    [Limit]        : $($VerifiedQuota.Size / 1MB) MB" -ForegroundColor Cyan
Write-Host "    [Quota Type]   : $($VerifiedQuota.QuotaType)" -ForegroundColor Cyan
Write-Host "    [Matches Temp] : $($VerifiedQuota.MatchesSourceTemplate)" -ForegroundColor Cyan

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 08 Storage Governance & Quota Hardening Completed!         " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
