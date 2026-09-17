# Firewall Rules

Rules are evaluated top-to-bottom. Access follows least privilege and all administrative services remain LAN-only.

| Order | Action | Source | Destination | Port | Purpose |
|---:|---|---|---|---:|---|
| 10 | Pass | `LAN net` | `192.168.10.10` | 53 TCP/UDP | Internal DNS |
| 20 | Pass | Admin host | `192.168.10.1` | 443 TCP | pfSense administration |
| 30 | Pass | `LAN net` | Any | 80,443 TCP | Web access |
| 40 | Pass | Established | Any | Any | Return traffic |
| 90 | Block/log | `LAN net` | Management services | 22 TCP | Unauthorized management |
| 100 | Block/log | Any | Any | Any | Default deny |

Changes require a recorded business reason, pre-change export, validation, and rollback plan.

