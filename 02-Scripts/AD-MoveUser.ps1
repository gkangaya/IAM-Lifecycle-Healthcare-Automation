# Healthcare IAM Lifecycle Automation
# Phase 2.5 - Move AD User Module

function Move-IAMUser {

    param(
        [Parameter(Mandatory=$true)]
        [string]$UserName,

        [Parameter(Mandatory=$true)]
        [string]$Department,

        [Parameter(Mandatory=$true)]
        [string]$JobTitle,

        [Parameter(Mandatory=$true)]
        [string[]]$Groups
    )

    Remove-IAMRBACGroups -UserName $UserName

    Set-ADUser `
        -Identity $UserName `
        -Department $Department `
        -Title $JobTitle

    Add-IAMUserToGroups `
        -UserName $UserName `
        -Groups $Groups

    Write-Host "User moved/updated: $UserName"
}