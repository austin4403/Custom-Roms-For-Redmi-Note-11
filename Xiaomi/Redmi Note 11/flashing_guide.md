# Custom ROM Flashing & Reinstallation Guide

> [!IMPORTANT]
> **For ALL NEW INSTALLATIONS:** You MUST always perform a Factory Reset and Format Data in recovery. Skipping this step will result in a bootloop.

This guide details the procedure for doing a clean install of a custom ROM (such as Project Infinity-X or crDroid) on the Redmi Note 11 (`spes`).

---

## Prerequisites
1. An unlocked bootloader.
2. Android SDK Platform-Tools (ADB/Fastboot) installed on your host machine.
3. The custom ROM `.zip` file.
4. The extracted partition images for the ROM (`boot.img`, `vendor_boot.img`, `dtbo.img`, `vbmeta.img`, `vbmeta_system.img`).
   - If not provided, compile/download `payload-dumper-go` and run:
     `./payload-dumper-go -p boot,vendor_boot,dtbo,vbmeta,vbmeta_system ota.zip`

---

## Step 1: Flashing Recovery Images (Fastboot Mode)
Put your device into Fastboot Mode (hold Volume Down + Power) and run the following commands to flash the custom ROM recovery to the active slot:

```bash
# Flash the boot, vendor_boot, and dtbo partitions
fastboot flash boot boot.img
fastboot flash vendor_boot vendor_boot.img
fastboot flash dtbo dtbo.img

# Flash vbmeta to disable Android Verified Boot checks (AVB)
# Note: Use TMPDIR=. if you run into local temp/quota space issues
TMPDIR=. fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
TMPDIR=. fastboot --disable-verity --disable-verification flash vbmeta_system vbmeta_system.img
```

---

## Step 2: Sideloading the ROM (Recovery Mode)
Reboot the device into the newly flashed custom recovery:
```bash
fastboot reboot recovery
```

Once in recovery:
1. Navigate to **Factory Reset** -> **Format Data/Factory Reset** and confirm. (Wipes old MIUI encryption keys).
2. Go back to the main menu, select **Apply Update** -> **Apply from ADB** to enter Sideload mode.
3. On your computer, run:
   ```bash
   adb sideload <ROM_name>.zip
   ```
   *(Note: The progress bar on the computer may freeze around 47% — this is normal. Sideload is complete when the phone screen prompts you to reboot or finish).*

---

## Step 3: Aligning the Slots (Crucial A/B Step)
When recovery finishes sideloading the ZIP, it installs the ROM to the **opposite** slot (e.g., Slot B) and sets it active. However, the opposite slot still has stock boot files. You must flash the recovery files to the newly active slot to boot successfully:

1. On the phone screen, select **Reboot to Bootloader** (Fastboot).
2. Verify which slot is active (it should have switched):
   ```bash
   fastboot getvar current-slot
   ```
3. Run the exact same flashing commands from **Step 1** again to flash `boot`, `vendor_boot`, `dtbo`, and `vbmeta` to this new slot.
4. Reboot the phone:
   ```bash
   fastboot reboot
   ```

---

## Step 4: Post-Install Setup (GCam)
The stock AOSP camera that comes with most custom ROMs will not take full advantage of your hardware. Installing Google Camera (GCam) is a **mandatory** step for taking high-quality photos.

Once your phone boots into Android and you finish the initial setup:
1. Enable USB Debugging in Developer Options.
2. Follow the [**GCam Installation Guide**](gcam_install.md) to push the configuration files over ADB and install the camera.
