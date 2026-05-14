
# AzureUser.org Infrastructure Documentation

## Overview

This repository documents **corp.azureuser.org**, an ongoing enterprise-style lab environment built to demonstrate systems administration, network engineering, security monitoring, virtualization, automation, and technical documentation skills.

The lab includes redundant routing, pfSense firewall high availability, Active Directory domain services, Group Policy baselines, centralized monitoring, SIEM visibility, TACACS+ network device authentication, and validation tracking.

Sensitive credentials, secrets, private keys, and raw passwords are excluded or sanitized.

---

## Architecture at a Glance

| Area | Implementation |
|---|---|
| Domain | `corp.azureuser.org` / CORP NetBIOS |
| Routing | Dual Cisco core routers with inter-VLAN routing and HSRP |
| Switching | Cisco access/distribution switches with VLANs, trunks, LACP, DHCP snooping, and DAI |
| Firewall | pfSense CARP HA pair with NAT, DNS enforcement, and pfBlockerNG |
| Identity | Active Directory, DNS, DHCP, Group Policy, PKI |
| Virtualization | Proxmox VE and VMware ESXi |
| Monitoring | Zabbix infrastructure monitoring |
| SIEM | Wazuh log collection, alerting, and custom firewall rules |
| AAA | TACACS+ with AD-backed authentication |
| Backup / File Services | BKU01 file server, logging share, and veeam replication |

---

## Topology

### Logical Topology

![Logical Topology](diagrams/logical%20topology/logical_topology.drawio.png)

### Physical Topology

> pending 

---

## Core Infrastructure

### Active Directory & Domain Services

* **Domain:** `corp.azureuser.org`
* **Domain Controllers:** DC01 and DC02 on separate hypervisors
* **Core Services:** AD DS, DNS, DHCP failover, Group Policy, and PKI integration
* **PKI:** Offline root CA with enterprise subordinate CA
* **Identity Structure:** Departmental OUs, security groups, service accounts, and AGDLP-based file access
* **Access Controls:** Windows LAPS, service account logon restrictions, and role-based administrative groups

**Documentation:** [Domain Controllers](docs/system_documentation/Domain%20Controllers.md)

---

### Network & Perimeter Security

* **Routing:** R1-CORE and R2-CORE provide inter-VLAN routing, HSRP gateway redundancy, DHCP relay, ACL enforcement, and default routing toward pfSense
* **Switching:** SW1 and SW2 provide VLAN segmentation, trunking, LACP EtherChannel, DHCP snooping, Dynamic ARP Inspection, and access-port hardening
* **Firewalls:** PFS01 and PFS02 operate as a pfSense CARP high-availability pair
* **NAT & DNS Enforcement:** Internal VLANs use outbound NAT, with client DNS forced through the firewall resolver
* **Threat Filtering:** pfBlockerNG DNSBL and IP blocklists are used for DNS and outbound threat filtering
* **Logging:** Firewall and network device logs are forwarded to WAZ01 for centralized visibility

**Documentation:**
[Firewalls](docs/network_documentation/firewall.md) · [Routers](docs/network_documentation/Routers.md) · [Switches](docs/network_documentation/switches.md)

---

### Group Policy

* Domain account and security baselines
* Workstation, server, and domain controller hardening
* Windows LAPS management for local administrator passwords
* GPO-managed local administrator membership
* Service account restrictions for interactive and RDP logon
* PowerShell transcription to centralized logging shares
* Zabbix and Wazuh agent deployment through GPO-managed scheduled tasks
* Removable media restrictions for selected business groups

**Documentation:**
[GPO Overview](docs/gpo/00-gpo-overview.md) · [GPO Scope & Link Order](docs/gpo/01-gpo-scope-and-link-order.md)

---

### Monitoring & SIEM

* **Zabbix:** Infrastructure monitoring for servers, hypervisors, firewalls, and network devices
* **Wazuh:** Centralized SIEM for log collection, alerting, and security visibility
* **Firewall Visibility:** Custom pfSense decoder and rules for allow/block events, brute-force indicators, and port-scan detection
* **Alerting:** Slack notifications for high-priority monitoring and security events
* **Network Monitoring:** SNMPv3 monitoring for Cisco devices

**Documentation:**
[ZBX01](docs/system_documentation/zbx01.md) · [WAZ01](docs/system_documentation/waz01.md)

---

### Virtualization

* **PVE1 / PVE2:** Proxmox VE hypervisors hosting core infrastructure services
* **ESXi:** VMware host used for workstation simulation
* **Placement:** Core services are distributed across hypervisors to reduce single-host dependency
* **Networking:** VLAN-aware bridges support segmented VM networking
* **Authentication:** Proxmox integrates with Active Directory using LDAPS

**Documentation:**
[PVE1](docs/system_documentation/PVE1.md) · [PVE2](docs/system_documentation/PVE2.md)

---

### Automation & Utility Services

