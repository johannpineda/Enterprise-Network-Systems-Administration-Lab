#Requires -Version 5.1
[CmdletBinding()]
param([string]$OutputDirectory = '.\evidence')

$ErrorActionPreference = 'Continue'
$stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$target = Join-Path $OutputDirectory $stamp
New-Item -ItemType Directory -Path $target -Force | Out-Null

Get-ComputerInfo | ConvertTo-Html -Title 'Windows Server System Evidence' |
    Set-Content (Join-Path $target 'system-information.html') -Encoding UTF8
Get-NetIPConfiguration | Format-List * |
    Out-File (Join-Path $target 'network-configuration.txt') -Encoding UTF8
Get-Service | Sort-Object Status, DisplayName | ConvertTo-Html -Title 'Service Status Evidence' |
    Set-Content (Join-Path $target 'services.html') -Encoding UTF8
gpresult /h (Join-Path $target 'group-policy.html') /f | Out-Null
dcdiag /v | Out-File (Join-Path $target 'domain-controller-diagnostics.txt') -Encoding UTF8

if (Get-Command Get-ADOrganizationalUnit -ErrorAction SilentlyContinue) {
    Get-ADOrganizationalUnit -Filter * -Properties CanonicalName |
        Select-Object Name, DistinguishedName, CanonicalName |
        Export-Csv (Join-Path $target 'active-directory-ous.csv') -NoTypeInformation
}
if (Get-Command Get-DhcpServerv4Lease -ErrorAction SilentlyContinue) {
    Get-DhcpServerv4Scope | ForEach-Object { Get-DhcpServerv4Lease -ScopeId $_.ScopeId } |
        Export-Csv (Join-Path $target 'dhcp-leases.csv') -NoTypeInformation
}

Write-Host "Evidence exported to $target" -ForegroundColor Green

