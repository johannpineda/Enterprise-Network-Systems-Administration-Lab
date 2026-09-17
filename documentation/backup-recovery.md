# Backup and Recovery

## Protected data

- Active Directory system state
- DHCP configuration and leases
- DNS zones
- Group Policy Objects
- pfSense configuration export
- Wazuh and Grafana configuration
- Scripts and documentation

## Schedule and retention

| Job | Frequency | Retention |
|---|---|---|
| Configuration export | Daily at 01:00 | 30 days |
| System state | Weekly | 8 weeks |
| Restore validation | Monthly | 12 reports |

Every run produces a timestamped log and SHA-256 manifest. Recovery testing verifies file integrity, configuration readability, and restoration into an isolated validation location.

