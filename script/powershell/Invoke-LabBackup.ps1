#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$BackupRoot,
    [string[]]$ConfigurationPaths = @(),
    [int]$RetentionDays = 30
)

$ErrorActionPreference = 'Stop'
$timestamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$destination = Join-Path $BackupRoot $timestamp
$logPath = Join-Path $destination 'backup.log'
New-Item -ItemType Directory -Path $destination -Force | Out-Null

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','SUCCESS','ERROR')][string]$Level = 'INFO')
    $line = '{0} [{1}] {2}' -f (Get-Date -Format 's'), $Level, $Message
    $line | Tee-Object -FilePath $logPath -Append
}

try {
    Write-Log "Backup started: $destination"
    Get-ComputerInfo | Out-File (Join-Path $destination 'computer-info.txt') -Encoding UTF8
    ipconfig /all | Out-File (Join-Path $destination 'network-config.txt') -Encoding UTF8

    if (Get-Command Export-DhcpServer -ErrorAction SilentlyContinue) {
        Export-DhcpServer -ComputerName $env:COMPUTERNAME -File (Join-Path $destination 'dhcp.xml') -Leases -Force
        Write-Log 'DHCP configuration exported.' 'SUCCESS'
    }
    if (Get-Command Export-DnsServerZone -ErrorAction SilentlyContinue) {
        Get-DnsServerZone | Where-Object { -not $_.IsAutoCreated } | ForEach-Object {
            $safeName = $_.ZoneName -replace '[^a-zA-Z0-9.-]', '_'
            Export-DnsServerZone -Name $_.ZoneName -FileName "$safeName.dns"
        }
        Write-Log 'DNS zones exported through the DNS service export directory.' 'SUCCESS'
    }
    if (Get-Command Backup-GPO -ErrorAction SilentlyContinue) {
        $gpoPath = Join-Path $destination 'gpo'
        New-Item -ItemType Directory -Path $gpoPath -Force | Out-Null
        Backup-GPO -All -Path $gpoPath | Out-Null
        Write-Log 'Group Policy Objects exported.' 'SUCCESS'
    }
    foreach ($path in $ConfigurationPaths) {
        if (Test-Path $path) {
            Copy-Item -Path $path -Destination $destination -Recurse -Force
            Write-Log "Copied configuration artifact: $path" 'SUCCESS'
        } else { Write-Log "Configuration path not found: $path" 'ERROR' }
    }

    Get-ChildItem -Path $destination -File -Recurse | Where-Object Name -ne 'SHA256SUMS.txt' |
        Get-FileHash -Algorithm SHA256 |
        ForEach-Object { "$($_.Hash)  $($_.Path.Substring($destination.Length + 1))" } |
        Set-Content (Join-Path $destination 'SHA256SUMS.txt') -Encoding UTF8
    Write-Log 'SHA-256 manifest created.' 'SUCCESS'

    Get-ChildItem -Path $BackupRoot -Directory |
        Where-Object LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) |
        ForEach-Object {
            Write-Log "Retention candidate retained for manual review: $($_.FullName)"
        }
    Write-Log 'Backup completed successfully.' 'SUCCESS'
} catch {
    Write-Log $_.Exception.Message 'ERROR'
    throw
}

