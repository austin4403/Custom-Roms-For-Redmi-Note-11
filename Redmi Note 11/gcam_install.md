# Google Camera (GCam) Installation Guide for Redmi Note 11 (spes/spesn)

The stock AOSP camera app bundled with custom ROMs often doesn't fully utilize the Redmi Note 11 hardware. To get flagship-quality photos (with excellent dynamic range, HDR+, and Night Sight), you must install a GCam port.

> [!IMPORTANT]
> **Why do I need a `.xml` config file?**
> GCam ports are universal. If you don't load a specific configuration file for the `spes` hardware, the app will likely crash, have green-tinted photos, or fail to use the ultrawide/macro lenses.

## Recommended Version
* **Port:** BSG 8.8 (Snapcam Package)
* **Config:** spesn8.8-sefat.xml

---

## Installation Procedure (via ADB)

We recommend using ADB to cleanly push the config file to the correct directory.

### 1. Download the Files
Download the APK and the XML file to your computer.
*   **APK Download Link:** [MGC_8.8.224_A11_V14a_snap.apk](https://1-dontsharethislink.celsoazevedo.com/file/filesc/MGC_8.8.224_A11_V14a_snap.apk) *(Do NOT commit this to GitHub as it exceeds the 100MB limit).*
*   **XML Config:** You can find `spesn8.8-sefat.xml` in this repository under the `Camera_GCam/` folder.

### 2. Connect Your Device
Ensure your phone has USB Debugging enabled in Developer Options, and plug it into your computer.

### 3. Run the Installation Commands
Open your terminal and run the following commands to install the app and copy the config:

```bash
# 1. Install the GCam APK
adb install path/to/MGC_8.8.224_A11_V14a_snap.apk

# 2. Create the configuration folder on your phone
adb shell mkdir -p /sdcard/Download/MGC_CONFIG/

# 3. Push the XML config file to the folder
adb push Camera_GCam/spesn8.8-sefat.xml /sdcard/Download/MGC_CONFIG/
```

### 4. Load the Config on the Phone
1. Open the newly installed **Camera** app.
2. Grant all requested permissions.
3. **Double-tap the black space** directly underneath or around the shutter button.
4. A dialog box will appear. You should see `spesn8.8-sefat.xml` selected.
5. Tap **Load** or **Import**.

The camera will restart automatically, and you will now be running the optimized Google Camera software!
