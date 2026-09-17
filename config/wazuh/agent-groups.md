# Wazuh Agent Groups

| Group | Agent | Address | Purpose |
|---|---|---:|---|
| Domain-Controllers | DC01 | `192.168.10.10` | AD DS, DNS, DHCP monitoring |
| Workstations | WIN11-01 | DHCP | Endpoint and authentication monitoring |
| Monitoring-Servers | WAZUH01 | `192.168.10.20` | Manager self-monitoring |

## Validated alert

- Source: WIN11-01
- Event: Windows Event ID 4625
- Rule: Multiple failed logon attempts
- MITRE ATT&CK: T1110 — Brute Force
- Result: Investigated and confirmed as an approved lab simulation

