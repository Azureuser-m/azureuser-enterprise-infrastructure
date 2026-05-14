# Validation

This document tracks validation areas that currently have linked evidence available in the Project-X repository.

## pfSense High Availability, Firewall, NAT, and DNSBL

### Scope
Validate pfSense HA state, firewall policy visibility, NAT visibility, DNS resolver status, and pfBlocker-related test evidence.

### Evidence
- [Firewall evidence folder](./evidence/network/firewalls/)
- [pfSense-01 screenshots](./evidence/network/firewalls/pfsense-01/screenshots/)
- [pfSense-02 screenshots](./evidence/network/firewalls/pfsense-02/screenshots/)
- [pfSense-01 CARP master status](./evidence/network/firewalls/pfsense-01/screenshots/pfsense01_carp_status_master.png)
- [pfSense-02 CARP backup status](./evidence/network/firewalls/pfsense-02/screenshots/pfsense02_carp_status_backup.png)
- [pfSense-01 dashboard](./evidence/network/firewalls/pfsense-01/screenshots/pfsense01_dashboard.jpeg)
- [pfSense-02 dashboard](./evidence/network/firewalls/pfsense-02/screenshots/pfsense02_dashboard.jpeg)
- [pfSense-01 interfaces status](./evidence/network/firewalls/pfsense-01/screenshots/pfsense01_interfaces_status.jpeg)
- [pfSense-01 services status](./evidence/network/firewalls/pfsense-01/screenshots/pfsense01_services_status.png)
- [pfSense-01 DNS resolver](./evidence/network/firewalls/pfsense-01/screenshots/pfsense01_dns_resolver.png)
- [pfSense-02 DNS resolver status](./evidence/network/firewalls/pfsense-02/screenshots/pfsense02_dns_resolver_status.png)
- [pfSense-01 gateways status](./evidence/network/firewalls/pfsense-01/screenshots/gateways_status.png)
- [pfSense-02 gateways status](./evidence/network/firewalls/pfsense-02/screenshots/pfsense02_gateways_status.png)
- [pfSense-01 outbound NAT](./evidence/network/firewalls/pfsense-01/screenshots/pfsense01_nat_outbound.jpeg)
- [LAN firewall rules](./evidence/network/firewalls/pfsense-01/screenshots/lan_firewall_rules.png)
- [NAT port forward](./evidence/network/firewalls/pfsense-01/screenshots/nat_port_forward.png)
- [Sync firewall rules](./evidence/network/firewalls/pfsense-01/screenshots/sync_firewall_rules.png)
- [Installed packages](./evidence/network/firewalls/pfsense-01/screenshots/installed_packages.png)
- [DNSBL group alternative path using UT1](./evidence/network/firewalls/pfsense-01/screenshots/dnsbl_group_alternative_path_using_ut1.png)
- [DNSBL group disabled for testing](./evidence/network/firewalls/pfsense-01/screenshots/dnsbl_group_disabled_for_testing.png)
- [pfBlocker notes](./evidence/network/firewalls/pfblocker_notes.txt)
- [pfBlocker test video](./evidence/network/firewalls/pfblocker_test.mp4)
- [CARP failover test video](./evidence/network/firewalls/carp_failover_test.mp4)

## WAZ01 Core Platform and Logging

### Scope
Validate Wazuh platform accessibility, dashboard visibility, agent visibility, ruleset test artifacts, and logging-related evidence captured from integrated network devices.

### Evidence
- [WAZ01 evidence folder](./evidence/servers/WAZ01/)
- [Wazuh dashboard](./evidence/servers/WAZ01/wazuh_dashboard.png)
- [Wazuh login page](./evidence/servers/WAZ01/wazuh_login_page.png)
- [Wazuh agents](./evidence/servers/WAZ01/wazuh_agents.png)
- [Custom ruleset tests](./evidence/servers/WAZ01/custom_ruleset_tests.txt)
- [WAZ01 validation notes](./evidence/servers/WAZ01/validation-notes.md)
- [SW1 logging screenshot](./evidence/servers/WAZ01/sw1_logging.png)
- [SW2 logging screenshot](./evidence/servers/WAZ01/sw2_logging.png)
- [R2 core logging screenshot](./evidence/servers/WAZ01/r2_core_logging.png)

## WAZ01 LDAPS Integration

### Scope
Validate LDAPS connectivity, Wazuh access behavior, and role or access-related evidence associated with the LDAPS integration area.

