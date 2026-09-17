# Sanitized pfSense Firewall Rules

This representation intentionally excludes passwords, certificates, keys, MAC addresses, and live public addresses.

| Interface | Action | Protocol | Source | Destination | Port | Log | Description |
|---|---|---|---|---|---:|---|---|
| LAN | Pass | TCP/UDP | LAN net | `192.168.10.10` | 53 | No | Allow internal DNS |
| LAN | Pass | TCP | Admin host | `192.168.10.1` | 443 | Yes | Allow firewall administration |
| LAN | Pass | TCP | LAN net | Any | 80,443 | No | Allow web traffic |
| LAN | Pass | Any | Established | Any | Any | No | Allow established traffic |
| LAN | Block | TCP | LAN net | Management | 22 | Yes | Block unauthorized management |
| LAN | Block | Any | Any | Any | Any | Yes | Default deny |

