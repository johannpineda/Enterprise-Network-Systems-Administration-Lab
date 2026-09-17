#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$DomainName = 'corp.example.test',
    [string]$DnsServer = '192.168.10.10',
    [string]$Gateway = '192.168.10.1',
    [string[]]$Hosts = @('DC01', 'WIN11-01', 'WAZUH01'),
    [string]$OutputPath = '.\output\lab-health.json'
)

$ErrorActionPreference = 'Stop'
$results = [System.Collections.Generic.List[object]]::new()

function Add-Check {
    param([string]$Name, [bool]$Passed, [string]$Details)
    $results.Add([pscustomobject]@{
        Check = $Name
        Status = if ($Passed) { 'PASS' } else { 'FAIL' }
        Details = $Details
        Timestamp = (Get-Date).ToString('o')
    })
}

try {
    $gatewayUp = Test-Connection -ComputerName $Gateway -Count 2 -Quiet
    Add-Check 'Default gateway reachable' $gatewayUp $Gateway
} catch { Add-Check 'Default gateway reachable' $false $_.Exception.Message }

try {
    $dnsResult = Resolve-DnsName -Name $DomainName -Server $DnsServer -ErrorAction Stop
    Add-Check 'Internal DNS resolution' ($null -ne $dnsResult) "$DomainName via $DnsServer"
} catch { Add-Check 'Internal DNS resolution' $false $_.Exception.Message }

try {
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    Add-Check 'Domain membership' ($computerSystem.Domain -eq $DomainName) "Current domain: $($computerSystem.Domain)"
} catch { Add-Check 'Domain membership' $false $_.Exception.Message }

foreach ($hostName in $Hosts) {
    try {
        $reachable = Test-Connection -ComputerName $hostName -Count 1 -Quiet
        Add-Check "Host reachable: $hostName" $reachable $hostName
    } catch { Add-Check "Host reachable: $hostName" $false $_.Exception.Message }
}

foreach ($serviceName in @('DNS', 'DHCPServer', 'NTDS')) {
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop
        Add-Check "Service running: $serviceName" ($service.Status -eq 'Running') $service.Status.ToString()
    } catch { Add-Check "Service running: $serviceName" $false 'Service unavailable on this host' }
}

try {
    $systemDrive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freePercent = [math]::Round(($systemDrive.FreeSpace / $systemDrive.Size) * 100, 1)
    Add-Check 'System drive free space' ($freePercent -ge 20) "$freePercent% free"
} catch { Add-Check 'System drive free space' $false $_.Exception.Message }

$parent = Split-Path -Parent $OutputPath
if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
$summary = [pscustomobject]@{
    GeneratedAt = (Get-Date).ToString('o')
    Computer = $env:COMPUTERNAME
    Passed = @($results | Where-Object Status -eq 'PASS').Count
    Failed = @($results | Where-Object Status -eq 'FAIL').Count
    Checks = $results
}
$summary | ConvertTo-Json -Depth 5 | Set-Content -Path $OutputPath -Encoding UTF8
$results | Format-Table -AutoSize
if ($summary.Failed -gt 0) { exit 1 }