### Evidence
- [LDAPS integration folder](./evidence/servers/WAZ01/ldaps_integration/)
- [LDAPS screenshots](./evidence/servers/WAZ01/ldaps_integration/screenshots/)
- [LDAPS videos](./evidence/servers/WAZ01/ldaps_integration/videos/)
- [LDAPS command outputs](./evidence/servers/WAZ01/ldaps_integration/command-outputs/)
- [Security analyst readonly dashboard](./evidence/servers/WAZ01/ldaps_integration/screenshots/sec_analyst01_readonly_dashboard.png)
- [Security analyst restricted permission](./evidence/servers/WAZ01/ldaps_integration/screenshots/sec_analyst01_restricted_permission.png)
- [Video detail note](./evidence/servers/WAZ01/ldaps_integration/screenshots/check_video%20evidence%20for%20more%20detail.txt)
- [SIEM admins permissions video](./evidence/servers/WAZ01/ldaps_integration/videos/siem_admins_permissions.mp4)
- [Security analyst readonly permissions video](./evidence/servers/WAZ01/ldaps_integration/videos/secanalyst01_readonly_permissions.mp4)
- [Wazuh status output](./evidence/servers/WAZ01/ldaps_integration/command-outputs/wazuh_status.txt)
- [LDAPS connect DC01](./evidence/servers/WAZ01/ldaps_integration/command-outputs/ldaps_connect_dc01.txt)
- [LDAPS connect DC02](./evidence/servers/WAZ01/ldaps_integration/command-outputs/ldaps_connect_dc02.txt)
- [Younglord login access](./evidence/servers/WAZ01/ldaps_integration/command-outputs/Younglord_login%20_access.txt)
- [Security analyst login access](./evidence/servers/WAZ01/ldaps_integration/command-outputs/secanalyst01_login%20_access.txt)
- [Helpdesk unauthorized access](./evidence/servers/WAZ01/ldaps_integration/command-outputs/helpdesk01_unauthorized%20_access.txt)

## WAZ01 Slack Integration

### Scope
Validate Slack alerting evidence associated with Wazuh application alerts and burst conditions.

### Evidence
- [Slack integration folder](./evidence/servers/WAZ01/slack_integration/)
- [Slack realtime Wazuh alert video](./evidence/servers/WAZ01/slack_integration/slack_realtime_wazuh_alert.mp4)
- [Wazuh app severity 10+ alert](./evidence/servers/WAZ01/slack_integration/wazuh_app_severity_10+_alert.png)
- [Wazuh app high alert burst monitor triggered](./evidence/servers/WAZ01/slack_integration/wazuh_app_high_alert_burst_monitor_triggered.png)
- [High alert burst](./evidence/servers/WAZ01/slack_integration/high_alert_burst.png)
- [Slack trim notes](./evidence/servers/WAZ01/slack_integration/trim_slack_videos%20and%20pngs.txt)

## ZBX01 Monitoring, LDAPS, and Provisioning

### Scope
Validate Zabbix UI visibility, host visibility, service output, LDAPS proof, JIT or provisioning evidence, and Slack-related screenshot evidence.

### Evidence
- [ZBX01 evidence folder](./evidence/servers/ZBX01/)
- [ZBX01 screenshots](./evidence/servers/ZBX01/screenshots/)
- [ZBX01 command outputs](./evidence/servers/ZBX01/command-outputs/)
- [ZBX01 videos](./evidence/servers/ZBX01/videos/)
- [ZBX01 validation notes](./evidence/servers/ZBX01/validation-notes.md)
- [Dashboard screenshot](./evidence/servers/ZBX01/screenshots/dashboard.png)
- [Hosts screenshot](./evidence/servers/ZBX01/screenshots/hosts.png)
- [LDAPS test proof](./evidence/servers/ZBX01/screenshots/LDAPS_Test_proof.png)
- [Provisioned users](./evidence/servers/ZBX01/screenshots/provisioned_users.png)
- [User groups](./evidence/servers/ZBX01/screenshots/user_groups.png)
- [Slack integration screenshot](./evidence/servers/ZBX01/screenshots/slack_integration.png)
- [Services output](./evidence/servers/ZBX01/command-outputs/Services.txt)
- [LDAP JIT provisioning video](./evidence/servers/ZBX01/videos/ldap_jit_provisioning.mp4)

## NEXUS01 Access Control and TACACS+

### Scope
Validate NEXUS01 access control, TACACS+-related evidence, AD-backed authorization outputs, and associated implementation evidence.

