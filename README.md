# Chrome App‑Mode Launchers for PiKVM

This repository contains small, purpose‑built launchers that open **PiKVM** in **Google Chrome app mode** while automatically selecting the best available network path (local LAN vs Tailscale).

The goal is to make PiKVM feel like a native desktop application instead of a browser tab, while still handling dynamic network conditions.

---

## What This Solves

* PiKVM may be reachable via **multiple IPs / hostnames** (LAN, mDNS, Tailscale)
* Chrome app‑mode windows are **not taskbar‑pinnable** when launched indirectly
* Windows does not allow `.bat` or `.ps1` files to be pinned directly

This repo provides **two working launch patterns**, each optimized for a different use case.

---

## Files Overview

### `pikkvm.ps1`

**PowerShell taskbar‑pinnable launcher**

* Pings a list of IPs / hostnames in priority order
* Launches Chrome using `--app=https://<target>`
* Intended to be launched via a `.lnk` that explicitly calls `powershell.exe`
* Can be pinned to the **Windows taskbar**

Use this if you want a **stable taskbar icon** that behaves like a real app.

---

### `pikvm.bat`

**Desktop‑clickable launcher**

* Same network‑selection logic as the PowerShell version
* Intended to be launched by double‑clicking a desktop shortcut
* Simple and portable

Use this if you want a **desktop button**, not a taskbar app.

---

### `pikvm_local.bat`

**Local‑only variant**

* Optimized for environments where PiKVM is always reachable on LAN
* Skips fallback logic
* Useful for single‑network setups

---

### `pikvm-light.ico`

Custom icon suitable for:

* Desktop shortcuts
* Taskbar pins
* Start Menu entries

---

## Chrome App Mode (Important)

All launchers rely on Chrome **app mode**:

```
chrome.exe --app=https://<target>
```

This:

* Removes the address bar
* Prevents normal Chrome window grouping
* Makes PiKVM behave like a standalone application

Chrome settings are **not accessible** from app‑mode windows. All settings must be adjusted in a normal Chrome session.

---

## Recommended Setup

### Desktop Button (BAT)

* Script:

  ```
  C:\Users\<you>\Desktop\Desktop scripts\pikvm.bat
  ```
* Shortcut:

  ```
  C:\Users\<you>\Desktop\PiKVM.lnk
  ```

This version is meant to be **double‑clicked**, not pinned.

---

### Taskbar App (PowerShell)

* Script:

  ```
  pikkvm.ps1
  ```
* Shortcut target:

  ```
  powershell.exe -ExecutionPolicy Bypass -NoProfile -File "<path>\\pikkvm.ps1"
  ```
* Shortcut location:

  ```
  %APPDATA%\Microsoft\Windows\Start Menu\Programs
  ```

Pin the shortcut to the taskbar **from the Start Menu**.

---

## Security Notes

* No credentials are stored
* No tokens, keys, or cookies are used
* All IPs shown are private, mDNS, or CGNAT (Tailscale)

This repository contains **launch logic only**, not authentication logic.

---

## Why Two Versions Exist

Windows treats launch surfaces differently:

| Use Case       | Best Tool           |
| -------------- | ------------------- |
| Desktop button | `.bat`              |
| Taskbar pin    | PowerShell + `.lnk` |

Both are valid. Neither replaces the other.

---

## License

This project is intentionally simple and unopinionated.

Use, modify, or adapt it freely.
