## PVE1

### Purpose
PVE1 is the primary Proxmox VE hypervisor in the AzureUser lab, hosting PFSENSE-01, DC01, ROOTCA01, NEXUS01, ADM01, and ZBX01. It runs on physical hardware on VLAN 50 and is managed via the Proxmox web GUI at `https://10.10.50.5:8006`.

---

## Proxmox Platform

### Overview
PVE1 runs Proxmox VE 9.1.0 on Debian GNU/Linux 13 (trixie) with kernel `6.17.13-1-pve`, deployed on an ASUSTeK P8H77-M host. It is the primary of two Proxmox nodes in the lab; PVE2 hosts the complementary VM set.

---

## Network Configuration

Three Linux bridges provide VM connectivity:

| Bridge  | Backing NIC | VLAN-Aware | VIDs                     | Purpose                   |
|---------|-------------|------------|--------------------------|---------------------------|
| `vmbr0` | `nic0`      | No         | —                        | WAN uplink (PFSENSE-01)   |
| `vmbr1` | `nic1`      | Yes        | 10, 20, 30, 50, 253, 254 | Primary VLAN trunk        |
| `vmbr2` | `enp1s0`    | Yes        | 253                      | pfSense CARP sync network |

PVE1's management interface is `vmbr1.50` at `10.10.50.5/24`, with a default gateway of `10.10.50.1`. DNS resolves against `10.10.10.10`, `10.128.100.12`, and `10.128.100.11` with search domain `corp.azureuser.org`.

---

## Storage

PVE1 has five storage pools across two 1 TB HDDs and one 32 GB SSD:

| Name               | Type    | Total    | Used   | Notes                              |
|--------------------|---------|----------|--------|------------------------------------|
| `local`            | dir     | ~98.5 GB | 49.58% | ISO images, snippets               |
| `local-lvm`        | lvmthin | ~833 GB  | 14.50% | Primary VM disk pool (HDD)         |
| `ssd-lvmthin-32gb` | lvmthin | ~31 GB   | 46.80% | SSD-backed thin pool for VM disks  |
| `vg_ssd`           | lvm     | ~31 GB   | 100%   | SSD LVM group (backs ssd-lvmthin-32gb) |
| `vm-storage2`      | lvm     | ~977 GB  | 24.05% | Secondary HDD LVM pool             |

`vg_ssd` is fully allocated to the `ssd-lvmthin-32gb` thin pool. ZBX01's data disk is placed on `ssd-lvmthin-32gb` for improved I/O performance.

---

## Virtual Machines

| VMID | Name       | OS                  | VLAN      | Memory  | Boot Disk                       | Startup Order |
|------|------------|---------------------|-----------|---------|---------------------------------|---------------|
| 100  | PFSENSE-01 | pfSense             | 254 / 253 | 3072 MB | 32 GB                           | 1, up=20s     |
| 101  | DC01       | Windows Server 2025 | 10        | 7000 MB | 64 GB                           | 2, up=120s    |
| 102  | ROOTCA01   | Windows Server 2025 | 10        | 4096 MB | 64 GB                           | —             |
| 103  | NEXUS01    | RHEL                | 10        | 5536 MB | 128 GB                          | 4, up=600s    |
| 104  | ADM01      | Windows 11          | 50        | 8222 MB | 32 GB + 64 GB (secondary)       | 3, up=300s    |
| 105  | ZBX01      | Ubuntu Server       | 10        | 3072 MB | 32 GB (HDD) + 20 GB (SSD cache) | 5, up=900s    |

All VMs use `cpu: host` and Q35 machine type. DC01, ROOTCA01, and ADM01 use VirtIO-SCSI single with `iothread=1` and UEFI/OVMF. DC01, ROOTCA01, and ADM01 include vTPM 2.0. ROOTCA01 has no `onboot` flag set, consistent with its role as an offline root CA. ZBX01's secondary disk is placed on `ssd-lvmthin-32gb` for improved I/O. Hard disk cache is set to writeback for all VMs to optimize performance in this lab environment.

---

## Active Directory Integration

### Proxmox Realm (GUI Authentication)
The `corp.ad` realm connects Proxmox authentication to `corp.azureuser.org` via LDAPS on port 636, binding with the `svc.join` service account. DC01 (`10.10.10.10`) is the primary server and DC02 (`10.10.10.11`) the fallback. A scheduled sync job runs Monday to Friday at 00:00 with scope `Users and Groups`, keeping Proxmox user and group membership current with the directory.

### Host OS Authentication (SSSD)
SSSD joins PVE1 to `corp.azureuser.org` using the AD provider with Kerberos (`CORP.AZUREUSER.ORG`). SSH access is restricted to `azuremaster` only via `simple_allow_users`. Fully qualified names (`user@corp.azureuser.org`) are enforced. Credentials are cached for offline resilience.

`azuremaster` is granted unrestricted `sudo` access via `/etc/sudoers.d/pve-sudoers`. No additional AD users or local automation accounts have sudo rights on PVE1.

---

## Access Control

Proxmox ACLs follow the principle of least privilege against AD identities:

| Path       | Principal                    | Role               | Propagate |
|------------|------------------------------|--------------------|-----------|
| `/`        | `azuremaster@corp.ad`        | `Administrator`    | Yes       |
| `/`        | `GG_IT_Security-corp.ad`     | `PVEAuditor`       | Yes       |
| `/nodes`   | `sysadmin01@corp.ad`         | `PVESysAdmin`      | Yes       |
| `/storage` | `GG_Service_Backup-corp.ad`  | `PVEDatastoreUser` | Yes       |

`GG_IT_Security` receives read-only audit access across the full node. `sysadmin01` is scoped to node-level system operations. `GG_Service_Backup` is restricted to storage allocation and audit at the `/storage` path. Unlike PVE2, `younglord` holds no Proxmox ACL on PVE1.

---

## Monitoring

- **`wazuh-agent.service`** — active and enabled; reports security events to WAZ01.
- **`zabbix-agent2.service`** — active and enabled; registered hostname `PVE1`, version 7.4.7, reporting to ZBX01.

For supporting service status output, see the `evidence/` folder.

---

## Production Considerations

1. **Storage Performance** — Hard disk cache is set to writeback for all VMs to optimize performance in this lab environment; production deployments should evaluate cache settings based on workload and risk tolerance.

2. **Directory Sync Scope** — The realm sync job is configured to sync all users and groups from AD. Production deployments should narrow this scope to specific security groups or organizational units to minimize credential exposure and reduce the attack surface.