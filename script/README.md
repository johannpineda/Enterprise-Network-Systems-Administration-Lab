# Lab Automation Scripts

This folder contains the automation used to provision, validate, protect, and document the Enterprise Network & Systems Administration Lab.

## Included tools

| Script | Purpose |
|---|---|
| `powershell/Test-LabHealth.ps1` | Validates gateway, DNS, domain, DHCP, services, disk space, and monitored hosts |
| `powershell/Initialize-ActiveDirectory.ps1` | Creates the documented OU and security-group structure safely and idempotently |
| `powershell/Invoke-LabBackup.ps1` | Exports DHCP, DNS, GPO, system information, and file-based configuration artifacts |
| `powershell/Export-LabEvidence.ps1` | Produces timestamped HTML and text evidence for portfolio documentation |
| `python/verify_backups.py` | Creates and verifies SHA-256 backup manifests |
| `python/analyze_auth_events.py` | Summarizes Windows authentication events exported as CSV |
| `python/generate_incident_report.py` | Converts structured incident JSON into a professional Markdown report |

## Requirements

- Windows Server 2019/2022
- PowerShell 5.1 or later
- ActiveDirectory, DhcpServer, DnsServer, and GroupPolicy modules for role-specific tasks
- Python 3.10 or later for the Python utilities
- Administrator privileges for server exports

## Safe usage

Preview Active Directory changes first:

```powershell
.\powershell\Initialize-ActiveDirectory.ps1 -WhatIf
```

Run a health assessment and export the result:

```powershell
.\powershell\Test-LabHealth.ps1 -OutputPath .\output\lab-health.json
```

Run the backup workflow:

```powershell
.\powershell\Invoke-LabBackup.ps1 -BackupRoot D:\LabBackups
```

Create and verify checksums:

```bash
python python/verify_backups.py create D:\LabBackups\2026-09-17_010000
python python/verify_backups.py verify D:\LabBackups\2026-09-17_010000
```

Generate an incident report:

```bash
python python/generate_incident_report.py incident.json incident-report.md
```

All example addresses and names match the documented lab: `corp.example.test`, `DC01`, `WIN11-01`, `WAZUH01`, and `192.168.10.0/24`.

