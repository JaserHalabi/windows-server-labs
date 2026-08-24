<#
.SYNOPSIS
    Day 05 - Automated DHCP Server Installation, AD Authorization, and Enterprise Scope Configuration.
.DESCRIPTION
    Installs the DHCP role, registers authorization in Active Directory, creates IPv4 Scope 192.168.1.0/24,
    and applies standard enterprise DHCP options (003 Router, 006 DNS, 015 Domain Name).
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$ScopeId = "192.168.1.0",
    [string]$ScopeName = "Enterprise Dynamic Client Scope",
    [string]$StartRange = "192.168.1.50",
    [string]$EndRange = "192.168.1.200",
    [string]$SubnetMask = "255.255.255.0",
    [string]$DefaultGateway = "192.168.1.1",
    [string]$DnsServer = "192.168.10.10",
    [string]$DomainName = "JASER.LOCAL",
    [string]$DnsHostName = "server2019.jaser.local",
    [string]$ServerIP = "192.168.10.10"
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 05: DHCP Server Deployment & Enterprise Options Automation" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Install DHCP Server Feature
Write-Host "[*] Installing DHCP Server role..." -ForegroundColor Yellow
$InstallStatus = Install-WindowsFeature -Name DHCP -IncludeManagementTools

# 2. Authorize in Active Directory (Prevents rogue status shutdown)
Write-Host "[*] Authorizing DHCP Server in Active Directory ($DnsHostName)..." -ForegroundColor Yellow
try {
    Add-DhcpServerInDC -DnsName $DnsHostName -IPAddress $ServerIP -ErrorAction Stop
    Write-Host "[+] DHCP Server authorized in Active Directory." -ForegroundColor Green
} catch {
    Write-Host "[=] DHCP Server authorization already exists or verified: $($_.Exception.Message)" -ForegroundColor Green
}

# 3. Create IPv4 Distribution Scope
Write-Host "[*] Provisioning IPv4 Scope '$ScopeName' ($StartRange - $EndRange)..." -ForegroundColor Yellow
$ExistingScope = Get-DhcpServerv4Scope -ScopeId $ScopeId -ErrorAction SilentlyContinue

if (-not $ExistingScope) {
    Add-DhcpServerv4Scope `
        -Name $ScopeName `
        -ScopeId $ScopeId `
        -StartRange $StartRange `
        -EndRange $EndRange `
        -SubnetMask $SubnetMask `
        -State Active `
        -LeaseDuration (New-TimeSpan -Days 8) `
        -Description "Corporate Dynamic Addressing Pool"
    Write-Host "[+] Scope $ScopeId created and activated." -ForegroundColor Green
} else {
    Write-Host "[=] Scope $ScopeId already exists." -ForegroundColor Green
}

# 4. Configure Standard Enterprise DHCP Options
Write-Host "[*] Setting Enterprise DHCP Scope Options..." -ForegroundColor Yellow

# Option 003: Router (Default Gateway)
Set-DhcpServerv4OptionValue -ScopeId $ScopeId -OptionId 3 -Value $DefaultGateway
Write-Host "    [Option 003] Default Gateway -> $DefaultGateway" -ForegroundColor Cyan

# Option 006: DNS Servers
Set-DhcpServerv4OptionValue -ScopeId $ScopeId -OptionId 6 -Value $DnsServer
Write-Host "    [Option 006] DNS Server      -> $DnsServer" -ForegroundColor Cyan

# Option 015: Domain Name Suffix
Set-DhcpServerv4OptionValue -ScopeId $ScopeId -OptionId 15 -Value $DomainName
Write-Host "    [Option 015] Domain Name     -> $DomainName" -ForegroundColor Cyan

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 05 DHCP Server Automation Completed Successfully!         " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
