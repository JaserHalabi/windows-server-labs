# Day 07: Centralized Data Redirection (GPO)

[![Day 07](https://img.shields.io/badge/Day-07-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Data%20Redirection-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 7.1 Objective
To implement **Folder Redirection** using Group Policy. This process ensures that a user’s "Documents" or "Desktop" folders are not stored locally on the PC, but are instead redirected to a secure, shared location on the server.

---

## 🛠️ 7.2 Implementation Details

- **Step 1: Network Share Creation**: A folder named **`CentralStorage`** was created and shared with Read/Write permissions to act as the primary repository for user data:
  - `Administrator`: Read/Write
  - `Administrators`: Owner
  - `Everyone`: Read/Write
- **Step 2: Policy Configuration**: 
  - **Setting**: `Basic - Redirect everyone's folder to the same location`
  - **Target Folder Location**: `Create a folder for each user under the root path`
  - **Root Path**: `\\SERVER2019\CentralStorage`

---

## 📸 7.3 Evidence of Configuration & Final Verification

### Evidence of Configuration:
| Network Access Sharing Configuration | Documents Properties GPO Configuration |
| :---: | :---: |
| ![Network Access Permissions](../assets/screenshots/07-smb-share-permissions.png) | ![Folder Redirection Properties](../assets/screenshots/07-folder-redirection-gpo.png) |

- **Left (Network Access)**: Shows `Everyone` granted `Read/Write` permission on `CentralStorage`.
- **Right (Documents Properties)**: Shows `Basic - Redirect everyone's folder to the same location` with root path `\\SERVER2019\CentralStorage`.

---

### Final Verification:
To verify the policy, a domain user session was initiated. The system successfully created a unique directory for the user on the server, as shown below:

![User Directory Verification](../assets/screenshots/07-user-folder-verification.png)

- **File Explorer**: Shows `Network > SERVER2019 > CentralStorage` containing the dynamically created user directory **`Jaser`** (Date modified: `4/9/2026 6:21 PM`, Type: `File folder`).

---

## 📋 7.4 Configuration Summary

| Property | Value / Setting | Verification Status |
| :--- | :--- | :---: |
| **Share Name** | `CentralStorage` | ✅ Verified |
| **Share Permissions** | Everyone: Read/Write | ✅ Verified |
| **Target Redirection Path** | `\\SERVER2019\CentralStorage` | ✅ Verified |
| **Dynamic User Folder** | `\\SERVER2019\CentralStorage\Jaser` | ✅ Verified |
