@echo off
setlocal ENABLEDELAYEDEXPANSION

REM =========================
REM CONFIG SECTION
REM =========================

REM List IPs / hostnames in priority order
set TARGETS=^
100.115.254.88 ^
192.168.1.100 ^
192.168.1.198 ^
pikvm.local

REM Ping timeout in milliseconds (Windows rounds to ~1s anyway)
set PING_TIMEOUT=1000

REM =========================
REM CHROME DETECTION
REM =========================

set CHROME=

if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    set CHROME="%ProgramFiles%\Google\Chrome\Application\chrome.exe"
) else if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
    set CHROME="%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
) else if exist "%LocalAppData%\Chromium\Application\chrome.exe" (
    set CHROME="%LocalAppData%\Chromium\Application\chrome.exe"
)

if not defined CHROME (
    echo ERROR: Chrome or Chromium not found.
    pause
    exit /b 1
)

REM =========================
REM TARGET CHECK LOOP
REM =========================

for %%T in (%TARGETS%) do (
    echo Checking %%T ...

    ping -n 1 -w %PING_TIMEOUT% %%T >nul 2>&1
    if !errorlevel! EQU 0 (
        echo Found reachable PiKVM at %%T
        start "" %CHROME% --app=https://%%T
        exit
    )
)

REM =========================
REM FAILURE CASE
REM =========================

echo.
echo PiKVM is not responding to pings on any configured address.
echo Checked:
for %%T in (%TARGETS%) do echo   - %%T
echo.
pause
exit /b 1


REM ============================================================
REM PiKVM Desktop Launcher (.bat version)
REM ============================================================
REM
REM PURPOSE
REM - Launch PiKVM in Chrome app mode as a desktop-clickable button
REM - Automatically select the first reachable IP/hostname
REM   (local LAN first, then Tailscale / fallback)
REM
REM HOW IT WORKS
REM - This script pings a list of IPs/hostnames in priority order
REM - On the first successful response, Chrome is launched with:
REM     chrome.exe --app=https://<target>
REM - This avoids normal Chrome window grouping and feels app-like
REM
REM SETUP
REM - Script:
REM   C:\Users\Malac\Desktop\Desktop scripts\pikvm.bat
REM
REM - Desktop shortcut (.lnk):
REM   C:\Users\Malac\Desktop\PiKVM.lnk
REM
REM - The shortcut points to this .bat file and is intended to be
REM   clicked directly from the desktop (NOT pinned to taskbar)
REM
REM LIMITATIONS
REM - Windows cannot pin .bat files cleanly to the taskbar
REM - Taskbar pinning requires a PowerShell wrapper or EXE
REM - This version is intended for desktop use only
REM
REM NOTES
REM - IP/hostname priority is defined in the CONFIG SECTION
REM - Ping timeout relies on Windows ping behavior (~1s minimum)
REM ============================================================
