# Incident Log
## Incident: PVE2 Unreachable and Silent Host Hang

**Date detected:** March 14, 2026  
**System affected:** PVE2 / Proxmox / pfSense HA  
**Summary:** PVE2 became unreachable while still powered on. No further logs or user activity were recorded until manual reboot.  
**Impact:** Loss of Proxmox GUI, management access, and host-related connectivity  
**Timeline:** See incident entry  
**Evidence reviewed:** journalctl, last, boot history, SMART output  
**Likely cause:** Silent host-level hang or severe lockup  
**Recovery action:** Manual reboot on March 16, 2026 around 03:02 PM CDT  
**Follow-up actions:** Review BIOS power settings, check additional disk health, improve monitoring and remote logging

## Incident: Wazuh Dashboard Not Ready Due to Host Disk I/O Bottleneck

**Date detected:** March 25, 2026  
**System affected:** WAZ01 / Wazuh Dashboard / Wazuh Indexer  
**Summary:** The Wazuh web interface displayed "Wazuh dashboard server is not ready yet" even though the wazuh-dashboard service was running. The backend wazuh-indexer service failed to complete startup before timeout.  
**Impact:** Wazuh dashboard unavailable; backend indexing service not fully operational  
**Timeline:** See incident entry  
**Evidence reviewed:** systemctl status, journalctl, memory usage, disk usage, service behavior during reduced VM load  
**Likely cause:** Host storage bottleneck causing high I/O delay during wazuh-indexer startup  
**Recovery action:** Reduced host load by shutting down some VMs, then restarted the service successfully  
**Follow-up actions:** Monitor host disk latency and I/O wait, reduce storage contention, consider faster storage for Wazuh workloads, document indexer sensitivity to host disk performance

## Incident: DC02 Enterprise CA Revocation Failure Due to Expired Root CRL

**Date detected:** April 7, 2026  
**System affected:** DC02 / AD CS / Certification Authority  
**Summary:** DC02 showed `0x80092013 (CRYPT_E_REVOCATION_OFFLINE)` because the root CRL had expired, and the existing subordinate CA certificate still referenced an old root CDP path while ROOTCA01 was offline.  
**Impact:** CA console showed revocation errors and `certsrv` did not start cleanly until recovery steps were applied.  
**Timeline:** See incident entry  
**Evidence reviewed:** PKI HTTP/share access, root CRL validity, `certutil -url`, `certutil -urlfetch -verify`, and CA service behavior  
**Cause:** Expired `Corp-RootCA.crl` plus stale CDP information embedded in the subordinate CA certificate  
**Recovery action:** Published a fresh root CRL, copied it to DC02 publication paths, cleared cache, temporarily enabled offline revocation ignore, started `certsrv`, and published a fresh issuing CA CRL  
**Follow-up actions:** Monitor CRL expiry, document manual offline root CRL renewal, and later renew/reissue the subordinate CA certificate so it uses the correct HTTP root CDP

### Incident entry

- DC02 CA console showed revocation offline errors while ROOTCA01 was offline.
- Root CRL was found to be expired.
- `certutil -urlfetch -verify` showed the subordinate CA certificate was still checking `file:////ROOTCA01/CertEnroll/Corp-RootCA.crl`.
- A fresh root CRL was published and copied to DC02.
- Cache was reset and temporary offline revocation ignore was enabled.
- `certsrv` started successfully and DC02 published a new CRL.
- Remaining verify errors against the subordinate CA certificate were due to the old embedded CDP and were left as a later cleanup item.

## Incident: NEXUS01 TACACS+ Service Unavailable Due to Missing Persistent `tac_plus-ng` Service

**Date detected:** May 6, 2026  
**System affected:** `nexus.corp.azureuser.org` / `tac_plus-ng` / MAVIS PAM backend / Cisco AAA clients  
**Severity:** Medium centralized network device AAA was unavailable, but local device fallback remained available  
**Summary:** SW1 could reach NEXUS01 by ICMP, but TACACS+ TCP/49 returned `Connection refused`. The issue was isolated to NEXUS01 because routing was working, but no TACACS+ listener was active on port 49.  
**Impact:** Routers and switches could not use NEXUS01 for TACACS+ authentication while the service was down. AAA fallback/local access was required until TACACS+ service availability was restored.  
**Timeline:** See incident entry  
**Evidence reviewed:** SW1 `ping 10.10.10.70`, SW1 `telnet 10.10.10.70 49`, `systemctl status spawnd`, `systemctl status tac_plus_ng`, `ss -lntp | grep ':49'`, `/var/log/tac_plus/authc.log`, `command -v tac_plus-ng`, `command -v pammavis`, and systemd service status output.  
**Cause:** `tac_plus-ng` was installed and configured, but no persistent systemd service existed initially. TACACS+ had  been started manually before, so after interruption/restart it was no longer listening on TCP/49.  
**Recovery action:** Confirmed the correct daemon was `/usr/local/sbin/tac_plus-ng`, started it with `/usr/local/etc/tac_plus-ng.cfg`, created a persistent `tac_plus-ng.service` systemd unit, reloaded systemd, enabled the service, and confirmed TCP/49 was listening.  
**Follow-up actions:** Capture final service status evidence, confirm AAA login from SW1/SW2/R1/R2, test local fallback, and document the systemd unit as part of NEXUS01 configuration.

### Incident entry

* SW1 successfully pinged NEXUS01 at `10.10.10.70`.
* SW1 failed to connect to TACACS+ with `telnet 10.10.10.70 49`, returning `Connection refused by remote host`.
* NEXUS01 initially showed no listener on TCP/49 with `ss -lntp | grep ':49'`.
* Attempts to check `spawnd.service` and `tac_plus_ng.service` failed because those systemd units did not exist.
* Local binary checks showed:

  * `/usr/local/sbin/tac_plus-ng` existed
  * `/usr/local/sbin/pammavis` existed
  * `spawnd` did not exist as a standalone binary
* TACACS+ was started using the installed `tac_plus-ng` binary and `/usr/local/etc/tac_plus-ng.cfg`.
* A new systemd unit was created at `/etc/systemd/system/tac_plus-ng.service`.
* `systemctl daemon-reload` and `systemctl enable --now tac_plus-ng` were run.
* TCP/49 was confirmed listening with `ss -lntp | grep ':49'`.
* Final validation confirmed TACACS+ service availability was restored.

### What changed

* Added persistent systemd management for `tac_plus-ng`.
* Confirmed the active TACACS+ daemon is `tac_plus-ng`, not `spawnd` or `pammavis`.
* Confirmed `pammavis` is part of the MAVIS/PAM authentication chain, not the service listener.
* Restored TACACS+ listener availability on TCP/49 for Cisco AAA clients.





