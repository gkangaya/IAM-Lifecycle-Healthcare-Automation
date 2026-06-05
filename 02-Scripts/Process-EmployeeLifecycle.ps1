# Healthcare IAM Lifecycle Automation
# Version 4.0 - RBAC with external role mapping

$ProjectRoot = "C:\Projects\IAM-Lifecycle-Healthcare-Automation"

$InputFile       = "$ProjectRoot\01-Input\employees.csv"
$RoleMappingFile = "$ProjectRoot\03-Data\RoleMappings.csv"
$DataFile        = "$ProjectRoot\03-Data\simulated_users.csv"
$LogFile         = "$ProjectRoot\04-Logs\audit_log.csv"

function New-UserName {
    param($FirstName, $LastName)
    return (($FirstName.Substring(0,1) + $LastName).ToLower())
}

function Write-AuditLog {
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

$SimulatedUsers = @()

foreach ($Employee in $Employees) {

    # Governance Validation

$ValidationErrors = @()

if ([string]::IsNullOrWhiteSpace($Employee.FirstName)) {
    $ValidationErrors += "Missing FirstName"
}

if ([string]::IsNullOrWhiteSpace($Employee.LastName)) {
    $ValidationErrors += "Missing LastName"
}

if ([string]::IsNullOrWhiteSpace($Employee.Department)) {
    $ValidationErrors += "Missing Department"
}

if ([string]::IsNullOrWhiteSpace($Employee.Manager)) {
    $ValidationErrors += "Missing Manager"
}

if ([string]::IsNullOrWhiteSpace($Employee.JobTitle)) {
    $ValidationErrors += "Missing JobTitle"
}

if (
    $Employee.Action -eq "Joiner" -and
    [string]::IsNullOrWhiteSpace($Employee.StartDate)
)
{
    $ValidationErrors += "Missing StartDate"
}

if ($ValidationErrors.Count -gt 0)
{
    $Status = "Validation Error"

    $Details = $ValidationErrors -join "; "

    $User = [PSCustomObject]@{
        EmployeeID = $Employee.EmployeeID
        UserName   = "N/A"
        FirstName  = $Employee.FirstName
        LastName   = $Employee.LastName
        Department = $Employee.Department
        JobTitle   = $Employee.JobTitle
        Manager    = $Employee.Manager
        Action     = $Employee.Action
        Status     = $Status
        Groups     = "N/A"
        ValidationMessage = $Details
    }

    $SimulatedUsers += $User

    Write-AuditLog `
        -EmployeeID $Employee.EmployeeID `
        -UserName "N/A" `
        -Action $Employee.Action `
        -Status $Status `
        -Details $Details

    continue
}

    $UserName = New-UserName -FirstName $Employee.FirstName -LastName $Employee.LastName

    $RoleMatch = $RoleMappings | Where-Object {
        $_.JobTitle -eq $Employee.JobTitle
    }

    if ($RoleMatch) {
        $Groups = $RoleMatch.Groups
    }
    else {
        $Groups = "NO_GROUP_MAPPING_FOUND"
    }

    switch ($Employee.Action) {

        "Joiner" {
            if ($Groups -eq "NO_GROUP_MAPPING_FOUND") {
                $Status = "Error"
                $Details = "No RBAC mapping found for job title: $($Employee.JobTitle)"
            }
            else {
                $Status = "Active"
                $Details = "Account created and groups assigned from RBAC mapping"
            }
        }

        "Mover" {
            if ($Groups -eq "NO_GROUP_MAPPING_FOUND") {
                $Status = "Error"
                $Details = "No RBAC mapping found for new job title: $($Employee.JobTitle)"
            }
            else {
                $Status = "Active - Updated Role"
                $Details = "Role updated and access modified from RBAC mapping"
            }
        }

        "Leaver" {
            $Status = "Disabled"
            $Groups = "Removed"
            $Details = "Account disabled and groups removed"
        }

        Default {
            $Status = "Error"
            $Details = "Unknown lifecycle action"
        }
    }

    $User = [PSCustomObject]@{
        EmployeeID = $Employee.EmployeeID
        UserName   = $UserName
        FirstName  = $Employee.FirstName
        LastName   = $Employee.LastName
        Department = $Employee.Department
        JobTitle   = $Employee.JobTitle
        Manager    = $Employee.Manager
        Action     = $Employee.Action
        Status     = $Status
        Groups     = $Groups
        ValidationMessage = $Details
    }

    $SimulatedUsers += $User

    Write-AuditLog `
        -EmployeeID $Employee.EmployeeID `
        -UserName $UserName `
        -Action $Employee.Action `
        -Status $Status `
        -Details $Details
}

$SimulatedUsers | Export-Csv -Path $DataFile -NoTypeInformation

Write-Host "Processing completed successfully."
Write-Host "RBAC mapping file : $RoleMappingFile"
Write-Host "Generated users   : $DataFile"
Write-Host "Generated audit   : $LogFile"