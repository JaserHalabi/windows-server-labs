# Day 06: Departmental Group Policy Implementation & Security Hardening

[![Day 06](https://img.shields.io/badge/Day-06-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Security%20Hardening-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 6.1 Objective
Setting up Group Policy Objects (GPOs) to make sure each department has the right level of access. Instead of having the same rules for everyone, I used the **`HR`**, **`IT`**, and **`Sales`** OUs to apply specific restrictions. This way, users only get the tools they actually need for their jobs, and we keep the server environment secure by locking down things they shouldn't be touching.

---

## 🛠️ 6.2 What I Did (Implementation Details & Technical Paths)

Using the Group Policy Management Editor, I created and linked specific GPOs with the following Administrative Template settings:

### 1. (HR) Security
*Focused on protecting sensitive employee PII and preventing unauthorized physical access:*
- **Force Screen Saver Password**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Personalization > Password protect the screen saver`
- **Restrict Control Panel Access**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Prohibit access to Control Panel and PC settings`

### 2. (IT) Administration
*Ensured administrative tools remain accessible to technical engineers while optimizing technician login flow:*
- **Allow Command Prompt**:
  - **Path**: `User Configuration > Policies > Administrative Templates > System > Prevent access to the command prompt` *(Set to Disabled)*
- **Disable Screen Lock**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Personalization > Do not display the lock screen`

### 3. Sales Department Standardization
*Enforced environment standardization and eliminated unauthorized application execution:*
- **Prevent Changing Wallpaper**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Personalization > Prevent changing desktop background`
- **Remove "Run" Command**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Start Menu and Taskbar > Remove Run menu from Start Menu`

---

## 🧠 6.3 "The Small Things": Technical Rationale & Sysadmin Details

- **The LSDOU Precedence Model**:
  Windows Group Policy evaluates policies in the order of **Local -> Site -> Domain -> OU**. By linking these GPOs directly to their respective departmental OUs beneath `Jaser-Enterprise`, the departmental settings take precedence over higher-level domain defaults.
- **Why HR needs Password-Protected Screen Saver & Control Panel restrictions**:
  HR personnel frequently handle sensitive payroll, identification, and personal information. Requiring a password on screen resume mitigates shoulder-surfing and unattended session takeover, while blocking Control Panel prevents users from tampering with network or system configurations.
- **Why Sales has the "Run" menu removed**:
  The Windows Run dialog (`Win+R`) allows direct launching of command-line tools or unapproved executables. Removing it streamlines the user interface and reduces the threat surface for non-technical commercial staff.

---

## 📸 6.4 Visual Evidence & UI Verification

Below is the verification screenshot from my lab report showing the Group Policy Management console:

![Group Policy Management Console Hierarchy](../assets/screenshots/06-group-policy-management.png)

### Breakdown of the Verification Screenshot:
- **Left Pane (GPO Hierarchy Tree)**:
  - **`Forest: JASER.LOCAL` > `Domains` > `JASER.LOCAL`**: Shows the top-level forest and domain hierarchy.
  - **`Jaser-Enterprise` OU**:
    - **`HR` OU**: Shows linked GPOs:
      - 🔗 `Force Screen Saver Password`
      - 🔗 `Restrict Control Panel Access`
    - **`IT` OU**: Shows linked GPOs:
      - 🔗 `Allow Command Prompt`
      - 🔗 `Disable Screen Lock`
    - **`Sales` OU**: Shows linked GPOs:
      - 🔗 `Prevent Changing Wallpaper.`
      - 🔗 `Remove "Run" Command`
- **Right Pane (Domain Status)**:
  - Shows **`Server2019.JASER.LOCAL is the baseline domain controller`**, confirming active directory and policy replication status are synchronized.

---

## 📋 6.5 Verification Summary

| Department OU | Linked GPO Name | Policy Path Configured | Status |
| :--- | :--- | :--- | :---: |
| **`HR`** | Force Screen Saver Password | `Control Panel > Personalization > Password protect the screen saver` | ✅ Verified |
| **`HR`** | Restrict Control Panel Access | `Control Panel > Prohibit access to Control Panel and PC settings` | ✅ Verified |
| **`IT`** | Allow Command Prompt | `System > Prevent access to the command prompt (Disabled)` | ✅ Verified |
| **`IT`** | Disable Screen Lock | `Control Panel > Personalization > Do not display the lock screen` | ✅ Verified |
| **`Sales`** | Prevent Changing Wallpaper | `Control Panel > Personalization > Prevent changing desktop background` | ✅ Verified |
| **`Sales`** | Remove "Run" Command | `Start Menu and Taskbar > Remove Run menu from Start Menu` | ✅ Verified |
