# Healthcare IAM Lifecycle Automation
# Phase 2.4 - HTML Report from Active Directory

Import-Module ActiveDirectory

$ProjectRoot = "C:\Projects\IAM-Lifecycle-Healthcare-Automation"

$AuditLogFile = "$ProjectRoot\04-Logs\ad_audit_log.csv"
$ReportFile   = "$ProjectRoot\05-Reports\Healthcare-IAM-AD-Lifecycle-Report.html"

$ActiveUsers = Get-ADUser -Filter * `
    -SearchBase "OU=Employees,DC=hospital,DC=local" `
    -Properties Department,Title,Enabled |
    Select-Object Name,SamAccountName,Department,Title,Enabled

$DisabledUsers = Get-ADUser -Filter * `
    -SearchBase "OU=Disabled Users,DC=hospital,DC=local" `
    -Properties Department,Title,Enabled,DistinguishedName |
    Select-Object Name,SamAccountName,Department,Title,Enabled,DistinguishedName

if (Test-Path $AuditLogFile) {
    $AuditLog = Import-Csv $AuditLogFile
}
else {
    $AuditLog = @()
}

$Joiners = ($AuditLog | Where-Object {$_.Action -eq "Joiner"}).Count
$Movers  = ($AuditLog | Where-Object {$_.Action -eq "Mover"}).Count
$Leavers = ($AuditLog | Where-Object {$_.Action -eq "Leaver"}).Count
$Errors  = ($AuditLog | Where-Object {$_.Status -eq "Error" -or $_.Status -eq "Validation Error"}).Count

$ActiveCount   = $ActiveUsers.Count
$DisabledCount = $DisabledUsers.Count
$Date = Get-Date

$ActiveUsersTable   = $ActiveUsers | ConvertTo-Html -Fragment
$DisabledUsersTable = $DisabledUsers | ConvertTo-Html -Fragment
$AuditLogTable      = $AuditLog | ConvertTo-Html -Fragment

$HTML = @"
<html>
<head>
<title>Healthcare IAM AD Lifecycle Report</title>
<style>
body {
    font-family: Arial;
    margin: 30px;
}
h1 {
    color: #1f4e79;
}
h2 {
    color: #1f4e79;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 30px;
}
th {
    background-color: #1f4e79;
    color: white;
    padding: 8px;
}
td {
    border: 1px solid #cccccc;
    padding: 8px;
}
.summary {
    background-color: #eef3f8;
    padding: 15px;
    border-left: 5px solid #1f4e79;
}
</style>
</head>

<body>

<h1>Healthcare IAM Active Directory Lifecycle Report</h1>

<p><b>Execution Date:</b> $Date</p>

<div class="summary">
<h2>Summary</h2>
<ul>
<li>Joiners processed: $Joiners</li>
<li>Movers processed: $Movers</li>
<li>Leavers processed: $Leavers</li>
<li>Errors / Validation Errors: $Errors</li>
<li>Active AD Users: $ActiveCount</li>
<li>Disabled AD Users: $DisabledCount</li>
</ul>
</div>

<h2>Active Directory Users - Employees OU</h2>
$ActiveUsersTable

<h2>Disabled Users - Disabled Users OU</h2>
$DisabledUsersTable

<h2>AD Lifecycle Audit Log</h2>
$AuditLogTable

</body>
</html>
"@

$HTML | Out-File $ReportFile

Write-Host ""
Write-Host "AD HTML report generated successfully:"
Write-Host $ReportFile
Write-Host ""