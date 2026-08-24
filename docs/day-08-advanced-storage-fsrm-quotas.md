# Day 08: Advanced Storage (FSRM)

[![Day 08](https://img.shields.io/badge/Day-08-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Advanced%20Storage-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 8.1 Objective
To implement enterprise-grade storage management using the **File Server Resource Manager (FSRM)**. This ensures that the centralized `CentralStorage` directory remains within defined resource boundaries and protects the server volume from accidental or malicious disk exhaustion.

---

## 🛠️ 8.2 Implementation Details

- **Quota Management**: A hard quota was applied to the **`C:\CentralStorage`** path using the built-in **`100 MB Limit`** template.
- **Enforcement Type**: By selecting a **Hard Quota**, the system is configured to physically block any write operations that would exceed the 100MB threshold, ensuring strict storage policies.

---

## 📸 8.3 Visual Evidence & Verification

![FSRM Quota Configuration Verification](../assets/screenshots/08-fsrm-quota-configuration.png)

### Verification Details from File Server Resource Manager:
- **`Quota Path`**: `C:\CentralStorage`
- **`% Used`**: `0%`
- **`Limit`**: `100 MB`
- **`Quota Type`**: `Hard`
- **`Source Template`**: `100 MB Limit`
- **`Match Template`**: `Yes`

---

## 📋 8.4 Configuration Summary

| Setting | Value | Verification Status |
| :--- | :--- | :---: |
| **Quota Path** | `C:\CentralStorage` | ✅ Verified |
| **Storage Limit** | `100 MB` | ✅ Verified |
| **Quota Type** | `Hard` (Physically blocks write operations) | ✅ Verified |
| **Source Template** | `100 MB Limit` | ✅ Verified |
| **Match Template** | `Yes` | ✅ Verified |
