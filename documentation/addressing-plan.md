# Addressing Plan

## IPv4 network

| Field | Value |
|---|---|
| Network | `192.168.10.0/24` |
| Usable range | `192.168.10.1–192.168.10.254` |
| Default gateway | `192.168.10.1` |
| DNS server | `192.168.10.10` |
| DHCP range | `192.168.10.100–192.168.10.199` |
| DNS suffix | `corp.example.test` |

## Host assignments

| Host | Address | Assignment | Role |
|---|---:|---|---|
| FW01 | `192.168.10.1` | Static | pfSense LAN gateway |
| DC01 | `192.168.10.10` | Static | Domain controller, DNS, DHCP |
| WAZUH01 | `192.168.10.20` | Static | Monitoring and dashboards |
| WIN11-01 | `192.168.10.100` | DHCP lease | Managed workstation |

The WAN example uses RFC 5737 documentation space and does not expose a real public address.

