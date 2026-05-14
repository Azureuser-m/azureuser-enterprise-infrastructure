# GPO Scope and Link Order

## Purpose

This document records Group Policy link locations, link order, inheritance, security filtering, and WMI filtering for `corp.azureuser.org`.

## Evidence Locations

- GPMC link-order and inheritance screenshots: [GPMC Link Order](../../evidence/shared/gpmc-link-order/)
- Per-GPO Scope tab screenshots: [Per-GPO Scope](../../evidence/shared/per-gpo/)
- GPO XML exports: [GPO XML Exports](../../configs/gpo/xml/)

## GPO Inventory Summary

All listed custom GPOs are shown in Group Policy Management as:

- **GPO Status:** Enabled
- **WMI Filter:** None
- **Owner:** Domain Admins

Custom GPOs present:

| GPO | Status |
|---|---|
| Cert-Autoenroll | Enabled |
| GPO 00 - Domain Account Policies | Enabled |
| GPO 01 - Domain Security Baseline | Enabled |
| GPO 04 - Corporate Baseline | Enabled |
| GPO 05 - Service Account Restrictions | Enabled |
| GPO 06 - Corporate Share | Enabled |
| GPO 10 - Workstation Baseline | Enabled |
| GPO 11 - Workstation Admin Control | Enabled |
| GPO 12 - Admin Workstation Hardening | Enabled |
| GPO 12 - ZABBIX - Workstations | Enabled |
| GPO 13 - WAZUH - Workstations | Enabled |
| GPO 20 - Server Baseline | Enabled |
| GPO 21 - ZABBIX - Servers | Enabled |
| GPO 22 - WAZUH - Servers | Enabled |
| GPO 30 - Domain Controller Restrictions | Enabled |
| GPO 60 - Removable Media Control | Enabled |

Evidence:

- [GPO Inventory](../../evidence/shared/gpmc-link-order/gpo_inventory.png)

---

## OU and Link Order Summary

### Domain Root: `corp.azureuser.org`

Linked GPOs:

| Link Order | GPO | Enforced | Link Enabled | WMI Filter |
|---:|---|---|---|---|
| 1 | GPO 00 - Domain Account Policies | No | Yes | None |
| 2 | GPO 01 - Domain Security Baseline | No | Yes | None |
| 3 | Default Domain Policy | No | Yes | None |

Inherited precedence:

| Precedence | GPO | Location |
|---:|---|---|
| 1 | GPO 00 - Domain Account Policies | corp.azureuser.org |
| 2 | GPO 01 - Domain Security Baseline | corp.azureuser.org |
| 3 | Default Domain Policy | corp.azureuser.org |

Evidence:

- [Domain Linked GPOs](../../evidence/shared/gpmc-link-order/domain_linked-gpos.png)
- [Domain GPO Inheritance](../../evidence/shared/gpmc-link-order/domain_gpo-inheritance.png)

---

### Corporate OU: `corp.azureuser.org/Corporate`

Linked GPOs:

| Link Order | GPO | Enforced | Link Enabled | WMI Filter |
|---:|---|---|---|---|
| 1 | Cert-Autoenroll | No | Yes | None |
| 2 | GPO 04 - Corporate Baseline | No | Yes | None |
| 3 | GPO 05 - Service Account Restrictions | No | Yes | None |
| 4 | GPO 06 - Corporate Share | No | Yes | None |

Inherited precedence:

| Precedence | GPO | Location |
|---:|---|---|
| 1 | Cert-Autoenroll | Corporate |
| 2 | GPO 04 - Corporate Baseline | Corporate |
| 3 | GPO 05 - Service Account Restrictions | Corporate |
| 4 | GPO 06 - Corporate Share | Corporate |
| 5 | GPO 00 - Domain Account Policies | corp.azureuser.org |
| 6 | GPO 01 - Domain Security Baseline | corp.azureuser.org |
| 7 | Default Domain Policy | corp.azureuser.org |

Evidence:

- [Corporate Linked GPOs](../../evidence/shared/gpmc-link-order/corporate_linked-gpos.png)
- [Corporate GPO Inheritance](../../evidence/shared/gpmc-link-order/corporate_gpo-inheritance.png)

---

### Admin Workstation OU: `corp.azureuser.org/Corporate/Admin Workstation`

Linked GPOs:

