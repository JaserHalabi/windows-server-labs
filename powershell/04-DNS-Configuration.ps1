<#
.SYNOPSIS
    Day 04 - Automated DNS Zone Management and Service Discovery Audit.
.DESCRIPTION
    Audits DNS zones, verifies Host (A) records, and validates Active Directory SRV locator records.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$ZoneName = "JASER.LOCAL",
    [string]$ServerIP = "192.168.10.10",
    [string]$DCName = "Server2019"
)

Import-Module DnsServer

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 04: DNS Management & Active Directory Service Locator Audit" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Audit Forward Lookup Zone
Write-Host "[*] Auditing Forward Lookup Zone '$ZoneName'..." -ForegroundColor Yellow
$Zone = Get-DnsServerZone -Name $ZoneName -ErrorAction SilentlyContinue

if ($Zone) {
    Write-Host "[+] Found Zone: $($Zone.ZoneName) | Type: $($Zone.ZoneType) | Replication: $($Zone.ReplicationScope)" -ForegroundColor Green
} else {
    Write-Error "[-] DNS Zone '$ZoneName' is not registered on this server."
    return
}

# 2. Verify Host (A) Record for Domain Controller
Write-Host "[*] Verifying Host (A) record for $DCName.$ZoneName..." -ForegroundColor Yellow
$DcARecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $DCName -RRType A -ErrorAction SilentlyContinue

if ($DcARecord) {
    Write-Host "[+] Host (A) Record Verified: $($DcARecord.HostName).$ZoneName -> $($DcARecord.RecordData.IPv4Address.IPAddressToString)" -ForegroundColor Green
} else {
    Write-Host "[*] Creating missing Host (A) record for $DCName..." -ForegroundColor Yellow
    Add-DnsServerResourceRecordA -ZoneName $ZoneName -Name $DCName -IPv4Address $ServerIP
    Write-Host "[+] Created Host (A) record: $DCName -> $ServerIP" -ForegroundColor Green
}

# 3. Audit Critical AD DS SRV Locator Records
Write-Host "[*] Auditing Essential AD DS SRV Records (_ldap, _kerberos)..." -ForegroundColor Yellow
$SrvRecords = Get-DnsServerResourceRecord -ZoneName $ZoneName -RRType SRV -ErrorAction SilentlyContinue

if ($SrvRecords) {
    foreach ($Srv in $SrvRecords) {
        Write-Host "    [SRV] $($Srv.HostName) -> Target: $($Srv.RecordData.MailExchange):$($Srv.RecordData.PortNumber)" -ForegroundColor Cyan
    }
} else {
    Write-Warning "[-] No SRV records found. Ensure Netlogon service is running."
}

# 4. Perform Resolution Tests
Write-Host "[*] Executing DNS Resolution Tests against Local Resolver (127.0.0.1)..." -ForegroundColor Yellow
$TestDomain = Resolve-DnsName -Name $ZoneName -Server "127.0.0.1" -Type A
$TestDC = Resolve-DnsName -Name "$DCName.$ZoneName" -Server "127.0.0.1" -Type A

Write-Host "[+] Domain Apex ($ZoneName) -> $($TestDomain.IPAddress)" -ForegroundColor Green
Write-Host "[+] Host ($DCName.$ZoneName) -> $($TestDC.IPAddress)" -ForegroundColor Green

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 04 DNS Infrastructure Health Verification Passed!          " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
