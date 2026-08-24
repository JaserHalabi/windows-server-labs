<#
.SYNOPSIS
    Day 02 - Automated AD DS Role Installation and Forest Root Promotion.
.DESCRIPTION
    Installs Active Directory Domain Services binaries and elevates Server2019 to the
    Root Domain Controller for forest JASER.LOCAL.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$DomainName = "JASER.LOCAL",
    [string]$NetbiosName = "JASER",
    [SecureString]$SafeModePassword = (ConvertTo-SecureString "EnterpriseAdmin2026!" -AsPlainText -Force),
    [switch]$NoReboot
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 02: AD DS Binary Deployment & Forest Root Promotion        " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Install AD DS Role & RSAT Administration Tools
Write-Host "[*] Installing Active Directory Domain Services role binaries..." -ForegroundColor Yellow
$InstallResult = Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

if ($InstallResult.Success) {
    Write-Host "[+] AD DS role installed successfully." -ForegroundColor Green
} else {
    Write-Error "[-] Failed to install AD DS role."
    return
}

# 2. Forest Promotion
Write-Host "[*] Promoting server to Root Domain Controller: $DomainName ($NetbiosName)..." -ForegroundColor Yellow
Write-Host "[*] Database Path: C:\Windows\NTDS | SYSVOL Path: C:\Windows\SYSVOL" -ForegroundColor Yellow

Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $SafeModePassword `
    -NoRebootOnCompletion:$NoReboot `
    -Force:$true

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " AD DS Forest Promotion Initialized. Server will reboot.       " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
