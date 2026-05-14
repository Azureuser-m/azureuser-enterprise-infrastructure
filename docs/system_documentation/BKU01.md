## BKU01

### Purpose
BKU01 is the dedicated file server and backup host in the AzureUser environment, providing domain-joined SMB file shares with department-scoped NTFS permissions, a centralized logging drop, and a software distribution share. Veeam Backup & Replication is installed for scheduled backup operations.

**Host Access Control**
- **Authentication**: Domain-joined to `corp.azureuser.org`; authentication handled by Active Directory via DC01 (`10.10.10.10`) and DC02 (`10.10.10.11`).
- **Local logon**: `Administrators`, `CORP\GG_IT_Infrastructure`, `CORP\GG_IT_Security`, and `CORP\GG_Server_Admins` are permitted to log on locally.
- **RDP access**: Restricted to `CORP\GG_Server_Admins` only.
- **Local administrators**: `CORP\GG_Server_Admins` and `CORP\Domain Admins` hold local administrator rights. A local `breakglass` account is present for emergency access.

## File Server

### Overview
BKU01 runs the **File Server** role (`FS-FileServer`) on Windows Server 2025 Standard Evaluation (`10.0.26100`), hosted on VLAN 10 at `10.10.10.30/24`. Three SMB shares are published: `Corporate` for department file access, `logging` for PowerShell and script log drops, and `software` for internal tool distribution. 

### SMB Shares

| Share       | Path                    | Access-Based Enumeration | Encryption |
|-------------|-------------------------|--------------------------|------------|
| `Corporate` | `C:\Shares\Corporate`   | Enabled                  | Yes        |
| `logging`   | `C:\Shares\logging`     | Disabled                 | Yes        |
| `software`  | `C:\Shares\software`    | Disabled                 | No         |

All three shares grant `Everyone` Full Control at the share permission level; access is enforced exclusively at the NTFS layer.

### NTFS Permissions

**Corporate share** — root ACL restricts access to `Authenticated Users` (read/execute) and `Administrators`/`Domain Admins`/`SYSTEM` (full control). Child folder permissions break inheritance and assign write access to the relevant Domain Local group per department:

| Folder                        | Write / Read-Execute Group          | Read-Only Groups                                      |
|-------------------------------|-------------------------------------|-------------------------------------------------------|
| `Corporate\Finance`           | `CORP\DL_File_Finance_RW`           | —                                                     |
| `Corporate\HR`                | `CORP\DL_File_HR_RW`                | —                                                     |
| `Corporate\IT`                | `CORP\DL_File_IT_RW`                | —                                                     |
| `Corporate\Operations`        | `CORP\DL_File_Operations_RW`        | `CORP\GG_Executives`, `CORP\GG_Finance_Users`         |
| `Corporate\Sales`             | `CORP\DL_File_Sales_RW`             | `CORP\GG_Finance_Users`                               |

This follows the AGDLP model defined in the domain group design: users are members of Global groups, which are nested into Domain Local groups assigned to each folder.

**logging share** — `BUILTIN\Users` inherits read/execute, append, and create rights on child folders (`servers\`, `workstation\`). `CORP\helpdesk01` holds an explicit Full Control entry on `workstation\`.

**software share** — `BUILTIN\Users` holds read/execute, append, and create rights; no department-scoped child folder ACLs are defined.

**File Share access auditing** (`Success and Failure`) is active. Logon failures and Logoff successes are also audited. All other subcategories are set to No Auditing.

---

## Veeam Backup & Replication

### Overview

> ⚠️ *This section is a placeholder. Veeam Backup & Replication is installed on BKU01 but backup jobs, schedules, retention policies, and target configuration have not yet been implemented. This section will be completed when Veeam is configured.*

For validation details, see `validation.md`. For supporting screenshots and job output, see the `evidence/` folder.