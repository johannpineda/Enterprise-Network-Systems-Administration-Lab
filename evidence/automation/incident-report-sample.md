# Incident Report — INC-2026-004

## Executive Summary

Wazuh detected repeated failed authentication attempts from WIN11-01 against an approved lab account. The event was investigated, contained, and closed without unauthorized access.

| Field | Value |
|---|---|
| Severity | Medium |
| Status | Closed |
| Affected asset | WIN11-01 |
| Detection source | Wazuh / Windows Event ID 4625 |
| MITRE ATT&CK | T1110 — Brute Force |

## Outcome

- Test account disabled during containment
- Source workstation isolated and validated
- Normal authentication restored
- Alert thresholds and lockout policy confirmed
- Lessons learned added to the response procedure

