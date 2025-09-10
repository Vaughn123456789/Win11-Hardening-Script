<#
==============================================================
 File: harden.ps1
 Author: Eddie
 Purpose: Hardening menu for Windows labs
 Notes: Demonstrates commenting styles (Lab 8)
==============================================================
#>

# ================================
# Define menu options
# ================================
$menuOptions = @(
    "Document the system",
    "Enable updates",
    "User Auditing",
    "Account Policies",
    "Local Policies",
    "Defensive Countermeasures",
    "Uncategorized OS Settings",
    "Service Auditing",
    "OS Updates",
    "Application Updates",
    "Prohibited Files",
    "Unwanted Software",
    "Malware",
    "Application Security Settings",
    "Exit"
)

# ================================
# Define functions for each option
# ================================

# Function to document system details
function Document-System { Write-Host "`n--- Starting: Document the system ---`n" }

# Function to enable system updates
function Enable-Updates { Write-Host "`n--- Starting: Enable updates ---`n" }

# Function to audit user accounts
function User-Auditing { Write-Host "`n--- Starting: User Auditing ---`n" }

# This function handles Account Policies
function Account-Policies { Write-Host "`n--- Starting: Account Policies ---`n" }

# Function to configure local policies
function Local-Policies { Write-Host "`n--- Starting: Local Policies ---`n" }

# Function to apply defensive countermeasures
function Defensive-Countermeasures { Write-Host "`n--- Starting: Defensive Countermeasures ---`n" }

# Function to review uncategorized OS settings
function Uncategorized-OS-Settings { Write-Host "`n--- Starting: Uncategorized OS Settings ---`n" }

# Function for service auditing
function Service-Auditing { Write-Host "`n--- Starting: Service Auditing ---`n" }

# Function for OS updates
function OS-Updates { Write-Host "`n--- Starting: OS Updates ---`n" }

# Function for application updates
function Application-Updates { Write-Host "`n--- Starting: Application Updates ---`n" }

# Function for checking prohibited files
function Prohibited-Files { Write-Host "`n--- Starting: Prohibited Files ---`n" }

# Function for unwanted software
function Unwanted-Software { Write-Host "`n--- Starting: Unwanted Software ---`n" }

# Function for malware checks
function Malware { Write-Host "`n--- Starting: Malware ---`n" }

# Function for application security settings
function Application-Security-Settings { Write-Host "`n--- Starting: Application Security Settings ---`n" }

# ================================
# Dynamic Menu Loop
# ================================
:menu do {
    Write-Host "`nSelect an option:`n"
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "`nEnter the number of your choice"

    switch ($selection) {
        "1"  { Document-System }              # Calls the Document-System function
        "2"  { Enable-Updates }               # Runs the Enable-Updates function
        "3"  { User-Auditing }
        "4"  { Account-Policies }             # In-line comment: calls Account-Policies function
        "5"  { Local-Policies }
        "6"  { Defensive-Countermeasures }
        "7"  { Uncategorized-OS-Settings }
        "8"  { Service-Auditing }
        "9"  { OS-Updates }
        "10" { Application-Updates }
        "11" { Prohibited-Files }
        "12" { Unwanted-Software }
        "13" { Malware }
        "14" { Application-Security-Settings }
        "15" { Write-Host "`nExiting..."; break menu } # Exit the menu loop
        default { Write-Host "`nInvalid selection. Please try again." }
    }
} while ($true)
