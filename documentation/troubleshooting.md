# Troubleshooting Guide

## Client cannot reach the internet

1. Confirm DHCP address, gateway, and DNS with `ipconfig /all`.
2. Ping `192.168.10.1`.
3. Review pfSense interface status and LAN rules.
4. Test IP connectivity separately from DNS resolution.

## Client cannot join the domain

1. Confirm the client uses `192.168.10.10` for DNS.
2. Run `nslookup dc01.corp.example.test`.
3. Confirm time synchronization.
4. Review DC01 DNS, Netlogon, and AD DS services.

## Group Policy does not apply

1. Run `gpupdate /force` and `gpresult /r`.
2. Confirm the computer or user is in the linked OU.
3. Review security filtering and inheritance.
4. Inspect the GroupPolicy operational event log.

## Wazuh agent is disconnected

1. Confirm hostname and IP reachability.
2. Validate required ports and firewall rules.
3. Restart the agent service.
4. Review agent and manager logs for enrollment or key errors.

