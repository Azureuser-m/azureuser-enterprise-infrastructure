# STARTUP - Zabbix - Servers.ps1

$ErrorActionPreference = 'Stop'

# Core settings
$ZabbixServer   = '10.10.10.40'
$ServerActive   = '10.10.10.40'
$HostMetadata   = 'windows-server'
$InstallFolder  = 'C:\Program Files\Zabbix Agent 2'
$ConfigPath     = Join-Path $InstallFolder 'zabbix_agent2.conf'
$MsiPath        = "\\corp.azureuser.org\NETLOGON\Software\zabbix_agent2-7.4.7.msi"

# Folder layout
$LocalRoot    = 'C:\ProgramData\AgentBootstrap'
$ScriptRoot   = Join-Path $LocalRoot 'scripts'
$LogRoot      = Join-Path $LocalRoot 'logs'
$CacheRoot    = Join-Path $LocalRoot 'cache'

# Logs and local MSI cache
$ScriptLog    = Join-Path $LogRoot 'zabbix-server-startup.log'
$MsiLog       = Join-Path $LogRoot 'zabbix-server-msi.log'
$LocalMsiPath = Join-Path $CacheRoot (Split-Path $MsiPath -Leaf)

New-Item -ItemType Directory -Path $LocalRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ScriptRoot -Force | Out-Null
New-Item -ItemType Directory -Path $LogRoot -Force | Out-Null
New-Item -ItemType Directory -Path $CacheRoot -Force | Out-Null

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = 'INFO'
    )

    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    Add-Content -Path $ScriptLog -Value $line
}

function Backup-File {
    param([string]$Path)

    if (Test-Path $Path) {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        Copy-Item -Path $Path -Destination "$Path.$stamp.bak" -Force
    }
}

function Get-IniValue {
    param(
        [string]$Path,
        [string]$Key
    )

    if (-not (Test-Path $Path)) {
        return $null
    }

    $line = Get-Content -Path $Path | Where-Object {
        $_ -match "^\s*$Key\s*=" -and $_ -notmatch '^\s*[#;]'
    } | Select-Object -First 1

    if (-not $line) {
        return $null
    }

    (($line -split '=', 2)[1]).Trim()
}

function Set-IniValue {
    param(
        [string]$Path,
        [string]$Key,
        [string]$Value
    )

    $lines = if (Test-Path $Path) { Get-Content -Path $Path } else { @() }
    $found = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^\s*$Key\s*=" -and $lines[$i] -notmatch '^\s*[#;]') {
            $lines[$i] = "$Key=$Value"
            $found = $true
            break
        }
    }

    if (-not $found) {
        $lines += "$Key=$Value"
    }

    Set-Content -Path $Path -Value $lines -Encoding ASCII
}

function Get-ZabbixService {
    Get-Service | Where-Object {
        $_.DisplayName -like 'Zabbix Agent*'
    } | Select-Object -First 1
}

try {
    Write-Log "=== Zabbix server startup script started ==="

    $productType = (Get-CimInstance Win32_OperatingSystem).ProductType
    if ($productType -eq 1) {
        Write-Log "Workstation OS detected. Exiting."
        exit 0
    }

    $svc = Get-ZabbixService
    $serverOk = ($svc -and (Get-IniValue -Path $ConfigPath -Key 'Server') -eq $ZabbixServer)
    $activeOk = ($svc -and (Get-IniValue -Path $ConfigPath -Key 'ServerActive') -eq $ServerActive)

    if ($svc -and $serverOk -and $activeOk) {
        if ($svc.Status -ne 'Running') {
            Start-Service -Name $svc.Name
            Write-Log "Zabbix already installed and configured. Service was stopped and has been started."
        }
        else {
            Write-Log "Zabbix already compliant. No action needed."
        }
        exit 0
    }

    if (-not $svc) {
        Write-Log "Zabbix service not found. Preparing install source."
        New-Item -ItemType Directory -Path $InstallFolder -Force | Out-Null

        $InstallSource = $null

        if (Test-Path $LocalMsiPath) {
            Write-Log "Using local cached MSI: $LocalMsiPath"
            $InstallSource = $LocalMsiPath
        }
        elseif (Test-Path $MsiPath) {
            Write-Log "Local MSI not found. Copying from share: $MsiPath"
            Copy-Item -Path $MsiPath -Destination $LocalMsiPath -Force
            $InstallSource = $LocalMsiPath
        }
        else {
            Write-Log "Neither local nor network MSI is reachable. Local: $LocalMsiPath | Network: $MsiPath" 'ERROR'
            exit 1
        }

        if (-not (Test-Path $InstallSource)) {
            Write-Log "Install source still not found after preparation: $InstallSource" 'ERROR'
            exit 1
        }

        Write-Log "Installing Zabbix from: $InstallSource"

        $args = @(
            '/i'
            "`"$InstallSource`""
            '/qn'
            "INSTALLFOLDER=`"$InstallFolder`""
            "SERVER=$ZabbixServer"
            "SERVERACTIVE=$ServerActive"
            "HOSTNAME=$env:COMPUTERNAME"
            "HOSTMETADATA=$HostMetadata"
            'STARTUPTYPE=automatic'
            '/l*v'
            "`"$MsiLog`""
        )

        $proc = Start-Process -FilePath 'msiexec.exe' -ArgumentList $args -Wait -NoNewWindow -PassThru
        Write-Log "msiexec exit code: $($proc.ExitCode)"

        if ($proc.ExitCode -notin 0, 3010) {
            Write-Log "Zabbix install failed. Check MSI log: $MsiLog" 'ERROR'
            exit 1
        }

        $svc = Get-ZabbixService
    }

    if (-not (Test-Path $ConfigPath)) {
        Write-Log "Config file not found after install/repair: $ConfigPath" 'ERROR'
        exit 1
    }

    Backup-File -Path $ConfigPath
    Set-IniValue -Path $ConfigPath -Key 'Server' -Value $ZabbixServer
    Set-IniValue -Path $ConfigPath -Key 'ServerActive' -Value $ServerActive
    Write-Log "Zabbix configuration verified/repaired."

    $svc = Get-ZabbixService
    if (-not $svc) {
        Write-Log "Zabbix service still not found after install." 'ERROR'
        exit 1
    }

    if ($svc.Status -eq 'Running') {
        Restart-Service -Name $svc.Name -Force
        Write-Log "Zabbix service restarted."
    }
    else {
        Start-Service -Name $svc.Name
        Write-Log "Zabbix service started."
    }

    Write-Log "=== Zabbix server startup script completed successfully ==="
    exit 0
}
catch {
    Write-Log "Fatal error: $($_.Exception.Message)" 'ERROR'
    exit 1
}