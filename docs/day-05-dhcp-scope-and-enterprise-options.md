# Day 05: DHCP Server Configuration & Enterprise Scope Options

[![Sprint Day](https://img.shields.io/badge/Sprint-Day%2005-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Network%20Automation-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)](../README.md)

---

## 🎯 5.1 Objective
The objective of this phase is to automate IP address management for the **`JASER.LOCAL`** domain by configuring a dedicated DHCP scope and standard enterprise options.

---

## 🔬 5.2 Enterprise Architecture & "The Small Things"

### 1. Scope Provisioning & Options Architecture
- **Scope Provisioning**: Initialized an IPv4 scope (**`192.168.1.0`**) to manage the distribution of dynamic addresses across network endpoints.
- **Option Configuration**: Configured standard DHCP options to streamline client connectivity:
  - **`003 Router`**: Set to **`192.168.1.1`** to provide the default gateway for inter-VLAN routing and Internet egress.
  - **`006 DNS Servers`**: Pointed to the local server **`192.168.10.10`** for domain name resolution and Active Directory authentication.
  - **`015 DNS Domain Name`**: Appended the **`JASER.LOCAL`** suffix to all leased clients to support single-label DNS queries.

### 2. Under the Hood: Active Directory Authorization
- In an Active Directory domain, Windows DHCP servers must be authorized in AD DS before they can service leases. This prevents rogue DHCP servers from hijacking IP allocation on the subnet.
- When an authorized DHCP server responds to a client `DHCP Discover`, it delivers these options within the `DHCP Offer` and `DHCP Ack` frames.

---

## 🛠️ 5.3 Implementation Steps

1. **Role Provisioning**:
   - Install the **DHCP Server** role via Server Manager or PowerShell.
   - Authorize the server in Active Directory using domain credentials.
2. **Scope Creation**:
   - Open **DHCP Manager** (`dhcpmgmt.msc`).
   - Expand `server2019.jaser.local` > Right-click **IPv4** > Select **New Scope...**.
   - Scope: `192.168.1.0`.
3. **Option Configuration**:
   - In Scope Options, configure:
     - **003 Router** -> `192.168.1.1`
     - **006 DNS Servers** -> `192.168.10.10`
     - **015 DNS Domain Name** -> `JASER.LOCAL`
   - Activate the scope.

---

## 📸 5.4 Visual Evidence & UI Artifact Analysis

![DHCP Manager Scope Options](../assets/screenshots/05-dhcp-scope-options.png)

### Deep-Dive Analysis of the Screenshot:
1. **DHCP Console Hierarchy (Left Pane)**:
   - **`server2019.jaser.local`**: Authoritative DHCP server instance.
   - **`IPv4`**: Expanded protocol container.
   - **`Scope [192.168.1.0] Clients`**: Shows the active client subnet scope.
   - Sub-containers visible: *Address Pool, Address Leases, Reservations, Scope Options, Policies*.
   - **`Scope Options`**: Selected and highlighted.
2. **Configured Scope Options Grid (Right Pane)**:
   - **Option 003 (Router)**:
     - `Option Name: 003 Router` | `Vendor: Standard` | `Value: 192.168.1.1` | `Policy Name: None`
     - Proves that dynamic clients will receive `192.168.1.1` as their default gateway.
   - **Option 006 (DNS Servers)**:
     - `Option Name: 006 DNS Servers` | `Vendor: Standard` | `Value: 192.168.10.10` | `Policy Name: None`
     - Proves that all leased clients will resolve domain queries against the Domain Controller `192.168.10.10`.
   - **Option 015 (DNS Domain Name)**:
     - `Option Name: 015 DNS Domain Name` | `Vendor: Standard` | `Value: JASER.LOCAL` | `Policy Name: None`
     - Proves that clients will automatically append the `JASER.LOCAL` search suffix.

---

## ⚡ 5.5 Automated PowerShell Deployment

```powershell
<#
.SYNOPSIS
    Day 05 - Automated DHCP Scope and Options Setup.
#>

$ScopeId = "192.168.1.0"
$ServerIP = "192.168.10.10"

# 1. Authorize in AD
Add-DhcpServerInDC -DnsName "server2019.jaser.local" -IPAddress $ServerIP -ErrorAction SilentlyContinue

# 2. Add Scope
Add-DhcpServerv4Scope -Name "Enterprise Clients" -ScopeId $ScopeId -StartRange "192.168.1.50" -EndRange "192.168.1.200" -SubnetMask "255.255.255.0" -State Active

# 3. Set Options
Set-DhcpServerv4OptionValue -ScopeId $ScopeId -OptionId 3 -Value "192.168.1.1"
Set-DhcpServerv4OptionValue -ScopeId $ScopeId -OptionId 6 -Value $ServerIP
Set-DhcpServerv4OptionValue -ScopeId $ScopeId -OptionId 15 -Value "JASER.LOCAL"
```

---

## 🔍 5.6 Verification & Audit Checklist

| Option Code | Option Display Name | Target Value Configured | Observed in Screenshot | Status |
| :--- | :--- | :--- | :--- | :--- |
| **003** | Router | `192.168.1.1` | `192.168.1.1` | ✅ Verified |
| **006** | DNS Servers | `192.168.10.10` | `192.168.10.10` | ✅ Verified |
| **015** | DNS Domain Name | `JASER.LOCAL` | `JASER.LOCAL` | ✅ Verified |
| **Scope** | `Scope [192.168.1.0]` | Subnet Active | Displayed in console tree | ✅ Verified |
