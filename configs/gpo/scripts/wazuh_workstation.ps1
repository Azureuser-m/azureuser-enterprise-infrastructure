# STARTUP - Wazuh - Workstations.ps1

$ErrorActionPreference = 'Stop'

# Core settings
$ManagerIP   = '10.10.10.50'
$AgentGroup  = 'workstations'
$ServiceName = 'WazuhSvc'
$MsiPath     = "\\corp.azureuser.org\NETLOGON\Software\wazuh-agent-4.14.3-1.msi"

# Folder layout
$LocalRoot    = 'C:\ProgramData\AgentBootstrap'
$ScriptRoot   = Join-Path $LocalRoot 'scripts'
$LogRoot      = Join-Path $LocalRoot 'logs'
$CacheRoot    = Join-Path $LocalRoot 'cache'

# Logs and local MSI cache
$ScriptLog    = Join-Path $LogRoot 'wazuh-workstation-startup.log'
$MsiLog       = Join-Path $LogRoot 'wazuh-workstation-msi.log'
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

function Get-WazuhConfigPath {
    $candidates = @(
        'C:\Program Files (x86)\ossec-agent\ossec.conf',
        'C:\Program Files\ossec-agent\ossec.conf'
    )

    foreach ($p in $candidates) {
        if (Test-Path $p) {
            return $p
        }
    }

    return $candidates[0]
}

function Get-WazuhAddress {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return $null
    }

    [xml]$xml = Get-Content -Path $Path -Raw
    $node = $xml.SelectSingleNode('/ossec_config/client/server/address')

    if ($node) {
        return $node.InnerText.Trim()
    }

    return $null
}

function Set-WazuhAddress {
    param(
        [string]$Path,
        [string]$Address
    )

    [xml]$xml = Get-Content -Path $Path -Raw

    $ossec = $xml.SelectSingleNode('/ossec_config')
    if (-not $ossec) {
        throw "Invalid ossec.conf: missing /ossec_config"
    }

    $client = $xml.SelectSingleNode('/ossec_config/client')
    if (-not $client) {
        $client = $xml.CreateElement('client')
        $null = $ossec.AppendChild($client)
    }

    $server = $xml.SelectSingleNode('/ossec_config/client/server')
    if (-not $server) {
        $server = $xml.CreateElement('server')
        $null = $client.AppendChild($server)
    }

    $addr = $xml.SelectSingleNode('/ossec_config/client/server/address')
    if (-not $addr) {
        $addr = $xml.CreateElement('address')
        $null = $server.AppendChild($addr)
    }

    $addr.InnerText = $Address
    $xml.Save($Path)
}

try {
    Write-Log "=== Wazuh workstation startup script started ==="

    $productType = (Get-CimInstance Win32_OperatingSystem).ProductType
    if ($productType -ne 1) {
        Write-Log "Server OS detected. Exiting."
        exit 0
    }

    $ConfigPath = Get-WazuhConfigPath
    $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    $addressOk = ($svc -and (Get-WazuhAddress -Path $ConfigPath) -eq $ManagerIP)

    if ($svc -and $addressOk) {
        if ($svc.Status -ne 'Running') {
            Start-Service -Name $ServiceName
            Write-Log "Wazuh already installed and configured. Service was stopped and has been started."
        }
        else {
            Write-Log "Wazuh already compliant. No action needed."
        }
        exit 0
    }

    if (-not $svc) {
        Write-Log "Wazuh service not found. Preparing install source."

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

        Write-Log "Installing Wazuh from: $InstallSource"

        $args = @(
            '/i'
            "`"$InstallSource`""
            '/q'
            "WAZUH_MANAGER=`"$ManagerIP`""
            "WAZUH_REGISTRATION_SERVER=`"$ManagerIP`""
            "WAZUH_AGENT_GROUP=`"$AgentGroup`""
            '/l*v'
            "`"$MsiLog`""
        )

        $proc = Start-Process -FilePath 'msiexec.exe' -ArgumentList $args -Wait -NoNewWindow -PassThru
        Write-Log "msiexec exit code: $($proc.ExitCode)"

        if ($proc.ExitCode -notin 0, 3010) {
            Write-Log "Wazuh install failed. Check MSI log: $MsiLog" 'ERROR'
            exit 1
        }

        $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        $ConfigPath = Get-WazuhConfigPath
    }

    if (-not (Test-Path $ConfigPath)) {
        Write-Log "ossec.conf not found after install/repair: $ConfigPath" 'ERROR'
        exit 1
    }

    $currentAddress = Get-WazuhAddress -Path $ConfigPath
    if ($currentAddress -ne $ManagerIP) {
        Backup-File -Path $ConfigPath
        Set-WazuhAddress -Path $ConfigPath -Address $ManagerIP
        Write-Log "Wazuh manager address repaired in: $ConfigPath"
    }
    else {
        Write-Log "Wazuh config already contains the correct manager address."
    }

    $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if (-not $svc) {
        Write-Log "Wazuh service still not found after install." 'ERROR'
        exit 1
    }

    if ($svc.Status -eq 'Running') {
        Restart-Service -Name $ServiceName -Force
        Write-Log "Wazuh service restarted."
    }
    else {
        Start-Service -Name $ServiceName
        Write-Log "Wazuh service started."
    }

    Write-Log "=== Wazuh workstation startup script completed successfully ==="
    exit 0
}
catch {
    Write-Log "Fatal error: $($_.Exception.Message)" 'ERROR'
    exit 1
}