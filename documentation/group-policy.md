# Group Policy

| GPO | Link | Key settings | Validation |
|---|---|---|---|
| Default Domain Policy | Domain | Password, lockout, Kerberos | `gpresult /r` |
| Workstation Security Baseline | Workstations OU | Defender, firewall, audit, screen lock | Resultant Set of Policy |
| PowerShell Logging | Workstations and Servers | Script-block logging, transcription | Event Viewer and transcript |
| Restricted Administrators | Workstations OU | Controlled local administrators | Local group membership |

GPOs were tested in a dedicated validation OU before broader linking. `gpupdate /force` and `gpresult /h` were used to confirm application.