### Evidence
- [NEXUS01 evidence folder](./evidence/servers/NEXUS01/)
- [NEXUS01 screenshots](./evidence/servers/NEXUS01/screenshots/)
- [NEXUS01 command outputs](./evidence/servers/NEXUS01/command-outputs/)
- [NEXUS01 validation notes](./evidence/servers/NEXUS01/validation-notes.md)
- [Cockpit dashboard](./evidence/servers/NEXUS01/cockpit_dashboard.png)
- [Evidence for TACACS+](./evidence/servers/NEXUS01/command-outputs/%23Evidence%20for%20tacacs%2B.txt)
- [Evidence log for TACACS](./evidence/servers/NEXUS01/command-outputs/evidence%20log%20for%20tacacs.txt)
- [AD permitted logon](./evidence/servers/NEXUS01/command-outputs/ad_permitted_logon.txt)
- [AD permitted sudoer](./evidence/servers/NEXUS01/command-outputs/ad_permitted_sudoer.txt)
- [Ansible Wazuh playbook output](./evidence/servers/NEXUS01/command-outputs/ansible-wazuh-playbook.txt)

## Workstation Baseline and Access Control

### Scope
Validate workstation-side baseline configuration evidence, application control evidence, local admin handling, scheduled task evidence, share access evidence, and RDP access evidence.

### Evidence
- [Workstations evidence folder](./evidence/workstations/)
- [Baseline folder](./evidence/workstations/baseline/)
- [Baseline screenshots](./evidence/workstations/baseline/screenshots/)
- [Baseline command outputs](./evidence/workstations/baseline/command-outputs/)
- [Workstation validation notes](./evidence/workstations/baseline/validation-notes.md)
- [Application control workstation GIF](./evidence/workstations/App_install%20control_workstation.gif)
- [PowerShell logging](./evidence/workstations/baseline/screenshots/powershell-logging.png)
- [Workstation GPO result](./evidence/workstations/baseline/command-outputs/gpo_ws.html)
- [Workstation security policy export](./evidence/workstations/baseline/command-outputs/ws01_secpol.inf)
- [ws01 certificate store](./evidence/workstations/baseline/command-outputs/ws01_cert_store.png)
- [ws01 local administrators](./evidence/workstations/baseline/screenshots/ws01_local_admin.png)
- [Password complexity enforcement](./evidence/workstations/baseline/screenshots/password_complexity.png)
- [Invalid logon attempts](./evidence/workstations/baseline/screenshots/invalid_logon_attempts.png)
- [Bootstrap ACL command output](./evidence/workstations/baseline/command-outputs/bootstrap_permission.txt)
- [Bootstrap local admin permissions](./evidence/workstations/baseline/screenshots/Bootstrap_local_admin_permissions.png)
- [Get local admin temp password](./evidence/workstations/baseline/screenshots/Get-local%20admin%20temp%20password.png)
- [Wazuh scheduled task](./evidence/workstations/baseline/screenshots/wazuh_scheduled_task.png)
- [Zabbix scheduled task](./evidence/workstations/baseline/screenshots/Zabbix_scheduled_task.png)
- [Agent bootstrap permission](./evidence/workstations/baseline/screenshots/Agent_bootstrap_permission.png)
- [Network settings](./evidence/workstations/baseline/screenshots/Network_settings.png)
- [Corporate drive access acct.payables](./evidence/workstations/baseline/screenshots/corporate_drive_access(acct.payables).png)
- [helpdesk01 Corporate permission](./evidence/workstations/baseline/screenshots/helpdesk01_Corporate_permission.png)
- [helpdesk RDP to domain controllers](./evidence/workstations/baseline/screenshots/hekpdesk_rdp_to_domain_controllers.png)
- [helpdesk RDP to servers](./evidence/workstations/baseline/screenshots/hekpdesk_rdp_to_servers.png)
- [normal user RDP to servers](./evidence/workstations/baseline/screenshots/normal_user_rdp_to_servers.png)
- [RDP logon access GIF](./evidence/workstations/baseline/screenshots/RDP_logon_access.gif)
- [Local admin group output](./evidence/workstations/baseline/command-outputs/Local_admin_group.txt)
- [IT users share privilege output](./evidence/workstations/baseline/command-outputs/IT_users_share_privilege.txt)
- [File system output](./evidence/workstations/baseline/command-outputs/File_system.txt)
- [GPO13,14 output](./evidence/workstations/baseline/command-outputs/GPO13,14.txt)
- [Bootstrap workstations log](./evidence/workstations/baseline/command-outputs/bootstrap-workstations.log)
- [Wazuh workstation MSI log](./evidence/workstations/baseline/command-outputs/wazuh-workstation-msi.log)
- [Wazuh workstation startup log](./evidence/workstations/baseline/command-outputs/wazuh-workstation-startup.log)
- [Zabbix workstation MSI log](./evidence/workstations/baseline/command-outputs/zabbix-workstation-msi.log)
- [Zabbix workstation startup log](./evidence/workstations/baseline/command-outputs/zabbix-workstation-startup.log)

