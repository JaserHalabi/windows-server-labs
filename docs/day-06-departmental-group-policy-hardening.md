# Day 06: Group Policy Implementation

[![Day 06](https://img.shields.io/badge/Day-06-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Group%20Policy-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 6.1 Objective
Setting up Group Policy Objects (GPOs) to make sure each department has the right level of access. Instead of having the same rules for everyone, I’m using the **`HR`**, **`IT`**, and **`Sales`** OUs to apply specific restrictions. This way, users only get the tools they actually need for their jobs, and we keep the server environment secure by locking down things they shouldn't be touching.

---

## 🛠️ 6.2 Implementation Details & Technical Paths

### • (HR) Security
- **Force Screen Saver Password**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Personalization > Password protect the screen saver`
- **Restrict Control Panel Access**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Prohibit access to Control Panel and PC settings`

### • (IT) Administration
- **Allow Command Prompt**:
  - **Path**: `User Configuration > Policies > Administrative Templates > System > Prevent access to the command prompt` *(Set to Disabled)*
- **Disable Screen Lock**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Personalization > Do not display the lock screen`

### • Sales Department Standardization
- **Prevent Changing Wallpaper**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Control Panel > Personalization > Prevent changing desktop background`
- **Remove "Run" Command**:
  - **Path**: `User Configuration > Policies > Administrative Templates > Start Menu and Taskbar > Remove Run menu from Start Menu`

---

## 📸 6.3 Visual Evidence & Verification

![Group Policy Management Console Verification](../assets/screenshots/06-group-policy-management.png)

### Verification Details from Group Policy Management:
- **`Forest: JASER.LOCAL` > `Domains` > `JASER.LOCAL` > `Jaser-Enterprise`**:
  - **`HR` OU**:
    - 🔗 `Force Screen Saver Password`
    - 🔗 `Restrict Control Panel Access`
  - **`IT` OU**:
    - 🔗 `Allow Command Prompt`
    - 🔗 `Disable Screen Lock`
  - **`Sales` OU**:
    - 🔗 `Prevent Changing Wallpaper.`
    - 🔗 `Remove "Run" Command`
- **Right Pane**: Confirms `Server2019.JASER.LOCAL is the baseline domain controller`.

---

## 📋 6.4 Configuration Summary

| Department OU | Linked GPO | Configured Setting Path | Status |
| :--- | :--- | :--- | :---: |
| **`HR`** | Force Screen Saver Password | `Control Panel > Personalization > Password protect the screen saver` | ✅ Verified |
| **`HR`** | Restrict Control Panel Access | `Control Panel > Prohibit access to Control Panel and PC settings` | ✅ Verified |
| **`IT`** | Allow Command Prompt | `System > Prevent access to the command prompt (Disabled)` | ✅ Verified |
| **`IT`** | Disable Screen Lock | `Control Panel > Personalization > Do not display the lock screen` | ✅ Verified |
| **`Sales`** | Prevent Changing Wallpaper | `Control Panel > Personalization > Prevent changing desktop background` | ✅ Verified |
| **`Sales`** | Remove "Run" Command | `Start Menu and Taskbar > Remove Run menu from Start Menu` | ✅ Verified |
