import re

prints_file = "/home/austin/.gemini/antigravity/brain/1408d4de-2c99-480f-a3b9-716d5ee33610/.system_generated/steps/808/content.md"

with open(prints_file, "r") as f:
    lines = f.readlines()

print(f"Total lines in prints.sh: {len(lines)}")

# We look for lines containing '=' and release version ':10/' or ':11/' or ':9/'
# Format: Name:Manufacturer:Model=Fingerprint__SecurityPatch
# Example: Asus Zenfone 8 Mini Europe ASUS_I006D (11):Asus:ASUS_I006D=asus/EU_I006D/ASUS_I006D:11/RKQ1.201022.002/30.11.51.83:user/release-keys__2021-05-05

valid_entries = []

for idx, line in enumerate(lines):
    if "=" in line and ":" in line:
        parts = line.split("=")
        if len(parts) >= 2:
            left = parts[0]
            right = parts[1].strip()
            
            # Extract name and brand
            left_parts = left.split(":")
            if len(left_parts) >= 3:
                name = left_parts[0]
                brand = left_parts[1]
                model = left_parts[2]
                
                # Check for Android 10 or 11 or 12 in the fingerprint
                # Fingerprint is usually brand/product/device:release/id/incremental:type/tags
                # Wait, the fingerprint right part might contain multiple versions separated by ';'
                fp_versions = right.split(";")
                for fp_ver in fp_versions:
                    # e.g., asus/WW_I006D/ASUS_I006D:11/RKQ1.201022.002/30.11.51.67:user/release-keys__2021-04-05
                    match = re.search(r':(9|10|11)/', fp_ver)
                    if match:
                        version = match.group(1)
                        # Split fingerprint and security patch
                        fp_parts = fp_ver.split("__")
                        fp_string = fp_parts[0]
                        sec_patch = fp_parts[1] if len(fp_parts) > 1 else "Unknown"
                        
                        valid_entries.append({
                            "line_num": idx + 1,
                            "name": name,
                            "brand": brand,
                            "model": model,
                            "version": version,
                            "fingerprint": fp_string,
                            "security_patch": sec_patch
                        })

print(f"Found {len(valid_entries)} fingerprints for Android 9/10/11.")

# Print some examples from different brands
brands = set(entry["brand"] for entry in valid_entries)
print(f"Available brands: {sorted(list(brands))}")

# Group by brand and show up to 2 per brand
grouped = {}
for entry in valid_entries:
    b = entry["brand"].lower()
    if b not in grouped:
        grouped[b] = []
    if len(grouped[b]) < 3:
        grouped[b].append(entry)

for b, entries in sorted(grouped.items()):
    print(f"\n--- Brand: {b.upper()} ---")
    for entry in entries:
        print(f"Line {entry['line_num']}: {entry['name']}")
        print(f"  Model: {entry['model']}")
        print(f"  FP: {entry['fingerprint']}")
        print(f"  Patch: {entry['security_patch']}")
