# Domain Controllers

## Overview

DC01 and DC02 provide the core Active Directory services for the `corp.azureuser.org` domain. Together, they support domain authentication, DNS resolution, Group Policy processing, DHCP availability, Kerberos, PKI integration, and directory redundancy. The domain controller pair is split across separate hypervisors (PVE1 and PVE2) to eliminate single points of failure.

## Domain Controller Inventory

| Item                | DC01                                      | DC02                                                                     |
| ------------------- | ----------------------------------------- | ------------------------------------------------------------------------ |
| Hostname            | DC01                                      | DC02                                                                     |
| FQDN                | `dc01.corp.azureuser.org`                 | `dc02.corp.azureuser.org`                                                |
| Domain              | `corp.azureuser.org`                      | `corp.azureuser.org`                                                     |
| Operating system    | Windows Server 2025 Standard Evaluation   | Windows Server 2025 Standard Evaluation                                  |
| OS build            | `26100`                                   | `26100`                                                                  |
| Primary role        | Primary domain controller                 | secondary domain controller                                    |
| Additional roles    | AD DS, DNS, DHCP, Group Policy management | AD DS, DNS, DHCP failover, Enterprise Subordinate CA, IIS PKI publishing |
| Hypervisor          | PVE1                                      | PVE2                                                                     |
| VLAN                | VLAN 10 - Servers                         | VLAN 10 - Servers                                                        |
| IP address          | `10.10.10.10/24`                          | `10.10.10.11/24`                                                         |
| Subnet mask         | `255.255.255.0`                           | `255.255.255.0`                                                          |
| Default gateway     | `10.10.10.1`                              | `10.10.10.1`                                                             |
| DNS client settings | Local loopback                            | Local loopback, DC01                                                     |

## Active Directory

The `corp.azureuser.org` domain uses the `CORP` NetBIOS name and runs at the Windows Server 2025 domain and forest functional level. DC01 holds all FSMO roles. DC01 and DC02 are both domain controllers, global catalog servers, and replication partners.

### Active Directory Users and Computers

The domain supports 24 standard user accounts and 5 service accounts organized across departmental OUs under `OU=Corporate,DC=corp,DC=azureuser,DC=org`. Key domain controller administrative accounts include:

- `azuremaster` — Primary infrastructure administrator with full domain control
- `Administrator` — Default domain administrator account
- `younglord` — Secondary infrastructure administrator for Proxmox and virtualization
- `sysadmin01` — Systems administrator for server management
- `network.admin` — Network administrator (network management)
- `siemadmin01` — SIEM administrator (Zabbix and Wazuh monitoring)

Domain controllers `DC01` and `DC02` are placed in `OU=Domain Controllers,DC=corp,DC=azureuser,DC=org` and are members of the `GG_Domain_Admins` security group. These enable certificate auto-enrollment and Group Policy application. Full organizational structure, user roles, and security group design are documented in the AD Users Inventory (corp_azureuser_org_users_table.md).

## DNS

DC02 hosts the same AD-integrated zones as DC01 via replication. Its forwarder list is broader, including internal infrastructure targets:

| Configured zone             | Type    | AD-integrated | Purpose                           |
| --------------------------- | ------- | ------------- | --------------------------------- |
| `corp.azureuser.org`        | Primary | Yes           | Main internal domain zone         |
| `_msdcs.corp.azureuser.org` | Primary | Yes           | Domain controller locator records |

### DNS Forwarders

| Server | Forwarder     | Purpose               |
| ------ | ------------- | --------------------- |
| DC01   | `8.8.8.8`     | External DNS fallback |
| DC02   | `10.10.10.10` | DC01 internal DNS     |
| DC02   | `10.10.254.4` | pfSense CARP VIP      |
| DC02   | `10.10.254.5` | PFS01                 |
| DC02   | `8.8.8.8`     | External DNS fallback |

DNS recursion is enabled and DNS scavenging is currently disabled.

