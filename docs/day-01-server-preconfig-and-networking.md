# Day 01: Server Pre-Configuration & Static Networking

[![Sprint Day](https://img.shields.io/badge/Sprint-Day%2001-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Host%20Initialization-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)](../README.md)

---

## 🎯 1.1 Objective
The primary objective of Day 01 is to establish a deterministic, enterprise-standard baseline for the host operating system before introducing Active Directory Domain Services (AD DS). This includes enforcing strict naming conventions, static IPv4 addressing, local loopback DNS bindings, and time zone synchronization.

---

## 🔬 1.2 Enterprise Architecture & "The Small Things"

### 1. Hostname Standardization (`Server2019`)
- **The Rationale**: Default Windows installations assign pseudo-random NetBIOS names (e.g., `WIN-49G8K3L0P`). Renaming a server **after** AD DS forest promotion requires updating Kerberos Service Principal Names (SPNs), DNS records, and directory metadata via `netdom computername /add` and `netdom computername /makeprimary`. 
- **Best Practice**: Standardize the server identity *prior* to role provisioning to establish clean initial directory metadata.

### 2. Static IPv4 Addressing & DNS Loopback (`127.0.0.1`)
- **Network Parameters**:
  - **IPv4 Address**: `192.168.10.10`
  - **Subnet Mask**: `255.255.255.0` (`/24`)
  - **Primary DNS**: `127.0.0.1` (IPv4 Loopback)
- **Why `127.0.0.1` is Critical for a Domain Controller**:
  When a server is promoted to a Domain Controller and DNS server, pointing its DNS client to `127.0.0.1` ensures that the server queries its local DNS database directly. If a DC points to an external or dynamic DNS resolver, it suffers from a "chicken-and-egg" resolution loop on startup, leading to delayed Netlogon initialization and transient replication failures.

### 3. Time Zone Localization & Kerberos Authentication
- **Configured Time Zone**: `(UTC+02:00) Jerusalem`
- **Kerberos Clock Skew Tolerance (`MaxClockSkew`)**:
  Active Directory authentication relies on the Kerberos v5 protocol. Kerberos tickets contain encrypted timestamps to prevent replay attacks. By default, the Active Directory Kerberos policy enforces a maximum clock skew tolerance of **5 minutes** (300 seconds). If a domain controller's clock drifts beyond 5 minutes relative to domain members, authentication requests will fail with `KRB_AP_ERR_SKEW` errors.

---

## 🛠️ 1.3 Implementation Steps

### Method 1: Graphical User Interface (GUI)
1. **Hostname Configuration**:
   - Open **Server Manager** > Navigate to **Local Server**.
   - Click the default **Computer Name** link > Select **Change...**.
   - Enter `Server2019` as the Computer Name > Click **OK**.
2. **Static Network Assignment**:
   - Open **Network and Sharing Center** (`ncpa.cpl`).
   - Right-click the primary Ethernet adapter > Select **Properties**.
   - Select **Internet Protocol Version 4 (TCP/IPv4)** > Click **Properties**.
   - Select **Use the following IP address**:
     - IP address: `192.168.10.10`
     - Subnet mask: `255.255.255.0`
     - Preferred DNS server: `127.0.0.1`
   - Click **OK** and close the adapter properties.
3. **Time Zone Synchronization**:
   - Click **Date and Time** in the system tray or Server Manager.
   - Click **Change time zone...** and select `(UTC+02:00) Jerusalem`.
   - Ensure the system time accurately reflects real-world local time.

---

## ⚡ 1.4 Automated PowerShell Deployment

```powershell
<#
.SYNOPSIS
    Day 01 - Automated Host Pre-Configuration & Static Networking Baseline.
.DESCRIPTION
    Renames the local computer, configures static IPv4 and loopback DNS, and sets the timezone.
#>

[CmdletBinding()]
param (
    [string]$NewComputerName = "Server2019",
    [string]$InterfaceAlias = "Ethernet0",
    [string]$IPAddress = "192.168.10.10",
    [int]$PrefixLength = 24,
    [string]$DnsServer = "127.0.0.1",
    [string]$TimeZoneId = "Israel Standard Time"
)

Write-Host "[+] Initializing Day 01 Server Baseline Configuration..." -ForegroundColor Cyan

# 1. Hostname Standardization
if ($env:COMPUTERNAME -ne $NewComputerName) {
    Write-Host "[*] Renaming computer to $NewComputerName..." -ForegroundColor Yellow
    Rename-Computer -NewName $NewComputerName -Force
    Write-Host "[+] Hostname set. A reboot will be required after script completion." -ForegroundColor Green
} else {
    Write-Host "[=] Hostname is already set to $NewComputerName." -ForegroundColor Green
}

# 2. Network Configuration
$TargetAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
if ($TargetAdapter) {
    $Alias = $TargetAdapter.Name
    Write-Host "[*] Configuring Static IP on adapter '$Alias'..." -ForegroundColor Yellow
    
    # Remove existing dynamic/static IPv4 addresses
    Get-NetIPAddress -InterfaceAlias $Alias -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
    
    # Assign Static IP
    New-NetIPAddress -InterfaceAlias $Alias -IPAddress $IPAddress -PrefixLength $PrefixLength
    
    # Assign DNS Loopback
    Set-DnsClientServerAddress -InterfaceAlias $Alias -ServerAddresses $DnsServer
    Write-Host "[+] Network configured: $IPAddress/$PrefixLength with DNS $DnsServer" -ForegroundColor Green
} else {
    Write-Warning "[-] No active network adapter found!"
}

# 3. Time Zone Localization
Write-Host "[*] Setting Time Zone to $TimeZoneId..." -ForegroundColor Yellow
Set-TimeZone -Id $TimeZoneId
Write-Host "[+] Time Zone successfully synchronized to $(Get-TimeZone | Select-Object -ExpandProperty DisplayName)." -ForegroundColor Green
```

---

## 🔍 1.5 Verification & Evidence

### Verification Commands
```powershell
# Verify Hostname and Domain / Workgroup State
Get-ComputerInfo | Select-Object CsName, WindowsProductName, TimeZone

# Verify IP & DNS Configuration
Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetAdapter | Where-Object Status -eq "Up").Name | Select-Object IPAddress, PrefixLength
Get-DnsClientServerAddress -AddressFamily IPv4
```

### Expected Output
```text
CsName     WindowsProductName               TimeZone
------     ------------------               --------
Server2019 Windows Server 2019 Datacenter   (UTC+02:00) Jerusalem

IPAddress      PrefixLength
---------      ------------
192.168.10.10            24

InterfaceAlias               ServerAddresses
--------------               ---------------
Ethernet0                    {127.0.0.1}
```

---

## 📌 1.6 Key Takeaways & Sysadmin Insights
- **Reboot Timing**: The system must be rebooted after renaming so the new NetBIOS name commits to the registry (`HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName`) before AD DS promotion.
- **Loopback Stability**: Using `127.0.0.1` prevents DNS lookups from depending on NIC driver physical link state during boot.
