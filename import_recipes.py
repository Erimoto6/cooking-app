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
        
        # IMPROVED: Split steps properly
        steps = []
        # Split by patterns like "1. ", "2. ", "3. " etc.
        step_matches = re.findall(r'\d+\.\s*(.*?)(?=\d+\.\s*|$)', procedure_text, re.DOTALL)
        if step_matches:
            for step in step_matches:
                step = step.strip()
                if step:
                    steps.append(step)
        else:
            # Fallback: split by newlines
            for line in procedure_text.strip().split('\n'):
                line = line.strip()
                if line and not line.startswith('['):
                    clean_step = re.sub(r'^\d+\.\s*', '', line)
                    if clean_step:
                        steps.append(clean_step)
        
        if len(steps) <= 5:
            difficulty = 'Easy'
        elif len(steps) <= 8:
            difficulty = 'Medium'
        else:
            difficulty = 'Hard'
        
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
            'steps': steps  # Now steps is a list of individual steps
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
    
    # Clear existing steps and ingredients first
    cur.execute("DELETE FROM steps")
    cur.execute("DELETE FROM ingredients")
    cur.execute("DELETE FROM recipes")
    print("Cleared existing recipes, ingredients, and steps")
    
    for recipe in recipes:
        # Insert recipe
        dish_id = recipe.get('dish_id', f"{recipe['cuisine'][:2]}_{inserted+1:02d}")
        
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
        for idx, step in enumerate(recipe['steps'], start=1):
            if step:
                cur.execute(
                    'INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)',
                    (recipe_id, idx, step)
                )
        
        print(f"  Inserted: {recipe['title']} ({len(recipe['steps'])} steps)")
        inserted += 1
    
    conn.commit()
    cur.close()
    conn.close()
    return inserted, skipped

if __name__ == '__main__':
    FILE = os.path.join(os.path.dirname(__file__), 'Cooking_Application_Drafts__1_.txt')
    
    if not os.path.exists(FILE):
        print(f"File not found: {FILE}")
        exit(1)
    
    print("Parsing recipes...")
    recipes = parse_recipes_from_pipe_format(FILE)
    print(f"   Found {len(recipes)} recipes.\n")
    
    print("Inserting into PostgreSQL...")
    inserted, skipped = insert_recipes(recipes)
    
    print(f"\nDone!")
    print(f"   Inserted : {inserted}")
    print(f"   Skipped  : {skipped}")