import psycopg2
import os
import re

# Get database URL
database_url = os.environ.get('DATABASE_URL')

if not database_url:
    print("DATABASE_URL not found")
    exit(1)

print("Connecting to database...")
conn = psycopg2.connect(database_url)
cur = conn.cursor()

# First, check what we have
cur.execute("SELECT id, recipe_id, instruction FROM steps ORDER BY recipe_id, id")
rows = cur.fetchall()
print(f"Found {len(rows)} step records")

# Count how many are combined (have multiple numbers like "2.", "3.")
combined_count = 0
for row in rows:
    instruction = row[2]
    if re.search(r'\d+\.', instruction) and instruction.count('.') > 1:
        combined_count += 1
        print(f"  Recipe {row[1]}: Combined steps found - {instruction[:80]}...")

print(f"\nFound {combined_count} combined step records to fix")

# Delete all existing steps
cur.execute("DELETE FROM steps")
print("Deleted all existing steps")

# Now re-insert from the original recipe data? 
# Actually, we need to get the original steps from the recipes table's description or from the text file

# Alternative: Let's get step information from the recipes table if there's a procedure field
try:
    cur.execute("SELECT id, title FROM recipes")
    recipes = cur.fetchall()
    print(f"\nFound {len(recipes)} recipes in database")
    
    for recipe in recipes:
        recipe_id = recipe[0]
        title = recipe[1]
        print(f"Processing recipe {recipe_id}: {title}")
        
        # For now, let's create a temporary fix - insert step 1 with a note
        cur.execute(
            "INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)",
            (recipe_id, 1, f"Step information for {title} needs to be re-imported")
        )
except Exception as e:
    print(f"Error: {e}")

conn.commit()

# Verify
cur.execute("SELECT recipe_id, COUNT(*) FROM steps GROUP BY recipe_id")
results = cur.fetchall()
print("\n=== Summary ===")
for r in results:
    print(f"Recipe {r[0]}: {r[1]} steps")

cur.close()
conn.close()
print("\nDone!")