| Link Order | GPO | Enforced | Link Enabled | WMI Filter |
|---:|---|---|---|---|
| 1 | GPO 12 - Admin Workstation Hardening | No | Yes | None |
| 2 | GPO 12 - ZABBIX - Workstations | No | Yes | None |
| 3 | GPO 13 - WAZUH - Workstations | No | Yes | None |

Inherited precedence:

| Precedence | GPO | Location |
|---:|---|---|
| 1 | GPO 12 - Admin Workstation Hardening | Admin Workstation |
| 2 | GPO 12 - ZABBIX - Workstations | Admin Workstation |
| 3 | GPO 13 - WAZUH - Workstations | Admin Workstation |
| 4 | Cert-Autoenroll | Corporate |
| 5 | GPO 04 - Corporate Baseline | Corporate |
| 6 | GPO 05 - Service Account Restrictions | Corporate |
| 7 | GPO 06 - Corporate Share | Corporate |
| 8 | GPO 00 - Domain Account Policies | corp.azureuser.org |
| 9 | GPO 01 - Domain Security Baseline | corp.azureuser.org |
| 10 | Default Domain Policy | corp.azureuser.org |

Evidence:

- [Admin Workstations Linked GPOs](../../evidence/shared/gpmc-link-order/admin-workstations_linked-gpos.png)
- [Admin Workstations GPO Inheritance](../../evidence/shared/gpmc-link-order/admin-workstations_gpo-inheritance.png)

---

### Workstations OU: `corp.azureuser.org/Corporate/Workstations`

Linked GPOs:

| Link Order | GPO | Enforced | Link Enabled | WMI Filter |
|---:|---|---|---|---|
| 1 | GPO 10 - Workstation Baseline | No | Yes | None |
| 2 | GPO 11 - Workstation Admin Control | No | Yes | None |
| 3 | GPO 12 - ZABBIX - Workstations | No | Yes | None |
| 4 | GPO 13 - WAZUH - Workstations | No | Yes | None |
| 5 | GPO 60 - Removable Media Control | No | Yes | None |

Inherited precedence:

| Precedence | GPO | Location |
|---:|---|---|
| 1 | GPO 10 - Workstation Baseline | Workstations |
| 2 | GPO 11 - Workstation Admin Control | Workstations |
| 3 | GPO 12 - ZABBIX - Workstations | Workstations |
| 4 | GPO 13 - WAZUH - Workstations | Workstations |
| 5 | GPO 60 - Removable Media Control | Workstations |
| 6 | Cert-Autoenroll | Corporate |
| 7 | GPO 04 - Corporate Baseline | Corporate |
| 8 | GPO 05 - Service Account Restrictions | Corporate |
| 9 | GPO 06 - Corporate Share | Corporate |
| 10 | GPO 00 - Domain Account Policies | corp.azureuser.org |
| 11 | GPO 01 - Domain Security Baseline | corp.azureuser.org |
| 12 | Default Domain Policy | corp.azureuser.org |

Evidence:

- [Workstations Linked GPOs](../../evidence/shared/gpmc-link-order/workstations_linked-gpos.png)
- [Workstations GPO Inheritance](../../evidence/shared/gpmc-link-order/workstations_gpo-inheritance.png)

---

### Servers OU: `corp.azureuser.org/Corporate/Servers`

Linked GPOs:

| Link Order | GPO | Enforced | Link Enabled | WMI Filter |
|---:|---|---|---|---|
| 1 | GPO 20 - Server Baseline | No | Yes | None |
| 2 | GPO 21 - ZABBIX - Servers | No | Yes | None |
| 3 | GPO 22 - WAZUH - Servers | No | Yes | None |

Inherited precedence:

| Precedence | GPO | Location |
|---:|---|---|
| 1 | GPO 20 - Server Baseline | Servers |
| 2 | GPO 21 - ZABBIX - Servers | Servers |
| 3 | GPO 22 - WAZUH - Servers | Servers |
| 4 | Cert-Autoenroll | Corporate |
| 5 | GPO 04 - Corporate Baseline | Corporate |
| 6 | GPO 05 - Service Account Restrictions | Corporate |
| 7 | GPO 06 - Corporate Share | Corporate |
| 8 | GPO 00 - Domain Account Policies | corp.azureuser.org |
| 9 | GPO 01 - Domain Security Baseline | corp.azureuser.org |
| 10 | Default Domain Policy | corp.azureuser.org |

Evidence:

- [Servers Linked GPOs](../../evidence/shared/gpmc-link-order/servers_linked-gpos.png)
- [Servers GPO Inheritance](../../evidence/shared/gpmc-link-order/servers_gpo-inheritance.png)

