## Switches

SW1 and SW2 are the access/distribution layer switches providing VLAN segmentation, trunk connectivity to routers and hypervisors, inter-switch redundancy via LACP EtherChannel, and Layer 2 security via DHCP snooping and Dynamic ARP Inspection. SW1 connects to R1-CORE and serves PVE1 and ESXi; SW2 connects to R2-CORE and serves PVE2. Each provides physical cross-uplinks to the opposite hypervisor for redundancy.

| | SW1 | SW2 |
|---|---|---|
| **Model** | Cisco WS-C2960-24TT-L | Cisco WS-C2960-24TT-L |
| **IOS Version** | 15.0(2)SE10a | 15.0(2)SE10a |
| **Management IP** | `10.10.50.9` | `10.10.50.10` |
| **Router Uplink** | `Gi0/1` → R1-CORE | `Gi0/1` → R2-CORE |

## Switching Configuration

### VLANs & Trunk Design

| VLAN | Name | Purpose |
|---|---|---|
| 10 | `SERVERS` | Server infrastructure |
| 20 | `CORP` | Corporate workstations |
| 30 | `GUEST` | Guest and BYOD clients |
| 50 | `MGMT` | Management and administration |
| 254 | `PFSENSE_TRANSIT` | Transit to pfSense CARP pair |
| 998 | `BLACKHOLE` | Unused port isolation |
| 999 | `NATIVE` | Native VLAN (untagged suppression) |

VLAN 1 is shut down on both switches. VLAN 998 serves as blackhole for disabled ports. VLAN 999 is native VLAN on all trunk interfaces.

**EtherChannel (LACP):** SW1 and SW2 interconnected via 16-port LACP EtherChannel (`Port-channel1`) spanning `Fa0/6–Fa0/21` in active mode. On SW1: `Fa0/6–Fa0/13` bundled and active; `Fa0/14–Fa0/21` in hot-standby. `Po1` trunks VLANs 10, 20, 30, 50, 254 with native VLAN 999. DTP negotiation disabled on all trunks.

**Trunk Interfaces:** All inter-device trunks carry VLANs 10, 20, 30, 50, 254 with native VLAN 999, except ESXi uplink (SW1 `Fa0/4`) restricted to VLANs 20, 50.

### Layer 2 Security

**DHCP Snooping (VLANs 20, 30):**
- Trusted: `Fa0/1`, `Fa0/2`, `Fa0/6–Fa0/21`, `Gi0/1`, `Po1` (unlimited)
- Untrusted: `Fa0/4` (SW1 ESXi), `Fa0/22–Fa0/24` (10 pps); `Fa0/5` (50 pps)
- Option 82 insertion disabled

**Dynamic ARP Inspection (VLANs 20, 30):** Source MAC, destination MAC, IP validation enabled. Trust state mirrors DHCP snooping. Logging configured for ACL and DHCP denial events.

**Spanning Tree (PVST):** PortFast on all access and ESXi uplink ports. BPDU Guard on all access and administratively disabled ports.

## Management & Security

| Setting | Details |
|---|---|
| **AAA/TACACS+** | Authenticate via NEXUS01 (`10.10.10.70`, port 49); local fallback; privilege 1 & 15 command accounting; local `azuremaster` fallback account |
| **SNMPv3** | Zabbix monitoring via `zabbix-admin` group (v3 priv) |
| **SSH** | Version 2 only; telnet disabled; VTY 0–4 SSH restricted; VTY 5–15 unrestricted |
| **Syslog** | Forwarded to WAZ01 (`10.10.10.50`) UDP 514; sourced from `Fa0/1`; hostname origin ID |
| **NTP** | Synchronized to DC01 (`10.10.10.10`) |
| **Hardening** | `service password-encryption` enabled; `enable secret` MD5; HTTP/HTTPS disabled; MOTD banner: *"Unauthorized access is strictly prohibited!!!"*; unused ports (Fa0/22–Fa0/24) shut down in VLAN 998 with BPDU Guard; VLAN 1 SVI shut down; management via VLAN 50 SVI only |

## Per-Switch Detail

### SW1

**Management:** SVI `Vlan50` — `10.10.50.9/24`, default gateway `10.10.50.1`

**Interface summary:**

| Interface | Description | Mode | VLANs | Notes |
|---|---|---|---|---|
| `Gi0/1` | R1-CORE uplink | Trunk | 10,20,30,50,254 | DAI/DHCP trusted |
| `Gi0/2` | Reserved — future R2-CORE uplink | Trunk (shutdown) | 10,20,30,50,254 | Administratively down |
| `Fa0/1` | PVE1 | Trunk | 10,20,30,50,254 | DAI/DHCP trusted |
| `Fa0/2` | PVE2 (cross-uplink) | Trunk | 10,20,30,50,254 | DAI/DHCP trusted; not connected |
| `Fa0/3` | Out-of-band management | Access | 50 | Port security: max 3, sticky, restrict |
| `Fa0/4` | VMware ESXi | Trunk | 20,50 | PortFast trunk; DAI untrusted (10 pps); DHCP untrusted (10 pps) |
| `Fa0/5` | Access point (AP-1 CORP) | Access | 20 | PortFast; BPDU Guard|
| `Fa0/6–Fa0/21` | EtherChannel members (Po1 → SW2) | Trunk | 10,20,30,50,254 | DAI/DHCP trusted; LACP active |
| `Fa0/22–Fa0/24` | Unused | Access | 998 | Shutdown; BPDU Guard |

---

### SW2

**Management:** SVI `Vlan50` — `10.10.50.10/24`, default gateway `10.10.50.1`

| Interface | Description | Mode | VLANs | Notes |
|---|---|---|---|---|
| `Gi0/1` | R2-CORE uplink | Trunk | 10,20,30,50,254 | DAI/DHCP trusted |
| `Gi0/2` | Reserved — future R1-CORE uplink | Trunk (shutdown) | 10,20,30,50,254 | Administratively down |
| `Fa0/1` | PVE2 | Trunk | 10,20,30,50,254 | DAI/DHCP trusted |
| `Fa0/2` | PVE1 (cross-uplink) | Trunk | 10,20,30,50,254 | DAI/DHCP trusted |
| `Fa0/3` | Out-of-band management | Access | 50 | Port security: max 3, sticky, restrict |
| `Fa0/4` | Unused | Access | 998 | Shutdown; BPDU Guard |
| `Fa0/5` | Access point (AP-2 GUEST) | Access | 30 | PortFast; BPDU Guard; shutdown |
| `Fa0/6–Fa0/21` | EtherChannel members (Po1 → SW1) | Trunk | 10,20,30,50,254 | DAI/DHCP trusted; LACP active |
| `Fa0/22–Fa0/24` | Unused | Access | 998 | Shutdown; BPDU Guard |
