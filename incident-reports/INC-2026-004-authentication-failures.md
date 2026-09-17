# INC-2026-004 — Simulated Authentication Failures

| Field | Value |
|---|---|
| Severity | Medium |
| Status | Closed |
| Detected | 2026-09-17 14:22 UTC |
| Closed | 2026-09-17 16:10 UTC |
| Affected asset | WIN11-01 |

## Executive summary

Wazuh detected repeated Windows logon failures generated through an approved lab exercise. The event was correlated to WIN11-01 and a dedicated test account. The account and source workstation were contained, evidence was preserved, and normal operation was verified. No unauthorized access occurred.

## Timeline

| Time | Phase | Action |
|---|---|---|
| 14:22 | Detection | Wazuh generated an alert for repeated Event ID 4625 records. |
| 14:35 | Triage | Analyst correlated the account, source address, and workstation logs. |
| 14:50 | Containment | Test account disabled and WIN11-01 isolated. |
| 15:30 | Recovery | Client restored after validation; authentication tested. |
| 16:10 | Review | Exercise closed and lessons documented. |

## Root cause

Controlled authentication-failure activity using an approved test account.

## Evidence

- Windows Security Event ID 4625 records
- Wazuh alert export and agent timeline
- WIN11-01 PowerShell and system logs

## Preventive actions

- Confirmed account-lockout policy behavior.
- Validated Wazuh thresholds and notification routing.
- Updated the incident-response checklist.