## DC01 Access Policy, DHCP, DNS, and Manageability

### Scope
Validate DC01 login-policy evidence, DHCP lease/options visibility, DNS zone visibility, and Server Manager manageability evidence currently available for review.

### Evidence
- [DC01 evidence folder](./evidence/servers/DC01/)
- [DC01 screenshots](./evidence/servers/DC01/screenshots/)
- [Who can login video](./evidence/servers/DC01/screenshots/Who_can_login.mp4)
- [Logon warning screenshot](./evidence/servers/DC01/screenshots/logon%20warning.png)
- [DHCP address leases](./evidence/servers/DC01/screenshots/address_leases.png)
- [DHCP server options](./evidence/servers/DC01/dhcp_server_options.png)
- [DHCP scope options](./evidence/servers/DC01/scope_options.png)
- [DNS zone visibility](./evidence/servers/DC01/screenshots/dns.png)
- [Windows servers manageability](./evidence/servers/DC01/screenshots/windows_servers_manageability.png)

### Notes
- `address_leases.png` shows DHCP lease visibility for the `10.10.20.0` CORP VLAN scope, including `ws01` at `10.10.20.10`.
- `dhcp_server_options.png` shows server-level DHCP options, including DNS servers `10.10.10.10` and `10.10.10.11`, boot server host name `10.10.10.70`, and bootfile `undionly.kpxe`.
- `scope_options.png` shows CORP VLAN scope options, including router `10.10.20.1`, DNS servers `10.10.10.10` and `10.10.10.11`, DNS domain `corp.azureuser.org`, PXE/TFTP server `10.10.10.70`, and bootfile `undionly.kpxe`.
- `dns.png` shows DNS Manager visibility for `DC01.corp.azureuser.org` and `DC02.corp.azureuser.org`, with AD-integrated forward lookup zones for `_msdcs.corp.azureuser.org` and `corp.azureuser.org`.
- `windows_servers_manageability.png` shows both `DC01` and `DC02` online in Server Manager.
- `logon warning.png` shows the configured interactive logon warning banner.

## DC02 DHCP, AD CS/PKI, GPO, and Access Policy

### Scope
Validate DC02 DHCP failover visibility, AD CS issuing CA configuration, PKI publication, certificate template/issuance visibility, GPO application, resultant security policy, audit policy, and interactive logon warning evidence.

### Evidence
- [DC02 evidence folder](./evidence/servers/DC02/)
- [DC02 screenshots](./evidence/servers/DC02/screenshots/)
- [DC02 command outputs](./evidence/servers/DC02/command-outputs/)
- [DHCP authorized servers](./evidence/servers/DC02/command-outputs/dhcp_servers.txt)
- [DHCP failover output](./evidence/servers/DC02/command-outputs/dhcp_failover.txt)
- [DHCP scope output](./evidence/servers/DC02/command-outputs/dhcp-server-scope.txt)
- [DHCP failover properties screenshot](./evidence/servers/DC02/screenshots/dc02_dhcp_failover_properties.png)
- [DHCP scope screenshot](./evidence/servers/DC02/screenshots/dc02_dhcp_scope.png)
- [CA discovery output](./evidence/servers/DC02/command-outputs/certutil-dump.txt)
- [CA registry output](./evidence/servers/DC02/command-outputs/certutil-getreg-ca.txt)
- [AIA properties screenshot](./evidence/servers/DC02/screenshots/aia_properties.png)
- [CDP extensions properties screenshot](./evidence/servers/DC02/screenshots/cdp_extenstions_properties.png)
- [Certificate templates screenshot](./evidence/servers/DC02/screenshots/certifcate_templates.png)
- [Issued certificates screenshot](./evidence/servers/DC02/screenshots/issued_certs.png)
- [PKI IIS screenshot](./evidence/servers/DC02/screenshots/pki_iis.png)
- [PKI site screenshot](./evidence/servers/DC02/screenshots/pki_corp_azureuser_org.png)
- [PKI full browser screenshot](./evidence/servers/DC02/screenshots/pki_full.png)
- [DC02 GPO result](./evidence/servers/DC02/command-outputs/GPO_DC02.html)
- [DC02 security policy export](./evidence/servers/DC02/command-outputs/DC02_secpol.inf)
- [DC02 audit policy export](./evidence/servers/DC02/command-outputs/DC02_auditpol.csv)
- [Logon warning screenshot](./evidence/servers/DC02/screenshots/login_warning.png)

