# Custom ROM Troubleshooting Guide

Here are the fixes for common errors and bootloops encountered during the installation of custom ROMs on the Redmi Note 11 (`spes`).

---

## 1. Fastboot Error: `Failed writing to modified vbmeta`
*   **Symptom:** When running `fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img`, fastboot returns an error saying it failed to write.
*   **Cause:** Fastboot attempts to write a temporary patched copy of the `vbmeta.img` to your computer's `/tmp` folder before flashing. If `/tmp` has exceeded its disk space/quota, the write will fail.
*   **Solution:** Set the `TMPDIR` environment variable to your local working directory (which has ample space) by prefixing your commands with `TMPDIR=.` like this:
    ```bash
    TMPDIR=. fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
    TMPDIR=. fastboot --disable-verity --disable-verification flash vbmeta_system vbmeta_system.img
    ```

---

## 2. Bootlooping Immediately Back to Recovery (Loop to Recovery)
*   **Symptom:** After selecting "Reboot system", the device shows the boot logo for a few seconds and then dumps you straight back into recovery.
*   **Cause A: Unformatted Data Partition (Encryption Issue)**
    - Custom ROMs cannot decrypt your storage if it was encrypted using stock MIUI/HyperOS keys.
    - *Fix:* Go to **Factory Reset** -> **Format Data/Factory Reset** in recovery and completely wipe the data partition (which requires typing "yes" in some recoveries).
*   **Cause B: Unaligned Partition Slots (A/B slot mismatch)**
    - Sideloading installs the ROM to the inactive slot and switches to it. If you only flashed the custom `boot.img`, `vendor_boot.img`, and `dtbo.img` to Slot A, then Slot B is still running on stock bootloader files.
    - *Fix:* Reboot the phone to bootloader (Fastboot) from recovery, verify that it has switched slots (`fastboot getvar current-slot`), and flash the custom ROM `boot.img`, `vendor_boot.img`, `dtbo.img`, and `vbmeta.img` to this active slot.

---

## 3. Recovery Warning: `E: Open failed: /metadata/ota: No such file or directory`
*   **Symptom:** The phone screen shows a red or orange warning saying `/metadata/ota` could not be found during sideloading or formatting data.
*   **Cause:** This is a **completely harmless, cosmetic warning** common to modern Android recovery environments. The recovery checks for an OTA metadata directory that only exists if you run an automatic system update within the OS.
*   **Solution:** You can safely ignore this warning. It does not affect data formatting or system flashing.