## DHCP

 DC01 and DC02 are configured as DHCP servers, with failover configured between them.

### DHCP Scopes

| Scope           | Name        | State  | Address range               | Lease duration |
| --------------- | ----------- | ------ | --------------------------- | -------------- |
| `10.10.20.0/24` | CORP VLAN   | Active | `10.10.20.1 - 10.10.20.254` | 8 days         |
| `10.10.30.0/24` | GUESTS VLAN | Active | `10.10.30.1 - 10.10.30.254` | 8 days         |

### DHCP Server Options

| Option | Setting               | DC01 value                   | DC02 value       |
| ------ | --------------------- | ---------------------------- | ---------------- |
| 66     | Boot Server Host Name | `10.10.10.70`                | `10.10.10.70`    |
| 67     | Bootfile Name         | `undionly.kkpxe`             | `undionly.kkpxe` |
| 42     | NTP Servers           | `10.10.10.10`, `10.10.10.11` | `10.10.10.10, 10.10.10.11`    |

Options 066 and 067 enable PXE boot via NEXUS01 (`10.10.10.70`) using the `undionly.kkpxe` bootfile.

### DHCP Failover

The DHCP failover relationship uses load-balance mode with a 50/50 split between DC01 and DC02.

| Item                  | Value                          |
| --------------------- | ------------------------------ |
| Failover relationship | `dc01.corp.azureuser.org-dc02` |
| Servers               | DC01 and DC02                  |
| Mode                  | LoadBalance                    |
| Load balance          | 50/50                          |
| State                 | Normal                         |
| Scopes                | `10.10.20.0`, `10.10.30.0`     |
| Authentication        | Enabled                        |

## NTP and Time Synchronization

DC01 synchronizes with external NTP servers (`0.ca.pool.ntp.org`, `1.ca.pool.ntp.org`, `time.cloudflare.com`) and serves time to DC02 and other domain systems. DC02 synchronizes from DC01 to maintain hierarchical consistency.

| Property             | DC01                      | DC02                        |
| -------------------- | ------------------------- | --------------------------- |
| Time Source          | 0.ca.pool.ntp.org         | DC01.corp.azureuser.org     |
| Stratum              | 3 (external NTP)          | 3 (DC01)                    |
| Reference ID         | 0xD049381D (208.73.56.29) | 0x0A0A0A0A (10.10.10.10)    |
| Last Successful Sync | 5/7/2026 9:58:38 PM       | 5/11/2026 8:34:51 PM        |
| Poll Interval        | 7 (128s)                  | 6 (64s)                     |
| Root Delay           | 0.0278281s                | 0.0289735s                  |
| Root Dispersion      | 1.8923663s                | 8.4980349s                  |

### Certificate Services

DC02 hosts the enterprise subordinate CA for the lab PKI design. The CA is named `corp-ca` and is published as `DC02.corp.azureuser.org\corp-ca`.

The CA supports domain certificate enrollment and publishes certificate revocation information through both HTTP and file-based publication paths.

| Item                   | Value                                  |
| ---------------------- | -------------------------------------- |
| CA common name         | `corp-ca`                              |
| CA server              | `DC02.corp.azureuser.org`              |
| CA type                | Enterprise Subordinate CA              |
| CA validity period     | 2 years                                |
| CRL period             | 3 months                               |
| Delta CRL period       | 1 day                                  |
| HTTP CRL / AIA path    | `http://pki.corp.azureuser.org/pki/`   |
| File publication path  | `\\dc02.corp.azureuser.org\pki`        |

DC02 uses IIS to publish PKI files. The `pki` virtual directory maps to `C:\pki` and is available over HTTP on port 80 through the Default Web Site.

Certificate auto-enrollment is applied to both domain controllers through Group Policy. This allows domain-managed certificate enrollment, renewal, pending request processing, revoked certificate cleanup, and certificate template management from Active Directory.