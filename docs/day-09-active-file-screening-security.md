# Day 09: Proactive Security via File Screening

[![Day 09](https://img.shields.io/badge/Day-09-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Storage%20Hardening-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](../README.md)

---

## 🎯 9.1 Objective
To implement **Active File Screening** within the FSRM role. This ensures that the server storage is used strictly for business-critical documents and prevents the storage of non-authorized media files (Audio/Video), which protects both storage capacity and network bandwidth.

---

## 🛠️ 9.2 What I Did (Implementation Details)

1. **Screening Type**:
   - Selected **Active Screening** (prevents users from saving unauthorized files).

2. **File Groups & Templates**:
   - Applied the built-in **"Block Audio and Video Files"** template to the **`C:\CentralStorage`** path.

3. **Mechanism**:
   - The FSRM filter driver intercepts I/O requests; if a file extension matches the blocked group (e.g., `.mp3`, `.mp4`, `.mov`, `.avi`, `.mkv`), the write operation is rejected at the kernel level.

---

## 🧠 9.3 "The Small Things": Technical Rationale & Sysadmin Details

- **How the FSRM Filter Driver Works**:
  File Screening does not rely on userland scripts or periodic scans. Instead, Windows uses a dedicated **kernel minifilter driver** (`srmfltr.sys`). When any process or network user attempts an I/O write request, the driver inspects the file extension. If it matches a blocked group, the kernel immediately aborts the write with `STATUS_ACCESS_DENIED`.
- **Active vs. Passive Screening**:
  - **Passive screening** allows the file to be saved and only generates an audit log or email alert.
  - **Active screening** halts the file write before data commits to storage blocks, protecting corporate bandwidth and storage from unauthorized personal media.
- **Ransomware Mitigation Principle**:
  The exact same kernel-level active file screening technique is used in enterprise cybersecurity to block ransomware extensions (e.g. `.crypt`, `.locky`, `.wannacry`), neutralizing unauthorized encryption writes in real time.

---

## 📸 9.4 Visual Evidence & UI Verification

Below is the verification screenshot from my lab report showing the configured Active File Screen in FSRM:

![FSRM Active File Screening Verification](../assets/screenshots/09-fsrm-active-file-screening.png)

### Breakdown of the Verification Screenshot:
- **`File Screen Path`**: `C:\CentralStorage`
  - Validates that the screening policy covers the entire user data redirection repository and all child subfolders.
- **`Screening Type`**: `Active`
  - Confirms proactive real-time blocking instead of passive monitoring.
- **`File Groups`**: `Block Audio and Video Files`
  - Confirms blocking of unauthorized multimedia extensions (`.mp3`, `.mp4`, `.mov`, `.avi`, `.wav`, etc.).
- **`Source Template`**: `Block Audio and Video Files`
  - Shows template inheritance.
- **`Match Template`**: `Yes`
  - Confirms full compliance with the security template.

---

## 📋 9.5 Verification Summary

| Property | Configured Setting | Observed in Screenshot | Status |
| :--- | :--- | :--- | :---: |
| **File Screen Path** | `C:\CentralStorage` | `C:\CentralStorage` | ✅ Verified |
| **Screening Type** | Active Screening (Real-time block) | `Active` | ✅ Verified |
| **Target File Group** | Audio and Video Files | `Block Audio and Video Files` | ✅ Verified |
| **Source Template** | Block Audio and Video Files | `Block Audio and Video Files` | ✅ Verified |
| **Enforcement Layer** | Windows NT Kernel (`srmfltr.sys`) | Active on all I/O writes | ✅ Verified |
