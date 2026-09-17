#!/usr/bin/env python3
"""Create or verify a portable SHA-256 manifest for a backup directory."""

from __future__ import annotations

import argparse
import hashlib
import sys
from pathlib import Path

MANIFEST = "SHA256SUMS.txt"


def digest(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


def files_under(root: Path):
    return sorted(
        (path for path in root.rglob("*") if path.is_file() and path.name != MANIFEST),
        key=lambda path: path.relative_to(root).as_posix(),
    )


def create(root: Path) -> int:
    entries = [f"{digest(path)}  {path.relative_to(root).as_posix()}" for path in files_under(root)]
    (root / MANIFEST).write_text("\n".join(entries) + "\n", encoding="utf-8")
    print(f"Created {MANIFEST} with {len(entries)} entries.")
    return 0


def verify(root: Path) -> int:
    manifest = root / MANIFEST
    if not manifest.is_file():
        print(f"ERROR: {manifest} does not exist.", file=sys.stderr)
        return 2
    failures = 0
    checked = 0
    for line in manifest.read_text(encoding="utf-8-sig").splitlines():
        if not line.strip():
            continue
        expected, relative = line.split("  ", 1)
        candidate = root / relative
        checked += 1
        if not candidate.is_file():
            print(f"MISSING  {relative}")
            failures += 1
        elif digest(candidate).lower() != expected.lower():
            print(f"FAILED   {relative}")
            failures += 1
        else:
            print(f"OK       {relative}")
    print(f"Verified {checked} files; failures: {failures}.")
    return 1 if failures else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("create", "verify"))
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    root = args.directory.resolve()
    if not root.is_dir():
        parser.error(f"not a directory: {root}")
    return create(root) if args.action == "create" else verify(root)


if __name__ == "__main__":
    raise SystemExit(main())

