# Healthcare IAM Lifecycle Automation
# Version 2.0 - Simulated account creation + audit log

$ProjectRoot = "C:\Projects\IAM-Lifecycle-Healthcare-Automation"
$InputFile   = "$ProjectRoot\01-Input\employees.csv"
$DataFile    = "$ProjectRoot\03-Data\simulated_users.csv"
$LogFile     = "$ProjectRoot\04-Logs\audit_log.csv"

$RoleGroups = @{
    "Nurse"          = "GRP_NURSES;GRP_EMAIL_BASIC;GRP_PATIENT_PORTAL"
    "Head Nurse"    = "GRP_NURSES;GRP_NURSE_SUPERVISORS;GRP_EMAIL_BASIC;GRP_PATIENT_PORTAL"
    "IAM Analyst"   = "GRP_IT_IAM;GRP_EMAIL_BASIC;GRP_ADMIN_TOOLS"
    "Lab Technician"= "GRP_LAB;GRP_EMAIL_BASIC;GRP_LAB_SYSTEM"
    "Accountant"    = "GRP_FINANCE;GRP_EMAIL_BASIC;GRP_FINANCE_SYSTEM"
}

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
$SimulatedUsers = @()

foreach ($Employee in $Employees) {

    $UserName = New-UserName -FirstName $Employee.FirstName -LastName $Employee.LastName
    $Groups = $RoleGroups[$Employee.JobTitle]

    switch ($Employee.Action) {

        "Joiner" {
            $Status = "Active"
            $Details = "Account created and groups assigned"
        }

        "Mover" {
            $Status = "Active - Updated Role"
            $Details = "Role updated and access modified"
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
Write-Host "Generated users file: $DataFile"
Write-Host "Generated audit log : $LogFile"