"""
import_recipes.py
----------------
Run this script ONCE from inside your cooking-app folder to parse the
recipes text file and insert everything into your PostgreSQL database.

Usage (from cooking-app folder, venv active):
    python import_recipes.py
"""

import psycopg2
import psycopg2.extras
import re
import os
from dotenv import load_dotenv

load_dotenv()

# ── DB connection ──────────────────────────────────────────────────────────────
DB_CONFIG = {
    'host':     os.getenv('DB_HOST', 'localhost'),
    'port':     os.getenv('DB_PORT', '5432'),
    'dbname':   os.getenv('DB_NAME', 'dishlydb'),
    'user':     os.getenv('DB_USER', 'dishly'),
    'password': os.getenv('DB_PASSWORD', ''),
}

# ── Section header patterns ────────────────────────────────────────────────────
# Maps text patterns found in the file → (cuisine, region, category)
SECTION_MAP = [
    # FILIPINO
    (r'ASIAN\s*[-–]\s*FILIPINO MAIN',       'Asian', 'Philippines', 'Main Course'),
    (r'FILIPINO DESSERTS?',                  'Asian', 'Philippines', 'Dessert'),
    (r'FILIPINO BEVERAGES?',                 'Asian', 'Philippines', 'Beverage'),
    # KOREAN
    (r'ASIAN\s*[-–]\s*KOREAN MAIN',         'Asian', 'South Korea', 'Main Course'),
    (r'KOREAN DESSERTS?',                    'Asian', 'South Korea', 'Dessert'),
    (r'KOREAN BEVERAGES?',                   'Asian', 'South Korea', 'Beverage'),
    # JAPANESE
    (r'ASIAN\s*[-–]\s*JAPANESE MAIN',       'Asian', 'Japan', 'Main Course'),
    (r'JAPANESE DESSERTS?',                  'Asian', 'Japan', 'Dessert'),
    (r'JAPANESE BEVERAGES?',                 'Asian', 'Japan', 'Beverage'),
    # CHINESE
    (r'ASIAN\s*[-–]\s*CHINESE MAIN',        'Asian', 'China', 'Main Course'),
    (r'CHINESE DESSERTS?',                   'Asian', 'China', 'Dessert'),
    (r'CHINESE BEVERAGES?',                  'Asian', 'China', 'Beverage'),
    # INDONESIAN
    (r'ASIAN\s*[-–]\s*INDONESIAN MAIN',     'Asian', 'Indonesia', 'Main Course'),
    (r'INDONESIAN DESSERTS?',                'Asian', 'Indonesia', 'Dessert'),
    (r'INDONESIAN BEVERAGES?',               'Asian', 'Indonesia', 'Beverage'),
    # NIGERIAN
    (r'AFRICAN\s*[-–]\s*NIGERIAN MAIN',     'African', 'Nigeria', 'Main Course'),
    (r'NIGERIAN DESSERTS?',                  'African', 'Nigeria', 'Dessert'),
    (r'NIGERIAN BEVERAGES?',                 'African', 'Nigeria', 'Beverage'),
    (r'NIGERIA\s*[-–]\s*MAIN',              'African', 'Nigeria', 'Main Course'),
    (r'NIGERIA\s*[-–]\s*DESSERTS?',         'African', 'Nigeria', 'Dessert'),
    (r'NIGERIA\s*[-–]\s*BEVERAGES?',        'African', 'Nigeria', 'Beverage'),
    # SOUTH AFRICA
    (r'SOUTH AFRICA\s*[-–]\s*MAIN',         'African', 'South Africa', 'Main Course'),
    (r'SOUTH AFRICA\s*[-–]\s*DESSERTS?',    'African', 'South Africa', 'Dessert'),
    (r'SOUTH AFRICA\s*[-–]\s*BEVERAGES?',   'African', 'South Africa', 'Beverage'),
    (r'AFRICAN\s*[-–]\s*SOUTH AFRICAN MAIN','African', 'South Africa', 'Main Course'),
    (r'SOUTH AFRICAN DESSERTS?',             'African', 'South Africa', 'Dessert'),
    (r'SOUTH AFRICAN BEVERAGES?',            'African', 'South Africa', 'Beverage'),
    # EGYPT
    (r'EGYPT\s*[-–]\s*MAIN',                'African', 'Egypt', 'Main Course'),
    (r'EGYPT\s*[-–]\s*DESSERTS?',           'African', 'Egypt', 'Dessert'),
    (r'EGYPT\s*[-–]\s*BEVERAGES?',          'African', 'Egypt', 'Beverage'),
    (r'AFRICAN\s*[-–]\s*EGYPTIAN MAIN',     'African', 'Egypt', 'Main Course'),
    (r'EGYPTIAN DESSERTS?',                  'African', 'Egypt', 'Dessert'),
    (r'EGYPTIAN BEVERAGES?',                 'African', 'Egypt', 'Beverage'),
    # AUSTRALIA
    (r'AUSTRALIA\s*[-–]\s*MAIN',            'Oceania', 'Australia', 'Main Course'),
    (r'AUSTRALIA\s*[-–]\s*DESSERTS?',       'Oceania', 'Australia', 'Dessert'),
    (r'AUSTRALIA\s*[-–]\s*BEVERAGES?',      'Oceania', 'Australia', 'Beverage'),
    (r'OCEANI[AC]\s*[-–]\s*AUSTRALIAN MAIN','Oceania', 'Australia', 'Main Course'),
    (r'AUSTRALIAN DESSERTS?',                'Oceania', 'Australia', 'Dessert'),
    (r'AUSTRALIAN BEVERAGES?',               'Oceania', 'Australia', 'Beverage'),
    # NEW ZEALAND
    (r'NEW ZEALAND\s*[-–]\s*MAIN',          'Oceania', 'New Zealand', 'Main Course'),
    (r'NEW ZEALAND\s*[-–]\s*DESSERTS?',     'Oceania', 'New Zealand', 'Dessert'),
    (r'NEW ZEALAND\s*[-–]\s*BEVERAGES?',    'Oceania', 'New Zealand', 'Beverage'),
    # FIJI
    (r'FIJI\s*[-–]\s*MAIN',                 'Oceania', 'Fiji', 'Main Course'),
    (r'FIJI\s*[-–]\s*DESSERTS?',            'Oceania', 'Fiji', 'Dessert'),
    (r'FIJI\s*[-–]\s*BEVERAGES?',           'Oceania', 'Fiji', 'Beverage'),
    # FRANCE
    (r'FRANCE\s*[-–]\s*MAIN',               'European', 'France', 'Main Course'),
    (r'FRANCE\s*[-–]\s*DESSERTS?',          'European', 'France', 'Dessert'),
    (r'FRANCE\s*[-–]\s*BEVERAGES?',         'European', 'France', 'Beverage'),
    (r'FRENCH MAIN',                         'European', 'France', 'Main Course'),
    (r'FRENCH DESSERTS?',                    'European', 'France', 'Dessert'),
    (r'FRENCH BEVERAGES?',                   'European', 'France', 'Beverage'),
    # GERMANY
    (r'GERMAN[Y]?\s*[-–]\s*MAIN',           'European', 'Germany', 'Main Course'),
    (r'GERMAN[Y]?\s*[-–]\s*DESSERTS?',      'European', 'Germany', 'Dessert'),
    (r'GERMAN[Y]?\s*[-–]\s*BEVERAGES?',     'European', 'Germany', 'Beverage'),
    (r'GERMAN MAIN',                         'European', 'Germany', 'Main Course'),
    (r'GERMAN DESSERTS?',                    'European', 'Germany', 'Dessert'),
    (r'GERMAN BEVERAGES?',                   'European', 'Germany', 'Beverage'),
    # ITALY
    (r'ITAL[YI]\s*[-–]\s*MAIN',             'European', 'Italy', 'Main Course'),
    (r'ITAL[YI]\s*[-–]\s*DESSERTS?',        'European', 'Italy', 'Dessert'),
    (r'ITAL[YI]\s*[-–]\s*BEVERAGES?',       'European', 'Italy', 'Beverage'),
    (r'ITALIAN MAIN',                        'European', 'Italy', 'Main Course'),
    (r'ITALIAN DESSERTS?',                   'European', 'Italy', 'Dessert'),
    (r'ITALIAN BEVERAGES?',                  'European', 'Italy', 'Beverage'),
    # CANADA
    (r'CANADA\s*[-–]\s*MAIN',               'North American', 'Canada', 'Main Course'),
    (r'CANADA\s*[-–]\s*DESSERTS?',          'North American', 'Canada', 'Dessert'),
    (r'CANADA\s*[-–]\s*BEVERAGES?',         'North American', 'Canada', 'Beverage'),
    (r'CANADIAN MAIN',                       'North American', 'Canada', 'Main Course'),
    (r'CANADIAN DESSERTS?',                  'North American', 'Canada', 'Dessert'),
    (r'CANADIAN BEVERAGES?',                 'North American', 'Canada', 'Beverage'),
    # UNITED STATES
    (r'UNITED STATES?\s*[-–]\s*MAIN',       'North American', 'United States', 'Main Course'),
    (r'UNITED STATES?\s*[-–]\s*DESSERTS?',  'North American', 'United States', 'Dessert'),
    (r'UNITED STATES?\s*[-–]\s*BEVERAGES?', 'North American', 'United States', 'Beverage'),
    (r'AMERICAN MAIN',                       'North American', 'United States', 'Main Course'),
    (r'AMERICAN DESSERTS?',                  'North American', 'United States', 'Dessert'),
    (r'AMERICAN BEVERAGES?',                 'North American', 'United States', 'Beverage'),
    # MEXICO
    (r'MEXICO\s*[-–]\s*MAIN',               'North American', 'Mexico', 'Main Course'),
    (r'MEXICO\s*[-–]\s*DESSERTS?',          'North American', 'Mexico', 'Dessert'),
    (r'MEXICO\s*[-–]\s*BEVERAGES?',         'North American', 'Mexico', 'Beverage'),
    (r'MEXICAN MAIN',                        'North American', 'Mexico', 'Main Course'),
    (r'MEXICAN DESSERTS?',                   'North American', 'Mexico', 'Dessert'),
    (r'MEXICAN BEVERAGES?',                  'North American', 'Mexico', 'Beverage'),
    # BRAZIL
    (r'BRAZIL\s*[-–]\s*MAIN',               'South American', 'Brazil', 'Main Course'),
    (r'BRAZIL\s*[-–]\s*DESSERTS?',          'South American', 'Brazil', 'Dessert'),
    (r'BRAZIL\s*[-–]\s*BEVERAGES?',         'South American', 'Brazil', 'Beverage'),
    (r'BRAZILIAN MAIN',                      'South American', 'Brazil', 'Main Course'),
    (r'BRAZILIAN DESSERTS?',                 'South American', 'Brazil', 'Dessert'),
    (r'BRAZILIAN BEVERAGES?',                'South American', 'Brazil', 'Beverage'),
    # ARGENTINA
    (r'ARGENTINA\s*[-–]\s*MAIN',            'South American', 'Argentina', 'Main Course'),
    (r'ARGENTINA\s*[-–]\s*DESSERTS?',       'South American', 'Argentina', 'Dessert'),
    (r'ARGENTINA\s*[-–]\s*BEVERAGES?',      'South American', 'Argentina', 'Beverage'),
    (r'ARGENTIN[AE] MAIN',                  'South American', 'Argentina', 'Main Course'),
    (r'ARGENTIN[AE] DESSERTS?',             'South American', 'Argentina', 'Dessert'),
    (r'ARGENTIN[AE] BEVERAGES?',            'South American', 'Argentina', 'Beverage'),
    # CHILE
    (r'CHILE\s*[-–]\s*MAIN',                'South American', 'Chile', 'Main Course'),
    (r'CHILE\s*[-–]\s*DESSERTS?',           'South American', 'Chile', 'Dessert'),
    (r'CHILE\s*[-–]\s*BEVERAGES?',          'South American', 'Chile', 'Beverage'),
    (r'CHILEAN MAIN',                        'South American', 'Chile', 'Main Course'),
    (r'CHILEAN DESSERTS?',                   'South American', 'Chile', 'Dessert'),
    (r'CHILEAN BEVERAGES?',                  'South American', 'Chile', 'Beverage'),
]

