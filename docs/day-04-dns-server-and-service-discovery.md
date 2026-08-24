# Day 04: DNS Management & Active Directory Service Discovery

[![Sprint Day](https://img.shields.io/badge/Sprint-Day%2004-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Network%20Services-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)](../README.md)

---

## 🎯 4.1 Objective
The objective of this phase is to verify the automated installation and health of the **Domain Name System (DNS)**. In an AD DS environment, DNS is required for service discovery and name-to-IP resolution.

---

## 🔬 4.2 Enterprise Architecture & "The Small Things"

### 1. Service Verification & Forward Lookup Zones
- **Service Verification**: Confirmed that the DNS Server role was successfully initialized alongside Active Directory.
- **Zone Management**: Verified the existence of the Forward Lookup Zone for **`JASER.LOCAL`**.
- **Record Validation**: Confirmed that the primary Host (A) record is correctly mapped to the server’s static IP (**`192.168.10.10`**).

### 2. Under the Hood: The AD DS DNS Namespace
- **Active Directory-Integrated Storage**: Zones are stored within the `DomainDnsZones` and `ForestDnsZones` directory partitions, enabling multi-master replication and Kerberos-authenticated dynamic updates.
- **`_msdcs.JASER.LOCAL` Subdomain**: Contains SRV locator records (`_ldap._tcp`, `_kerberos._tcp`, `_kpasswd._tcp`) that allow client machines to discover domain controllers, authenticate tickets, and locate global catalog servers.
- **Apex Host (A) Record (`(same as parent folder)`)**: Maps queries directed to `jaser.local` directly to the DC IP `192.168.10.10`.

---

## 🛠️ 4.3 Implementation Steps

1. **Service Verification**:
   - Open **DNS Manager** (`dnsmgmt.msc`).
   - Expand server node **`SERVER2019`**.
2. **Zone Audit**:
   - Expand **Forward Lookup Zones** > Select **`JASER.LOCAL`**.
3. **Record Validation**:
   - Verified that the Start of Authority (SOA), Name Server (NS), and Host (A) records exist and point to valid targets.

---

## 📸 4.4 Visual Evidence & UI Artifact Analysis

![DNS Manager Forward Lookup Zone and Records](../assets/screenshots/04-dns-manager-records.png)

### Deep-Dive Analysis of the Screenshot:
1. **Console Navigation Tree (Left Pane)**:
   - **`SERVER2019`**: Authoritative DNS server node.
   - **Forward Lookup Zones**: Expanded to show `_msdcs.JASER.LOCAL` and `JASER.LOCAL`.
   - **Service Folders**: Under `JASER.LOCAL`, service subfolders `_msdcs`, `_sites`, `_tcp`, `_udp`, `DomainDnsZones`, and `ForestDnsZones` are clearly visible.
2. **Resource Records Grid (Right Pane)**:
   - **Start of Authority (SOA)**:
     - `Name: (same as parent folder)` | `Type: Start of Authority (SOA)` | `Data: [19], server2019.jaser.local.` | `Timestamp: static`
     - Indicates the zone's serial number is 19 and authoritative primary server is `server2019.jaser.local`.
   - **Name Server (NS)**:
     - `Name: (same as parent folder)` | `Type: Name Server (NS)` | `Data: server2019.jaser.local.` | `Timestamp: static`
   - **Parent Apex Host (A) Record**:
     - `Name: (same as parent folder)` | `Type: Host (A)` | `Data: 192.168.10.10` | `Timestamp: static`
   - **Domain Controller Host (A) Record**:
     - `Name: server2019` | `Type: Host (A)` | `Data: 192.168.10.10` | `Timestamp: static`
     - Validates that `server2019.jaser.local` resolves directly to `192.168.10.10`.

---

## ⚡ 4.5 Automated PowerShell Validation

```powershell
<#
.SYNOPSIS
    Day 04 - Automated DNS Zone Audit and Record Health Validation.
#>

Import-Module DnsServer

$ZoneName = "JASER.LOCAL"
Write-Host "[*] Auditing DNS Forward Lookup Zone: $ZoneName..." -ForegroundColor Yellow

# 1. Query Resource Records
Get-DnsServerResourceRecord -ZoneName $ZoneName | 
    Where-Object { $_.RecordType -in @("SOA", "NS", "A") } | 
    Select-Object HostName, RecordType, @{Name="Data"; Expression={$_.RecordData.IPv4Address.IPAddressToString + $_.RecordData.PrimaryServer}}

# 2. Test Name Resolution
$ApexResult = Resolve-DnsName -Name $ZoneName -Server 127.0.0.1
$HostResult = Resolve-DnsName -Name "server2019.$ZoneName" -Server 127.0.0.1

Write-Host "[+] Domain Apex ($ZoneName) resolves to: $($ApexResult.IPAddress)" -ForegroundColor Green
Write-Host "[+] Host (server2019.$ZoneName) resolves to: $($HostResult.IPAddress)" -ForegroundColor Green
```

---

## 🔍 4.6 Verification & Audit Checklist

| Record Name | Record Type | Target / IP Data | Observed in Screenshot | Status |
| :--- | :--- | :--- | :--- | :--- |
| `(same as parent folder)` | SOA | `[19], server2019.jaser.local.` | Present & Valid | ✅ Verified |
| `(same as parent folder)` | NS | `server2019.jaser.local.` | Present & Valid | ✅ Verified |
| `(same as parent folder)` | Host (A) | `192.168.10.10` | Present & Valid | ✅ Verified |
| `server2019` | Host (A) | `192.168.10.10` | Present & Valid | ✅ Verified |
| `_msdcs` Sub-tree | Delegation/Folder | Service Locator Records | Present & Active | ✅ Verified |
