# CHG-001 — Restrict Firewall Management Access

| Field | Value |
|---|---|
| Status | Completed |
| Risk | Medium |
| System | FW01 / pfSense |
| Window | 2026-09-17 18:00–18:30 UTC |
| Owner | Lab Administrator |

## Business reason

Restrict pfSense administration to approved LAN management traffic and log unauthorized SSH attempts.

## Implementation

1. Exported the current pfSense configuration.
2. Added a pass rule for HTTPS from the administrative host to `192.168.10.1:443`.
3. Added a logged block rule for unauthorized SSH access to management services.
4. Placed the explicit rules above the default deny rule.
5. Applied the rules and cleared test states.

## Validation

- Approved HTTPS administration succeeded.
- Unauthorized SSH was blocked and logged.
- DNS and web traffic remained operational.
- No unexpected deny events were observed.

## Rollback

Restore the pre-change configuration export or disable the two new rules and reapply the prior rule set.

## Result

Successful. No rollback required.

