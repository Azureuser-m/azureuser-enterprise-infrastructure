## PFS01 / PFS02

### Purpose

PFS01 and PFS02 are the perimeter firewalls for the AzureUser.org environment, deployed as a CARP high-availability pair. PFS01 operates as the active MASTER node; PFS02 operates as the passive BACKUP node. Together they provide NAT, policy enforcement, DNS interception, threat blocking via pfBlockerNG, and centralized firewall log forwarding to WAZ01.

---

### Network Interfaces

Each node has three interfaces:

| Interface | Adapter | PFS01 Address | PFS02 Address | Purpose |
|-----------|---------|---------------|---------------|---------|
| WAN | `vtnet0` | DHCP | DHCP | Shared upstream WAN |
| LAN | `vtnet1` | `10.10.254.5/29` | `10.10.254.6/29` | Transit to internal routing layer |
| SYNC (`opt1`) | `vtnet2` | `10.10.253.1/30` | `10.10.253.2/30` | Dedicated HA sync interface |

The shared CARP virtual IP is `10.10.254.4/29` on the LAN interface (VHID 4). PFS01 holds MASTER status (`advskew 0`); PFS02 holds BACKUP status (`advskew 100`). Internal traffic from R1 and R2 targets this VIP as its upstream/default gateway.

---

### Routing

Both nodes carry identical static routes, synchronized from PFS01 to PFS02 via XMLRPC:

| Network | Gateway | Description |
|---------|---------|-------------|
| `10.10.10.0/24` | `LANGW` (`10.10.254.1`) | Servers VLAN |
| `10.10.20.0/24` | `LANGW` | Corporate VLAN |
| `10.10.30.0/24` | `LANGW` | Guest VLAN |
| `10.10.50.0/24` | `LANGW` | Management VLAN |

DNS is resolved using DC01 (`10.10.10.10`) and DC02 (`10.10.10.11`) as downstream servers.

---

### NAT

Outbound NAT is configured in hybrid mode. A manual rule masquerades all traffic from `10.10.0.0/16` to the WAN IP, covering all internal VLANs in a single rule.

---

### DNS Enforcement

A NAT port forward on the LAN interface intercepts any DNS request (TCP/UDP port 53) redirects it to `127.0.0.1:53`, forcing all client DNS through the local Unbound resolver. The associated firewall rule permits this redirected traffic. This prevents clients from bypassing the firewall's DNS controls, including pfBlockerNG DNSBL.

Unbound is configured with DNSSEC, an internal ACL permitting queries from `10.10.0.0/16`, and the pfBlockerNG Python plugin for DNSBL enforcement.

---

### Firewall Rules

Both nodes share the same rule set (synchronized from PFS01). Key rules on the LAN interface:

- **pfB_PRI1_v4 reject** — Rejects outbound traffic to IPs in the pfBlockerNG PRI1 blocklist alias.
- **DNS redirect pass** — Permits the NAT-redirected DNS traffic to the local resolver.
- **Internal pass** — Permits all traffic sourced from `10.10.0.0/16` to any destination.
- **Default LAN allow** — Standard pfSense default LAN-to-any pass rule (IPv4 and IPv6).

Rules on the SYNC (`opt1`) interface permit pfsync state synchronization traffic, TCP configuration sync, and ICMP for diagnostics between the two nodes.

---

### pfBlockerNG

pfBlockerNG-devel v3.2.10 is installed on both nodes.

**IP Blocking (IPv4 — PRI1 tier)**

Action is `Deny_Outbound`, updated hourly. Six feeds are aggregated into the `pfB_PRI1_v4` alias:

| Feed Header | Source |
|-------------|--------|
| `Abuse_Feodo_C2` | feodotracker.abuse.ch |
| `CINS_army` | cinsarmy.com |
| `ET_Block` | rules.emergingthreats.net |
| `ET_Comp` | rules.emergingthreats.net |
| `ISC_Block` | isc.sans.edu |
| `Spamhaus_Drop` | spamhaus.org |

**DNSBL**

Four DNSBL lists are configured (`UT1_DATING`, `ADs_Basic`, `UT1_Ai`, `testing`). All are currently set to `Disabled`, check pfblocker.mp4 for test status. DNSBL infrastructure (Python mode, loopback VIP `10.10.24.5`, HSTS, CNAME validation) is present and functional.

> Note: Initial pfBlockerNG testing `pfblocker.mp4` was affected by stale DNS cache. ChatGPT had been accessed before the UT1_Ai feed was enabled and remained reachable, while Claude AI, which had not been previously accessed, was blocked as expected. Clearing browser cache and flushing DNS did not change the result. Follow-up testing indicated the behavior was caused by stale DNS cache on the internal DNS server, not by browser cache or website-side caching. check `pfblocker_test2.mp4` for video details 

---

### Syslog Forwarding

Both nodes forward all firewall logs to WAZ01 (`10.10.10.50:514`) using RFC 5424 format over UDP, sourced from the LAN interface. Configuration change logging is enabled. This feeds the custom pfSense decoder and rule set documented in `waz01.md`.

---

### High Availability Synchronization

CARP failover and state synchronization operate over the dedicated SYNC interface (`opt1`, `10.10.253.0/30`). PFS01 (pfhostid 1) pushes the following configuration sections to PFS02 (pfhostid 2) via XMLRPC on `10.10.253.2`:

users, auth servers, certificates, firewall rules, schedules, aliases, NAT, OpenVPN, static routes, virtual IPs, traffic shaper, traffic shaper limiters, DNS forwarder, and captive portal.

PFS02 does not push configuration back to PFS01.

---

### Monitoring

Both nodes run Zabbix Agent 7 (v1.0.9_1), reporting to ZBX01 at `10.10.10.40` on port `10050`. Agent transport is PSK-encrypted on both nodes.

For validation details, see `validation.md`. For supporting screenshots, logs, and command output, see the `evidence/` folder.

---

## Production Considerations

- **Loopback VIP `10.10.24.5`** — Replace with custom block notification webpage instead of unused VIP address
- Tailor pfBlockerNG feeds and blocking tiers to organizational risk tolerance and threat landscape; consider enabling additional feeds and DNSBL lists as needed.