# Day 01: Server Pre-Configuration & Static Networking

[![Day 01](https://img.shields.io/badge/Day-01-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Host%20Pre--Configuration-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 1.1 Objective
The goal of this phase is to establish a standardized identity for the server and configure a static network environment before installing any server roles.

---

## 🛠️ 1.2 What I Did (Implementation Steps)

1. **Hostname Configuration**:
   - Opened **Server Manager** and accessed the **Local Server** properties.
   - Renamed the default Windows hostname from the random string (e.g. `WIN-XXXXX`) to **`Server2019`** to adhere to enterprise naming standards.
   
2. **Network Configuration**:
   - Opened **Network and Sharing Center** (`ncpa.cpl`) and configured the primary network adapter with static IPv4 addressing:
     - **IP Address**: `192.168.10.10`
     - **Subnet Mask**: `255.255.255.0` (`/24`)
     - **DNS Server**: `127.0.0.1` (Local Loopback)

3. **Time Zone Localization**:
   - Configured the system clock to the **`(UTC+02:00) Jerusalem`** time zone to ensure accurate timestamping for security logs and Kerberos authentication.

---

## 🧠 1.3 "The Small Things": Technical Rationale & Sysadmin Details

- **Renaming before Active Directory Promotion**:
  Renaming a Windows server *after* promoting it to a Domain Controller is complex and requires updating Active Directory metadata, Kerberos Service Principal Names (SPNs), and DNS records using `netdom`. Doing this upfront guarantees a clean initial directory tree.
- **Why I used `127.0.0.1` as the DNS Server**:
  A Domain Controller hosts its own DNS database. Pointing the adapter to the loopback address (`127.0.0.1`) ensures that the server can resolve domain records locally during boot, eliminating cold-start DNS isolation and Netlogon service errors.
- **Why Time Zone Localization Matters for Kerberos**:
  Active Directory uses Kerberos v5 for authentication. Kerberos tickets include timestamps to defend against replay attacks, allowing a maximum clock skew of only **5 minutes** (`MaxClockSkew`). Establishing accurate time synchronization ensures domain authentication will function seamlessly.

---

## 📸 1.4 Visual Evidence & UI Verification

Below is the verification screenshot from my lab report showing the completed server baseline:

![Server Pre-Configuration Verification](../assets/screenshots/01-server-manager-preconfig.png)

### Breakdown of the Verification Screenshot:
- **Computer Name (`Server2019`)**: Confirms the server hostname was successfully updated.
- **Workgroup (`WORKGROUP`)**: Proves the machine is currently a standalone server prior to domain controller promotion.
- **Ethernet (`192.168.10.10, IPv6 enabled`)**: Confirms the static IP address assignment on the primary adapter.
- **Time Zone (`(UTC+02:00) Jerusalem`)**: Shows the time zone was correctly localized for Kerberos and logging.
- **Windows Defender Firewall (`Public: On`)**: Confirms firewall protection is active.

---

## 📋 1.5 Verification Summary

| Item Configured | Value / Setting | Status |
| :--- | :--- | :---: |
| **Server Hostname** | `Server2019` | ✅ Verified |
| **Static IPv4 Address** | `192.168.10.10` | ✅ Verified |
| **Subnet Mask** | `255.255.255.0` | ✅ Verified |
| **Preferred DNS Server** | `127.0.0.1` | ✅ Verified |
| **Time Zone** | `(UTC+02:00) Jerusalem` | ✅ Verified |
