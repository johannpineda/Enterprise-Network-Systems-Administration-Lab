#!/usr/bin/env python3
"""Summarize Windows logon events exported from Event Viewer as CSV."""

from __future__ import annotations

import argparse
import csv
import json
from collections import Counter
from pathlib import Path

FAILED_LOGON = "4625"
SUCCESSFUL_LOGON = "4624"


def value(row: dict[str, str], *names: str) -> str:
    lowered = {key.lower(): val for key, val in row.items()}
    for name in names:
        if name.lower() in lowered:
            return lowered[name.lower()]
    return "Unknown"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="CSV exported from Windows Event Viewer")
    parser.add_argument("--output", type=Path, default=Path("auth-summary.json"))
    args = parser.parse_args()

    event_counts: Counter[str] = Counter()
    users: Counter[str] = Counter()
    sources: Counter[str] = Counter()
    total = 0
    with args.input.open(newline="", encoding="utf-8-sig") as handle:
        for row in csv.DictReader(handle):
            event_id = value(row, "Event ID", "Id", "EventID")
            if event_id not in {FAILED_LOGON, SUCCESSFUL_LOGON}:
                continue
            total += 1
            event_counts[event_id] += 1
            users[value(row, "User", "Account Name", "TargetUserName")] += 1
            sources[value(row, "Source Address", "IpAddress", "Source Network Address")] += 1

    report = {
        "events_analyzed": total,
        "successful_logons": event_counts[SUCCESSFUL_LOGON],
        "failed_logons": event_counts[FAILED_LOGON],
        "top_accounts": users.most_common(10),
        "top_source_addresses": sources.most_common(10),
    }
    args.output.write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

