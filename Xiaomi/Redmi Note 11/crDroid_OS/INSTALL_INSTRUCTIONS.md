# crDroid 12.4 Installation Guide (Redmi Note 11 'spes')

> [!IMPORTANT]
> **For ALL NEW INSTALLATIONS:** You MUST always perform a Factory Reset and Format Data in recovery. Skipping this step will result in a bootloop.

This folder contains all the necessary files to clean-flash crDroid 12.4 onto the Redmi Note 11 (spes). 
Because this device uses a Virtual A/B partition scheme, the process involves extracting the boot files, flashing them to the active slot, sideloading the ROM, and then re-flashing the boot files to the newly active slot to ensure slot alignment.

## Prerequisites
Ensure your device's bootloader is unlocked and you have the Android Platform Tools (ADB & Fastboot) installed on your computer.

## Files Included in this Folder
- `crDroidAndroid-16.0-20251209-spes-v12.4.zip`: The main crDroid ROM.
- `MindTheGapps-16.0.0-arm64-20260409_073023.zip`: The Google Apps package (since crDroid is vanilla).
- `payload-dumper-go`: The tool used to extract partition images from the ROM zip.
- `crDroid_images/`: The pre-extracted partition images (`boot`, `dtbo`, `vendor_boot`, `vbmeta`, `vbmeta_system`) ready for fastboot.

---

## Step-by-Step Installation

### Step 1: Boot to Fastboot
Power off your phone, then hold **Volume Down + Power** until the FASTBOOT rabbit appears. Connect it to your PC.

### Step 2: Flash Initial Boot Images
Run the following commands in your terminal to flash the extracted boot images to your current slot:
```bash
fastboot flash boot crDroid_images/boot.img
fastboot flash vendor_boot crDroid_images/vendor_boot.img
fastboot flash dtbo crDroid_images/dtbo.img
TMPDIR=. fastboot --disable-verity --disable-verification flash vbmeta crDroid_images/vbmeta.img
TMPDIR=. fastboot --disable-verity --disable-verification flash vbmeta_system crDroid_images/vbmeta_system.img
```

### Step 3: Boot to Recovery and Format Data
1. Reboot the device into the newly installed crDroid recovery:
   ```bash
   fastboot reboot recovery
   ```
2. On your phone, tap **Factory Reset** -> **Format data / factory reset**. *(Warning: This wipes your phone!)*
3. Go back to the main menu and tap **Apply update** -> **Apply from ADB**.

### Step 4: Sideload the ROM
Run this command on your PC to push the ROM to the phone:
```bash
adb sideload crDroidAndroid-16.0-20251209-spes-v12.4.zip
```
*(Wait until your phone says "Install completed with status 0". The computer may stop at 47%, which is normal.)*

### Step 5: Sideload GApps (Optional but Recommended)
If you want the Google Play Store:
1. Your phone will ask if you want to reboot to recovery to install additional packages. Tap **Yes**.
2. Once back in recovery, tap **Apply update** -> **Apply from ADB** again.
3. Sideload the GApps package:
   ```bash
   adb sideload MindTheGapps-16.0.0-arm64-20260409_073023.zip
   ```

### Step 6: Final Slot Alignment
Because the ROM installed to the *opposite* slot, you must flash the boot images one more time to align the slots and prevent bootloops.
1. On your phone's recovery menu, tap the back arrow and select **Advanced** -> **Reboot to bootloader**.
2. Run the exact same flashing commands from Step 2 again.
3. Finally, reboot your phone:
   ```bash
   fastboot reboot
   ```

You are now done! Enjoy crDroid!
