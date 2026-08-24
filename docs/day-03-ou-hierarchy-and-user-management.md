# Day 03: Organizational Unit (OU) & User Management

[![Day 03](https://img.shields.io/badge/Day-03-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-OU%20%26%20User%20Management-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 3.1 Objective
To design a logical hierarchy that reflects a corporate structure, allowing for granular management of users, computers, and Group Policy Objects (GPOs).

---

## 🛠️ 3.2 Implementation Steps

- **Root OU Creation**: Established a top-level OU titled **`Jaser-Enterprise`** to separate corporate objects from default system containers.
- **Departmental Segmentation**: Created sub-OUs for **`IT`**, **`Sales`**, and **`HR`** to mirror a standard corporate business model.
- **User Provisioning**: Populated the `IT` OU with initial user accounts applying enterprise naming conventions and security protocols:
  - **`Jaser Al. Halabi`** (User)
  - **`Reem Abu. Shamma`** (User)

---

## 📸 3.3 Visual Evidence & Verification

![Active Directory Users and Computers Hierarchy](../assets/screenshots/03-active-directory-users-and-ous.png)

### Verification Details from Active Directory Users and Computers:
- **Left Directory Tree**:
  - Shows top-level root OU **`Jaser-Enterprise`** under domain `JASER.LOCAL`.
  - Shows sub-OUs: **`IT`** (selected), **`Sales`**, and **`HR`**.
- **Right Details Pane**:
  - Confirms provisioned user accounts inside `OU=IT,OU=Jaser-Enterprise,DC=JASER,DC=LOCAL`:
    - **`Jaser Al. Halabi`** | Type: `User`
    - **`Reem Abu. Shamma`** | Type: `User`

---

## 📋 3.4 Configuration Summary

| Organizational Unit | Sub-OUs Created | Provisioned User Accounts | Verification Status |
| :--- | :--- | :--- | :---: |
| **`Jaser-Enterprise`** | `IT`, `Sales`, `HR` | — | ✅ Verified |
| **`IT`** | — | `Jaser Al. Halabi`, `Reem Abu. Shamma` | ✅ Verified |
| **`Sales`** | — | Departmental OU | ✅ Verified |
| **`HR`** | — | Departmental OU | ✅ Verified |
