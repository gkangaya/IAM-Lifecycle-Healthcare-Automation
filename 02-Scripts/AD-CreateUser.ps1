# Healthcare IAM Lifecycle Automation
# Phase 2.5 - Create AD User Module

function New-IAMADUser {

    param(
        [string]$FirstName,
        [string]$LastName,
        [string]$Department,
        [string]$JobTitle,
        [string]$EmployeeOU
    )

    $UserName = (($FirstName.Substring(0,1)) + $LastName).ToLower()

    New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $UserName `
        -UserPrincipalName "$UserName@hospital.local" `
        -Department $Department `
        -Title $JobTitle `
        -Path $EmployeeOU `
        -AccountPassword (ConvertTo-SecureString "P@ssword123!" -AsPlainText -Force) `
        -Enabled $true

    Write-Host "User created: $UserName"

    return $UserName
}