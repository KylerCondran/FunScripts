# ADEnumerator.ps1
# Active Directory Account Enumeration Script
# Requires ActiveDirectory PowerShell module

# Check if AD module is installed
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Host "ActiveDirectory module is not installed. Please install RSAT tools or run this on a domain controller." -ForegroundColor Red
    exit
}

# Import the Active Directory module
Import-Module ActiveDirectory

function Get-ADAccountSummary {
    [CmdletBinding()]
    param()
    
    Write-Host "`n=== Active Directory Account Summary ===" -ForegroundColor Cyan
    
    # Get all users
    $allUsers = Get-ADUser -Filter *
    $enabledUsers = $allUsers | Where-Object {$_.Enabled -eq $true}
    $disabledUsers = $allUsers | Where-Object {$_.Enabled -eq $false}
    
    # Get all groups
    $allGroups = Get-ADGroup -Filter *
    
    Write-Host "`nTotal Users: $($allUsers.Count)"
    Write-Host "Enabled Users: $($enabledUsers.Count)"
    Write-Host "Disabled Users: $($disabledUsers.Count)"
    Write-Host "Total Groups: $($allGroups.Count)"
}

function Get-ADPrivilegedAccounts {
    [CmdletBinding()]
    param()
    
    Write-Host "`n=== Privileged Account Analysis ===" -ForegroundColor Cyan
    
    # Check Domain Admins
    $domainAdmins = Get-ADGroupMember "Domain Admins" -Recursive | Get-ADUser -Properties LastLogonDate, Enabled
    Write-Host "`nDomain Admins:" -ForegroundColor Yellow
    $domainAdmins | Format-Table Name, Enabled, LastLogonDate -AutoSize

    # Check Enterprise Admins
    try {
        $enterpriseAdmins = Get-ADGroupMember "Enterprise Admins" -Recursive | Get-ADUser -Properties LastLogonDate, Enabled
        Write-Host "`nEnterprise Admins:" -ForegroundColor Yellow
        $enterpriseAdmins | Format-Table Name, Enabled, LastLogonDate -AutoSize
    } catch {
        Write-Host "Enterprise Admins group not accessible in this context." -ForegroundColor Yellow
    }
}

function Get-ADInactiveAccounts {
    [CmdletBinding()]
    param(
        [int]$DaysInactive = 90
    )
    
    Write-Host "`n=== Inactive Account Analysis ===" -ForegroundColor Cyan
    $date = (Get-Date).AddDays(-$DaysInactive)
    
    $inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $date -and Enabled -eq $true} -Properties LastLogonDate |
        Select-Object Name, SamAccountName, LastLogonDate
    
    Write-Host "`nInactive accounts (not logged in for $DaysInactive days):" -ForegroundColor Yellow
    $inactiveUsers | Format-Table -AutoSize
}

function Get-ADPasswordPolicy {
    [CmdletBinding()]
    param()
    
    Write-Host "`n=== Password Policy Analysis ===" -ForegroundColor Cyan
    
    $policy = Get-ADDefaultDomainPasswordPolicy
    $policy | Format-List ComplexityEnabled, MinPasswordLength, PasswordHistoryCount, MaxPasswordAge, MinPasswordAge, LockoutThreshold, LockoutDuration
}

function Get-ADRecentlyCreatedAccounts {
    [CmdletBinding()]
    param(
        [int]$DaysBack = 30
    )
    
    Write-Host "`n=== Recently Created Accounts ===" -ForegroundColor Cyan
    $date = (Get-Date).AddDays(-$DaysBack)
    
    $newAccounts = Get-ADUser -Filter {Created -gt $date} -Properties Created |
        Select-Object Name, SamAccountName, Created
    
    Write-Host "`nAccounts created in the last $DaysBack days:" -ForegroundColor Yellow
    $newAccounts | Format-Table -AutoSize
}

# Main menu function
function Show-Menu {
    Clear-Host
    Write-Host "=== Active Directory Account Enumeration Tool ===" -ForegroundColor Cyan
    Write-Host "1. Get Account Summary"
    Write-Host "2. List Privileged Accounts"
    Write-Host "3. Find Inactive Accounts"
    Write-Host "4. Show Password Policy"
    Write-Host "5. Show Recently Created Accounts"
    Write-Host "6. Run All Reports"
    Write-Host "Q. Quit"
    Write-Host
}

# Main script loop
do {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    
    switch ($selection) {
        '1' { Get-ADAccountSummary; pause }
        '2' { Get-ADPrivilegedAccounts; pause }
        '3' { 
            $days = Read-Host "Enter number of days for inactivity threshold (default: 90)"
            if ([string]::IsNullOrWhiteSpace($days)) { $days = 90 }
            Get-ADInactiveAccounts -DaysInactive $days
            pause
        }
        '4' { Get-ADPasswordPolicy; pause }
        '5' { 
            $days = Read-Host "Enter number of days to look back (default: 30)"
            if ([string]::IsNullOrWhiteSpace($days)) { $days = 30 }
            Get-ADRecentlyCreatedAccounts -DaysBack $days
            pause
        }
        '6' {
            Get-ADAccountSummary
            Get-ADPrivilegedAccounts
            Get-ADInactiveAccounts
            Get-ADPasswordPolicy
            Get-ADRecentlyCreatedAccounts
            pause
        }
        'Q' { return }
        'q' { return }
    }
} while ($true)