# ── Difficulty heuristics ──────────────────────────────────────────────────────
def guess_difficulty(steps):
    n = len(steps)
    if n <= 5:
        return 'Easy'
    elif n <= 7:
        return 'Medium'
    return 'Hard'

# ── Parser ─────────────────────────────────────────────────────────────────────
import re

# Helper to identify if a numbered line is structurally an instruction step rather than a title
def is_cooking_step(text):
    text_upper = text.upper().strip()
    if not text_upper:
        return False
    
    # Common imperative cooking action verbs
    verbs = {
        'ADD', 'PLACE', 'MIX', 'BAKE', 'COMBINE', 'HEAT', 'POUR', 'ALLOW', 
        'COOK', 'STIR', 'FRY', 'WHISK', 'GARNISH', 'BLEND', 'BRING', 'SIMMER', 
        'CHOP', 'PUT', 'TRANSFER', 'ARRANGE', 'PREHEAT', 'SEASON', 'DICE', 
        'SLICE', 'SPOON', 'SPRINKLE', 'SERVE', 'SQUEEZE', 'WHIP', 'BOIL',
        'DRAIN', 'RINSE', 'REMOVE', 'COVER', 'REDUCE', 'LET', 'MELT', 'TOAST',
        'FLATTEN', 'ROLL', 'SHAPE', 'DROP', 'GRILL', 'ROAST', 'GRATE'
    }
    
    words = text_upper.split()
    if not words:
        return False
    
    # Extract the first word and clear punctuation marks
    first_word = ''.join(c for c in words[0] if c.isalnum())
    if first_word in verbs:
        return True
    
    # Fallback step keywords or structural sentence indicators
    step_keywords = ['MINUTES', 'MINS', 'HOURS', 'UNTIL', 'OVEN', 'BOWL', 'PAN', 'SKILLET', 'MEDIUM HEAT', 'LOW HEAT', 'HIGH HEAT', 'TO ROOM TEMPERATURE']
    if any(kw in text_upper for kw in step_keywords):
        return True
        
    if len(words) > 7 and (text.strip().endswith('.') or text.strip().endswith(';')):
        return True
        
    return False

