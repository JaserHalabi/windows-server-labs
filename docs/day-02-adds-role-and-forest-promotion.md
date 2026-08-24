# Day 02: Active Directory Domain Services (AD DS) Deployment & Forest Promotion

[![Sprint Day](https://img.shields.io/badge/Sprint-Day%2002-blue)](../README.md)
[![Phase](https://img.shields.io/badge/Phase-Identity%20Core-orange)](../README.md)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)](../README.md)

---

## 🎯 2.1 Objective
The objective of Day 02 is to install the Active Directory Domain Services (AD DS) server binaries and promote `Server2019` into the primary Domain Controller of a brand-new Active Directory forest: **`JASER.LOCAL`**.

---

## 🔬 2.2 Enterprise Architecture & "The Small Things"

### 1. The Two-Step Deployment Model
Deploying a Domain Controller in modern Windows Server consists of two distinct stages:
1. **Binary Installation (`AD-Domain-Services`)**: Copies the server binaries, PowerShell modules, and MMC snap-in management tools to the local `WinSxS` component store.
2. **Forest Promotion (`Install-ADDSForest`)**: Initializes directory partitions, creates the cryptographic keys, builds the Extensible Storage Engine (ESE) database, and provisions the `SYSVOL` share.

### 2. Deep Directory Internals
- **Database (`NTDS.dit`)**: Located at `C:\Windows\NTDS\ntds.dit`. This is an ESE (Jet Blue) indexed database holding all directory objects, schema definitions, and security principals.
- **Transaction Logs (`edb.log`)**: Circular logging mechanism ensuring ACID transactions across directory operations.
- **`SYSVOL` Share**: Located at `C:\Windows\SYSVOL\sysvol\JASER.LOCAL`. This shared directory houses all Group Policy Objects (GPOs), startup/logon scripts, and is replicated across Domain Controllers via Distributed File System Replication (DFSR).
- **Directory Services Restore Mode (DSRM)**: A local administrator account stored in the SAM registry hive rather than Active Directory, utilized solely when booting into Safe Mode / DSRM for offline database compaction or authoritative restores.

### 3. FSMO Role Seeding
As the root Domain Controller of a new forest, `Server2019` automatically becomes the master holder of all 5 **Flexible Single Master Operation (FSMO)** roles:
- **Forest-Wide**: Schema Master, Domain Naming Master.
- **Domain-Wide**: Primary Domain Controller (PDC) Emulator, Relative Identifier (RID) Master, Infrastructure Master.

---

## 🛠️ 2.3 Implementation Steps

### Method 1: Graphical User Interface (GUI)
1. **Role Provisioning**:
   - Open **Server Manager** > Click **Manage** > Select **Add Roles and Features**.
   - Proceed to the **Server Roles** page and select **Active Directory Domain Services**.
   - Accept the prompt to include all required management features (RSAT tools).
   - Complete the wizard and click **Install**.
2. **Forest Promotion**:
   - Once installation completes, click the **Notification flag** in Server Manager and select **Promote this server to a domain controller**.
   - On the **Deployment Configuration** page:
     - Select **Add a new forest**.
     - Specify the **Root domain name**: `JASER.LOCAL`.
   - On the **Domain Controller Options** page:
     - Verify Forest and Domain Functional Levels are set to **Windows Server 2016** (highest available in Server 2019).
     - Ensure **Domain Name System (DNS) server** and **Global Catalog (GC)** are checked.
     - Enter a strong **Directory Services Restore Mode (DSRM) password**.
   - Retain default NetBIOS domain name (`JASER`) and standard database paths (`C:\Windows\NTDS`, `C:\Windows\SYSVOL`).
   - Pass prerequisite checks and click **Install**. The server will automatically reboot upon completion.

---

## ⚡ 2.4 Automated PowerShell Deployment

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
    [SecureString]$SafeModePassword = (ConvertTo-SecureString "P@ssw0rd2026!" -AsPlainText -Force)
)

Write-Host "[+] Initializing Day 02 AD DS Deployment..." -ForegroundColor Cyan

# 1. Install AD DS Binaries and Management Tools
Write-Host "[*] Installing Active Directory Domain Services role..." -ForegroundColor Yellow
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 2. Forest Promotion
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

## 🔍 2.5 Verification & Evidence

### Verification Commands
```powershell
# Verify Domain Membership and Functional Levels
Get-ADDomain -Identity JASER.LOCAL | Select-Object Name, DomainMode, PDCEmulator, RIDMaster, InfrastructureMaster

# Verify Forest Structure & FSMO Roles
Get-ADForest -Identity JASER.LOCAL | Select-Object Name, ForestMode, SchemaMaster, DomainNamingMaster

# Verify SYSVOL and Netlogon Shares
Get-SmbShare | Where-Object { $_.Name -in @("SYSVOL", "NETLOGON") }
```

### Expected Output
```text
Name        DomainMode        PDCEmulator                RIDMaster
----        ----------        -----------                ---------
JASER.LOCAL Windows2016Domain Server2019.jaser.local      Server2019.jaser.local

Name        ScopeName Path
----        --------- ----
NETLOGON    *         C:\Windows\SYSVOL\sysvol\jaser.local\SCRIPTS
SYSVOL      *         C:\Windows\SYSVOL\sysvol
```

---

## 📌 2.6 Key Takeaways & Sysadmin Insights
- **Functional Levels**: Server 2019 runs on the Windows Server 2016 Forest/Domain Functional Level because Microsoft did not introduce breaking schema functional changes in 2019.
- **Integrated DNS**: Promoting with `-InstallDns:$true` automatically provisions the Active Directory-Integrated DNS forward lookup zone, securing dynamic record registrations.
