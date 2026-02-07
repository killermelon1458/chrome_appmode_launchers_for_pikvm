# =========================
# CONFIG SECTION
# =========================

# List IPs / hostnames in priority order
$Targets = @(
    "100.115.254.88"
    "192.168.1.100"
    "192.168.1.198"
    "pikvm.local"
)

# Ping timeout in milliseconds
$PingTimeoutMs = 1000

# =========================
# CHROME DETECTION
# =========================

$ChromeCandidates = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
    "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
    "$env:LocalAppData\Chromium\Application\chrome.exe"
)

$Chrome = $ChromeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $Chrome) {
    Write-Error "Chrome or Chromium not found."
    Pause
    exit 1
}

# =========================
# TARGET CHECK LOOP
# =========================

foreach ($Target in $Targets) {
    Write-Host "Checking $Target ..."

    $reachable = Test-Connection `
        -ComputerName $Target `
        -Count 1 `
        -Quiet

    if ($reachable) {
        Write-Host "Found reachable PiKVM at $Target"
        Start-Process $Chrome "--app=https://$Target"
        exit 0
    }
}


# =========================
# FAILURE CASE
# =========================

Write-Host ""
Write-Host "PiKVM is not responding to pings on any configured address."
Write-Host "Checked:"
$Targets | ForEach-Object { Write-Host "  - $_" }
Write-Host ""
Pause
exit 1

<#
PiKVM Launcher (Taskbar-pinnable)

PURPOSE
- Launch PiKVM in Chrome app mode
- Automatically select the first reachable IP/hostname (local or Tailscale)
- Provide a Windows taskbar–pinnable “app” entry

WHY POWERSHELL
- Windows cannot pin .bat or .ps1 files directly to the taskbar
- Taskbar pins must target a real executable
- This script is launched via a .lnk that explicitly calls powershell.exe

SETUP
- Script:
  C:\Users\Malac\Desktop\Desktop scripts\pikkvm.ps1

- Shortcut (.lnk):
  C:\Users\Malac\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PiKvm_ps.lnk

- Shortcut target:
  powershell.exe -ExecutionPolicy Bypass -NoProfile -File "<path>\pikkvm.ps1"

- Shortcut is pinned to the taskbar (NOT the .ps1 file)

NOTES
- Do not double-click the .ps1 file directly
- The taskbar shortcut is the intended launch method
- Chrome is launched with --app= to avoid normal Chrome window grouping
#>

