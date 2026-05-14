## ZBX01

### System Summary

| Item | Value |
|---|---|
| Hostname | ZBX01 |
| FQDN | zbx01.corp.azureuser.org |
| Role | Zabbix monitoring server |
| OS | Ubuntu Server 20.04 LTS |
| IP Address | 10.10.10.40 |
| VLAN | VLAN 10 - Servers |
| Hosted On | PVE1 |
| Application | Zabbix 7.4.7 |
| Database | MySQL |
| Web Frontend | nginx |
### Purpose
ZBX01 is the dedicated Zabbix host in this environment, providing centralized infrastructure monitoring, alerting, and performance visibility to all VMs and network devices.

**Host Access Control**
- **Authentication**: Managed via SSSD with corporate Active Directory integration. Only members of `GG_Server_Admins` and `GG_IT_Infrastructure` are permitted to log in.
- **Authorization**: `GG_Server_Admins` has root privileges; `GG_IT_Infrastructure` has login-only access.

---

## Zabbix Platform

### Overview
Zabbix 7.4.7 delivers centralized metric collection, threshold-based alerting, and infrastructure visibility across the environment. The server, web frontend (nginx), and database (MySQL) are co-located on ZBX01 for lab purposes; production deployments typically separate these components.

See `Sanitized_zabbix_server_conf.txt` for full configuration details and **validation.md** for verification procedures.

### LDAP / Active Directory Integration
Directory-backed authentication with JIT provisioning eliminates local user management:

- **Authentication**: LDAPS on port 636, binding to `dc02.corp.azureuser.org` with a fallback to `dc01.corp.azureuser.org`. User identity is resolved using `sAMAccountName` as the search attribute against `DC=corp,DC=azureuser,DC=org`.
- **Bind account**: `svc.zabbix`.
- **JIT provisioning**: Enabled with a provisioning period of 1 hour. Accounts are created automatically on first login based on AD group membership.
- **Role mappings**: `GG_SIEM_Admins` maps to the SIEM Admins user group with Admin role, and `GG_IT_Security` maps to IT_Security_ReadOnly with User role.

See `ldap_server_auth_settings.png` for configuration details and **validation.md** for verification procedures.

### Auto-Registration
Active agent auto-registration automatically adds hosts when the Zabbix agent first connects, using `HostMetadata` to classify the host type.

| Rule | Metadata Match | Template | Host Tags | Notifications |
|---|---|---|---|---|
| `linux-servers` | `linux` | Linux by Zabbix agent active | — | SIEM Admins, Zabbix administrators |
| `windows-servers` | `server` | Windows by Zabbix agent active | — | SIEM Admins, Zabbix administrators |
| `windows-workstations` | `Workstation` | Windows by Zabbix agent active | Windows, Workstation | SIEM Admins, Zabbix administrators |

### Alerting
Alerts are forwarded to Slack via trigger actions and user media:

- **Trigger action**: `Report problems to Zabbix administrators` fires when trigger severity is ≥ *High*, sending a message to the **Zabbix administrators** user group via Slack.
- **User media**: Slack channel `#zabbix`, active 1–7 / 00:00–24:00, enabled for severities Warning, Average, High, and Disaster.

See `zbx_export_mediatypes.yaml` for configuration details and **validation.md** for verification procedures.

See `zabbix_host_inventory.md` for the full host inventory, interface types, assigned templates, and host tags.

### Considerations for Production

- Database, Manager and web frontend should be separated from the Zabbix server process in a production deployment.
- In a larger environment, consider using multiple zabbix indexers to offload data collection and reduce load on the central server.