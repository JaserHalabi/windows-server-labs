<#
.SYNOPSIS
    Day 03 - Automated Enterprise OU Hierarchy & User Account Provisioning.
.DESCRIPTION
    Builds the Jaser-Enterprise logical container hierarchy and provisions
    departmental users with enterprise security standards.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$DomainDN = "DC=JASER,DC=LOCAL",
    [string]$RootOU = "Jaser-Enterprise"
)

Import-Module ActiveDirectory

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 03: Enterprise OU Hierarchy & User Account Provisioning   " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Create Top-Level Enterprise Root OU
$FullRootPath = "OU=$RootOU,$DomainDN"

if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$RootOU'" -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Creating Root Organizational Unit: $RootOU..." -ForegroundColor Yellow
    New-ADOrganizationalUnit `
        -Name $RootOU `
        -Path $DomainDN `
        -ProtectedFromAccidentalDeletion $true `
        -Description "Primary Enterprise Root OU for Corporate Assets"
    Write-Host "[+] Root OU '$RootOU' created successfully." -ForegroundColor Green
} else {
    Write-Host "[=] Root OU '$RootOU' already exists." -ForegroundColor Green
}

# 2. Create Departmental Sub-OUs (IT, Sales, HR)
$Departments = @(
    @{ Name = "IT"; Description = "Information Technology and Systems Administration" },
    @{ Name = "Sales"; Description = "Sales and Client Operations" },
    @{ Name = "HR"; Description = "Human Resources and Personnel Records" }
)

foreach ($Dept in $Departments) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$($Dept.Name)'" -SearchBase $FullRootPath -ErrorAction SilentlyContinue)) {
        Write-Host "[*] Provisioning Sub-OU: $($Dept.Name)..." -ForegroundColor Yellow
        New-ADOrganizationalUnit `
            -Name $Dept.Name `
            -Path $FullRootPath `
            -ProtectedFromAccidentalDeletion $true `
            -Description $Dept.Description
        Write-Host "[+] Sub-OU '$($Dept.Name)' created under $RootOU." -ForegroundColor Green
    } else {
        Write-Host "[=] Sub-OU '$($Dept.Name)' already exists." -ForegroundColor Green
    }
}

# 3. Provision Initial User Accounts in IT OU
$ITPath = "OU=IT,$FullRootPath"
$DefaultPassword = ConvertTo-SecureString "EnterpriseSecure2026!" -AsPlainText -Force

$UserAccounts = @(
    @{
        FirstName   = "Jaser"
        LastName    = "Al. Halabi"
        DisplayName = "Jaser Al. Halabi"
        SamAccount  = "jhalabi"
        UPN         = "jhalabi@jaser.local"
        Title       = "Lead Systems & Security Engineer"
        Department  = "IT"
    },
    @{
        FirstName   = "Reem"
        LastName    = "Abu. Shamma"
        DisplayName = "Reem Abu. Shamma"
        SamAccount  = "rshamma"
        UPN         = "rshamma@jaser.local"
        Title       = "Network Operations Engineer"
        Department  = "IT"
    }
)

foreach ($User in $UserAccounts) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.SamAccount)'" -ErrorAction SilentlyContinue)) {
        Write-Host "[*] Provisioning User: $($User.DisplayName) ($($User.SamAccount))..." -ForegroundColor Yellow
        New-ADUser `
            -Name $User.DisplayName `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -DisplayName $User.DisplayName `
            -SamAccountName $User.SamAccount `
            -UserPrincipalName $User.UPN `
            -Title $User.Title `
            -Department $User.Department `
            -Path $ITPath `
            -AccountPassword $DefaultPassword `
            -Enabled $true `
            -PasswordNeverExpires $false `
            -ChangePasswordAtLogon $false
        Write-Host "[+] User '$($User.SamAccount)' provisioned in $ITPath." -ForegroundColor Green
    } else {
        Write-Host "[=] User '$($User.SamAccount)' already exists." -ForegroundColor Green
    }
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 03 Identity Provisioning Completed!                        " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
