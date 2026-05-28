"""
import_working.py - Simplified importer for the already-cleaned recipe file
"""

import psycopg2
import psycopg2.extras
import re
import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host':     os.getenv('DB_HOST', 'localhost'),
    'port':     os.getenv('DB_PORT', '5432'),
    'dbname':   os.getenv('DB_NAME', 'dishlydb'),
    'user':     os.getenv('DB_USER', 'dishly'),
    'password': os.getenv('DB_PASSWORD', ''),
}

def parse_recipes_from_cleaned_file(filepath):
    """Parse the already-cleaned recipe file with [DISH_ID:] format"""
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    recipes = []
    
    # Split by [DISH_ID: to get individual recipe blocks
    blocks = re.split(r'\n(?=\[DISH_ID:)', content)
    
    for block in blocks:
        if not block.strip() or not block.startswith('[DISH_ID:'):
            continue
        
        recipe = {}
        
        # Extract DISH_ID
        dish_match = re.search(r'\[DISH_ID:([^\]]+)\]', block)
        if dish_match:
            recipe['dish_id'] = dish_match.group(1)
        
        # Extract TITLE
        title_match = re.search(r'\[TITLE:([^\]]+)\]', block)
        if title_match:
            recipe['title'] = title_match.group(1)
        
        # Extract CATEGORY
        cat_match = re.search(r'\[CATEGORY:([^\]]+)\]', block)
        if cat_match:
            recipe['cuisine'] = cat_match.group(1)
        
        # Extract SUBCATEGORY
        sub_match = re.search(r'\[SUBCATEGORY:([^\]]+)\]', block)
        if sub_match:
            subcat = sub_match.group(1)
            # Parse region and course type
            parts = subcat.split()
            if len(parts) >= 2:
                recipe['region'] = parts[0]
                # Determine category
                if 'Main' in subcat or 'Course' in subcat:
                    recipe['category'] = 'Main Course'
                elif 'Dessert' in subcat:
                    recipe['category'] = 'Dessert'
                elif 'Beverage' in subcat:
                    recipe['category'] = 'Beverage'
                else:
                    recipe['category'] = parts[-1]
            else:
                recipe['region'] = subcat
                recipe['category'] = 'Main Course'
        
        # Extract INGREDIENTS
        ing_match = re.search(r'\[INGREDIENTS:([^\]]+)\]', block)
        if ing_match:
            ingredients_str = ing_match.group(1)
            recipe['ingredients'] = [i.strip() for i in ingredients_str.split('|') if i.strip()]
        else:
            recipe['ingredients'] = []
        
        # Extract PROCEDURE
        proc_match = re.search(r'\[PROCEDURE:([^\]]+)\]', block)
        if proc_match:
            steps_str = proc_match.group(1)
            recipe['steps'] = [s.strip() for s in steps_str.split('|') if s.strip()]
        else:
            recipe['steps'] = []
        
        # Add description from first step
        if recipe.get('steps'):
            first_step = recipe['steps'][0]
            recipe['description'] = first_step[:150] + '...' if len(first_step) > 150 else first_step
        elif recipe.get('ingredients'):
            recipe['description'] = f"Made with {recipe['ingredients'][0]}..."
        else:
            recipe['description'] = ''
        
        # Default values
        recipe['prep_time'] = 15
        recipe['cook_time'] = 30
        recipe['difficulty'] = 'Medium'
        
        # Adjust difficulty based on steps count
        steps_count = len(recipe.get('steps', []))
        if steps_count <= 5:
            recipe['difficulty'] = 'Easy'
        elif steps_count >= 9:
            recipe['difficulty'] = 'Hard'
        
        if recipe.get('dish_id') and recipe.get('title'):
            recipes.append(recipe)
    
    return recipes

def insert_recipes(recipes):
    """Insert recipes into database"""
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    inserted = 0
    skipped = 0
    
    for r in recipes:
        # Check if dish_id already exists
        cur.execute("SELECT id FROM recipes WHERE dish_id = %s", (r['dish_id'],))
        if cur.fetchone():
            print(f"  ⏭ Skipping duplicate: {r['dish_id']} - {r['title']}")
            skipped += 1
            continue
        
        try:
            # Insert recipe with dish_id
            cur.execute('''
                INSERT INTO recipes 
                (dish_id, title, description, cuisine, region, category, difficulty, prep_time, cook_time)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING id
            ''', (
                r['dish_id'], r['title'], r['description'], 
                r.get('cuisine', ''), r.get('region', ''), r.get('category', ''),
                r['difficulty'], r['prep_time'], r['cook_time']
            ))
            recipe_id = cur.fetchone()[0]
            
            # Insert ingredients
            for ing in r['ingredients']:
                # Try to split name and quantity if pipe-separated
                if '|' in ing:
                    parts = ing.split('|')
                    name = parts[0].strip()
                    qty = parts[1].strip() if len(parts) > 1 else ''
                else:
                    name = ing
                    qty = ''
                cur.execute(
                    'INSERT INTO ingredients (recipe_id, name, quantity) VALUES (%s, %s, %s)',
                    (recipe_id, name, qty)
                )
            
            # Insert steps
            for idx, step in enumerate(r['steps'], start=1):
                cur.execute(
                    'INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)',
                    (recipe_id, idx, step)
                )
            
            print(f"  ✅ Inserted: {r['dish_id']} - {r['title']}")
            inserted += 1
            
        except Exception as e:
            print(f"  ❌ Error inserting {r['dish_id']}: {e}")
            conn.rollback()
            cur = conn.cursor()
            skipped += 1
            continue
    
    conn.commit()
    cur.close()
    conn.close()
    return inserted, skipped

if __name__ == '__main__':
    # Use your existing file (it's already in the correct format!)
    FILE = "Cooking_Application_Drafts__1_.txt"
    
    if not os.path.exists(FILE):
        print(f"❌ File not found: {FILE}")
        exit(1)
    
    print("📖 Parsing recipes from cleaned file...")
    recipes = parse_recipes_from_cleaned_file(FILE)
    print(f"   Found {len(recipes)} recipes.\n")
    
    if len(recipes) == 0:
        print("⚠️ No recipes found! The file might be empty or in wrong format.")
        print("   First 500 characters of file:")
        with open(FILE, 'r', encoding='utf-8') as f:
            print(f.read(500))
        exit(1)
    
    print("💾 Inserting into PostgreSQL...")
    inserted, skipped = insert_recipes(recipes)
    
    print(f"\n🎉 Done!")
    print(f"   Inserted : {inserted}")
    print(f"   Skipped  : {skipped}")