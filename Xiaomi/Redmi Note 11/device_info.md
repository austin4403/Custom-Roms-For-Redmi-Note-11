# Redmi Note 11 (spes/spesn) - Device Information & Layout

## Hardware Specifications
- **Device Codename:** `spes` (standard 4G model) or `spesn` (NFC-enabled 4G model).
- **Processor:** Qualcomm Snapdragon 680.
- **Bootloader Status:** Unlocked.

---

## Partition Layout & Architecture

Unlike older Android devices, the Redmi Note 11 utilizes a modern **Virtual A/B partition scheme** and does not have a dedicated physical `recovery` partition.

### 1. A/B Slot System
- The device features duplicate partitions for slot `a` and slot `b` (e.g., `boot_a` / `boot_b`, `vendor_boot_a` / `vendor_boot_b`, `dtbo_a` / `dtbo_b`).
- Custom ROMs are installed to the **inactive** slot during an OTA or sideload update. On reboot, the bootloader switches the active slot.
- For a successful boot, the system files on the active slot must match the bootloader files (`boot`, `vendor_boot`, `dtbo`, `vbmeta`) on the same slot.

### 2. Boot-as-Recovery
- Because there is no standalone `recovery` partition, recovery is packaged inside the `boot.img` and `vendor_boot.img` ramdisk.
- Flashing a recovery image directly to the boot partition will replace the OS kernel, preventing normal Android boot.
- The correct way to run recovery is either to boot it temporarily (`fastboot boot recovery.img`) or to flash the custom ROM's `boot.img` and `vendor_boot.img`, which contain the ROM's custom recovery.

---

## Critical Warnings
> [!WARNING]
> **Codename Verification:** The Redmi Note 11 has many variants (e.g., `spes` for 4G, `viva` for Pro 4G, `veux` for Pro 5G, `rosemary` for Redmi Note 10S). Flashing files compiled for other codenames (like `viva` or `rosemary`) will result in a bricked device. Always double-check device compatibility on XDA or official sources.
