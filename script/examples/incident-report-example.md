# Incident Report — INC-2026-004

## Executive Summary

Monitoring identified repeated failed sign-ins against an approved lab account. The activity was contained, validated as a controlled exercise, and closed without unauthorized access.

| Field | Value |
|---|---|
| Incident | Simulated repeated authentication failures |
| Severity | Medium |
| Status | Closed |
| Detected | 2026-09-17 14:22 UTC |
| Closed | 2026-09-17 16:10 UTC |
| Affected asset | WIN11-01 |

## Timeline

| Time | Phase | Action |
|---|---|---|
| 14:22 | Detection | Wazuh alert triggered. |
| 14:35 | Triage | Correlated Windows security events and source host. |
| 14:50 | Containment | Locked the test account and isolated the source client. |
| 15:30 | Recovery | Confirmed normal authentication and restored the client. |
| 16:10 | Review | Closed the exercise and documented lessons learned. |

## Evidence

- Windows Event ID 4625 records
- Wazuh alert export
- Source workstation logs

## Root Cause

Approved authentication-failure simulation using a dedicated lab account.

## Containment and Recovery

- Disabled the test account
- Isolated WIN11-01
- Validated normal service operation

## Preventive Actions

- Confirmed account-lockout policy
- Validated alert thresholds
- Updated response documentation

## Lessons Learned

Centralized event collection shortened the time required to correlate the account and source workstation.
