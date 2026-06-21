# Healthcare IAM Lifecycle Automation
# Phase 2.5 - Disable AD User Module

function Disable-IAMUser {

    param(
        [Parameter(Mandatory=$true)]
        [string]$UserName,

        [Parameter(Mandatory=$true)]
        [string]$DisabledOU
    )

    $ExistingUser = Get-ADUser `
        -Filter "SamAccountName -eq '$UserName'" `
        -Properties DistinguishedName `
        -ErrorAction SilentlyContinue

    if (-not $ExistingUser) {
        Write-Host "User not found: $UserName"
        return
    }

    Remove-IAMRBACGroups -UserName $UserName

    Disable-ADAccount -Identity $UserName

    Move-ADObject `
        -Identity $ExistingUser.DistinguishedName `
        -TargetPath $DisabledOU

    Write-Host "User disabled and moved to Disabled Users OU: $UserName"
}