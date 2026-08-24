# Day 02: Active Directory Domain Services (AD DS) Deployment & Forest Promotion

[![Sprint Day](https://img.shields.io/badge/Sprint-Day%2002-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Identity%20Core-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)](../README.md)

---

## 🎯 2.1 Objective
The objective of this phase is to install the Active Directory Domain Services (AD DS) role and promote the server to a Domain Controller, creating a brand-new forest to serve as the centralized identity provider for the network.

---

## 🔬 2.2 Enterprise Architecture & "The Small Things"

### 1. The Two-Step Deployment Model
Deploying an enterprise Domain Controller in Windows Server 2019 consists of two sequential phases:
1. **Role Provisioning**: Navigated to the Add Roles and Features Wizard to install the Active Directory Domain Services binary files and management consoles (RSAT).
2. **Forest Promotion**: Initialized the post-deployment configuration by selecting "Add a new forest" and defining the Root Domain Name as **`JASER.LOCAL`**.

### 2. Under the Hood: Directory Partitions & Files
- **Database File (`NTDS.dit`)**: Located at `C:\Windows\NTDS\ntds.dit`. Uses the Extensible Storage Engine (ESE / Jet Blue) to store directory objects, schema definitions, and credentials.
- **`SYSVOL` Folder**: Located at `C:\Windows\SYSVOL\sysvol\JASER.LOCAL`. Replicated across DCs via Distributed File System Replication (DFSR), holding domain GPOs and logon scripts.
- **FSMO Role Seeding**: As the forest root DC, `Server2019` automatically seeds and owns all 5 Flexible Single Master Operation (FSMO) roles: Schema Master, Domain Naming Master, PDC Emulator, RID Master, and Infrastructure Master.

---

## 🛠️ 2.3 Implementation Steps

1. **Role Provisioning**:
   - Open **Server Manager** > Select **Add Roles and Features**.
   - Navigate to **Server Roles** > Check **Active Directory Domain Services**.
   - Accept the addition of required RSAT management consoles.
   - Complete installation.
2. **Forest Promotion**:
   - Click the post-deployment notification flag in Server Manager > **Promote this server to a domain controller**.
   - On the **Deployment Configuration** page:
     - Select **Add a new forest**.
     - Specify the **Root domain name**: `JASER.LOCAL`.
     - Target Server: `Server2019`.
   - Set Forest/Domain Functional Levels to **Windows Server 2016**.
   - Enter the **Directory Services Restore Mode (DSRM)** recovery password.
   - Execute prerequisite checks and initiate promotion.

---

## 📸 2.4 Visual Evidence & UI Artifact Analysis

| Phase 1: AD DS Role Provisioning | Phase 2: Forest Root Promotion |
| :---: | :---: |
| ![AD DS Role Selection](../assets/screenshots/02-adds-role-selection.png) | ![AD DS Forest Promotion](../assets/screenshots/02-adds-forest-promotion.png) |

### Deep-Dive Analysis of the Screenshots:

#### Left Screenshot (Add Roles and Features Wizard):
1. **Role Selection Checkbox**:
   - `Active Directory Domain Services` is explicitly checked with its child management consoles included.
   - The description box details the role function: *"Active Directory Domain Services (AD DS) stores information about objects on the network and makes this information available to users and network administrators."*
2. **Installation Wizard Workflow**:
   - Visible left navigation track shows the linear validation path: *Before You Begin -> Installation Type -> Server Selection -> Server Roles -> Features -> AD DS -> Confirmation -> Results*.

#### Right Screenshot (Active Directory Domain Services Configuration Wizard):
1. **Deployment Configuration Operation**:
   - The radio button **"Add a new forest"** is selected (rather than adding a DC to an existing domain or adding a new domain to an existing forest), confirming this is the foundational root domain.
2. **Root Domain Name (`JASER.LOCAL`)**:
   - Shows the enterprise root namespace `JASER.LOCAL` entered into the Root domain name field.
3. **Target Server**:
   - Upper right corner displays `TARGET SERVER: Server2019`, confirming promotion is occurring on the previously standardized host.

---

## ⚡ 2.5 Automated PowerShell Deployment

```powershell
<#
.SYNOPSIS
    Day 02 - Automated AD DS Role Installation and Forest Promotion.
.DESCRIPTION
    Installs the Active Directory binaries and elevates the machine to the Root Domain Controller for JASER.LOCAL.
#>

[CmdletBinding()]
param (
    [string]$DomainName = "JASER.LOCAL",
    [string]$NetbiosName = "JASER",
    [SecureString]$SafeModePassword = (ConvertTo-SecureString "EnterpriseAdmin2026!" -AsPlainText -Force)
)

Write-Host "[+] Installing Active Directory Domain Services role..." -ForegroundColor Yellow
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Write-Host "[*] Promoting server to Domain Controller for forest: $DomainName..." -ForegroundColor Yellow
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $SafeModePassword `
    -NoRebootOnCompletion:$false `
    -Force:$true
```

---

## 🔍 2.6 Verification & Audit Checklist

| Item Verified | Expected Value | Observed in Screenshots | Status |
| :--- | :--- | :--- | :--- |
| **Server Role** | Active Directory Domain Services | Checked in Add Roles Wizard | ✅ Verified |
| **Deployment Mode** | Add a new forest | Selected in Configuration Wizard | ✅ Verified |
| **Root Domain Name** | `JASER.LOCAL` | Specified in Root Domain field | ✅ Verified |
| **Target Server** | `Server2019` | Displayed on wizard title bar | ✅ Verified |
| **DNS Server Role** | Integrated with AD DS | Auto-provisioned during promotion | ✅ Verified |