---

### Domain Controllers OU: `corp.azureuser.org/Domain Controllers`

Linked GPOs:

| Link Order | GPO | Enforced | Link Enabled | WMI Filter |
|---:|---|---|---|---|
| 1 | GPO 30 - Domain Controller Restrictions | No | Yes | None |
| 2 | Cert-Autoenroll | No | Yes | None |
| 3 | Default Domain Controllers Policy | No | Yes | None |

Inherited precedence:

| Precedence | GPO | Location |
|---:|---|---|
| 1 | GPO 30 - Domain Controller Restrictions | Domain Controllers |
| 2 | Cert-Autoenroll | Domain Controllers |
| 3 | Default Domain Controllers Policy | Domain Controllers |
| 4 | GPO 00 - Domain Account Policies | corp.azureuser.org |
| 5 | GPO 01 - Domain Security Baseline | corp.azureuser.org |
| 6 | Default Domain Policy | corp.azureuser.org |

Evidence:

- [Domain Controllers Linked GPOs](../../evidence/shared/gpmc-link-order/domain-controllers_linked-gpos.png)
- [Domain Controllers GPO Inheritance](../../evidence/shared/gpmc-link-order/domain-controllers_gpo-inheritance.png)

---

## Per-GPO Scope Summary

All GPOs have the following consistent properties unless noted:
- **Enforced:** No
- **Link Enabled:** Yes
- **WMI Filter:** None
- **Security Filtering:** Authenticated Users (except GPO 60)

| GPO | Linked Location(s) | Security Filtering | Evidence |
|---|---|---|---|
| Cert-Autoenroll | `corp.azureuser.org/Corporate`, `corp.azureuser.org/Domain Controllers` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/cert-autoenroll_scope.png) |
| GPO 00 - Domain Account Policies | `corp.azureuser.org` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-00-domain-account-policies_scope.png) |
| GPO 01 - Domain Security Baseline | `corp.azureuser.org` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-01-domain-security-baseline_scope.png) |
| GPO 04 - Corporate Baseline | `corp.azureuser.org/Corporate` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-04-corporate-baseline_scope.png) |
| GPO 05 - Service Account Restrictions | `corp.azureuser.org/Corporate` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-05-service-account-restrictions_scope.png) |
| GPO 06 - Corporate Share | `corp.azureuser.org/Corporate` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-06-corporate-share_scope.png) |
| GPO 10 - Workstation Baseline | `corp.azureuser.org/Corporate/Workstations` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-10-workstation-baseline_scope.png) |
| GPO 11 - Workstation Admin Control | `corp.azureuser.org/Corporate/Workstations` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-11-workstation-admin-control_scope.png) |
| GPO 12 - Admin Workstation Hardening | `corp.azureuser.org/Corporate/Admin Workstation` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-12-admin-workstation-hardening_scope.png) |
| GPO 12 - ZABBIX - Workstations | `corp.azureuser.org/Corporate/Admin Workstation`, `corp.azureuser.org/Corporate/Workstations` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-12-zabbix-workstations_scope.png) |
| GPO 13 - WAZUH - Workstations | `corp.azureuser.org/Corporate/Admin Workstation`, `corp.azureuser.org/Corporate/Workstations` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-13-wazuh-workstations_scope.png) |
| GPO 20 - Server Baseline | `corp.azureuser.org/Corporate/Servers` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-20-server-baseline_scope.png) |
| GPO 21 - ZABBIX - Servers | `corp.azureuser.org/Corporate/Servers` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-21-zabbix-servers_scope.png) |
| GPO 22 - WAZUH - Servers | `corp.azureuser.org/Corporate/Servers` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-22-wazuh-servers_scope.png) |
| GPO 30 - Domain Controller Restrictions | `corp.azureuser.org/Domain Controllers` | Authenticated Users | [Scope](../../evidence/shared/per-gpo/gpo-30-domain-controller-restrictions_scope.png) |
| GPO 60 - Removable Media Control | `corp.azureuser.org/Corporate/Workstations` | `CORP\GG_Finance_Users`, `CORP\GG_HR_Users`, `CORP\GG_Operations_Users`, `CORP\GG_Sales_Users` | [Scope](../../evidence/shared/per-gpo/gpo-60-removable-media-control_scope.png) |

---

 Endpoint application is validated separately in [Validation](../../validation.md).