### Notes
- `dhcp_servers.txt` confirms authorized DHCP servers `dc01.corp.azureuser.org` at `10.10.10.10` and `dc02.corp.azureuser.org` at `10.10.10.11`.
- `dhcp_failover.txt` and `dc02_dhcp_failover_properties.png` confirm DHCP failover relationship `dc01.corp.azureuser.org-dc02`, partner server `dc01.corp.azureuser.org`, mode `LoadBalance`, and state `Normal`.
- `dhcp-server-scope.txt` and `dc02_dhcp_scope.png` confirm active DHCP scopes for `10.10.20.0` CORP VLAN and `10.10.30.0` GUESTS VLAN.
- `certutil-dump.txt` confirms the issuing CA is `DC02.corp.azureuser.org\corp-ca`.
- `certutil-getreg-ca.txt` confirms `corp-ca` is configured as an Enterprise Subordinate CA with AD integration, CDP/AIA publication paths, CRL settings, and CA security entries.
- `aia_properties.png` shows AIA publication paths for the CA certificate, including LDAP, HTTP PKI, and file-based publication locations.
- `cdp_extenstions_properties.png` shows CDP publication paths and CRL publication options.
- `certifcate_templates.png` shows published certificate templates, including domain controller, Kerberos/domain authentication, web server, computer, user, subordinate CA, and custom DC LDAPS-related template visibility.
- `issued_certs.png` shows issued domain controller certificates for `CORP\DC01$` and `CORP\DC02$`.
- `pki_iis.png`, `pki_corp_azureuser_org.png`, and `pki_full.png` show IIS-backed PKI publication at `pki.corp.azureuser.org/pki/`, including CRL and CA certificate files.
- `GPO_DC02.html` confirms DC02 computer policy processing succeeded and applied relevant GPOs, including `Cert-Autoenroll`, `GPO 01 - Domain Security Baseline`, `GPO 05 - Service Account Restrictions`, and `GPO 30 - Domain Controller Restrictions`.
- `DC02_secpol.inf` confirms resultant security settings including password/lockout policy values, LDAP/server signing-related registry settings, legal notice text/title, machine inactivity timeout, UAC, and restricted DC logon rights.
- `DC02_auditpol.csv` confirms audit settings for logon, logoff, file share, process creation, audit policy change, user account management, directory service changes, and credential validation.
- `login_warning.png` confirms the configured interactive logon warning banner: `WARNING! Unauthorized Access is Strictly Prohibited`.

## BKU01 Corporate File Share Evidence

### Scope
Validate BKU01 Corporate share folder permissions using captured ACL output.

### Evidence
- [BKU01 evidence folder](./evidence/servers/BKU01/)
- [BKU01 screenshots](./evidence/servers/BKU01/screenshots/)
- [BKU01 command outputs](./evidence/servers/BKU01/command-outputs/)
- [Corporate folder permissions](./evidence/servers/BKU01/command-outputs/Corporate_folder_permissions.txt)

### Notes
- `Corporate_folder_permissions.txt` confirms NTFS ACLs for:
    - `C:\Shares\Corporate\Finance`
    - `C:\Shares\Corporate\HR`
    - `C:\Shares\Corporate\IT`
    - `C:\Shares\Corporate\Operations`
    - `C:\Shares\Corporate\Sales`
- The output shows department-specific domain local groups such as:
    - `CORP\DL_File_Finance_RW`
    - `CORP\DL_File_HR_RW`
    - `CORP\DL_File_IT_RW`
    - `CORP\DL_File_Operations_RW`
    - `CORP\DL_File_Sales_RW`

## Server Agent Bootstrap and Scheduled Repair Tasks

### Scope
Validate server-side agent bootstrap, Wazuh/Zabbix server startup behavior, and scheduled repair task evidence.

