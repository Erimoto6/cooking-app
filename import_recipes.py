import psycopg2
import os
import re
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'dbname': os.getenv('DB_NAME', 'dishlydb'),
    'user': os.getenv('DB_USER', 'dishly'),
    'password': os.getenv('DB_PASSWORD', 'Dishly2026'),
}

def parse_recipes_from_pipe_format(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    recipes = []
    recipe_pattern = r'\[DISH_ID:(.*?)\]\n\[TITLE:(.*?)\]\n\[CATEGORY:(.*?)\]\n\[SUBCATEGORY:(.*?)\]\n\[INGREDIENTS:(.*?)\]\n\[PROCEDURE:(.*?)\]'
    
    matches = re.findall(recipe_pattern, content, re.DOTALL)
    
    for match in matches:
        dish_id = match[0].strip()
        title = match[1].strip()
        category = match[2].strip()
        subcategory = match[3].strip()
        ingredients_text = match[4].strip()
        procedure_text = match[5].strip()
        
        parts = subcategory.split(' ')
        region = parts[0] if parts else ''
        cuisine = category
        
        ingredients = [ing.strip() for ing in ingredients_text.split('|')]
        
        # ========== IMPROVED STEP PARSING WITH CLEANING ==========
        steps = []
        
        # Method 1: Split by patterns like "1. ", "2. ", "3. "
        step_matches = re.findall(r'\d+\.\s*(.*?)(?=\d+\.\s*|$)', procedure_text, re.DOTALL)
        
        for step in step_matches:
            # Clean the step text
            step = step.strip()
            # Remove leading "I", "-", "•", "*", and extra spaces
            step = re.sub(r'^[I\-•*\s]+', '', step)
            step = step.strip()
            # Remove trailing "|" or special chars
            step = re.sub(r'[\|\s]+$', '', step)
            # Remove any remaining weird characters at the beginning
            step = re.sub(r'^[^a-zA-Z0-9\s]', '', step)
            step = step.strip()
            if step and len(step) > 2:
                steps.append(step)
        
        # Method 2: Split by newlines as fallback
        if not steps:
            for line in procedure_text.strip().split('\n'):
                line = line.strip()
                if line and not line.startswith('['):
                    # Remove step number if present
                    clean_step = re.sub(r'^\d+\.\s*', '', line)
                    # Remove leading special characters
                    clean_step = re.sub(r'^[I\-•*\s]+', '', clean_step)
                    clean_step = clean_step.strip()
                    if clean_step and len(clean_step) > 2:
                        steps.append(clean_step)
        
        # Method 3: Split by pipe as last resort
        if not steps and '|' in procedure_text:
            pipe_parts = procedure_text.split('|')
            for part in pipe_parts:
                part = part.strip()
                # Remove step number if present
                clean_step = re.sub(r'^\d+\.\s*', '', part)
                clean_step = re.sub(r'^[I\-•*\s]+', '', clean_step)
                clean_step = clean_step.strip()
                if clean_step and len(clean_step) > 2:
                    steps.append(clean_step)
        
        # Determine difficulty
        if len(steps) <= 5:
            difficulty = 'Easy'
        elif len(steps) <= 8:
            difficulty = 'Medium'
        else:
            difficulty = 'Hard'
        
        # Determine category type
        if 'Main' in subcategory or 'MAIN' in subcategory.upper():
            category_type = 'Main Course'
        elif 'Dessert' in subcategory or 'DESSERT' in subcategory.upper():
            category_type = 'Dessert'
        elif 'Beverage' in subcategory or 'BEVERAGE' in subcategory.upper():
            category_type = 'Beverage'
        else:
            category_type = 'Main Course'
        
        recipe = {
            'dish_id': dish_id,
            'title': title,
            'cuisine': cuisine,
            'region': region,
            'category': category_type,
            'difficulty': difficulty,
            'prep_time': 15,
            'cook_time': 30,
            'ingredients': ingredients,
            'steps': steps
        }
        recipes.append(recipe)
    
    return recipes

def insert_recipes(recipes):
    database_url = os.environ.get('DATABASE_URL')
    
    if database_url:
        print(f"Connecting to Railway database...")
        conn = psycopg2.connect(database_url)
    else:
        print(f"Connecting to local database...")
        conn = psycopg2.connect(**DB_CONFIG)
    
    cur = conn.cursor()
    inserted = 0
    skipped = 0
    
    # Clear existing data
    try:
        cur.execute("DELETE FROM steps")
        cur.execute("DELETE FROM ingredients")
        cur.execute("DELETE FROM recipes")
        print("Cleared existing recipes, ingredients, and steps")
    except Exception as e:
        print(f"Note: {e}")
    
    for recipe in recipes:
        # Generate dish_id if not present
        dish_id = recipe.get('dish_id', f"{recipe['cuisine'][:2]}_{inserted+1:02d}")
        
        # Insert recipe
        cur.execute('''
            INSERT INTO recipes 
            (dish_id, title, description, cuisine, region, category, difficulty, prep_time, cook_time)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id
        ''', (
            dish_id,
            recipe['title'],
            f"A delicious {recipe['category']} from {recipe['region']}",
            recipe['cuisine'],
            recipe['region'],
            recipe['category'],
            recipe['difficulty'],
            recipe['prep_time'],
            recipe['cook_time']
        ))
        recipe_id = cur.fetchone()[0]
        
        # Insert ingredients
        for ing in recipe['ingredients']:
            if ing:
                cur.execute(
                    'INSERT INTO ingredients (recipe_id, name, quantity) VALUES (%s, %s, %s)',
                    (recipe_id, ing, '')
                )
        
        # Insert steps - EACH STEP AS A SEPARATE ROW
        step_count = 0
        for idx, step in enumerate(recipe['steps'], start=1):
            if step:
                cur.execute(
                    'INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)',
                    (recipe_id, idx, step)
                )
                step_count += 1
        
        print(f"  ✅ Inserted: {recipe['title']} ({step_count} steps, {len(recipe['ingredients'])} ingredients)")
        inserted += 1
    
    conn.commit()
    cur.close()
    conn.close()
    return inserted, skipped

if __name__ == '__main__':
    # Path to your recipe file
    FILE = os.path.join(os.path.dirname(__file__), 'Cooking_Application_Drafts__1_.txt')
    
    # Alternative filename if not found
    if not os.path.exists(FILE):
        FILE = os.path.join(os.path.dirname(__file__), 'Cooking_Application_Drafts__1.txt')
    
    if not os.path.exists(FILE):
        print(f"❌ File not found: {FILE}")
        print("   Make sure the recipe text file is in the same folder.")
        exit(1)
    
    print("📖 Parsing recipes from pipe-delimited format...")
    recipes = parse_recipes_from_pipe_format(FILE)
    print(f"   Found {len(recipes)} recipes.\n")
    
    # Count total steps
    total_steps = sum(len(r['steps']) for r in recipes)
    print(f"   Total steps across all recipes: {total_steps}")
    print()
    
    print("💾 Inserting into PostgreSQL...")
    inserted, skipped = insert_recipes(recipes)
    
    print(f"\n🎉 Done!")
    print(f"   Inserted : {inserted}")
    print(f"   Skipped  : {skipped}")