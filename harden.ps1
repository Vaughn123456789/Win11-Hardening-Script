[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [switch]$Apply,
    [string]$LogPath = "$PSScriptRoot\harden.log"
)

function Assert-Admin {
    try {
        $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($identity)
        if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { return $true }
        Write-Warning "Not running as Administrator. Some steps may fail. Re-run elevated for full effect."
        return $false
    } catch {
        Write-Warning "Unable to determine elevation: $($_.Exception.Message)"
        return $false
    }
}

function Show-SystemInfo {
    Write-Host "=== System Info ==="
    try {
        $info = Get-ComputerInfo -Property CsName, WindowsProductName, WindowsVersion, OsBuildNumber
        Write-Host ("Computer     : {0}" -f $info.CsName)
        Write-Host ("Windows      : {0} (Version {1}, Build {2})" -f $info.WindowsProductName, $info.WindowsVersion, $info.OsBuildNumber)
    } catch {
        Write-Host "Computer     : $env:COMPUTERNAME"
    }
}

function Ensure-Firewall {
    Write-Host "=== Firewall Profiles ==="
    try {
        $profiles = Get-NetFirewallProfile
        $profiles | Format-Table Name, Enabled | Out-String | Write-Host

        if ($Apply) {
            if ($PSCmdlet.ShouldProcess("All firewall profiles","Enable")) {
                Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -Confirm:$false -ErrorAction Continue
                Write-Host "Firewall profiles set to Enabled."
            }
        } else {
            Write-Host "DRY RUN: would enable all firewall profiles. Use -Apply to make changes."
        }
    } catch {
        Write-Warning "Firewall cmdlets not available on this edition."
    }
}

function Disable-SMB1 {
    Write-Host "=== SMBv1 State ==="
    try {
        $state = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue
        if ($state.State -eq 'Enabled') {
            Write-Host "SMBv1 is ENABLED."
            if ($Apply) {
                if ($PSCmdlet.ShouldProcess("SMBv1","Disable")) {
                    Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction Continue | Out-Null
                    Write-Host "SMBv1 disabled (restart may be required)."
                }
            } else {
                Write-Host "DRY RUN: would disable SMBv1. Use -Apply to make changes."
            }
        } else {
            Write-Host "SMBv1 is already disabled or not present."
        }
    } catch {
        Write-Warning "SMBv1 feature cmdlets not available."
    }
}

function Invoke-Hardening {
    param([switch]$Apply)
    Write-Host "Starting hardening (Apply=$Apply)"
    Assert-Admin | Out-Null
    Show-SystemInfo
    Ensure-Firewall
    Disable-SMB1
    Write-Host "Hardening complete."
}

# Start logging (best-effort)
try { Start-Transcript -Path $LogPath -Append -ErrorAction SilentlyContinue | Out-Null } catch {}

# Auto-run when executed (not dot-sourced)
if ($MyInvocation.InvocationName -ne '.') {
    Invoke-Hardening -Apply:$Apply
    try { Stop-Transcript | Out-Null } catch {}
} else {
    Write-Host "harden.ps1 loaded. Run Invoke-Hardening [-Apply] to execute."
}
