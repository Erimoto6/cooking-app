import sqlite3
from datetime import datetime
from flask import g
import os
import sys

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
    
    # Insert demo user if no users exist
    cursor.execute("SELECT COUNT(*) as count FROM users")
    if cursor.fetchone()['count'] == 0:
        cursor.execute('''
            INSERT INTO users (username, phone_number, password) 
            VALUES (?, ?, ?)
        ''', ('demo_user', '1234567890', 'password123'))
        
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