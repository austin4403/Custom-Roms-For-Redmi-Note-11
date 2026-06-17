# Magisk Rooting Guide

This guide explains how to root your custom ROM on the Redmi Note 11 (`spes`) using Magisk via recovery sideloading.

---

## Guide
1. **Download Magisk:** Download the official Magisk `.apk` from the official repository (`topjohnwu/Magisk`).
2. **Rename to `.zip`:** Rename the downloaded `.apk` file to `.zip` (e.g., rename `Magisk-v27.0.apk` to `Magisk-v27.0.zip`). This allows custom recoveries to flash it as a package.
3. **Reboot to Recovery:** Put your phone into custom recovery mode.
4. **Enter Sideload Mode:** Select **Apply Update** -> **Apply from ADB** (Sideload) in recovery.
5. **Flash the Zip:** On your computer, run:
   ```bash
   adb sideload Magisk-v27.0.zip
   ```
6. **Reboot:** Once the installation finishes (usually reporting success on the phone or returning `Total xfer: 0.75x` or similar), select **Reboot System**.
7. **Complete App Setup:**
   - Boot into Android and connect to Wi-Fi.
   - Look for the Magisk icon in your app drawer.
   - Open it and follow the prompt to upgrade to the full Magisk app.
   - Follow the prompt to complete the final setup, which will reboot your phone once more.
   - You now have full root access!
