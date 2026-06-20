# Healthcare IAM Lifecycle Automation
# Phase 2.5 - Add AD Groups Module

function Add-IAMUserToGroups {
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserName,

        [Parameter(Mandatory=$true)]
        [string[]]$Groups
    )

    foreach ($Group in $Groups) {
        try {
            Add-ADGroupMember `
                -Identity $Group `
                -Members $UserName `
                -ErrorAction Stop

            Write-Host "Added $UserName to $Group"
        }
        catch {
            Write-Host "Could not add $UserName to $Group - $($_.Exception.Message)"
        }
    }
}