#Requires -Version 5.1
#Requires -Modules ActiveDirectory
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
param(
    [string]$DomainDn = 'DC=corp,DC=example,DC=test'
)

$ErrorActionPreference = 'Stop'
$organizationalUnits = @(
    @{ Name = 'Admin'; Path = $DomainDn },
    @{ Name = 'Users'; Path = $DomainDn },
    @{ Name = 'Computers'; Path = $DomainDn },
    @{ Name = 'Groups'; Path = $DomainDn },
    @{ Name = 'Administrative Users'; Path = "OU=Admin,$DomainDn" },
    @{ Name = 'Service Accounts'; Path = "OU=Admin,$DomainDn" },
    @{ Name = 'Finance'; Path = "OU=Users,$DomainDn" },
    @{ Name = 'Human Resources'; Path = "OU=Users,$DomainDn" },
    @{ Name = 'Information Technology'; Path = "OU=Users,$DomainDn" },
    @{ Name = 'Workstations'; Path = "OU=Computers,$DomainDn" },
    @{ Name = 'Servers'; Path = "OU=Computers,$DomainDn" }
)

foreach ($ou in $organizationalUnits) {
    $dn = "OU=$($ou.Name),$($ou.Path)"
    if (-not (Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($dn, 'Create organizational unit')) {
            New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -ProtectedFromAccidentalDeletion $true
        }
    } else { Write-Verbose "OU exists: $dn" }
}

$groups = @(
    @{ Name = 'GG-IT-Admins'; Description = 'Privileged IT administration' },
    @{ Name = 'GG-Helpdesk'; Description = 'Delegated workstation support' },
    @{ Name = 'GG-Finance-Users'; Description = 'Finance department users' },
    @{ Name = 'GG-HR-Users'; Description = 'Human Resources department users' },
    @{ Name = 'GG-Workstation-Users'; Description = 'Standard workstation access' }
)

$groupPath = "OU=Groups,$DomainDn"
foreach ($group in $groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($group.Name)'" -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($group.Name, 'Create security group')) {
            New-ADGroup -Name $group.Name -Path $groupPath -GroupScope Global -GroupCategory Security -Description $group.Description
        }
    } else { Write-Verbose "Group exists: $($group.Name)" }
}

Write-Host 'Active Directory structure validated successfully.' -ForegroundColor Green

