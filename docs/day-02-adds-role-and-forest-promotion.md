# Day 02: Active Directory Domain Services (AD DS) Deployment

[![Day 02](https://img.shields.io/badge/Day-02-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-AD%20DS%20Deployment-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 2.1 Objective
The objective of this phase is to install the AD DS role and promote the server to a Domain Controller, creating a new forest to serve as the centralized identity provider for the network.

---

## 🛠️ 2.2 Implementation Steps

- **Role Provisioning**: Navigated to the **Add Roles and Features Wizard** to install the Active Directory Domain Services binary files and management consoles.
- **Forest Promotion**: Initialized the post-deployment configuration by selecting **"Add a new forest"** and defining the Root Domain Name as **`JASER.LOCAL`**.

---

## 📸 2.3 Visual Evidence & Verification

| Role Provisioning (Add Roles and Features Wizard) | Forest Promotion (Deployment Configuration Wizard) |
| :---: | :---: |
| ![AD DS Role Selection](../assets/screenshots/02-adds-role-selection.png) | ![AD DS Forest Promotion](../assets/screenshots/02-adds-forest-promotion.png) |

### Verification Details from Wizards:
- **Add Roles and Features Wizard**:
  - `Active Directory Domain Services` selected in the Server Roles list.
  - Management consoles and required RSAT features automatically staged.
- **AD DS Configuration Wizard**:
  - Operation: **"Add a new forest"** selected.
  - Root Domain Name: **`JASER.LOCAL`** specified.
  - Target Server: **`Server2019`**.

---

## 📋 2.4 Configuration Summary

| Setting | Configured Value | Verification Status |
| :--- | :--- | :---: |
| **Server Role Installed** | Active Directory Domain Services | ✅ Verified |
| **Deployment Mode** | Add a new forest | ✅ Verified |
| **Root Domain Name** | `JASER.LOCAL` | ✅ Verified |
| **Target Server** | `Server2019` | ✅ Verified |
