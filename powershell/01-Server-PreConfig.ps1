<#
.SYNOPSIS
    Day 01 - Automated Host Pre-Configuration & Static Networking Baseline.
.DESCRIPTION
    Renames the local computer to Server2019, configures static IPv4 and loopback DNS,
    and synchronizes system time with the Jerusalem time zone.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$NewComputerName = "Server2019",
    [string]$IPAddress = "192.168.10.10",
    [int]$PrefixLength = 24,
    [string]$DnsServer = "127.0.0.1",
    [string]$TimeZoneId = "Israel Standard Time"
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 01: Host Pre-Configuration & Static Networking Baseline    " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Hostname Standardization
if ($env:COMPUTERNAME -ne $NewComputerName) {
    Write-Host "[*] Standardizing Hostname to '$NewComputerName'..." -ForegroundColor Yellow
    Rename-Computer -NewName $NewComputerName -Force
    Write-Host "[+] Hostname registered. System restart will commit name to registry." -ForegroundColor Green
} else {
    Write-Host "[=] Hostname is already set to '$NewComputerName'." -ForegroundColor Green
}

# 2. Network Configuration
$TargetAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
if ($TargetAdapter) {
    $Alias = $TargetAdapter.Name
    Write-Host "[*] Configuring Static IPv4 on active adapter '$Alias'..." -ForegroundColor Yellow
    
    # Remove existing dynamic/static IPv4 addresses
    Get-NetIPAddress -InterfaceAlias $Alias -AddressFamily IPv4 -ErrorAction SilentlyContinue | 
        Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
    
    # Assign Static IP Address
    New-NetIPAddress -InterfaceAlias $Alias -IPAddress $IPAddress -PrefixLength $PrefixLength -ErrorAction Stop
    
    # Assign Local Loopback DNS
    Set-DnsClientServerAddress -InterfaceAlias $Alias -ServerAddresses $DnsServer -ErrorAction Stop
    Write-Host "[+] IPv4 Address $IPAddress/$PrefixLength assigned with DNS $DnsServer." -ForegroundColor Green
} else {
    Write-Warning "[-] No active network interface detected! Please check virtual NIC connection."
}

# 3. Time Zone Localization (Kerberos Clock Skew Protection)
Write-Host "[*] Synchronizing Time Zone to '$TimeZoneId'..." -ForegroundColor Yellow
try {
    Set-TimeZone -Id $TimeZoneId -ErrorAction Stop
    $CurrentTZ = Get-TimeZone
    Write-Host "[+] Time Zone set to: $($CurrentTZ.DisplayName)" -ForegroundColor Green
} catch {
    Write-Warning "[-] Could not set time zone '$TimeZoneId'. Current: $((Get-TimeZone).DisplayName)"
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 01 Baseline Completed Successfully!                        " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
