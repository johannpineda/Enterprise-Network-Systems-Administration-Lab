# Restore Test 001

| Field | Value |
|---|---|
| Date | 2026-09-17 |
| Backup set | `2026-09-17_010000` |
| Tester | Lab Administrator |
| Result | Passed |

## Scope

Validate the integrity and usability of the DHCP export, GPO backup, pfSense configuration archive, and documentation bundle.

## Procedure

1. Verified `SHA256SUMS.txt` against all backup files.
2. Restored files into an isolated validation directory.
3. Parsed the DHCP XML export and confirmed scope `192.168.10.0/24`.
4. Enumerated the GPO backup metadata.
5. Opened and validated the sanitized pfSense configuration archive.
6. Compared restored documentation with the source repository.

## Results

| Test | Result |
|---|---|
| Checksum verification | Pass |
| DHCP export readable | Pass |
| GPO metadata readable | Pass |
| pfSense archive readable | Pass |
| Documentation comparison | Pass |

## Conclusion

The selected backup set was recoverable. No corruption or missing artifacts were detected.

