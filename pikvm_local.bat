@echo off
setlocal ENABLEDELAYEDEXPANSION

REM =========================
REM CONFIG SECTION
REM =========================

REM List IPs / hostnames in priority order
set TARGETS=^
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
