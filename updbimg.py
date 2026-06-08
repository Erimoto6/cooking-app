import cloudinary
import cloudinary.api
import cloudinary.uploader
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

cloudinary.config(
    cloud_name="dybaojdge",
    api_key="324229828458714",
    api_secret="O_4BAZfVhMYWdsr1pbQeOYEgvYE"
)

conn = psycopg2.connect(
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432'),
    dbname=os.getenv('DB_NAME', 'dishlydb'),
    user=os.getenv('DB_USER', 'dishly'),
    password=os.getenv('DB_PASSWORD', 'Dishly2026')
)
cur = conn.cursor()

print("=" * 60)
print("FIXING LAST TWO RECIPES")
print("=" * 60)

# First, let's see what images are actually in Cloudinary for these
print("\n📸 Searching Cloudinary for Lemon and Ossobuco images...")

try:
    result = cloudinary.api.resources(type="upload", max_results=500)
    
    lemon_found = None
    ossobuco_found = None
    
    for resource in result['resources']:
        public_id = resource['public_id']
        if 'lemon' in public_id.lower() or 'paeroa' in public_id.lower():
            lemon_found = resource['secure_url']
            print(f"   Found Lemon image: {public_id}")
        if 'ossobuco' in public_id.lower() or 'milanese' in public_id.lower():
            ossobuco_found = resource['secure_url']
            print(f"   Found Ossobuco image: {public_id}")
    
    print("\n" + "=" * 60)
    print("UPDATING RECIPES")
    print("=" * 60)
    
    # Update Lemon and Paeroa
    if lemon_found:
        cur.execute("""
            UPDATE recipes SET image_url = %s 
            WHERE title = 'Lemon and Paeroa' OR title = 'Lemon & Paeroa (L&P)'
        """, (lemon_found,))
        print(f"✅ Updated Lemon and Paeroa with Cloudinary URL")
    else:
        # Use placeholder for now
        print(f"⚠️ Lemon image not found in Cloudinary")
        lemon_placeholder = 'https://res.cloudinary.com/dybaojdge/image/upload/v1/cooking_app/placeholder.jpg'
        cur.execute("""
            UPDATE recipes SET image_url = %s 
            WHERE title = 'Lemon and Paeroa' OR title = 'Lemon & Paeroa (L&P)'
        """, (lemon_placeholder,))
        print(f"✅ Updated Lemon and Paeroa with placeholder")
    
    # Update Ossobuco alla Milanese
    if ossobuco_found:
        cur.execute("""
            UPDATE recipes SET image_url = %s 
            WHERE title = 'Ossobuco alla Milanese'
        """, (ossobuco_found,))
        print(f"✅ Updated Ossobuco alla Milanese with Cloudinary URL")
    else:
        print(f"⚠️ Ossobuco image not found in Cloudinary")
        ossobuco_placeholder = 'https://res.cloudinary.com/dybaojdge/image/upload/v1/cooking_app/placeholder.jpg'
        cur.execute("""
            UPDATE recipes SET image_url = %s 
            WHERE title = 'Ossobuco alla Milanese'
        """, (ossobuco_placeholder,))
        print(f"✅ Updated Ossobuco alla Milanese with placeholder")

except Exception as e:
    print(f"Error searching Cloudinary: {e}")
    print("\nUsing manual URLs instead...")
    
    # Manual URLs (these are the likely correct ones)
    lemon_url = 'https://res.cloudinary.com/dybaojdge/image/upload/v1/cooking_app/Lemon%20%26%20Paeroa%20%28L%26P%29.jpg'
    ossobuco_url = 'https://res.cloudinary.com/dybaojdge/image/upload/v1/cooking_app/Ossobuco%20alla%20Milanese%20.jpg'
    
    cur.execute("""
        UPDATE recipes SET image_url = %s 
        WHERE title = 'Lemon and Paeroa' OR title = 'Lemon & Paeroa (L&P)'
    """, (lemon_url,))
    print(f"✅ Updated Lemon and Paeroa with manual URL")
    
    cur.execute("""
        UPDATE recipes SET image_url = %s 
        WHERE title = 'Ossobuco alla Milanese'
    """, (ossobuco_url,))
    print(f"✅ Updated Ossobuco alla Milanese with manual URL")

conn.commit()

print("\n" + "=" * 60)
print("VERIFICATION")
print("=" * 60)

# Check Lemon and Paeroa
cur.execute("SELECT id, title, image_url FROM recipes WHERE title LIKE '%Lemon%' OR title LIKE '%Paeroa%'")
lemon_results = cur.fetchall()
for recipe_id, title, url in lemon_results:
    print(f"✅ {title}")
    print(f"   URL: {url[:80] if url else 'No URL'}...")

# Check Ossobuco
cur.execute("SELECT id, title, image_url FROM recipes WHERE title LIKE '%Ossobuco%'")
ossobuco_results = cur.fetchall()
for recipe_id, title, url in ossobuco_results:
    print(f"✅ {title}")
    print(f"   URL: {url[:80] if url else 'No URL'}...")

# Final check
cur.execute("SELECT COUNT(*) FROM recipes WHERE image_url IS NULL OR image_url = ''")
remaining = cur.fetchone()[0]
print(f"\n📊 Total recipes still missing images: {remaining}")

if remaining == 0:
    print("\n🎉🎉🎉 ALL RECIPES NOW HAVE IMAGES! 🎉🎉🎉")
else:
    cur.execute("SELECT id, title FROM recipes WHERE image_url IS NULL OR image_url = ''")
    still_missing = cur.fetchall()
    print("\nStill missing:")
    for recipe_id, title in still_missing:
        print(f"  • {title}")

cur.close()
conn.close()