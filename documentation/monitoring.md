# Monitoring

## Wazuh

Agents are grouped by workload:

- `Domain-Controllers`: DC01
- `Workstations`: WIN11-01
- `Monitoring-Servers`: WAZUH01

Collected events include authentication, account management, service state, PowerShell activity, policy changes, and selected firewall events. A controlled Windows Event ID 4625 test confirmed alert ingestion and triage.

## Grafana

The Enterprise Lab Overview dashboard presents:

- Host availability and uptime
- CPU, memory, disk, and network utilization
- AD DS and DNS service health
- Wazuh manager and agent connectivity
- Authentication failures
- Backup status and last-success timestamp

Alert thresholds emphasize sustained conditions rather than single transient spikes.

