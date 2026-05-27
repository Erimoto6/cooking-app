import sqlite3
from datetime import datetime
from flask import g
import os
import sys
import hashlib

# Get the correct path whether running as script or EXE
if getattr(sys, 'frozen', False):
    BASE_DIR = os.path.dirname(sys.executable)
else:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))

INSTANCE_FOLDER = os.path.join(BASE_DIR, 'instance')
DATABASE = os.path.join(INSTANCE_FOLDER, 'recipes.db')

# Ensure instance folder exists
os.makedirs(INSTANCE_FOLDER, exist_ok=True)

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        db.row_factory = sqlite3.Row
    return db

def init_db():
    """Initialize database with all tables"""
    db = get_db()
    cursor = db.cursor()
    
    # Users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            phone_number TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Recipes table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS recipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            cuisine TEXT,
            region TEXT,
            category TEXT,
            prep_time INTEGER,
            cook_time INTEGER,
            difficulty TEXT,
            image_url TEXT,
            user_id INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    # Ingredients table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS ingredients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER,
            name TEXT NOT NULL,
            quantity TEXT,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
        )
    ''')
    
    # Steps table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER,
            step_number INTEGER,
            instruction TEXT NOT NULL,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
        )
    ''')
    
    # Shopping list table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS shopping_list (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            ingredient_name TEXT NOT NULL,
            quantity TEXT,
            checked BOOLEAN DEFAULT 0,
            recipe_id INTEGER,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
    ''')
    
    # Favorites table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
            user_id INTEGER,
            recipe_id INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE,
            PRIMARY KEY (user_id, recipe_id)
        )
    ''')
    
    # Recipe folders table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS recipe_folders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            folder_name TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
    ''')

    # Voice commands table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS voice_command (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            command TEXT NOT NULL,
            action TEXT,
            recipe_id INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id)
        )
    ''')
    
    # Insert demo user if no users exist
    cursor.execute("SELECT COUNT(*) as count FROM users")
    if cursor.fetchone()['count'] == 0:
        demo_password = hashlib.sha256('password123'.encode()).hexdigest()
        cursor.execute('''
            INSERT INTO users (username, phone_number, password) 
            VALUES (?, ?, ?)
        ''', ('demo_user', '1234567890', demo_password))
        
        # Get the user ID
        cursor.execute("SELECT id FROM users WHERE username = 'demo_user'")
        user_id = cursor.fetchone()['id']
        
        # Create default folders
        for folder in ['For Breakfast', 'For Dinner', 'Quick Meals']:
            cursor.execute('INSERT INTO recipe_folders (user_id, folder_name) VALUES (?, ?)',
                          (user_id, folder))
    
    db.commit()
    print(f"✅ Database initialized at: {DATABASE}")

# Rest of your database functions here...
# (keep all your existing query functions like get_all_recipes, etc.)

def close_db(e=None):
    db = g.pop('_database', None)
    if db is not None:
        db.close()

def get_recipe_by_id(recipe_id):
    """
    Safely fetches a single recipe and its nested ingredients and steps 
    from the database, adapting dynamically to table structures.
    """
    db = get_db()
    # Force sqlite to return dictionary-like rows instead of tuples
    db.row_factory = sqlite3.Row
    cursor = db.cursor()
    
    # 1. Fetch the main recipe row
    cursor.execute('SELECT * FROM recipes WHERE id = ?', (recipe_id,))
    recipe_row = cursor.fetchone()
    
    if not recipe_row:
        # Prevent Jinja template crashes by returning a safe fallback dictionary
        return {
            'id': recipe_id, 'title': 'Recipe Not Found', 'description': 'This recipe does not exist.',
            'prep_time': 0, 'cook_time': 0, 'difficulty': 'Unknown',
            'region': 'Unknown', 'cuisine': '', 'image_url': '',
            'ingredients': [], 'steps': []
        }
    
    # Convert row object to a standard mutable Python dictionary
    recipe = dict(recipe_row)
    
    # 2. Fetch Ingredients safely
    try:
        cursor.execute('SELECT * FROM ingredients WHERE recipe_id = ?', (recipe_id,))
        recipe['ingredients'] = [dict(row) for row in cursor.fetchall()]
    except Exception as e:
        print(f" Voice-Assistant Database Warning (ingredients): {e}")
        recipe['ingredients'] = []
        
    # 3. Fetch Steps safely with smart schema adaptation
    try:
        # Check what columns exist in your steps table so we don't guess wrong
        cursor.execute("PRAGMA table_info(steps)")
        columns = [col['name'] for col in cursor.fetchall()]
        
        # Determine the correct column names based on your schema
        step_num_col = 'step_number' if 'step_number' in columns else ('step_no' if 'step_no' in columns else 'id')
        instruction_col = 'instruction' if 'instruction' in columns else ('description' if 'description' in columns else 'text')
        
        # Run a safe query using your actual columns, renaming them for the UI template
        query = f"SELECT {step_num_col} AS step_number, {instruction_col} AS instruction FROM steps WHERE recipe_id = ?"
        
        # If there's an ordering column, use it
        if 'step_number' in columns or 'step_no' in columns:
            query += f" ORDER BY {step_num_col}"
            
        cursor.execute(query, (recipe_id,))
        recipe['steps'] = [dict(row) for row in cursor.fetchall()]
        
    except Exception as e:
        print(f" Voice-Assistant Database Error (steps): {e}")
        recipe['steps'] = []
            
    return recipe