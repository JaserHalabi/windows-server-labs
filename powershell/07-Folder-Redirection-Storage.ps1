<#
.SYNOPSIS
    Day 07 - Automated Storage Share Provisioning and NTFS ACL Security Architecture.
.DESCRIPTION
    Creates C:\CentralStorage, applies strict NTFS DACLs for CREATOR OWNER isolation,
    provisions SMB Share \\SERVER2019\CentralStorage for GPO Folder Redirection.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$StoragePath = "C:\CentralStorage",
    [string]$ShareName = "CentralStorage",
    [string]$ShareDescription = "Centralized User Profile & Data Redirection Repository"
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 07: CentralStorage Share & NTFS Isolation Architecture     " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Directory Initialization
if (-not (Test-Path -Path $StoragePath)) {
    Write-Host "[*] Creating root storage directory: $StoragePath..." -ForegroundColor Yellow
    New-Item -Path $StoragePath -ItemType Directory -Force | Out-Null
    Write-Host "[+] Directory $StoragePath created." -ForegroundColor Green
} else {
    Write-Host "[=] Directory $StoragePath already exists." -ForegroundColor Green
}

# 2. Configure NTFS Discretionary Access Control Lists (DACL)
# Enforces that users CANNOT browse each other's private redirected folders
Write-Host "[*] Applying granular NTFS Access Control Entries (DACL)..." -ForegroundColor Yellow

$Acl = Get-Acl -Path $StoragePath
# Disable inheritance and copy current inherited rules to explicit rules
$Acl.SetAccessRuleProtection($true, $true)

# Remove any broad 'Users' group permissions
$Acl.Access | Where-Object { $_.IdentityReference.Value -like "*Users*" -and $_.IdentityReference.Value -notlike "*Authenticated Users*" } | ForEach-Object {
    $Acl.RemoveAccessRule($_) | Out-Null
}

# Explicit Rule 1: Administrators - Full Control (Folder, Subfolders, Files)
$AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "BUILTIN\Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
)

# Explicit Rule 2: NT AUTHORITY\SYSTEM - Full Control (Folder, Subfolders, Files)
$SystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
)

# Explicit Rule 3: CREATOR OWNER - Full Control (Subfolders and Files Only)
$CreatorOwnerRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "CREATOR OWNER", "FullControl", "ContainerInherit,ObjectInherit", "InheritOnly", "Allow"
)

# Explicit Rule 4: Authenticated Users - Create Folders / Append Data (This Folder Only)
$AuthUsersRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "NT AUTHORITY\Authenticated Users", "CreateDirectories,AppendData,ReadAndExecute,Synchronize", "None", "None", "Allow"
)

# Commit Rules to ACL
$Acl.ResetAccessRule($AdminRule)
$Acl.AddAccessRule($SystemRule)
$Acl.AddAccessRule($CreatorOwnerRule)
$Acl.AddAccessRule($AuthUsersRule)

Set-Acl -Path $StoragePath -AclObject $Acl
Write-Host "[+] NTFS Security Descriptors locked down for CREATOR OWNER isolation." -ForegroundColor Green

# 3. Provision SMB Share
if (-not (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Provisioning SMB Share '\\SERVER2019\$ShareName'..." -ForegroundColor Yellow
    New-SmbShare `
        -Name $ShareName `
        -Path $StoragePath `
        -FullAccess "Everyone" `
        -Description $ShareDescription `
        -FolderEnumerationMode AccessBased
    Write-Host "[+] SMB Share created with Access-Based Enumeration enabled." -ForegroundColor Green
} else {
    Write-Host "[=] SMB Share '$ShareName' already active." -ForegroundColor Green
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 07 Storage Security Architecture Successfully Deployed!   " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
