# Host Inventory
 This document provides a comprehensive inventory of all hosts monitored within the AzureUser lab environment, including their IP addresses, interface types, assigned Zabbix templates, group memberships, operating systems/platforms, and descriptive tags. This inventory serves as a reference for monitoring scope, configuration management, and operational visibility across the environment.

## Summary

| Metric | Count |
|---|---|
| Total Hosts | 17 |
| Windows Hosts | 5 |
| Linux / BSD Hosts | 6 |
| Network Devices | 4 |
| Firewalls | 2 |

---

## Host Inventory Table

| Hostname | Display Name | IP Address | Interface Type | Template | Group(s) | OS / Platform | Description | Tags |
|---|---|---|---|---|---|---|---|---|
| ADM01 | ADM01 | 10.10.50.70 | Agent | Windows by Zabbix agent active | Virtual machines | Windows 10 Pro (Build 26200.8037) | Admin PC | Environment: Admin |
| ADM02 | ADM02 | 10.10.20.11 | Agent | Windows by Zabbix agent active | Discovered hosts, Virtual machines, Windows workstations | — | — | Windows: Workstation |
| CLT01-TEMP | CLT01-TEMP | 10.10.20.10 | Agent | Windows by Zabbix agent active | Discovered hosts, Virtual machines, Windows workstations | — | — | Windows: Workstation |
| DC01 | DC01 | 10.10.10.10 | Agent | Windows by Zabbix agent active | Virtual machines | Windows Server 2025 Standard Eval (Build 26100.32522) | Domain Controller | Server: Windows |
| DC02 | DC02 | 10.10.10.11 | Agent | Windows by Zabbix agent active | Discovered hosts, Virtual machines, Windows servers | — | — | — |
| NEXUS01 | NEXUS01 | 10.10.10.70 | Agent | Linux by Zabbix agent active | Discovered hosts, Linux servers | — | — | — |
| PFS01 | PFS01 | 10.10.254.4 | Agent | FreeBSD by Zabbix agent | Discovered hosts | FreeBSD 15.0-CURRENT (pfSense 2.8.1) | — | Firewall: PfSense-01 |
| PFS02 | PFS02 | 10.10.254.6 | Agent | — | Discovered hosts | — | — | Firewall: PfSense-02 |
| PVE1 | PVE1 | 10.10.50.5 | Agent | Linux by Zabbix agent active | Hypervisors | Linux 6.17.13-1-pve (Proxmox, GCC 14.2.0) | — | — |
| PVE2 | PVE2 | 10.10.50.6 | Agent | Linux by Zabbix agent active | Discovered hosts, Linux servers | — | — | — |
| R1-CORE | R1-CORE | 10.10.10.2 | SNMP v3 (port 161) | Cisco IOS by SNMP | Core Cisco Routers | Cisco IOS 15.4(3)M3 | R1-CORE | — |
| R2-CORE | R2-CORE | 10.10.10.3 | SNMP v3 (port 161) | Cisco IOS by SNMP | Core Cisco Routers | — | R2-CORE Router | — |
| SW1 | SW1 | 10.10.50.9 | SNMP v3 (port 161) | Cisco IOS by SNMP | Discovered hosts, Switches | Cisco IOS 15.0(2)SE10a | — | Network: Switch |
| SW2 | SW2 | 10.10.50.10 | SNMP v3 (port 161) | Cisco IOS by SNMP | Discovered hosts, Switches | Cisco IOS 15.0(2)SE10a | — | Network: Switch |
| WAZ01 | WAZ01 | 10.10.10.50 | Agent | Linux by Zabbix agent active | Linux servers | — | — | — |
| ZBX01 | Zabbix Server 01 | — | Agent | Linux by Zabbix agent, Zabbix server health | Zabbix servers | Linux 6.8.0-107-generic (Ubuntu 24.04) | — | — |

See [zbx_export_hosts.yaml](../configs/servers/ZBX01/command-outputs/zbx_export_hosts.yaml) for the full inventory export in YAML format.