# Fallback clean title generator if a text block entirely omitted a name heading
def clean_instruction_title(text):
    text_lower = text.lower()
    if 'avocado' in text_lower: return 'Avocado Smoothie'
    if 'tea' in text_lower: return 'Traditional Tea'
    if 'sausage' in text_lower: return 'Grilled Sausages'
    if 'sugar' in text_lower: return 'Sweet Beverage'
    if 'pastry' in text_lower or 'ali' in text_lower: return 'Umm Ali (Dessert)'
    
    words = text.split()
    if len(words) > 3:
        return ' '.join(words[:3]).title() + '...'
    return text.title()

# ── Main Parser ────────────────────────────────────────────────────────────────
def parse_recipes(filepath):
    with open(filepath, encoding='utf-8') as f:
        text = f.read()

    lines = text.splitlines()
    recipes = []

    current_section = {'cuisine': None, 'region': None, 'category': None}
    current_recipe = None
    mode = None

    title_re = re.compile(r'^\s*\d+[\.\)]\s*(.+)')

    for idx, line in enumerate(lines):
        cleaned = line.strip()
        if not cleaned:
            continue

        # 1. Section Header Detection
        upper_line = cleaned.upper()
        is_sec = False
        for pattern, cuisine, region, category in SECTION_MAP:
            if re.search(pattern, upper_line):
                current_section = {'cuisine': cuisine, 'region': region, 'category': category}
                is_sec = True
                break
        if is_sec:
            continue

        # 2. Section Mode Boundary Switches
        if 'INGREDIENT' in upper_line:
            mode = 'ingredients'
            continue
        if any(h in upper_line for h in ['PROCEDURE', 'INSTRUCTION', 'DIRECTION', 'METHOD', 'PREPARATION']):
            mode = 'steps'
            continue

        # 3. Numbered Line Rules (Title vs Step Selection)
        m = title_re.match(cleaned)
        if m:
            content = m.group(1).strip()
            
            if is_cooking_step(content):
                # Look ahead briefly to see if this instruction line sits before an ingredient list (missing title case)
                is_block_start = False
                for k in range(idx + 1, min(idx + 5, len(lines))):
                    nxt = lines[k].strip()
                    if not nxt: continue
                    if 'INGREDIENT' in nxt.upper() or nxt.startswith('*'):
                        is_block_start = True
                        break
                    if title_re.match(nxt) or any(re.search(pat, nxt.upper()) for pat, _, _, _ in SECTION_MAP):
                        break
                
                if is_block_start:
                    if current_recipe:
                        recipes.append(current_recipe)
                    current_recipe = {
                        'title':       clean_instruction_title(content),
                        'description': '',
                        'cuisine':     current_section['cuisine'],
                        'region':      current_section['region'],
                        'category':    current_section['category'],
                        'difficulty':  'Medium',
                        'prep_time':   15,
                        'cook_time':   30,
                        'ingredients': [],
                        'steps':       [re.sub(r'^\d+[\.\)]\s*', '', content).strip()],
                    }
                    mode = 'steps'
                else:
                    # Cleanly funnel this straight into the ongoing recipe step list
                    step_text = re.sub(r'^\d+[\.\)]\s*', '', content).strip()
                    if current_recipe:
                        current_recipe['steps'].append(step_text)
                        mode = 'steps'
            else:
                # Valid explicit new recipe layout detected
                if current_recipe:
                    recipes.append(current_recipe)
                
                if ' - ' in content:
                    title, description = content.split(' - ', 1)
                elif ' – ' in content:
                    title, description = content.split(' – ', 1)
                else:
                    title = content
                    description = ''

                current_recipe = {
                    'title':       title.strip().rstrip('.'),
                    'description': description.strip(),
                    'cuisine':     current_section['cuisine'],
                    'region':      current_section['region'],
                    'category':    current_section['category'],
                    'difficulty':  'Easy',
                    'prep_time':   15,
                    'cook_time':   30,
                    'ingredients': [],
                    'steps':       [],
                }
                mode = None
            continue

        # 4. Standard Line Data Extraction
        if cleaned.startswith('*'):
            ing = cleaned.lstrip('* ').strip()
            if ing and current_recipe:
                current_recipe['ingredients'].append(ing)
                mode = 'ingredients'
        elif mode == 'steps':
            if current_recipe:
                current_recipe['steps'].append(cleaned)
        elif mode == 'ingredients' or mode is None:
            if current_recipe and not current_recipe['ingredients'] and not current_recipe['steps']:
                if current_recipe['description']:
                    current_recipe['description'] += " " + cleaned
                else:
                    current_recipe['description'] = cleaned

    # Save the final open recipe element
    if current_recipe:
        recipes.append(current_recipe)

    # Re-evaluate visual difficulty tags based on the final total steps
    for r in recipes:
        r['difficulty'] = guess_difficulty(r['steps'])

    return recipes

