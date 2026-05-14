## Troubleshooting Note: TACACS+ Authorization and Profile Mapping Validation

**Date worked on:** April 6, 2026  
**System worked on:** `nexus.corp.azureuser.org` / `tac_plus-ng` / MAVIS PAM backend  
**Summary:** TACACS+ authentication through MAVIS was working, but shell login was initially failing during authorization. Logs showed `ACK` from MAVIS followed by shell login denial, pointing to the authorization ruleset rather than the authentication backend.  
**Issue observed:** Users could authenticate against the backend, but TACACS+ shell access was denied instead of assigning the expected profile.  
**Evidence reviewed:** `journalctl -f _COMM=tac_plus-ng`, `/usr/local/etc/tac_plus-ng.cfg`, and login results for `azuremaster`, `network.admin`, and `younglord`.  
**Likely issue identified:** The final line in the `group_map` ruleset was set to `deny`, causing authorization failure when earlier group evaluation did not resolve as expected.  
**Change made:** Updated the final line in the `group_map` ruleset from `deny` to `permit` and re-tested TACACS+ logins.  
**Validation results:** `azuremaster` succeeded with `profile=admin`, `network.admin` succeeded with `profile=admin`, and `younglord` succeeded with `profile=readonly`.  
**Outcome:** TACACS+ authentication, authorization, and profile assignment were successfully validated after the ruleset change.

## Troubleshooting Note: TACACS+ Listener Not Running and Systemd Startup Fix

**Date worked on:** May 6, 2026
**System worked on:** `nexus.corp.azureuser.org` / `tac_plus-ng` / MAVIS PAM backend
**Summary:** TACACS+ authentication had worked previously, but SW1 could no longer connect to NEXUS01 on TCP/49. ICMP reachability to `10.10.10.70` was successful, but TCP/49 returned `Connection refused`, proving the issue was on the TACACS+ listener side rather than routing or VLAN reachability.
**Issue observed:** SW1 could ping NEXUS01, but `telnet 10.10.10.70 49` failed with `Connection refused by remote host`. On NEXUS01, `ss -lntp | grep ':49'` initially showed no listener, and attempted service checks for `spawnd`, `tac_plus_ng`, and `tac_plus_ng.service` failed because those units did not exist.
**Evidence reviewed:** SW1 ping and telnet output, `systemctl status spawnd`, `systemctl status tac_plus_ng`, `ss -lntp | grep ':49'`, `/var/log/tac_plus/authc.log`, `command -v tac_plus-ng`, `command -v pammavis`, and `/usr/local/etc/tac_plus-ng.cfg`. The PAM backend uses `/etc/pam.d/tacacs`, which authenticates through `pam_sss.so` and restricts access to `GG_Network_Admins` / `GG_Network_readonly`. 
**Likely issue identified:** The installed TACACS+ daemon was `tac_plus-ng`, not `spawnd` or `tac_plus_ng`. No persistent systemd service existed for the installed binary, so TACACS+ was not automatically running/listening on TCP/49 after restart or service interruption.
**Change made:** Confirmed the installed binaries were `/usr/local/sbin/tac_plus-ng` and `/usr/local/sbin/pammavis`, then started TACACS+ using `/usr/local/sbin/tac_plus-ng -f /usr/local/etc/tac_plus-ng.cfg`. A persistent systemd unit was created at `/etc/systemd/system/tac_plus-ng.service` using `ExecStart=/usr/local/sbin/tac_plus-ng -f /usr/local/etc/tac_plus-ng.cfg`, followed by `systemctl daemon-reload` and `systemctl enable --now tac_plus-ng`.
**Validation results:** `ss -lntp | grep ':49'` showed `tac_plus-ng` listening on TCP/49. SW1 could then connect to NEXUS01 on TACACS+ port 49, confirming the listener was active.
**Outcome:** TACACS+ service availability was restored. The root cause was not routing, firewall transit, or PAM/MAVIS authentication; it was the TACACS+ daemon not running persistently under systemd. NEXUS01 now has a systemd-managed `tac_plus-ng` service for persistent TACACS+ startup.