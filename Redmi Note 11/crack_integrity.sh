#!/bin/bash

# Array of candidate fingerprints
# Format: MANUFACTURER|MODEL|FINGERPRINT|BRAND|PRODUCT|DEVICE|RELEASE|ID|INCREMENTAL|SECURITY_PATCH|SDK
candidates=(
    "Asus|ZS661KS|asus/WW_I003D/ASUS_I003_1:10/QKQ1.200419.002/17.0823.2012.122-0:user/release-keys|asus|WW_I003D|ASUS_I003_1|10|QKQ1.200419.002|17.0823.2012.122-0|2020-12-01|29"
    "Huawei|SNE-LX1|HUAWEI/SNE-LX1EEA/HWSNE:9/HUAWEISNE-L01/245EEAC782:user/release-keys|HUAWEI|SNE-LX1EEA|HWSNE|9|PKQ1.190723.001|245EEAC782|2019-09-01|28"
    "HTC|HTC U12+|htc/imeuhl_00617/htc_imeuhl:9/PQ2A.190205.003/1087121.1:user/release-keys|htc|imeuhl_00617|htc_imeuhl|9|PQ2A.190205.003|1087121.1|2019-07-01|28"
    "Fairphone|FP3|Fairphone/FP3/FP3:10/8901.3.A.0054.20200929/09290922:user/release-keys|Fairphone|FP3|FP3|10|8901.3.A.0054.20200929|09290922|2020-10-05|29"
    "Essential|PH-1|essential/mata/mata:10/QQ1A.200105.032/540:user/release-keys|essential|mata|mata|10|QQ1A.200105.032|540|2020-02-05|29"
    "Infinix|Infinix X604|Infinix/H633/Infinix-X604_sprout:10/QP1A.190711.020/H-191227V306:user/release-keys|Infinix|H633|Infinix-X604_sprout|10|QP1A.190711.020|H-191227V306|2020-01-05|29"
    "Asus|ZS673KS|asus/WW_I005D/ASUS_I005_1:11/RKQ1.201022.002/18.0840.2103.26-0:user/release-keys|asus|WW_I005D|ASUS_I005_1|11|RKQ1.201022.002|18.0840.2103.26-0|2021-03-05|30"
    "asus|ASUS_I007D|asus/WW_I007D/ASUS_I007_1:11/RKQ1.201112.002/18.1030.2107.138-0:user/release-keys|asus|WW_I007D|ASUS_I007_1|11|RKQ1.201112.002|18.1030.2107.138-0|2021-07-01|30"
)

# PIN Code
PIN="15214863"

echo "=== Play Integrity Fingerprint Cracking Loop ==="
echo "Total candidates: ${#candidates[@]}"
echo ""

# Ensure device is connected
adb wait-for-device

# Unlock phone once
echo "Unlocking phone..."
adb shell input keyevent KEYCODE_WAKEUP
sleep 0.5
adb shell input keyevent 82
sleep 0.5
adb shell input keyevent 8 12 9 8 11 15 13 10 66
sleep 1.5

# Focus Play Integrity app
echo "Launching Integrity Checker..."
adb shell monkey -p gr.nikolasspyr.integritycheck 1 > /dev/null 2>&1
sleep 2

for i in "${!candidates[@]}"; do
    candidate="${candidates[$i]}"
    
    IFS='|' read -r MANUFACTURER MODEL FINGERPRINT BRAND PRODUCT DEVICE RELEASE ID INCREMENTAL SECURITY_PATCH SDK <<< "$candidate"
    
    echo "----------------------------------------"
    echo "Testing Candidate $((i+1))/${#candidates[@]}: $MANUFACTURER $MODEL ($RELEASE)"
    echo "Fingerprint: $FINGERPRINT"
    
    # 1. Write the properties file
    cat <<EOF > temp.pif.prop
MANUFACTURER=$MANUFACTURER
MODEL=$MODEL
FINGERPRINT=$FINGERPRINT
BRAND=$BRAND
PRODUCT=$PRODUCT
DEVICE=$DEVICE
RELEASE=$RELEASE
ID=$ID
INCREMENTAL=$INCREMENTAL
TYPE=user
TAGS=release-keys
SECURITY_PATCH=$SECURITY_PATCH
DEVICE_INITIAL_SDK_INT=$SDK

*.build.id=$ID
*.security_patch=$SECURITY_PATCH
*api_level=$SDK

spoofBuild=1
spoofProps=1
spoofProvider=1
spoofSignature=0
spoofVendingFinger=0
spoofVendingSdk=0
verboseLogs=0
EOF

    # 2. Push to device and kill GMS DroidGuard
    adb push temp.pif.prop /data/local/tmp/custom.pif.prop > /dev/null 2>&1
    adb shell "su -c 'cp /data/local/tmp/custom.pif.prop /data/adb/modules/playintegrityfix/custom.pif.prop && chmod 644 /data/adb/modules/playintegrityfix/custom.pif.prop && sh /data/adb/modules/playintegrityfix/killpi.sh'" > /dev/null 2>&1
    
    # 3. Tap CHECK
    echo "Running check on device..."
    adb shell input tap 540 1526
    sleep 6
    
    # 4. Dump XML and parse
    adb shell uiautomator dump /sdcard/window_dump_crack.xml > /dev/null 2>&1
    adb pull /sdcard/window_dump_crack.xml ./window_dump_crack.xml > /dev/null 2>&1
    
    if [ -f "./window_dump_crack.xml" ]; then
        # Format XML to parse
        sed -i 's/></>\n</g' ./window_dump_crack.xml
        
        BASIC=$(grep 'basic_integrity_icon' ./window_dump_crack.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
        DEVICE=$(grep 'device_integrity_icon' ./window_dump_crack.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
        STRONG=$(grep 'strong_integrity_icon' ./window_dump_crack.xml | grep -oE 'content-desc="[^"]+"' | cut -d'"' -f2)
        
        echo "Results:"
        echo "  BASIC:  $BASIC"
        echo "  DEVICE: $DEVICE"
        echo "  STRONG: $STRONG"
        
        if [ "$DEVICE" = "Pass" ]; then
            echo ""
            echo "=================================================="
            echo " SUCCESS!!! Working fingerprint found!"
            echo " Manufacturer: $MANUFACTURER"
            echo " Model:        $MODEL"
            echo " Fingerprint:  $FINGERPRINT"
            echo "=================================================="
            
            # Save the winning file to spes.pif.prop as well
            cp temp.pif.prop spes.pif.prop
            rm -f temp.pif.prop
            exit 0
        fi
    else
        echo "Error: Failed to dump window XML from device."
    fi
    
    rm -f temp.pif.prop
    sleep 1
done

echo ""
echo "=================================================="
echo " FAILURE: Checked all candidates, none passed DEVICE integrity."
echo "=================================================="
exit 1
