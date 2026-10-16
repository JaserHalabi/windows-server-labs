# Server Pre-Configuration & Static Networking
[![Phase](https://img.shields.io/badge/Phase-Server%20Pre--Configuration-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 1.1 Objective
The goal of this phase is to establish a standardized identity for the server and configure a static network environment.

---

## 🛠️ 1.2 Implementation Steps

- **Hostname Configuration**: Renamed the default Windows hostname to **`Server2019`** to follow enterprise naming standards.
- **Network Configuration**: Opened **Network and Sharing Center** to assign a static IPv4 address:
  - **IP Address**: `192.168.10.10`
  - **Subnet Mask**: `255.255.255.0`
  - **DNS Server**: `127.0.0.1`
- **Time Zone Localization**: Set the system time to the **`(UTC+02:00) Jerusalem`** time zone to ensure accurate timestamping for security logs and Kerberos authentication.

---

## 📸 1.3 Visual Evidence & Verification

![Server Pre-Configuration Verification](../assets/screenshots/01-server-manager-preconfig.png)

### Verification Details from Server Manager:
- **Computer Name**: `Server2019` (Successfully updated from default naming).
- **Workgroup**: `WORKGROUP` (Confirmed standalone host prior to domain promotion).
- **Ethernet**: Static IPv4 `192.168.10.10` assigned with IPv6 enabled.
- **Time Zone**: Localized to `(UTC+02:00) Jerusalem`.
- **Windows Defender Firewall**: Active (`Public: On`).

---

## 📋 1.4 Configuration Summary

| Setting | Configured Value | Verification Status |
| :--- | :--- | :---: |
| **Computer Name** | `Server2019` | ✅ Verified |
| **IPv4 Address** | `192.168.10.10` | ✅ Verified |
| **Subnet Mask** | `255.255.255.0` | ✅ Verified |
| **Preferred DNS Server** | `127.0.0.1` | ✅ Verified |
| **Time Zone** | `(UTC+02:00) Jerusalem` | ✅ Verified |
