import psycopg2
import psycopg2.extras
from flask import g
import os
import hashlib
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host':     os.getenv('DB_HOST', 'localhost'),
    'port':     os.getenv('DB_PORT', '5432'),
    'dbname':   os.getenv('DB_NAME', 'dishlydb'),
    'user':     os.getenv('DB_USER', 'dishly'),
    'password': os.getenv('DB_PASSWORD', ''),
}

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = psycopg2.connect(**DB_CONFIG)
    return db

def close_db(e=None):
    db = g.pop('_database', None)
    if db is not None:
        db.close()

def query(sql, args=(), one=False):
    """Helper: run a SELECT and return dict rows."""
    cur = get_db().cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute(sql, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

def execute(sql, args=()):
    """Helper: run INSERT/UPDATE/DELETE and commit."""
    db = get_db()
    cur = db.cursor()
    cur.execute(sql, args)
    db.commit()
    cur.close()

def execute_returning(sql, args=()):
    """Helper: run INSERT ... RETURNING id and return the id."""
    db = get_db()
    cur = db.cursor()
    cur.execute(sql, args)
    row = cur.fetchone()
    db.commit()
    cur.close()
    return row[0] if row else None

def init_db():
    db = get_db()
    cursor = db.cursor()

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            username TEXT UNIQUE NOT NULL,
            phone_number TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS recipes (
            id SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            cuisine TEXT,
            region TEXT,
            category TEXT,
            prep_time INTEGER,
            cook_time INTEGER,
            difficulty TEXT,
            image_url TEXT,
            user_id INTEGER REFERENCES users(id),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS ingredients (
            id SERIAL PRIMARY KEY,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            name TEXT NOT NULL,
            quantity TEXT
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS steps (
            id SERIAL PRIMARY KEY,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            step_number INTEGER,
            instruction TEXT NOT NULL
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS shopping_list (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            ingredient_name TEXT NOT NULL,
            quantity TEXT,
            checked BOOLEAN DEFAULT FALSE,
            recipe_id INTEGER,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (user_id, recipe_id)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS recipe_folders (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            folder_name TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS voice_command (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            command TEXT NOT NULL,
            action TEXT,
            recipe_id INTEGER REFERENCES recipes(id),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    # Demo user
    cursor.execute("SELECT COUNT(*) FROM users")
    if cursor.fetchone()[0] == 0:
        demo_password = hashlib.sha256('password123'.encode()).hexdigest()
        cursor.execute(
            "INSERT INTO users (username, phone_number, password) VALUES (%s, %s, %s) RETURNING id",
            ('demo_user', '1234567890', demo_password)
        )
        user_id = cursor.fetchone()[0]
        for folder in ['For Breakfast', 'For Dinner', 'Quick Meals']:
            cursor.execute(
                'INSERT INTO recipe_folders (user_id, folder_name) VALUES (%s, %s)',
                (user_id, folder)
            )

    db.commit()
    print("✅ PostgreSQL database initialized!")

def get_recipe_by_id(recipe_id):
    recipe = query('SELECT * FROM recipes WHERE id = %s', (recipe_id,), one=True)
    if not recipe:
        return {
            'id': recipe_id, 'title': 'Recipe Not Found', 'description': '',
            'prep_time': 0, 'cook_time': 0, 'difficulty': 'Unknown',
            'region': 'Unknown', 'cuisine': '', 'image_url': '',
            'ingredients': [], 'steps': []
        }
    recipe = dict(recipe)
    recipe['ingredients'] = query(
        'SELECT * FROM ingredients WHERE recipe_id = %s', (recipe_id,))
    recipe['steps'] = query(
        'SELECT * FROM steps WHERE recipe_id = %s ORDER BY step_number', (recipe_id,))
    return recipe