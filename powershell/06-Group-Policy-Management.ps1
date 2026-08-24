<#
.SYNOPSIS
    Day 06 - Automated Departmental Group Policy Infrastructure & Security Hardening.
.DESCRIPTION
    Creates targeted GPOs for HR, IT, and Sales departments, defines Administrative Template
    registry settings, and links GPOs to departmental sub-OUs.
.NOTES
    Author: Jaser Halabi
    Course: Cybersecurity & Network Engineering
    Lab: Windows Server 2019 Deployment Project
#>

[CmdletBinding()]
param (
    [string]$DomainName = "JASER.LOCAL",
    [string]$BaseOU = "OU=Jaser-Enterprise,DC=JASER,DC=LOCAL"
)

Import-Module GroupPolicy

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 06: Departmental Group Policy Security Hardening           " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# Helper Function: Create, Configure, and Link GPOs
function Initialize-DepartmentGPO {
    param (
        [string]$GpoName,
        [string]$TargetSubOU,
        [string]$Description
    )
    
    $TargetDN = "OU=$TargetSubOU,$BaseOU"
    Write-Host "[*] Configuring GPO: '$GpoName' for Target: '$TargetSubOU'..." -ForegroundColor Yellow
    
    $GPO = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
    if (-not $GPO) {
        $GPO = New-GPO -Name $GpoName -Comment $Description
        Write-Host "    [+] Created GPO: $GpoName" -ForegroundColor Green
    } else {
        Write-Host "    [=] GPO $GpoName exists." -ForegroundColor Green
    }
    
    # Create Link if not linked
    $Links = (Get-GPInheritance -Target $TargetDN).InheritedGpoLinks
    if ($Links.DisplayName -notcontains $GpoName) {
        New-GPLink -Name $GpoName -Target $TargetDN -LinkEnabled Yes | Out-Null
        Write-Host "    [+] Linked $GpoName -> $TargetDN" -ForegroundColor Green
    }
    
    return $GPO
}

# 1. HR Security GPO
# Objective: Protect sensitive PII, force screen saver lock, disable Control Panel
$HR_GpoName = "HR-Security-Policy"
Initialize-DepartmentGPO -GpoName $HR_GpoName -TargetSubOU "HR" -Description "HR Department Security Baseline: Screensaver & Control Panel Lock"

# Force Password Protected Screen Saver
Set-GPRegistryValue -Name $HR_GpoName -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -ValueName "ScreenSaverIsSecure" -Type String -Value "1"
Set-GPRegistryValue -Name $HR_GpoName -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -ValueName "ScreenSaveTimeOut" -Type String -Value "300"
Set-GPRegistryValue -Name $HR_GpoName -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -ValueName "SCRNSAVE.EXE" -Type String -Value "scrnsave.scr"

# Prohibit Access to Control Panel and PC Settings
Set-GPRegistryValue -Name $HR_GpoName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoControlPanel" -Type DWord -Value 1

# 2. IT Administration GPO
# Objective: Ensure technician access to CLI tools and streamline login flow
$IT_GpoName = "IT-Administration-Policy"
Initialize-DepartmentGPO -GpoName $IT_GpoName -TargetSubOU "IT" -Description "IT Administration Baseline: Command Prompt Enabled & Lock Screen Bypass"

# Allow Command Prompt (Set Prevent Access = Disabled -> Value 0)
Set-GPRegistryValue -Name $IT_GpoName -Key "HKCU\Software\Policies\Microsoft\Windows\System" -ValueName "DisableCMD" -Type DWord -Value 0

# Do Not Display Lock Screen (Computer Configuration)
Set-GPRegistryValue -Name $IT_GpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ValueName "NoLockScreen" -Type DWord -Value 1

# 3. Sales Standardization GPO
# Objective: Corporate desktop standardization & execution surface reduction
$Sales_GpoName = "Sales-Standardization-Policy"
Initialize-DepartmentGPO -GpoName $Sales_GpoName -TargetSubOU "Sales" -Description "Sales Standardization: Wallpaper Lockdown & Run Menu Removal"

# Prevent Changing Desktop Background
Set-GPRegistryValue -Name $Sales_GpoName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -ValueName "NoChangingWallPaper" -Type DWord -Value 1

# Remove 'Run' Menu from Start Menu
Set-GPRegistryValue -Name $Sales_GpoName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoRun" -Type DWord -Value 1

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Day 06 Group Policy Hardening Automation Completed!            " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
