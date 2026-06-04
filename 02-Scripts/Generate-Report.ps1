$ProjectRoot = "C:\Projects\IAM-Lifecycle-Healthcare-Automation"

$UsersFile = "$ProjectRoot\03-Data\simulated_users.csv"
$ReportFile = "$ProjectRoot\05-Reports\Healthcare-IAM-Lifecycle-Report.html"

$Users = Import-Csv $UsersFile

$Joiners = ($Users | Where-Object {$_.Action -eq "Joiner"}).Count
$Movers  = ($Users | Where-Object {$_.Action -eq "Mover"}).Count
$Leavers = ($Users | Where-Object {$_.Action -eq "Leaver"}).Count

$Date = Get-Date

$Table = $Users | ConvertTo-Html -Fragment

$HTML = @"
<html>
<head>
<title>Healthcare IAM Lifecycle Report</title>

<style>
body {
    font-family: Arial;
    margin: 30px;
}

h1 {
    color: darkblue;
}

table {
    border-collapse: collapse;
    width: 100%;
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
</style>

</head>

<body>

<h1>Healthcare IAM Lifecycle Report</h1>

<p><b>Execution Date:</b> $Date</p>

<h2>Summary</h2>

<ul>
<li>Joiners : $Joiners</li>
<li>Movers : $Movers</li>
<li>Leavers : $Leavers</li>
</ul>

<h2>Employee Lifecycle Details</h2>

$Table

</body>
</html>
"@

$HTML | Out-File $ReportFile

Write-Host ""
Write-Host "Report generated:"
Write-Host $ReportFile
Write-Host ""