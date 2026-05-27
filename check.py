# test_db_direct.py - Direct database test without Flask context
import psycopg2
import psycopg2.extras
import os
from dotenv import load_dotenv

load_dotenv()

# Connect directly to database
conn = psycopg2.connect(
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432'),
    dbname=os.getenv('DB_NAME', 'dishlydb'),
    user=os.getenv('DB_USER', 'dishly'),
    password=os.getenv('DB_PASSWORD', '')
)

cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

# Test finding a recipe by dish_id
cursor.execute("SELECT * FROM recipes WHERE dish_id = 'PH_M01'")
recipe = cursor.fetchone()

if recipe:
    print(f"✅ Found recipe!")
    print(f"   Title: {recipe['title']}")
    print(f"   Dish ID: {recipe['dish_id']}")
    print(f"   Cuisine: {recipe['cuisine']}")
    print(f"   Region: {recipe['region']}")
    
    # Get ingredients
    cursor.execute("SELECT * FROM ingredients WHERE recipe_id = %s", (recipe['id'],))
    ingredients = cursor.fetchall()
    print(f"   Ingredients: {len(ingredients)} items")
    for ing in ingredients[:3]:
        print(f"      - {ing['name']}")
    
    # Get steps
    cursor.execute("SELECT * FROM steps WHERE recipe_id = %s ORDER BY step_number", (recipe['id'],))
    steps = cursor.fetchall()
    print(f"   Steps: {len(steps)} steps")
    for step in steps[:2]:
        print(f"      {step['step_number']}. {step['instruction'][:60]}...")
else:
    print("❌ Recipe not found")

cursor.close()
conn.close()