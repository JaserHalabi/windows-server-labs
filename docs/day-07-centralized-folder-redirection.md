# Day 07: Centralized Data Redirection (GPO)

[![Day 07](https://img.shields.io/badge/Day-07-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Data%20Management-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 7.1 Objective
To implement **Folder Redirection** using Group Policy. This process ensures that a user’s "Documents" or "Desktop" folders are not stored locally on the PC, but are instead redirected to a secure, shared location on the server.

---

## 🛠️ 7.2 What I Did (Implementation Steps)

1. **Step 1: Network Share Creation**:
   - Created a folder named **`CentralStorage`** on the server volume (`C:\CentralStorage`).
   - Shared the folder with **Read/Write** network permissions to act as the primary repository for user data:
     - `Administrator`: Read/Write
     - `Administrators`: Owner
     - `Everyone`: Read/Write

2. **Step 2: Policy Configuration**:
   - In Group Policy Management, navigated to `User Configuration > Policies > Windows Settings > Folder Redirection > Documents`.
   - Configured the policy to redirect the Documents library to the network share using the UNC path:
     $$\text{\texttt{\textbackslash\textbackslash SERVER2019\textbackslash CentralStorage}}$$
   - **Setting**: `Basic - Redirect everyone's folder to the same location`
   - **Target Folder Location**: `Create a folder for each user under the root path`
   - **Root Path**: `\\SERVER2019\CentralStorage`

---

## 🧠 7.3 "The Small Things": Technical Rationale & Sysadmin Details

- **Why Centralized Folder Redirection Matters**:
  If a user workstation experiences hardware failure, malware infection, or drive corruption, locally saved documents are lost. Redirecting the Documents library guarantees that all user files reside on the central server where they can be backed up and protected with enterprise quotas.
- **Dynamic Per-User Subdirectory Generation**:
  By selecting *"Create a folder for each user under the root path"*, Windows automatically resolves the connecting user's security token and provisions a unique folder named after their username (e.g. `\\SERVER2019\CentralStorage\Jaser\Documents`).
- **Seamless User Experience**:
  To the end user, clicking on their standard "Documents" shortcut in File Explorer appears completely normal, while Windows transparently handles the network redirection in the background.

---

## 📸 7.4 Visual Evidence & UI Verification

### Configuration Evidence:
Below are the screenshots from my lab report showing the Network Access sharing configuration and the GPO Documents Redirection properties:

| Network Access Share Permissions | Documents Folder Redirection GPO Properties |
| :---: | :---: |
| ![Network Access Permissions](../assets/screenshots/07-smb-share-permissions.png) | ![Folder Redirection Properties](../assets/screenshots/07-folder-redirection-gpo.png) |

#### Breakdown of the Configuration Screenshots:
- **Left Screenshot (Network Access Sharing Dialog)**:
  - Shows `Administrator` with `Read/Write` permission level.
  - Shows `Administrators` as `Owner`.
  - Shows `Everyone` with `Read/Write` permission level, ensuring connecting domain users can establish their storage directories.
- **Right Screenshot (Documents Properties Dialog)**:
  - **Setting**: `Basic - Redirect everyone's folder to the same location`.
  - **Target folder location**: `Create a folder for each user under the root path`.
  - **Root Path**: `\\SERVER2019\CentralStorage`.
  - **Preview Text**: *"For user Clair, this folder will be redirected to: \\SERVER2019\CentralStorage\Clair\Documents"*.

---

### Final Verification Screenshot:
To verify the policy, a domain user session was initiated. The system successfully created a unique directory for the user on the server, as shown below:

![User Directory Verification](../assets/screenshots/07-user-folder-verification.png)

#### Breakdown of the Final Verification Screenshot:
- **Address Bar**: Shows `Network > SERVER2019 > CentralStorage`.
- **Created Content**: Shows the private user folder **`Jaser`** (Date modified: `4/9/2026 6:21 PM`, Type: `File folder`), proving that the GPO executed and automated per-user directory provisioning upon domain logon.

---

## 📋 7.5 Verification Summary

| Item | Value / Setting | Status |
| :--- | :--- | :---: |
| **Storage Share** | `\\SERVER2019\CentralStorage` | ✅ Verified |
| **Share Permissions** | Everyone: Read/Write | ✅ Verified |
| **GPO Redirection Setting** | Basic - Redirect everyone's folder | ✅ Verified |
| **Dynamic Provisioning** | Auto-created `\Jaser` directory upon logon | ✅ Verified |
