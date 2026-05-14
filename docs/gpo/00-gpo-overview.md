# GPO Overview
## Purpose
Group Policy enforces security baselines, access controls, monitoring agent deployment, and endpoint configuration across corp.azureuser.org. Policies are numbered to reflect scope and processing order, domain-wide settings apply first, with progressively more specific OU-linked policies layered on top.

---

## Design Approach

| Tier | Prefix | Scope |
|---|---|---|
| Domain root | 00–01 | All objects in `corp.azureuser.org` |
| Corporate OU | 04–06 | All managed computers and users |
| Workstations / Admin Workstation | 10–13 | Corporate workstations and jump boxes |
| Servers | 20–22 | Windows server fleet |
| Domain Controllers | 30, Cert | DC-specific restrictions and PKI |
| Targeted (filtered) | 60 | Security group–scoped user policy |

---

## Key Policies

**Domain Account Policies (GPO 00)** — Password and lockout baseline: 14-character minimum, complexity required, 24-password history, 5-attempt lockout with a 15-minute duration.

**Domain Security Baseline (GPO 01)** — Security options applied across all machines: NTLMv2-only authentication, UAC enforced, SMB signing required, anonymous SAM enumeration blocked, Windows Firewall enabled on all profiles, and a comprehensive advanced audit policy covering logon, account management, directory changes, and file share access.

**Corporate Baseline / LAPS (GPO 04)** — Windows LAPS manages a custom `breakglass` local admin account on every domain-joined computer. Passwords are encrypted and stored in Active Directory, enforcing automatic rotation.

**Service Account Restrictions (GPO 05)** — All five service account groups (`Zabbix`, `Wazuh`, `Join`, `Deploy`, `Backup`) are explicitly denied interactive and RDP logon domain-wide, limiting their use to service contexts only.

**Workstation and Server Baselines (GPO 10/11, GPO 20)** — Local administrator group membership is managed by GPO on both tiers, replacing any pre-existing local accounts. RDP access to servers is restricted to `GG_Server_Admins`. PowerShell transcription is enabled on servers and admin workstations, with transcripts written to centralized logging shares on BKU01.

**Admin Workstation Hardening (GPO 12)** — Interactive logon on ADM01/ADM02 is restricted to IT Infrastructure and Security groups only. A legal notice banner is applied. PowerShell transcription captures all admin activity to `\\BKU01\logging\admin_workstation`.

**Monitoring Deployment (GPO 12/13, GPO 21/22)** — Zabbix and Wazuh agents are deployed and self-healing via GPO-managed scheduled tasks running as `SYSTEM` with S4U logon. Separate GPOs target workstations and servers, keeping agent management isolated and independently controllable.

**Removable Media Control (GPO 60)** — All removable storage access is blocked for HR, Finance, Operations, and Sales users on workstations. IT groups are explicitly excluded via security group filtering on the GPO permissions rather than a WMI filter, keeping the policy scoped without affecting IT operations.

**Domain Controller Restrictions (GPO 30)** — Interactive logon to DCs is limited to `GG_Domain_Admins` and the built-in Administrator. RDP access is restricted to `GG_Domain_Admins` only.

**Certificate Autoenrollment (Cert-Autoenroll)** — Domain controllers automatically enroll and renew certificates from the corporate PKI (ROOTCA01 / DC02 Subordinate CA), with template updates and revocation checks enabled.

---

## Evidence and Documentation Map

| Area | Location |
|---|---|
| GPO scope, link order, inheritance, filtering | [GPO Scope and Link Order](./01-gpo-scope-and-link-order.md) |
| GPO XML exports | [GPO XML Exports](../../configs/gpo/xml/) |
| GPO HTML reports | [GPO HTML Reports](../../configs/gpo/html/) |
| GPO scripts | [GPO Scripts](../../configs/gpo/scripts/) |
| Validation evidence | [Validation](../../validation.md) |
| Shared GPO evidence | [Shared Evidence](../../evidence/shared/) |
| Workstation evidence | [Workstation Evidence](../../evidence/workstations/) |
| Admin workstation evidence | [Admin Workstation Evidence](../../evidence/admin-workstations/) |
| Server evidence | [Server Evidence](../../evidence/servers/) |

---

