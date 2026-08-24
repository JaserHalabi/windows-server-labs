<#
.SYNOPSIS
    Day 09 - Automated Active File Screening Deployment via FSRM.
.DESCRIPTION
    Configures an Active File Screen on C:\CentralStorage to block multimedia files (.mp3, .mp4, .mov, .avi)
    at the kernel filter driver layer (srmfltr.sys).
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$ScreenPath = "C:\CentralStorage",
    [string]$TemplateName = "Block Audio and Video Files"
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 09: Proactive Security via Active File Screening (FSRM)   " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Verify Target Path
if (-not (Test-Path $ScreenPath)) {
    Write-Host "[*] Creating storage directory: $ScreenPath..." -ForegroundColor Yellow
    New-Item -Path $ScreenPath -ItemType Directory -Force | Out-Null
}

# 2. Deploy Active File Screen
Write-Host "[*] Enforcing Active File Screen on '$ScreenPath' using template '$TemplateName'..." -ForegroundColor Yellow

$ExistingScreen = Get-FsrmFileScreen -Path $ScreenPath -ErrorAction SilentlyContinue

if (-not $ExistingScreen) {
    New-FsrmFileScreen `
        -Path $ScreenPath `
        -Template $TemplateName `
        -Active:$true `
        -ErrorAction Stop
    Write-Host "[+] Active File Screen successfully enforced." -ForegroundColor Green
} else {
    Write-Host "[*] Updating existing screen to Active template '$TemplateName'..." -ForegroundColor Yellow
    Set-FsrmFileScreen -Path $ScreenPath -Template $TemplateName -Active:$true
    Write-Host "[+] Active File Screen updated." -ForegroundColor Green
}

# 3. Audit Blocked File Extensions Group
Write-Host "[*] Auditing Blocked Multimedia Extensions Pattern List..." -ForegroundColor Yellow
$FileGroup = Get-FsrmFileGroup -Name "Audio and Video Files" -ErrorAction SilentlyContinue

if ($FileGroup) {
    Write-Host "    [Patterns Blocked]: $($FileGroup.IncludePattern -join ', ')" -ForegroundColor Cyan
}

# 4. Verification Check
$CurrentScreen = Get-FsrmFileScreen -Path $ScreenPath
Write-Host "[*] Policy Verification Check:" -ForegroundColor Yellow
Write-Host "    [Path]         : $($CurrentScreen.Path)" -ForegroundColor Cyan
Write-Host "    [Active Mode]  : $($CurrentScreen.Active)" -ForegroundColor Cyan
Write-Host "    [Groups]       : $($CurrentScreen.IncludeGroup -join ', ')" -ForegroundColor Cyan

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 09 Kernel-Level Storage Defense Successfully Deployed!     " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