### Evidence
- [Shared common-reference folder](./evidence/common-reference/)
- [Server bootstrap log](./evidence/common-reference/bootstrap-servers.log)
- [Wazuh server startup log](./evidence/common-reference/wazuh-server-startup.log)
- [Zabbix server startup log](./evidence/common-reference/zabbix-server-startup.log)
- [Server scheduled task output](./evidence/common-reference/GPO_11,12_SERVERS.txt)

### Notes
- `bootstrap-servers.log` confirms server bootstrap copied Wazuh and Zabbix scripts from `\\corp.azureuser.org\NETLOGON\AgentBootstrap\Servers\` and completed successfully.
- `wazuh-server-startup.log` confirms Wazuh agent startup/compliance repair completed successfully.
- `zabbix-server-startup.log` confirms Zabbix agent startup checks completed and reported compliant state.
- `GPO_11,12_SERVERS.txt` confirms scheduled repair tasks exist on BKU01 for:
    - `Zabbix Agent Repair - Servers`
    - `Wazuh Agent Repair - Servers`

## Admin Workstation Hardening and Agent Deployment

### Scope
Validate admin workstation GPO application, local administrator membership control, LAPS-managed breakglass account evidence, scheduled agent repair tasks, and resultant security policy evidence for admin workstations.

### Evidence
- [Admin workstation evidence folder](./evidence/admin-workstations/baseline/)
- [Admin workstation screenshots](./evidence/admin-workstations/baseline/screenshots/)
- [Admin workstation command outputs](./evidence/admin-workstations/baseline/command-outputs/)
- [Admin workstation GPO result](./evidence/admin-workstations/baseline/command-outputs/GPO_AdminsWS.html)
- [Admin workstation security policy export](./evidence/admin-workstations/baseline/command-outputs/GPO_AdminWS.inf)
- [Admin workstation LAPS test](./evidence/admin-workstations/baseline/command-outputs/laps%20test_admin_workstation.txt)
- [Local administrators screenshot](./evidence/admin-workstations/baseline/screenshots/local_admin.png)
- [Wazuh scheduled task screenshot](./evidence/admin-workstations/baseline/screenshots/scheduled_task_wazuh.png)
- [Zabbix scheduled task screenshot](./evidence/admin-workstations/baseline/screenshots/scheduled_task_zabbix.png)

### Notes
- `GPO_AdminsWS.html` confirms the target computer is `CORP\ADM02`, joined to `corp.azureuser.org`, and located under `corp.azureuser.org/Corporate/Admin Workstation`.
- `GPO_AdminsWS.html` confirms successful Group Policy processing with no detected errors.
- `GPO_AdminsWS.html` confirms applied GPOs include `GPO 12 - Admin Workstation Hardening`, `GPO 12 - ZABBIX - Workstations`, `GPO 13 - WAZUH - Workstations`, `GPO 04 - Corporate Baseline`, `GPO 05 - Service Account Restrictions`, `GPO 01 - Domain Security Baseline`, `GPO 00 - Domain Account Policies`, `Default Domain Policy`, and `Cert-Autoenroll`.
- `GPO_AdminsWS.html` confirms `GPO 12 - Admin Workstation Hardening` applied local users/groups preferences to the built-in `Administrators` group and added `CORP\GG_workstation_admins`.
- `local_admin.png` visually confirms the local `Administrators` group contains `Administrator`, `breakglass`, `CORP\Domain Admins`, and `CORP\GG_workstation_admins`.
- `laps test_admin_workstation.txt` confirms Windows LAPS retrieval for `ADM01` and `ADM02`, with managed account `breakglass`, encrypted password source, successful decryption, and `CORP\Domain Admins` as authorized decryptor.
- `scheduled_task_wazuh.png` confirms the `Wazuh agent repair` scheduled task exists, runs as `SYSTEM`, is configured to run with highest privileges, and last completed successfully.
- `scheduled_task_zabbix.png` confirms the `Zabbix Agent Repair - Workstations` scheduled task exists, runs as `SYSTEM`, is configured to run with highest privileges, and last completed successfully.
- `GPO_AdminsWS.html` confirms the Wazuh and Zabbix scheduled task preferences were applied successfully from `GPO 13 - WAZUH - Workstations` and `GPO 12 - ZABBIX - Workstations`.
- `GPO_AdminWS.inf` confirms resultant admin workstation security policy values, including password/lockout policy, legal notice text/title, 900-second inactivity timeout, UAC enabled, anonymous enumeration restrictions, LM compatibility level, and local/RDP logon rights.

## PVE1 Proxmox AD Integration, Access Control, Networking, DNS, Storage, and Disk Evidence

### Scope
Validate PVE1 Proxmox host configuration evidence, AD/LDAPS realm configuration, AD user/group visibility, local storage, disks, network bridges, DNS settings, VM inventory visibility, and role-based privilege behavior.

### Evidence
- [PVE1 evidence folder](./evidence/virtualization/PVE1/)
- [PVE1 screenshots](./evidence/virtualization/PVE1/screenshots/)
- [PVE1 command outputs](./evidence/virtualization/PVE1/command-outputs/)
- [PVE1 AD authentication login success video](./evidence/virtualization/PVE1/ad_authn_login_success.mp4)
- [PVE1 AD authentication permission video](./evidence/virtualization/PVE1/ad_authn_permission.mp4)
- [PVE1 AD realms screenshot](./evidence/virtualization/PVE1/screenshots/ad_realms.png)
- [PVE1 AD server general screenshot](./evidence/virtualization/PVE1/screenshots/ad_server_general.png)
- [PVE1 AD server sync screenshot](./evidence/virtualization/PVE1/screenshots/ad_server_sync.png)
- [PVE1 AD synced users screenshot](./evidence/virtualization/PVE1/screenshots/ad_synced_users.png)
- [PVE1 AD synced groups screenshot](./evidence/virtualization/PVE1/screenshots/ad_synced_groups.png)
- [PVE1 network screenshot](./evidence/virtualization/PVE1/screenshots/network.png)
- [PVE1 DNS screenshot](./evidence/virtualization/PVE1/screenshots/dns.png)
- [PVE1 storage screenshot](./evidence/virtualization/PVE1/screenshots/storage.png)
- [PVE1 disks screenshot](./evidence/virtualization/PVE1/screenshots/disks.png)
- [PVE1 sysadmin sudo denied output](./evidence/virtualization/PVE1/command-outputs/sysadmin_sudo_login_denied.txt)

### Notes
- `ad_realms.png` shows PVE1 configured with the `corp.ad` Active Directory realm, plus local `pam` and `pve` realms.
- `ad_server_general.png` shows the `corp.ad` realm configured for domain `corp.azureuser.org`, server `10.10.10.10`, fallback server `10.10.10.11`, port `636`, and mode `LDAPS`.
- `ad_server_sync.png` shows Active Directory sync options for the `corp.ad` realm, including bind-user configuration and default sync settings.
- `ad_synced_users.png` shows synced AD users visible in Proxmox under the `corp.ad` realm, including administrative, workstation, service, and user accounts.
- `ad_synced_groups.png` shows synced AD groups visible in Proxmox under the `corp.ad` realm, including administrative groups, department groups, and file-access groups.
- `ad_authn_login_success.mp4` documents PVE1 AD authentication login success.
- `ad_authn_permission.mp4` documents PVE1 AD authentication permission behavior.
- `sysadmin_sudo_login_denied.txt` confirms `sysadmin01@corp.azureuser.org` was denied sudo elevation on PVE1 because the account is not in the sudoers file. 
- `network.png` shows PVE1 physical NICs and Linux bridges, including `vmbr0`, `vmbr1`, `vmbr1.50`, and `vmbr2`.
- `network.png` shows `vmbr1.50` configured with `10.10.50.5/24` and gateway `10.10.50.1`.
- `dns.png` shows PVE1 search domain `corp.azureuser.org` and DNS servers `10.10.10.10`, `10.128.100.12`, and `10.128.100.11`.
- `storage.png` shows enabled PVE1 storage entries including `local`, `local-lvm`, `ssd-lvmthin-32gb`, `vg_ssd`, and `vm-storage2`.
- `disks.png` shows detected PVE1 disks, including two 1 TB hard disks and one 32.02 GB SSD, with SMART status shown as `PASSED`.
- The PVE1 left-side inventory shows VMs/guests including `PFSENSE-01`, `DC01`, `ROOTCA01`, `NEXUS01`, `ADM01`, and `ZBX01`.

## PVE2 Proxmox AD Integration, Access Control, Monitoring, and Local Network Evidence

### Scope
Validate PVE2 Proxmox host configuration evidence, AD/LDAPS realm configuration, AD user/group visibility, Proxmox permissions, role-based privilege behavior, monitoring agent service status, local network bridge visibility, and AD authentication login evidence.

### Evidence
- [PVE2 evidence folder](./evidence/virtualization/PVE2/)
- [PVE2 screenshots](./evidence/virtualization/PVE2/screenshots/)
- [PVE2 command outputs](./evidence/virtualization/PVE2/command-outputs/)
- [PVE2 AD authentication login video](./evidence/virtualization/PVE2/ad_authn_login.mp4)
- [PVE2 sysadmin permissions GUI and terminal GIF](./evidence/virtualization/PVE2/sysadmin_permissions_gui_and_terminal.gif)
- [PVE2 AD ACL screenshot](./evidence/virtualization/PVE2/screenshots/ad_acl.png)
- [PVE2 AD server screenshot](./evidence/virtualization/PVE2/screenshots/ad_server.png)
- [PVE2 AD server general screenshot](./evidence/virtualization/PVE2/screenshots/ad_server_general.png)
- [PVE2 AD synced groups screenshot](./evidence/virtualization/PVE2/screenshots/ad_synced_groups.png)
- [PVE2 AD synced users screenshot](./evidence/virtualization/PVE2/screenshots/ad_synced_users.png)
- [PVE2 local network screenshot](./evidence/virtualization/PVE2/screenshots/local_network.png)
- [PVE2 realms screenshot](./evidence/virtualization/PVE2/screenshots/realms.png)
- [PVE2 sudoers screenshot](./evidence/virtualization/PVE2/screenshots/sudoers.png)
- [PVE2 sudoers command output](./evidence/virtualization/PVE2/command-outputs/sudoers.txt)
- [PVE2 Wazuh agent service status](./evidence/virtualization/PVE2/command-outputs/wazuh-agent.service_status.txt)
- [PVE2 Zabbix agent service status](./evidence/virtualization/PVE2/command-outputs/zabbix-agent2.service_status.txt)

### Notes
- `realms.png` shows PVE2 configured with the `corp.ad` Active Directory realm, plus local `pam` and `pve` realms.
- `ad_server_general.png` shows the `corp.ad` realm configured for domain `corp.azureuser.org`, server `10.10.10.10`, fallback server `10.10.10.11`, port `636`, and mode `LDAPS`.
- `ad_server.png` shows the `corp.ad` realm sync job enabled with a scheduled next run.
- `ad_server_sync.png` shows Active Directory sync options for the `corp.ad` realm, including bind-user configuration, user/group sync scope, and enabled new-user synchronization.
- `ad_synced_users.png` shows synced AD users visible in Proxmox under the `corp.ad` realm, including workstation, server, service, and named user accounts.
- `ad_synced_groups.png` shows synced AD groups visible in Proxmox under the `corp.ad` realm, including administrative groups, department groups, helpdesk groups, security groups, and file-access groups.
- `ad_acl.png` shows Proxmox ACL assignments, including:
  - `azuremaster@corp.ad` with `Administrator`
  - `younglord@corp.ad` with `Administrator`
  - `@GG_IT_Security-corp.ad` with `PVEAuditor`
  - `sysadmin01@corp.ad` with `PVESysAdmin`
  - `svc.backup@corp.ad` with `PVEDatastoreUser`
- `sudoers.png` shows PVE2 privilege testing from the Proxmox shell.
- `sudoers.txt` confirms `younglord@corp.azureuser.org` and `azuremaster@corp.azureuser.org` can elevate to root with `sudo -i`.
- `sudoers.txt` confirms `sysadmin01@corp.azureuser.org` and `secanalyst01@corp.azureuser.org` were denied `su` access.
- `sysadmin_permissions_gui_and_terminal.gif` documents PVE2 sysadmin permission behavior through the Proxmox GUI and terminal.
- `ad_authn_login.mp4` documents PVE2 AD authentication login behavior.
- `local_network.png` shows PVE2 local network bridge visibility, including `vmbr0`, `vmbr1`, and `vmbr2`.
- `wazuh-agent.service_status.txt` confirms `wazuh-agent.service` is loaded, enabled, and active/running on PVE2.
- `zabbix-agent2.service_status.txt` confirms `zabbix-agent2.service` is loaded, enabled, and active/running on PVE2.

### Validation Status
- AD/LDAPS realm configuration: supported by screenshots.
- AD user/group visibility: supported by screenshots.
- Proxmox ACL and role assignment visibility: supported by screenshots.
- Authorized sudo elevation: supported by command output.
- Denied unauthorized account switching: supported by command output.
- Wazuh and Zabbix agent runtime status: supported by command output.
- Local network bridge visibility: supported by screenshot.
- AD login and permission behavior: supported by recorded media evidence.

## Not Included Yet

- Direct router validation
- Direct switch validation
- ROOTCA01
- BKU01
