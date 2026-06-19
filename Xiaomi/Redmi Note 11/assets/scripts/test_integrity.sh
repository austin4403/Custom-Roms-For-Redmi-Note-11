#!/bin/bash

# Device PIN
PIN="15214863"

echo "=== Starting Play Integrity Automation ==="

# 1. Wait for device
echo "[1/7] Waiting for ADB device to connect..."
adb wait-for-device
echo "Device connected!"

# 2. Unlock phone
echo "[2/7] Attempting to unlock screen..."
adb shell input keyevent KEYCODE_WAKEUP
sleep 1
# Dismiss lock screen swipe
adb shell input keyevent 82
sleep 1
# Send PIN digits (1 5 2 1 4 8 6 3) and Enter
# Keycodes: 1=8, 5=12, 2=9, 1=8, 4=11, 8=15, 6=13, 3=10, Enter=66
adb shell input keyevent 8 12 9 8 11 15 13 10 66
sleep 2

# Verify unlock
FOCUS=$(adb shell dumpsys window | grep -E "mCurrentFocus")
echo "Current focus after unlock: $FOCUS"

# 3. Launch Play Store for sync
echo "[3/7] Launching Google Play Store to force account sync..."
adb shell monkey -p com.android.vending 1 > /dev/null 2>&1
sleep 8

# 4. Launch Play Integrity Checker
echo "[4/7] Launching Play Integrity API Checker app..."
adb shell monkey -p gr.nikolasspyr.integritycheck 1 > /dev/null 2>&1
sleep 3

# Verify app launched
FOCUS=$(adb shell dumpsys window | grep -E "mCurrentFocus")
if [[ $FOCUS == *"gr.nikolasspyr.integritycheck"* ]]; then
    echo "Play Integrity Checker successfully launched and focused."
else
    echo "WARNING: App might not be focused. Attempting to launch MainActivity directly..."
    adb shell am start -n gr.nikolasspyr.integritycheck/gr.nikolasspyr.integritycheck.MainActivity > /dev/null 2>&1
    sleep 3
fi

# 5. Tap Check button
echo "[5/7] Tapping CHECK button (X=540, Y=1526)..."
adb shell input tap 540 1526
sleep 6

# 6. Dump UI hierarchy
echo "[6/7] Dumping UI layout to parse results..."
adb shell uiautomator dump /sdcard/window_dump_auto.xml > /dev/null 2>&1
adb pull /sdcard/window_dump_auto.xml ./window_dump_auto.xml > /dev/null 2>&1

# 7. Parse and display results
echo "[7/7] Parsed Play Integrity Results:"
if [ -f "./window_dump_auto.xml" ]; then
    BASIC=$(grep 'basic_integrity_icon' ./window_dump_auto.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
    DEVICE=$(grep 'device_integrity_icon' ./window_dump_auto.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
    STRONG=$(grep 'strong_integrity_icon' ./window_dump_auto.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
    
    [ -z "$BASIC" ] && BASIC="Unknown (Try checking if app shows checking screen)"
    [ -z "$DEVICE" ] && DEVICE="Unknown"
    [ -z "$STRONG" ] && STRONG="Unknown"
    
    echo "--------------------------------------"
    echo "  MEETS_BASIC_INTEGRITY:  $BASIC"
    echo "  MEETS_DEVICE_INTEGRITY: $DEVICE"
    echo "  MEETS_STRONG_INTEGRITY: $STRONG"
    echo "--------------------------------------"
else
    echo "Error: Failed to retrieve window hierarchy dump."
fi

echo "=== Automation Finished ==="
