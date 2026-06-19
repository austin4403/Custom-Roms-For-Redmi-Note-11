#!/bin/bash

PIN="15214863"

echo "=== GMS Reset & Reboot Flow ==="

# 1. Clear Play Services and Play Store data
echo "[1/8] Clearing Google Play Services and Play Store data..."
adb shell "su -c 'pm clear com.google.android.gms'"
adb shell "su -c 'pm clear com.android.vending'"
sleep 2

# 2. Reboot device
echo "[2/8] Rebooting device..."
adb reboot
echo "Waiting for device to go offline..."
sleep 5

# 3. Wait for device to boot up and connect
echo "[3/8] Waiting for device to reconnect via ADB..."
adb wait-for-device
echo "Device connected! Waiting 20 seconds for system services to initialize..."
sleep 20

# 4. Unlock phone
echo "[4/8] Attempting to unlock phone..."
adb shell input keyevent KEYCODE_WAKEUP
sleep 1.5
adb shell input keyevent 82
sleep 1.5
# PIN digits: 1 5 2 1 4 8 6 3 + Enter
# Keycodes: 1=8, 5=12, 2=9, 1=8, 4=11, 8=15, 6=13, 3=10, Enter=66
adb shell input keyevent 8 12 9 8 11 15 13 10 66
sleep 6

# Verify if unlocked
FOCUS=$(adb shell dumpsys window | grep -E "mCurrentFocus")
echo "Current focus after unlock: $FOCUS"

# 5. Open Google Play Store to trigger GMS account check-in/sync
echo "[5/8] Launching Google Play Store to force GMS account sync..."
adb shell monkey -p com.android.vending 1 > /dev/null 2>&1
echo "Waiting 15 seconds for account sync to complete..."
sleep 15

# 6. Launch Play Integrity API Checker
echo "[6/8] Launching Play Integrity Checker..."
adb shell monkey -p gr.nikolasspyr.integritycheck 1 > /dev/null 2>&1
sleep 4

# 7. Tap CHECK button
echo "[7/8] Tapping CHECK button (X=540, Y=1526)..."
adb shell input tap 540 1526
echo "Waiting 8 seconds for integrity check to complete..."
sleep 8

# 8. Dump and parse results
echo "[8/8] Parsing results..."
adb shell uiautomator dump /sdcard/window_dump_auto.xml > /dev/null 2>&1
adb pull /sdcard/window_dump_auto.xml ./window_dump_auto.xml > /dev/null 2>&1

if [ -f "./window_dump_auto.xml" ]; then
    sed -i 's/></>\n</g' ./window_dump_auto.xml
    BASIC=$(grep 'basic_integrity_icon' ./window_dump_auto.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
    DEVICE=$(grep 'device_integrity_icon' ./window_dump_auto.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
    STRONG=$(grep 'strong_integrity_icon' ./window_dump_auto.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
    
    [ -z "$BASIC" ] && BASIC="Unknown"
    [ -z "$DEVICE" ] && DEVICE="Unknown"
    [ -z "$STRONG" ] && STRONG="Unknown"
    
    echo "--------------------------------------"
    echo "  MEETS_BASIC_INTEGRITY:  $BASIC"
    echo "  MEETS_DEVICE_INTEGRITY: $DEVICE"
    echo "  MEETS_STRONG_INTEGRITY: $STRONG"
    echo "--------------------------------------"
    
    if [ "$DEVICE" = "Pass" ]; then
        echo "SUCCESS! Play Integrity Device Integrity passes!"
    else
        echo "Device Integrity still failing."
    fi
else
    echo "Error: Failed to retrieve window layout dump."
fi

echo "=== Flow Finished ==="
