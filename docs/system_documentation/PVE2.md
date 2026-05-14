## PVE2

### Purpose
PVE2 is the secondary Proxmox VE hypervisor in the AzureUser lab, hosting PFS02, DC02, WAZ01, BKU01, and CLT01. It runs on physical hardware on VLAN 50 and is managed via the Proxmox web GUI at `https://10.10.50.6:8006`.

---

## Proxmox Platform

### Overview
PVE2 runs Proxmox VE 9.1.0 on Debian GNU/Linux 13 (trixie) with kernel `6.17.13-1-pve`. It supports VLAN-backed VM networking, AD-backed Proxmox authentication, local storage, backup-oriented storage, and staged VM startup ordering.

---

## Network Configuration

Three Linux bridges provide VM connectivity:

| Bridge  | Backing NIC | VLAN-Aware | VIDs                    | Purpose                       |
|---------|-------------|------------|-------------------------|-------------------------------|
| `vmbr0` | `nic0`      | No         | —                       | WAN uplink (PFS02)            |
| `vmbr1` | `nic1`      | Yes        | 10, 20, 30, 50, 253, 254 | Primary VLAN trunk           |
| `vmbr2` | `enp1s0`    | Yes        | 253                     | pfSense CARP sync network     |

PVE2's management interface is `vmbr1.50` at `10.10.50.6/24`, with a default gateway of `10.10.50.1`. DNS resolves against DC01 (`10.10.10.10`), DC02 (`10.10.10.11`), and PFS01 (`10.10.254.5`) with search domain `corp.azureuser.org`.

---

## Storage

| Name           | Type    | Total    | Used   | Notes                         |
|----------------|---------|----------|--------|-------------------------------|
| `local`        | dir     | ~98.5 GB | 48.64% | ISO images, snippets          |
| `local-lvm`    | lvmthin | ~833 GB  | 24.23% | Primary VM disk pool          |
| `local_backup` | lvm     | ~488 GB  | 97.69% | Dedicated backup volume       |

---

## Virtual Machines

| VMID | Name  | OS                  | VLAN      | Memory  | Boot Disk                  | Startup Order |
|------|-------|---------------------|-----------|---------|----------------------------|---------------|
| 100  | PFS02 | pfSense             | 254 / 253 | 4064 MB | 32 GB                      | 1, up=20s     |
| 101  | DC02  | Windows Server 2025 | 10        | 6000 MB | 256 GB                     | 2, up=120s    |
| 102  | WAZ01 | Ubuntu Server       | 10        | 4096 MB | 64 GB                      | 3, up=300s    |
| 103  | BKU01 | Windows Server 2025 | 10        | 8448 MB | 300 GB + 455 GB (backup)   | 4, up=500s    |
| 104  | CLT01 | Windows 11          | 20        | 4096 MB | 76 GB                      | —             |

All VMs use `cpu: host`, Q35 machine type, VirtIO-SCSI with `iothread=1` and writeback cache, and UEFI/OVMF where applicable. DC02, BKU01, and CLT01 include vTPM 2.0.

---

## Active Directory Integration

### Proxmox Realm (GUI Authentication)
The `corp.ad` realm connects Proxmox authentication to `corp.azureuser.org` via LDAPS on port 636, binding with the `svc.join` service account. DC01 (`10.10.10.10`) is the primary server and DC02 (`10.10.10.11`) the secondary. This realm is set as the default login realm.

A scheduled sync job runs at `2,22:30` with scope `Users and Groups`, keeping Proxmox user and group membership current with the directory.

### Host OS Authentication (SSSD)
SSSD joins PVE2 to `corp.azureuser.org` using the AD provider with Kerberos (`CORP.AZUREUSER.ORG`). SSH access is restricted to `younglord` and `azuremaster` via `simple_allow_users`. 

Both AD users are granted unrestricted `sudo` access via `/etc/sudoers.d/pve-sudoers`. An `ansible` local account also holds unrestricted sudo rights via `/etc/sudoers.d/ansible`.

---

## Access Control

Proxmox ACLs follow the principle of least privilege against AD identities:

| Path       | Principal                | Role               | Propagate |
|------------|--------------------------|--------------------|-----------|
| `/`        | `younglord@corp.ad`      | `Administrator`    | Yes       |
| `/`        | `azuremaster@corp.ad`    | `Administrator`    | Yes       |
| `/`        | `GG_IT_Security@corp.ad` | `PVEAuditor`       | Yes       |
| `/nodes`   | `sysadmin01@corp.ad`     | `PVESysAdmin`      | Yes       |
| `/storage` | `svc.backup@corp.ad`     | `PVEDatastoreUser` | Yes       |

`GG_IT_Security` receives read-only audit access across the full node. `sysadmin01` is scoped to node-level system operations. `svc.backup` is restricted to storage allocation and audit at the `/storage` path.

---

## Monitoring

- **`wazuh-agent.service`** — active and enabled; reports security events to WAZ01.
- **`zabbix-agent2.service`** — active and enabled; registered hostname `PVE2`, version 7.4.8, reporting to ZBX01.

For supporting service status output, see the `evidence/` folder.