* **NEXUS01:** TACACS+, Ansible control node, and FOG deployment server
* **TACACS+:** AD-backed network device authentication and authorization
* **Ansible:** Agentless deployment and automation support for Linux Systems
* **FOG:** Network-based imaging and deployment testing

**Documentation:** [NEXUS01](docs/system_documentation/nexus01.md)

---

### File Services & Backup

* **BKU01:** Windows file server and backup host
* **Shares:** Corporate file share, software share, and centralized logging share
* **Access Model:** NTFS permissions mapped through AD security groups
* **Backup:** Veeam installed; detailed backup job documentation is in progress

**Documentation:** [BKU01](docs/system_documentation/BKU01.md)

---

## Infrastructure Inventory

| Host     | Role                                    | Address / Notes                        | Platform              |
| -------- | --------------------------------------- | -------------------------------------- | --------------------- |
| PFS01    | Primary pfSense firewall                | `10.10.254.5`, CARP VIP `10.10.254.4`  | pfSense               |
| PFS02    | Secondary pfSense firewall              | `10.10.254.6`                          | pfSense               |
| DC01     | Primary DC, AD DS, DNS, DHCP            | `10.10.10.10`                          | Windows Server / PVE1 |
| DC02     | Secondary DC, DNS, DHCP, Subordinate CA | `10.10.10.11`                          | Windows Server / PVE2 |
| ROOTCA01 | Offline root CA                         | Offline / `10.10.10.80` when connected | Windows Server / PVE1 |
| ZBX01    | Zabbix monitoring server                | `10.10.10.40`                          | Ubuntu Server / PVE1  |
| WAZ01    | Wazuh SIEM server                       | `10.10.10.50`                          | Ubuntu Server / PVE2  |
| NEXUS01  | TACACS+, Ansible, FOG                   | `10.10.10.70`                          | RHEL / PVE1           |
| BKU01    | File server, logging share, backup host | `10.10.10.30`                          | Windows Server / PVE2 |
| R1-CORE  | Core router, HSRP active                | Per-VLAN `.2`, transit `10.10.254.2`   | Cisco 2901            |
| R2-CORE  | Core router, HSRP standby               | Per-VLAN `.3`, transit `10.10.254.3`   | Cisco ISR 4321        |
| SW1      | Access/distribution switch              | `10.10.50.9`                           | Cisco 2960            |
| SW2      | Access/distribution switch              | `10.10.50.10`                          | Cisco 2960            |
| PVE1     | Primary Proxmox hypervisor              | `10.10.50.5`                           | Proxmox VE            |
| PVE2     | Secondary Proxmox hypervisor            | `10.10.50.6`                           | Proxmox VE            |
| ESX01    | VMware hypervisor                       | `10.10.50.15`                           | VMware ESXi           |

---

## Documentation Structure

```text
docs/
├── network_documentation/
│   ├── firewall.md
│   ├── Routers.md
│   └── switches.md
├── system_documentation/
│   ├── Domain Controllers.md
│   ├── PVE1.md
│   ├── PVE2.md
│   ├── BKU01.md
│   ├── nexus01.md
│   ├── waz01.md
│   └── zbx01.md
├── gpo/
│   ├── 00-gpo-overview.md
│   └── 01-gpo-scope-and-link-order.md
├── validation.md
├── troubleshooting-notes.md
├── implementation-log.md
└── incident-log.md
```

---

## Project Status

| Area                                          | Status      |
| --------------------------------------------- | ----------- |
| Core routing and HSRP                         | Documented  |
| Switching and VLAN design                     | Documented  |
| pfSense firewall HA, NAT, and DNS enforcement | Partial     |
| Active Directory, DNS, and DHCP               | Documented  |
| Group Policy design                           | Documented  |
| Proxmox virtualization                        | Documented  |
| Vmware virtualization                         | In progress |
| Zabbix monitoring                             | Documented  |
| Wazuh SIEM                                    | Documented  |
| TACACS+ network device AAA                    | Documented  |
| Backup / Veeam job details                    | In progress |
| Full validation coverage                      | In progress |
| Wireless / NPS / captive portal               | Planned     |

---

## Skills Demonstrated

* Cisco routing and switching
* VLAN design and inter-VLAN routing
* HSRP, CARP, LACP, DHCP snooping, and Dynamic ARP Inspection
* pfSense firewalling, NAT, DNS enforcement, and pfBlockerNG
* Active Directory administration
* DNS, DHCP, GPO, PKI, and Windows LAPS
* Windows and Linux server administration
* Proxmox and VMware virtualization
* Zabbix monitoring and Wazuh SIEM integration
* TACACS+ authentication and authorization
* Ansible-based deployment support
* Technical documentation, validation, and incident tracking

---

## Disclaimer

This is a lab environment built for learning, documentation, and portfolio demonstration. It is not a production deployment.

Some areas are still being improved, and incomplete sections are intentionally marked as in progress.

