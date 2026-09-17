# Active Directory Design

## Forest and domain

- Forest: `corp.example.test`
- NetBIOS name: `CORP`
- Domain controller: `DC01`
- DNS: Active Directory-integrated

## OU hierarchy

```text
corp.example.test
├── Admin
│   ├── Administrative Users
│   └── Service Accounts
├── Users
│   ├── Finance
│   ├── Human Resources
│   └── Information Technology
├── Computers
│   ├── Workstations
│   └── Servers
└── Groups
```

## Access model

| Group | Purpose |
|---|---|
| `GG-IT-Admins` | Privileged infrastructure administration |
| `GG-Helpdesk` | Delegated endpoint support |
| `GG-Finance-Users` | Finance resource access |
| `GG-HR-Users` | Human Resources resource access |
| `GG-Workstation-Users` | Standard domain workstation access |

Permissions are assigned to groups, not directly to users. Administrators use separate standard and privileged accounts. Service accounts are non-interactive and documented by owner and purpose.

