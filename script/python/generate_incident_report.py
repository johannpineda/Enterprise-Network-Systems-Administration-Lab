#!/usr/bin/env python3
"""Generate a consistent Markdown incident report from structured JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def bullets(items: list[str]) -> str:
    return "\n".join(f"- {item}" for item in items) or "- None recorded"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    data = json.loads(args.input.read_text(encoding="utf-8"))
    required = ("incident_id", "title", "severity", "status", "summary")
    missing = [key for key in required if not data.get(key)]
    if missing:
        parser.error(f"missing required fields: {', '.join(missing)}")

    timeline_rows = "\n".join(
        f"| {item.get('time', '')} | {item.get('phase', '')} | {item.get('action', '')} |"
        for item in data.get("timeline", [])
    ) or "| — | — | No timeline entries recorded |"
    report = f"""# Incident Report — {data['incident_id']}

## Executive Summary

{data['summary']}

| Field | Value |
|---|---|
| Incident | {data['title']} |
| Severity | {data['severity']} |
| Status | {data['status']} |
| Detected | {data.get('detected_at', 'Not recorded')} |
| Closed | {data.get('closed_at', 'Not recorded')} |
| Affected asset | {data.get('affected_asset', 'Not recorded')} |

## Timeline

| Time | Phase | Action |
|---|---|---|
{timeline_rows}

## Evidence

{bullets(data.get('evidence', []))}

## Root Cause

{data.get('root_cause', 'Not determined')}

## Containment and Recovery

{bullets(data.get('containment_and_recovery', []))}

## Preventive Actions

{bullets(data.get('preventive_actions', []))}

## Lessons Learned

{data.get('lessons_learned', 'No lessons recorded')}
"""
    args.output.write_text(report, encoding="utf-8")
    print(f"Created {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

