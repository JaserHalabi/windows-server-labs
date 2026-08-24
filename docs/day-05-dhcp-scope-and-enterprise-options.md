# Day 05: DHCP Server Configuration & Enterprise Scope Options

[![Day 05](https://img.shields.io/badge/Day-05-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Network%20Automation-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 5.1 Objective
The objective of this phase is to automate IP address management for the **`JASER.LOCAL`** domain by configuring a dedicated DHCP scope and options.

---

## 🛠️ 5.2 What I Did (Implementation Steps)

1. **Scope Provisioning**:
   - Initialized an IPv4 scope (**`192.168.1.0`**) in the DHCP Management console to manage the dynamic distribution of IP addresses.

2. **Option Configuration**:
   - Configured standard enterprise DHCP options to streamline client network connectivity:
     - **`003 Router`**: Set to **`192.168.1.1`** to provide the default gateway.
     - **`006 DNS Servers`**: Pointed to the local server **`192.168.10.10`** for domain name resolution.
     - **`015 DNS Domain Name`**: Appended the **`JASER.LOCAL`** suffix to all leased clients.

---

## 🧠 5.3 "The Small Things": Technical Rationale & Sysadmin Details

- **Why each DHCP Option is Critical**:
  - **Option 003 (Router)** tells connecting client computers which gateway IP to send non-local packets to.
  - **Option 006 (DNS Servers)** is vital because without pointing dynamically assigned clients to `192.168.10.10`, clients would fail to locate the Domain Controller or authenticate domain logons.
  - **Option 015 (DNS Domain Name)** automatically appends `jaser.local` to unqualified hostname queries (e.g. `ping server2019` resolves to `server2019.jaser.local`).
- **Active Directory DHCP Authorization**:
  Windows Server DHCP instances must be authorized within Active Directory. If an unauthorized DHCP server starts up on the domain network, Windows Server automatically disables the DHCP service listener to protect against rogue DHCP spoofing.

---

## 📸 5.4 Visual Evidence & UI Verification

Below is the verification screenshot from my lab report showing the configured DHCP Scope Options:

![DHCP Server Scope Options Verification](../assets/screenshots/05-dhcp-scope-options.png)

### Breakdown of the Verification Screenshot:
- **Left Pane (DHCP Tree)**:
  - Shows the server instance **`server2019.jaser.local`**.
  - Shows **`IPv4`** expanded to **`Scope [192.168.1.0] Clients`**.
  - Shows **`Scope Options`** selected.
- **Right Pane (Configured Options Grid)**:
  - **`003 Router`** | Vendor: `Standard` | Value: **`192.168.1.1`**
  - **`006 DNS Servers`** | Vendor: `Standard` | Value: **`192.168.10.10`**
  - **`015 DNS Domain Name`** | Vendor: `Standard` | Value: **`JASER.LOCAL`**

---

## 📋 5.5 Verification Summary

| Option Code | Option Display Name | Target Value | Observed in Screenshot | Status |
| :--- | :--- | :--- | :--- | :---: |
| **003** | Router | `192.168.1.1` | `192.168.1.1` | ✅ Verified |
| **006** | DNS Servers | `192.168.10.10` | `192.168.10.10` | ✅ Verified |
| **015** | DNS Domain Name | `JASER.LOCAL` | `JASER.LOCAL` | ✅ Verified |
| **Scope** | Enterprise IPv4 Scope | `192.168.1.0` | `Scope [192.168.1.0]` | ✅ Verified |