# ── Inserter ───────────────────────────────────────────────────────────────────
def insert_recipes(recipes):
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    inserted = 0
    skipped  = 0

    for r in recipes:
        # Skip duplicates by title
        cur.execute("SELECT id FROM recipes WHERE title = %s", (r['title'],))
        if cur.fetchone():
            print(f"  ⏭  Skipping duplicate: {r['title']}")
            skipped += 1
            continue

        # Insert recipe
        cur.execute('''
            INSERT INTO recipes
              (title, description, cuisine, region, category, difficulty, prep_time, cook_time)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id
        ''', (
            r['title'], r['description'], r['cuisine'], r['region'],
            r['category'], r['difficulty'], r['prep_time'], r['cook_time']
        ))
        recipe_id = cur.fetchone()[0]

        # Insert ingredients
        for ing in r['ingredients']:
            cur.execute(
                'INSERT INTO ingredients (recipe_id, name, quantity) VALUES (%s, %s, %s)',
                (recipe_id, ing, '')
            )

        # Insert steps
        for idx, step in enumerate(r['steps'], start=1):
            cur.execute(
                'INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)',
                (recipe_id, idx, step)
            )

        print(f"  ✅ Inserted: {r['title']} ({r['cuisine']} / {r['region']} / {r['category']})")
        inserted += 1

    conn.commit()
    cur.close()
    conn.close()
    return inserted, skipped

# ── Main ───────────────────────────────────────────────────────────────────────
if __name__ == '__main__':
    # Path to the text file — put it in the same folder as this script
    FILE = os.path.join(os.path.dirname(__file__), 'Cooking_Application_Drafts__1_.txt')

    if not os.path.exists(FILE):
        print(f"❌ File not found: {FILE}")
        print("   Make sure 'Cooking_Application_Drafts__1_.txt' is in the same folder as this script.")
        exit(1)

    print("📖 Parsing recipes from text file...")
    recipes = parse_recipes(FILE)
    print(f"   Found {len(recipes)} recipes.\n")

    print("💾 Inserting into PostgreSQL...")
    inserted, skipped = insert_recipes(recipes)

    print(f"\n🎉 Done!")
    print(f"   Inserted : {inserted}")
    print(f"   Skipped  : {skipped} (duplicates)")