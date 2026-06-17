# Custom ROMs for Redmi Note 11 (spes/spesn)

Welcome! This repository serves as a comprehensive collection of installation guides, troubleshooting documentation, and partition specifications for running custom ROMs (Android distributions) on the **Xiaomi Redmi Note 11** (codenamed `spes` or `spesn`).

---

## 📱 Supported Device
* **Device Name:** Xiaomi Redmi Note 11 (4G / NFC 4G)
* **Codenames:** `spes` (standard) / `spesn` (NFC version)
* **Chipset:** Qualcomm Snapdragon 680 (SM6225)
* **Architecture:** Virtual A/B Slot Partitioning (No dedicated recovery partition)

---

## 🗺️ Documentation Portal

Use the links below to navigate the guides and reference documents:

| Guide Name | Description |
| :--- | :--- |
| 📖 [**Device Information**](device_info.md) | Deep-dive into specifications and A/B partition structure. |
| ⚡ [**Flashing & Install Guide**](flashing_guide.md) | Standard recovery flashing, ROM sideloading, and slot alignment. |
| 🛠️ [**Troubleshooting Index**](troubleshooting.md) | Fixes for vbmeta errors, boot loops, and recovery warnings. |
| 🔓 [**Magisk Rooting Guide**](magisk_root.md) | Step-by-step walkthrough for flashing and setting up Magisk root. |
| 📸 [**GCam Installation Guide**](gcam_install.md) | Get the best camera experience using Google Camera ports. |

---

## 🎨 Supported Custom ROMs (Android Distributions)

We categorize custom ROMs for `spes` based on their philosophy and system footprint:

### 🌟 Feature-Rich AOSP ROMs (e.g., Project Infinity-X, Evolution X)
* **Google Services:** Usually comes with full GApps preloaded (GApps variant).
* **Pros:** Advanced UI customization, unlimited Google Photos backup spoofing, built-in gaming modes, and system tweaks.
* **Cons:** Larger system footprint, slightly higher idle battery usage, potential for minor community bugs.
* **Best For:** Users who want a Pixel-like experience packed with customization.
* **Download Portals:**
  * [Project Infinity-X Website](https://infinity-x.org/) / [Official spes Telegram Channel](https://t.me/InfinityXSpes)

### ⚡ Clean & Lightweight ROMs (e.g., crDroid, LineageOS)
* **Google Services:** Vanilla (no GApps pre-installed). Recommended to pair with a minimal GApps package like *MindTheGApps* or *NikGApps Core*.
* **Pros:** Extreme performance, minimal RAM usage, exceptional battery life, long-term stability.
* **Cons:** Minimal default UI customization.
* **Best For:** Daily drivers who value reliability, speed, and privacy above all.
* **Download Portals:**
  * [crDroid Official spes Page](https://crdroid.net/spes)
  * [MindTheGApps Official Downloads](https://androidfilehost.com/?w=files&flid=322935) (For Google Services)

### 🛠️ Root & Firmware Tools
* **Rooting:** [Official Magisk GitHub Releases](https://github.com/topjohnwu/Magisk/releases)
* **Stock ROMs:** [Xiaomi Firmware Updater (spes/spesn)](https://xiaomifirmwareupdater.com/miui/spes/) (To download stock Fastboot `.tgz` files to recover or extract stock boot images).

---

> [!CAUTION]
> **Warning on Variant Bricking:**
> Do **not** flash ZIPs or boot images compiled for Redmi Note 11 Pro (`viva`/`veux`) or Redmi Note 10S (`rosemary`) on your standard Redmi Note 11 (`spes`). Doing so will brick your device. Always verify the codename assertion during recovery installation.
