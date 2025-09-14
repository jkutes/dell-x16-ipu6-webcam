# Dell X16 IPU6 Webcam Setup

This repository contains a single-purpose setup script to enable the **Intel IPU6** webcam on the Dell X16 (2024+) under Linux. The script automates all the fussy bits so your internal camera shows up in apps like Zoom, Google Meet, and OBS.

> **File:** `Dell_X16_ipu6_webcam.sh`

## What it does
- Loads kernel modules: v4l2loopback
- Manages systemd unit(s): ipu6-camera.service
- Installs udev rules: /etc/udev/rules.d/99-ipu6-psys.rules
- Builds/installs DKMS modules
- Builds components from source

## Requirements
- Linux with systemd (tested distros likely compatible with `apt`)
- Internet access for package/firmware fetches
- Administrative privileges (required — run with `sudo` if needed)

## Usage
```bash
sudo bash Dell_X16_ipu6_webcam.sh
```

The script is idempotent where possible; re-running it should be safe. Review the script before running if you’re cautious (recommended).

## Notes
- Back up any config files the script may touch (e.g., GRUB, udev rules, firmware directories).
- If your distro uses a different package manager, adapt the package install lines accordingly.
- A reboot might be needed if kernel modules or GRUB parameters are changed.

## Uninstall / Revert
If the script installed firmware, udev rules, or systemd services, reverse those steps by removing the created files and disabling services. Refer to the script for exact paths and names.

## Script header (for quick context)
```
This script automates the installation and configuration of the Intel IPU6 camera
on Ubuntu 24.04 by installing packages from a PPA, setting udev rules,
and configuring a systemd service to make the camera available to applications.
```

----

### Why share?
IPU6 laptops are increasingly common, but getting the camera working on Linux can be confusing. This repo documents a working approach for the **Dell X16** so others don’t have to rediscover it.

### Contributing
PRs welcome — especially distro notes, bug fixes, and improved detection of drivers/firmware.

### License
MIT — see [LICENSE](LICENSE).

