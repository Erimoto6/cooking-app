import psycopg2
import os
import re
from dotenv import load_dotenv

load_dotenv()

# Get database URL
database_url = os.environ.get('DATABASE_URL')

if not database_url:
    # Try local settings
    database_url = f"postgresql://{os.getenv('DB_USER', 'dishly')}:{os.getenv('DB_PASSWORD', 'Dishly2026')}@{os.getenv('DB_HOST', 'localhost')}:{os.getenv('DB_PORT', '5432')}/{os.getenv('DB_NAME', 'dishlydb')}"

print(f"Connecting to database...")
conn = psycopg2.connect(database_url)
cur = conn.cursor()

# Get all existing steps
cur.execute("SELECT id, recipe_id, instruction FROM steps ORDER BY recipe_id, id")
rows = cur.fetchall()

print(f"Found {len(rows)} step records to process")

# Delete all existing steps
cur.execute("DELETE FROM steps")
print("Deleted existing steps")

# Process each recipe
current_recipe = None
step_counter = 0

for row in rows:
    recipe_id = row[1]
    instruction = row[2]
    
    # Check if instruction contains multiple steps (has numbers like "2.", "3.")
    if re.search(r'\d+\.', instruction):
        # Split by patterns like "1. ", "2. ", "3. "
        steps = re.split(r'\d+\.\s*', instruction)
        # Remove empty strings
        steps = [s.strip() for s in steps if s.strip()]
        
        for i, step_text in enumerate(steps, 1):
            cur.execute(
                "INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)",
                (recipe_id, i, step_text)
            )
            print(f"  Recipe {recipe_id}: Added step {i}")
    else:
        # Already a single step
        cur.execute(
            "INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)",
            (recipe_id, 1, instruction)
        )

conn.commit()

# Verify
cur.execute("SELECT recipe_id, COUNT(*) as step_count FROM steps GROUP BY recipe_id ORDER BY recipe_id")
results = cur.fetchall()
print("\n=== Summary ===")
for r in results:
    print(f"Recipe {r[0]}: {r[1]} steps")

cur.close()
conn.close()
print("\n✅ Steps fixed successfully!")