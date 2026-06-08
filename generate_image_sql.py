import os

# Your images folder
image_folder = "static/images"

# Get all image files from all subfolders
images = []
for root, dirs, files in os.walk(image_folder):
    for file in files:
        if file.lower().endswith(('.jpg', '.jpeg', '.png')):
            # Get the relative path from static/images/
            rel_path = os.path.relpath(os.path.join(root, file), image_folder)
            images.append((file, rel_path))

print(f"Found {len(images)} images")
print("=" * 60)

# Generate SQL statements
sql_statements = []

for filename, rel_path in images:
    # Get the recipe name from filename (remove extension)
    recipe_name = filename.replace('.jpg', '').replace('.jpeg', '').replace('.png', '')
    # Clean up the name
    recipe_name = recipe_name.replace('_', ' ').replace('-', ' ')
    
    # Create the URL path
    image_url = f"/static/images/{rel_path.replace('\\', '/')}"
    
    sql = f"UPDATE recipes SET image_url = '{image_url}' WHERE title ILIKE '%{recipe_name}%' AND image_url IS NULL;"
    sql_statements.append(sql)
    print(f"📸 {rel_path} -> {recipe_name[:40]}")

# Save to file
with open("update_images.sql", "w", encoding="utf-8") as f:
    f.write("-- Auto-generated SQL to update recipe images\n")
    f.write("-- Run this on your database\n\n")
    f.write("\n".join(sql_statements))

print("\n" + "=" * 60)
print(f"✅ Generated update_images.sql with {len(sql_statements)} statements")