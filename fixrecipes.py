# fix_regions.py
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432'),
    dbname=os.getenv('DB_NAME', 'dishlydb'),
    user=os.getenv('DB_USER', 'dishly'),
    password=os.getenv('DB_PASSWORD', '')
)

cur = conn.cursor()

# Fix the region names
updates = [
    ("South Africa", "South"),
    ("South Korea", "Korean"),
    ("United States", "United"),
    ("New Zealand", "New"),
]

for correct_name, wrong_name in updates:
    cur.execute("UPDATE recipes SET region = %s WHERE region = %s", (correct_name, wrong_name))
    print(f"Fixed: {wrong_name} -> {correct_name}")

conn.commit()

# Verify the fixes
cur.execute("SELECT region, COUNT(*) FROM recipes GROUP BY region ORDER BY region")
print("\nUpdated regions:")
for row in cur.fetchall():
    print(f"  {row[0]}: {row[1]} recipes")

cur.close()
conn.close()