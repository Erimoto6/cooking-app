import cloudinary
import cloudinary.uploader
import cloudinary.api
import os
import re

cloudinary.config(
    cloud_name="dybaojdge",
    api_key="324229828458714",
    api_secret="O_4BAZfVhMYWdsr1pbQeOYEgvYE"
)

folder_path = r"C:\Users\shiel\Downloads\PICTURES-20260608T001901Z-3-001\PICTURES"

def clean_public_id(text):
    text = re.sub(r'[&<>"\'/\\?*%:]', '_', text)
    text = re.sub(r'_+', '_', text)
    return text

# Get already uploaded files from Cloudinary
print("Checking already uploaded files...")
try:
    existing = cloudinary.api.resources(type="upload", prefix="cooking_app", max_results=500)
    existing_ids = set(r['public_id'] for r in existing['resources'])
    print(f"Already uploaded: {len(existing_ids)} images")
except:
    existing_ids = set()
    print("No existing uploads found")

# Find all local images
images = []
for root, dirs, files in os.walk(folder_path):
    for file in files:
        if file.lower().endswith(('.jpg', '.jpeg', '.png')):
            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, folder_path)
            clean_path = clean_public_id(rel_path)
            public_id = f"cooking_app/{clean_path.replace('\\', '/').replace('.jpg', '').replace('.jpeg', '').replace('.png', '')}"
            images.append((full_path, rel_path, public_id))

print(f"\n📸 Total local images: {len(images)}")

# Upload only missing files
to_upload = [img for img in images if img[2] not in existing_ids]
print(f"Need to upload: {len(to_upload)}")

for full_path, rel_path, public_id in to_upload:
    try:
        result = cloudinary.uploader.upload(full_path, public_id=public_id, use_filename=True)
        print(f"✅ Uploaded: {rel_path}")
    except Exception as e:
        print(f"❌ Failed: {rel_path} - {e}")

print("\n🎉 Done!")