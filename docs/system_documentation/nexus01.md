## NEXUS01

### Purpose
NEXUS01 is the utility and automation host in the AzureUser lab environment, providing centralized TACACS+ network device authentication, Ansible-based agent deployment, and network OS imaging via FOG.

---

## TACACS+

### Overview
TACACS+ (tac_plus-ng) provides centralized authentication and privilege-level authorization for network devices in the AzureUser environment. Authentication is delegated to Active Directory via SSSD and PAM (pammavis, a MAVIS module for PAM integration - see [pammavis documentation](https://projects.pro-bono-publico.de/event-driven-servers/doc/tac_plus-ng.html) for details). This is done to eliminate local credential management. 

### AD Group Integration
AD group membership is resolved at authentication time through two MAVIS modules:

- **groups module**: Resolves AD group membership, storing results in the `TACMEMBER` attribute. Only members of `gg_network_admins` or `gg_network_readonly` are processed.
- **external module**: Invokes `pammavis` against the `tacacs` PAM service (`/etc/pam.d/tacacs`), which authenticates via `pam_sss.so` and enforces group membership using `pam_succeed_if`. see [cat-etc-pam.d-tacacs.txt](../../configs/servers/NEXUS01/command-outputs/tacacs+%20NG/cat-etc-pam.d-tacacs.txt) for config.

### Authorization Profiles
Device access is controlled by two profiles applied via group-based ruleset evaluation:

| AD Group | Profile | Privilege Level | Shell Access |
|---|---|---|---|
| `gg_network_admins` | `admin` | 15 | Full |
| `gg_network_readonly` | `readonly` | 1 | Shell only |

The `admin` profile permits all commands; `readonly` permits shell login only and denies other services. The device global block accepts connections from `0.0.0.0/0` on port 49.

Authentication, authorization, and accounting events are logged to `/var/log/tac_plus/authc.log`, `/var/log/tac_plus/authz.log`, and `/var/log/tac_plus/acct.log`.

See `tac_plus-ng.cfg` and `/etc/pam.d/tacacs` for configuration details and **validation.md** for verification procedures.

---

## Ansible

### Overview
NEXUS01 hosts the Ansible control node used to deploy and configure monitoring agents across the environment. The wazuh-ansible vendor collection is bundled under `vendor/wazuh-ansible/` and referenced directly via `roles_path`. All plays connect as the `ansible` remote user with privilege escalation to root via sudo.

### Wazuh Agent Deployment
The `wazuh-agent.yml` playbook targets the `wazuh_agents` inventory group using the `ansible-wazuh-agent` role. Agent registration and communication are directed to WAZ01 (`10.10.10.50`):

- **Manager connection**: TCP port 1514
- **Agent registration (authd)**: Port 1515, SSL auto-negotiate disabled

### Zabbix Agent Deployment
The `zabbix-agent.yml` playbook targets the `zabbix_agents` inventory group using the `zabbix.zabbix.agent` role. Agents are configured to report to ZBX01 (`10.10.10.40`) with the following parameters:

- **Agent variant**: 2 (Zabbix Agent 2)
- **Version**: 6.0
- **Host metadata**: `linux-servers`

> **Note**: The `zabbix.zabbix.agent` role was not usable against the Proxmox host (PVE2) due to its Debian 13 (Trixie) base, which falls outside zabbix's documented support matrix. Zabbix agent deployment on PVE2 was performed using the official Zabbix Debian 13 repository via a custom playbook. See `limitation_notes.md` for details.

See `ansible.cfg`, `inventory.ini`, `wazuh-agent.yml`, and `zabbix-agent.yml` for configuration details and **validation.md** for verification procedures.

---

## FOG Server

### Overview
FOG is installed on NEXUS01 and provides network-based OS imaging and deployment capabilities for the lab environment.

> **Note**: Configuration files for FOG have not been captured at this stage. This section will be expanded in a future update. See the `evidence/` folder for web UI confirmation.

---

### Considerations for Production
- The device global block in `tac_plus-ng.cfg` uses `address = 0.0.0.0/0`; production deployments should scope this to known network device management addresses.
