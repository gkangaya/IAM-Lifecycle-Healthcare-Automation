# Healthcare IAM Lifecycle Automation
# Phase 2.2 - Active Directory Integration

Import-Module ActiveDirectory
. "$PSScriptRoot\AD-AddGroups.ps1"
. "$PSScriptRoot\AD-CreateUser.ps1"
. "$PSScriptRoot\AD-DisableUser.ps1"
. "$PSScriptRoot\AD-MoveUser.ps1"

$ProjectRoot = "C:\Projects\IAM-Lifecycle-Healthcare-Automation"

$InputFile       = "$ProjectRoot\01-Input\employees.csv"
$RoleMappingFile = "$ProjectRoot\03-Data\RoleMappings.csv"
$LogFile         = "$ProjectRoot\04-Logs\ad_audit_log.csv"

$EmployeeOU = "OU=Employees,DC=hospital,DC=local"
$DisabledOU = "OU=Disabled Users,DC=hospital,DC=local"
#$GroupsOU   = "OU=Groups,DC=hospital,DC=local"
function New-IAMUserName {
    param($FirstName, $LastName)
    return (($FirstName.Substring(0,1) + $LastName).ToLower())
}

function Write-IAMAuditLog {
    param($EmployeeID, $UserName, $Action, $Status, $Details)

    [PSCustomObject]@{
        DateTime   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        EmployeeID = $EmployeeID
        UserName   = $UserName
        Action     = $Action
        Status     = $Status
        Details    = $Details
    } | Export-Csv -Path $LogFile -NoTypeInformation -Append
}

$Employees = Import-Csv $InputFile
$RoleMappings = Import-Csv $RoleMappingFile

function Remove-IAMRBACGroups {
    param($UserName)

    $CurrentGroups = Get-ADPrincipalGroupMembership $UserName |
        Where-Object {
            $_.Name -like "GRP_*" -and $_.Name -ne "Domain Users"
        }

    foreach ($Group in $CurrentGroups) {
        Remove-ADGroupMember `
            -Identity $Group.Name `
            -Members $UserName `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }
}

foreach ($Employee in $Employees) {

    $ValidationErrors = @()

    if ([string]::IsNullOrWhiteSpace($Employee.FirstName)) { $ValidationErrors += "Missing FirstName" }
    if ([string]::IsNullOrWhiteSpace($Employee.LastName)) { $ValidationErrors += "Missing LastName" }
    if ([string]::IsNullOrWhiteSpace($Employee.Department)) { $ValidationErrors += "Missing Department" }
    if ([string]::IsNullOrWhiteSpace($Employee.Manager)) { $ValidationErrors += "Missing Manager" }
    if ([string]::IsNullOrWhiteSpace($Employee.JobTitle)) { $ValidationErrors += "Missing JobTitle" }

    if ($ValidationErrors.Count -gt 0) {
        Write-IAMAuditLog -EmployeeID $Employee.EmployeeID -UserName "N/A" -Action $Employee.Action -Status "Validation Error" -Details ($ValidationErrors -join "; ")
        continue
    }

    $UserName = New-IAMUserName -FirstName $Employee.FirstName -LastName $Employee.LastName

    $RoleMatch = $RoleMappings | Where-Object {
        $_.JobTitle -eq $Employee.JobTitle
    }

    if (-not $RoleMatch -and $Employee.Action -ne "Leaver") {
        Write-IAMAuditLog -EmployeeID $Employee.EmployeeID -UserName $UserName -Action $Employee.Action -Status "Error" -Details "No RBAC mapping found for job title: $($Employee.JobTitle)"
        continue
    }

    switch ($Employee.Action) {

        "Joiner" {

            $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue

            if ($ExistingUser) {
                Write-IAMAuditLog -EmployeeID $Employee.EmployeeID -UserName $UserName -Action "Joiner" -Status "Skipped" -Details "User already exists in Active Directory"
                continue
            }

            $UserName = New-IAMADUser `
    -FirstName $Employee.FirstName `
    -LastName $Employee.LastName `
    -Department $Employee.Department `
    -JobTitle $Employee.JobTitle `
    -EmployeeOU $EmployeeOU

            $Groups = $RoleMatch.Groups -split ";"

            Add-IAMUserToGroups `
    -UserName $UserName `
    -Groups $Groups

            Write-IAMAuditLog -EmployeeID $Employee.EmployeeID -UserName $UserName -Action "Joiner" -Status "Success" -Details "AD user created and groups assigned"
        }

        "Mover" {

    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue

    if (-not $ExistingUser) {
        Write-IAMAuditLog -EmployeeID $Employee.EmployeeID -UserName $UserName -Action "Mover" -Status "Error" -Details "User not found in Active Directory"
        continue
    }

    $Groups = $RoleMatch.Groups -split ";"

    Move-IAMUser `
        -UserName $UserName `
        -Department $Employee.Department `
        -JobTitle $Employee.JobTitle `
        -Groups $Groups

    Write-IAMAuditLog `
        -EmployeeID $Employee.EmployeeID `
        -UserName $UserName `
        -Action "Mover" `
        -Status "Success" `
        -Details "Old RBAC groups removed, AD user updated and new groups assigned"
}
        "Leaver" {

    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue

    if (-not $ExistingUser) {
        Write-IAMAuditLog -EmployeeID $Employee.EmployeeID -UserName $UserName -Action "Leaver" -Status "Error" -Details "User not found in Active Directory"
        continue
    }

    Disable-IAMUser `
        -UserName $UserName `
        -DisabledOU $DisabledOU

    Write-IAMAuditLog `
        -EmployeeID $Employee.EmployeeID `
        -UserName $UserName `
        -Action "Leaver" `
        -Status "Success" `
        -Details "AD user disabled, RBAC groups removed and moved to Disabled Users OU"
}
    }
}

Write-Host "Phase 2.2 AD processing completed."
Write-Host "Audit log generated: $LogFile"