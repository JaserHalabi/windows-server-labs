# Day 04: DNS Management & Service Discovery

[![Day 04](https://img.shields.io/badge/Day-04-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Network%20Services-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 4.1 Objective
The objective of this phase is to verify the automated installation and health of the **Domain Name System (DNS)**. In an AD DS environment, DNS is required for service discovery and name-to-IP resolution.

---

## 🛠️ 4.2 What I Did (Implementation Steps)

1. **Service Verification**:
   - Confirmed that the DNS Server role was successfully initialized alongside Active Directory Domain Services.
   
2. **Zone Management**:
   - Opened **DNS Manager** (`dnsmgmt.msc`) under `SERVER2019`.
   - Verified the existence of the Forward Lookup Zone for **`JASER.LOCAL`**.

3. **Record Validation**:
   - Confirmed that the primary Host (A) record is correctly mapped to the server’s static IP (**`192.168.10.10`**).
   - Validated the Start of Authority (SOA) and Name Server (NS) records.

---

## 🧠 4.3 "The Small Things": Technical Rationale & Sysadmin Details

- **Why DNS is Essential for Active Directory**:
  In a Windows domain, DNS does more than translate hostnames to IPs. Active Directory relies on **SRV (Service) locator records** stored inside the `_msdcs.JASER.LOCAL` subfolder to help client workstations discover Domain Controllers running LDAP (port 389) and Kerberos KDC (port 88).
- **Active Directory-Integrated Forward Lookup Zone**:
  The `JASER.LOCAL` zone is stored directly within Active Directory, enabling secure dynamic updates (only authenticated domain members can register their IP addresses) and multi-master replication.
- **Apex Host (A) Record (`(same as parent folder)`)**:
  This record ensures that any client querying the base domain name `jaser.local` directly resolves to `192.168.10.10`.

---

## 📸 4.4 Visual Evidence & UI Verification

Below is the verification screenshot from my lab report showing the DNS Manager console and configured records:

![DNS Manager Records Verification](../assets/screenshots/04-dns-manager-records.png)

### Breakdown of the Verification Screenshot:
- **Left Pane (Console Tree)**:
  - Shows server node **`SERVER2019`**.
  - Shows **Forward Lookup Zones** expanded to `_msdcs.JASER.LOCAL` and `JASER.LOCAL`.
  - Under `JASER.LOCAL`, service subfolders `_msdcs`, `_sites`, `_tcp`, `_udp`, `DomainDnsZones`, and `ForestDnsZones` are visible.
- **Right Pane (Record Details)**:
  - **Start of Authority (SOA)**: `[19], server2019.jaser.local.` (Serial number: 19, Primary server: `server2019.jaser.local`).
  - **Name Server (NS)**: `server2019.jaser.local.`.
  - **Host (A) Record `(same as parent folder)`**: Points to static IP `192.168.10.10`.
  - **Host (A) Record `server2019`**: Points to static IP `192.168.10.10`.

---

## 📋 4.5 Verification Summary

| Record Name | Type | Configured Data | Observed in Screenshot | Status |
| :--- | :--- | :--- | :--- | :---: |
| `(same as parent folder)` | Start of Authority (SOA) | `[19], server2019.jaser.local.` | `[19], server2019.jaser.local.` | ✅ Verified |
| `(same as parent folder)` | Name Server (NS) | `server2019.jaser.local.` | `server2019.jaser.local.` | ✅ Verified |
| `(same as parent folder)` | Host (A) | `192.168.10.10` | `192.168.10.10` | ✅ Verified |
| `server2019` | Host (A) | `192.168.10.10` | `192.168.10.10` | ✅ Verified |
| `_msdcs.JASER.LOCAL` | Sub-Zone / Folders | Service Locators | Present & Healthy | ✅ Verified |
