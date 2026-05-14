## WAZ01

### Purpose
WAZ01 is the dedicated Wazuh host in the AzureUser lab environment, providing centralized SIEM and security monitoring.

**Host Access Control**
- **Authentication**: Managed via SSSD with corporate Active Directory integration. Only members of `GG_Server_Admins` and `GG_Infrastructure` are permitted to log in.
- **Authorization**: `GG_Server_Admins` has root privileges; `GG_Infrastructure` has login-only access.

---

## Wazuh Platform

### Overview
Wazuh (v 4.14) delivers centralized log collection, analysis, alerting, and security event visibility across the environment. The stack (manager, indexer, and dashboard) is co-located on WAZ01 for lab purposes; production deployments distribute these components across separate hosts.

### LDAP/Active Directory Integration
Directory-backed authentication and group-based authorization eliminate local user management:

- **Authentication**: LDAPS with trusted CA certificates, binding to DC01 and DC02 on port 636. User identity is resolved by searching the corporate Users OU using `sAMAccountName` as the login attribute.
- **Authorization**: Derives roles from AD group membership by searching the corporate Groups OU using `rolesearch: '(member={0})'`. Nested group resolution (`resolve_nested_roles: true`) enables users to inherit permissions from groups-within-groups automatically.
- **Role mappings**: `GG_SIEM_Admins` → `LDAP_SIEM_Admins` (`administrator`) and `GG_IT_Security` → `LDAP_IT_Security` (`readonly`) at the dashboard level. At the indexer level, `roles_mapping.yml` maps `GG_SIEM_Admins`, `GG_Server_Admins`, `GG_IT_Security`, and `admin` to the `all_access` role.


See `config.yml` for configuration details and **validation.md** for verification procedures.

### Slack Integration
Alerts are forwarded via two complementary mechanisms:

- **Real-time forwarding**: Native integration sends alerts ≥ level 10 directly to Slack in JSON format.
- **Burst detection**: Indexer-level monitor detects sustained alert spikes (5+ alerts from a single agent within 5 minutes) and routes notifications to wazuh-alerts Slack channel.

See `ossec.conf` and `custom_high_alert_burst_agent.json` for configuration details and **validation.md** for verification procedures.

### Custom pfSense Rules and Decoders
Custom decoder and six rules handle RFC 5424 formatted firewall logs, enabling meaningful firewall alerting:

| Rule ID | Description | Level |
|---|---|---|
| 100200 | Base filterlog event | 2 |
| 100201 | Allow event | 3 |
| 100202 | Block event | 5 |
| 100203 | Block on sensitive ports (22, 80, 443, 3389, etc.) | 7 |
| 100204 | Possible brute force (6+ blocks from same source in 60s) | 10 |
| 100205 | Possible port scan (10+ blocks across ports in 60s) | 10 |
| 100206 | Possible reconnaissance (15+ blocks across hosts in 120s) | 12 |

pfSense logs are ingested agentlessly via UDP 514 from `10.10.254.4`.

See `local_decoder.xml` and `local_rules.xml` for configuration details and **validation.md** for verification procedures.

### Considerations for Production

- Slack alert threshold should be raised to level 12 to reduce noise.
- Burst detection monitor should use wildcard index patterns (`wazuh-alerts-4.x-*`).
- Wazuh components should be distributed across separate hosts for scalability and redundancy.
