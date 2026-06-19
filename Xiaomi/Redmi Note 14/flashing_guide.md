# Flashing Guide for Redmi Note 14 (Tanzanite)

Follow these steps to flash crDroid or any other custom ROM on your Redmi Note 14:

## Prerequisites
- Download the latest ROM zip (e.g., `crDroidAndroid-16.0-20251027-tanzanite-v12.2.zip`) into the `os_zips` directory.
- Download the matching `vendor_boot.img` into the `images` directory.
- Ensure your device is in `fastboot` mode.

## Flashing Steps

1. **Flash `vendor_boot` to both slots:**
   Run the following command from the `images` directory to flash `vendor_boot.img` to both the A and B slots:
   ```bash
   fastboot flash vendor_boot --slot=all vendor_boot.img
   ```
   *Expected output:*
   ```text
   Sending 'vendor_boot_a' (65536 KB)                 OKAY [  1.438s]
   Writing 'vendor_boot_a'                            OKAY [  0.212s]
   Sending 'vendor_boot_b' (65536 KB)                 OKAY [  1.424s]
   Writing 'vendor_boot_b'                            OKAY [  0.213s]
   Finished. Total time: 3.414s
   ```

2. **Reboot into Recovery:**
   After successfully flashing the `vendor_boot` partition, restart your device directly into the newly flashed recovery:
   ```bash
   fastboot reboot
   ```
   *(Be sure to hold the Volume Up button during reboot if the device does not automatically boot into recovery mode).*

3. **Sideload the ROM:**
   Once in recovery, select **Apply Update -> Apply from ADB**. Then run the following command from the `os_zips` directory:
   ```bash
   adb sideload crDroidAndroid-16.0-20251027-tanzanite-v12.2.zip
   ```
   *Expected output:*
   ```text
   Total xfer: 1.00x
   ```
   
4. **Format Data & Reboot:**
   - After sideloading is complete, go back to the main menu in recovery.
   - Select **Factory Reset -> Format data/factory reset**.
   - Reboot to system.
