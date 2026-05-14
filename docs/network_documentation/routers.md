## Routers

R1-CORE and R2-CORE are the core layer-3 routing devices providing inter-VLAN routing, default gateway redundancy via HSRP, DHCP relay, inbound traffic policy enforcement via ACLs, and default route forwarding to the pfSense CARP VIP. R1-CORE is the HSRP active router; R2-CORE is standby.

| | R1-CORE | R2-CORE |
|---|---|---|
| **Model** | Cisco 2901 (`CISCO2901/K9`) | Cisco ISR 4321 (`ISR4321/K9`) |
| **IOS Version** | 15.4(3)M3 | IOS XE 16.6.3 |
| **Trunk Interface** | `GigabitEthernet0/1` | `GigabitEthernet0/0/1` |
| **HSRP Role** | Active (priority 110) | Standby (priority 105) |

## Routing Configuration

### Subinterface Layout

Both routers terminate identical 802.1Q subinterfaces. Subinterface `.999` (native VLAN) is shut down to prevent untagged frame processing.

| Subinterface | VLAN | Description | R1-CORE IP | R2-CORE IP | HSRP VIP |
|---|---|---|---|---|---|
| `.10` | 10 | Servers | `10.10.10.2` | `10.10.10.3` | `10.10.10.1` |
| `.20` | 20 | Corp | `10.10.20.2` | `10.10.20.3` | `10.10.20.1` |
| `.30` | 30 | Guest | `10.10.30.2` | `10.10.30.3` | `10.10.30.1` |
| `.50` | 50 | Management | `10.10.50.2` | `10.10.50.3` | `10.10.50.1` |
| `.254` | 254 | Transit (pfSense) | `10.10.254.2` | `10.10.254.3` | `10.10.254.1` |

**Routing:** Static default route `S* 0.0.0.0/0 [1/0] via 10.10.254.4` on both routers. Directly connected routes for all subinterfaces. No dynamic routing protocols in use.

**DHCP Relay:** VLAN 20 and 30 subinterfaces relay DHCP to DC01 (`10.10.10.10`) and DC02 (`10.10.10.11`).

### HSRP

HSRP is configured across all five active subinterfaces. R1-CORE (priority 110) is active; R2-CORE (priority 105) is standby. Preemption is enabled on all groups.

R1-CORE runs IP SLA probing the pfSense CARP VIP (`10.10.254.4`) via ICMP every 5 seconds. If unreachable, R1-CORE's priority decrements by 30 to 80 on all groups, triggering R2-CORE failover. R2-CORE has no tracking configured (no benefit as last-resort gateway).

## Security & Access Control

### ACLs

| ACL Name | Applied To | Purpose | Rules |
|---|---|---|---|
| `VTY-ACL` | VTY lines 0–4 | Management access | SSH access from VLAN 50 (`10.10.50.0/24`) only; deny all other sources |
| `CORP-ACL` | VLAN 20 inbound | Workstation policy | Allow DHCP; deny SSH/RDP to Server VLAN (`10.10.10.0/24`); deny access to VLAN 30/50; permit established RDP return to VLAN 50; permit remaining traffic |
| `GUEST-ACL` | VLAN 30 inbound | Guest isolation | Allow DHCP; permit DNS to DC01/DC02 only; deny all internal `10.10.0.0/16`; permit internet-bound |

### Authentication & Accounting (AAA/TACACS+)

Both routers authenticate via TACACS+ server NEXUS01 (`10.10.10.70`, port 49) with local fallback. Includes command accounting (privilege 1 & 15) and exec accounting (start-stop records). Local `azuremaster` account retained as fallback credential.

### Management & Monitoring

| Setting | Details |
|---|---|
| **SSH** | Version 2 only; telnet disabled; restricted to VLAN 50 via `VTY-ACL` |
| **SNMPv3** | Monitored by Zabbix; `zabbix-admin` group with MD5 auth + AES128 privacy; user `azuremaster` assigned |
| **Syslog** | Forwarded to WAZ01 (`10.10.10.50`) UDP 514 at info level; sourced from VLAN 10; hostname-based origin ID |
| **NTP** | Synchronized to DC01 (`10.10.10.10`) |
| **DNS** | Domain `corp.azureuser.org`; DC01 as nameserver; `no ip domain lookup` enabled |

### Hardening

- `service password-encryption` enabled
- `enable secret` with MD5 hashing
- HTTP/HTTPS management disabled
- MOTD banner: *"Unauthorized access is strictly prohibited!!!"*
- Unused interfaces shut down