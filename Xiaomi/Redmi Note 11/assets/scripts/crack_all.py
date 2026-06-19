import subprocess
import re
import time
import sys

prints_file = "/home/austin/.gemini/antigravity/brain/1408d4de-2c99-480f-a3b9-716d5ee33610/.system_generated/steps/808/content.md"

def run_adb(cmd):
    result = subprocess.run(["adb"] + cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return result.stdout, result.returncode

def run_adb_su(cmd_str):
    return run_adb(["shell", f"su -c '{cmd_str}'"])

def parse_prints():
    with open(prints_file, "r") as f:
        lines = f.readlines()
        
    entries = []
    for idx, line in enumerate(lines):
        if "=" in line and ":" in line:
            parts = line.split("=")
            if len(parts) >= 2:
                left = parts[0].strip()
                right = parts[1].strip()
                
                left_parts = left.split(":")
                if len(left_parts) >= 3:
                    name = left_parts[0]
                    manufacturer = left_parts[1]
                    model = left_parts[2]
                    
                    # Fingerprints can contain multiple versions separated by ';'
                    fp_versions = right.split(";")
                    for fp_ver in fp_versions:
                        # e.g., asus/WW_I003D/ASUS_I003_1:10/QKQ1.200419.002/17.0823.2012.122-0:user/release-keys__2020-12-01
                        match = re.search(r':(9|10|11)/', fp_ver)
                        if match:
                            release_ver = match.group(1)
                            
                            # Split fingerprint and security patch
                            fp_parts = fp_ver.split("__")
                            fp_string = fp_parts[0]
                            security_patch = fp_parts[1] if len(fp_parts) > 1 else "2020-10-05" # fallback security patch
                            
                            entries.append({
                                "name": name,
                                "manufacturer": manufacturer,
                                "model": model,
                                "fingerprint": fp_string,
                                "security_patch": security_patch,
                                "release": release_ver
                            })
    return entries

def parse_fp_details(entry):
    fp_str = entry["fingerprint"]
    col_parts = fp_str.split(':')
    if len(col_parts) < 3:
        return None
    
    first_part = col_parts[0]  # BRAND/PRODUCT/DEVICE
    second_part = col_parts[1] # RELEASE/ID/INCREMENTAL
    third_part = col_parts[2]  # TYPE/TAGS
    
    slash_parts_1 = first_part.split('/')
    if len(slash_parts_1) < 3:
        return None
    brand = slash_parts_1[0]
    product = slash_parts_1[1]
    device = slash_parts_1[2]
    
    slash_parts_2 = second_part.split('/')
    if len(slash_parts_2) < 3:
        return None
    release = slash_parts_2[0]
    build_id = slash_parts_2[1]
    incremental = slash_parts_2[2]
    
    type_tags = third_part.split('/')
    build_type = type_tags[0] if len(type_tags) > 0 else "user"
    tags = type_tags[1] if len(type_tags) > 1 else "release-keys"
    
    sdk_map = {
        "9": "28", "10": "29", "11": "30"
    }
    sdk = sdk_map.get(release, "30")
    
    return {
        "MANUFACTURER": entry["manufacturer"],
        "MODEL": entry["model"],
        "FINGERPRINT": fp_str,
        "BRAND": brand,
        "PRODUCT": product,
        "DEVICE": device,
        "RELEASE": release,
        "ID": build_id,
        "INCREMENTAL": incremental,
        "TYPE": build_type,
        "TAGS": tags,
        "SECURITY_PATCH": entry["security_patch"],
        "SDK": sdk
    }

def main():
    print("=== Automated Play Integrity Cracker ===")
    entries = parse_prints()
    print(f"Loaded {len(entries)} candidate fingerprints.")
    
    # Unlock phone
    print("Unlocking phone...")
    run_adb(["shell", "input", "keyevent", "KEYCODE_WAKEUP"])
    time.sleep(0.5)
    run_adb(["shell", "input", "keyevent", "82"])
    time.sleep(0.5)
    run_adb(["shell", "input", "keyevent", "8", "12", "9", "8", "11", "15", "13", "10", "66"])
    time.sleep(1.5)
    
    # Launch Play Store once to ensure account sync
    print("Syncing Play Store...")
    run_adb(["shell", "monkey", "-p", "com.android.vending", "1"])
    time.sleep(8)
    
    # Force launch Checker app
    print("Launching Play Integrity Checker...")
    run_adb(["shell", "monkey", "-p", "gr.nikolasspyr.integritycheck", "1"])
    time.sleep(3)
    
    for idx, entry in enumerate(entries):
        details = parse_fp_details(entry)
        if not details:
            continue
            
        print(f"\n----------------------------------------")
        print(f"Testing Candidate {idx+1}/{len(entries)}: {entry['name']} (Android {entry['release']})")
        print(f"FP: {details['FINGERPRINT']}")
        print(f"Security Patch: {details['SECURITY_PATCH']}")
        
        # 1. Write the pif.prop content
        pif_content = f"""MANUFACTURER={details['MANUFACTURER']}
MODEL={details['MODEL']}
FINGERPRINT={details['FINGERPRINT']}
BRAND={details['BRAND']}
PRODUCT={details['PRODUCT']}
DEVICE={details['DEVICE']}
RELEASE={details['RELEASE']}
ID={details['ID']}
INCREMENTAL={details['INCREMENTAL']}
TYPE={details['TYPE']}
TAGS={details['TAGS']}
SECURITY_PATCH={details['SECURITY_PATCH']}
DEVICE_INITIAL_SDK_INT={details['SDK']}

*.build.id={details['ID']}
*.security_patch={details['SECURITY_PATCH']}
*api_level={details['SDK']}

spoofBuild=1
spoofProps=1
spoofProvider=1
spoofSignature=0
spoofVendingFinger=0
spoofVendingSdk=0
verboseLogs=0
"""
        with open("temp.pif.prop", "w") as f:
            f.write(pif_content)
            
        # 2. Push and apply
        run_adb(["push", "temp.pif.prop", "/data/local/tmp/custom.pif.prop"])
        run_adb_su("cp /data/local/tmp/custom.pif.prop /data/adb/modules/playintegrityfix/custom.pif.prop && chmod 644 /data/adb/modules/playintegrityfix/custom.pif.prop && sh /data/adb/modules/playintegrityfix/killpi.sh")
        
        # 3. Tap CHECK
        run_adb(["shell", "input", "tap", "540", "1526"])
        time.sleep(6)
        
        # 4. Dump XML and parse
        run_adb(["shell", "uiautomator", "dump", "/sdcard/window_dump_crack.xml"])
        run_adb(["pull", "/sdcard/window_dump_crack.xml", "./window_dump_crack.xml"])
        
        try:
            with open("window_dump_crack.xml", "r") as f:
                xml_content = f.read()
            
            # Format XML
            xml_content = xml_content.replace("><", ">\n<")
            lines = xml_content.splitlines()
            
            basic = "Unknown"
            device = "Unknown"
            strong = "Unknown"
            
            for line in lines:
                if "basic_integrity_icon" in line:
                    m = re.search(r'content-desc="([^"]+)"', line)
                    if m: basic = m.group(1)
                elif "device_integrity_icon" in line:
                    m = re.search(r'content-desc="([^"]+)"', line)
                    if m: device = m.group(1)
                elif "strong_integrity_icon" in line:
                    m = re.search(r'content-desc="([^"]+)"', line)
                    if m: strong = m.group(1)
            
            print(f"Results:")
            print(f"  BASIC:  {basic}")
            print(f"  DEVICE: {device}")
            print(f"  STRONG: {strong}")
            
            if device == "Pass":
                print("\n==================================================")
                print(" SUCCESS!!! Working fingerprint found!")
                print(f" Name: {entry['name']}")
                print(f" Fingerprint: {details['FINGERPRINT']}")
                print("==================================================")
                
                # Save the winning file
                run_adb(["push", "temp.pif.prop", "/data/local/tmp/spes.pif.prop"])
                run_adb_su("cp /data/local/tmp/spes.pif.prop /data/adb/modules/playintegrityfix/custom.pif.prop && chmod 644 /data/adb/modules/playintegrityfix/custom.pif.prop")
                
                subprocess.run(["cp", "temp.pif.prop", "spes.pif.prop"])
                subprocess.run(["rm", "-f", "temp.pif.prop", "window_dump_crack.xml"])
                sys.exit(0)
                
        except Exception as e:
            print(f"Error parsing window dump: {e}")
            
        time.sleep(1)

    print("\n==================================================")
    print(" FAILURE: Checked all candidates, none passed DEVICE integrity.")
    print("==================================================")
    sys.exit(1)

if __name__ == "__main__":
    main()
