import psycopg2
import psycopg2.extras
from flask import g
import os
from dotenv import load_dotenv

load_dotenv()

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        # Get database URL from environment (Railway sets this automatically)
        database_url = os.environ.get('DATABASE_URL')
        
        if not database_url:
            raise Exception("DATABASE_URL environment variable not set!")
        
        print(f"Connecting to database...")
        db = g._database = psycopg2.connect(database_url)
        print("Database connected successfully!")
        
    return db

def get_cursor():
    return get_db().cursor(cursor_factory=psycopg2.extras.RealDictCursor)

def close_db(e=None):
    db = g.pop('_database', None)
    if db is not None:
        db.close()

def query(sql, args=(), one=False):
    cur = get_cursor()
    cur.execute(sql, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

def execute(sql, args=()):
    db = get_db()
    cur = db.cursor()
    cur.execute(sql, args)
    db.commit()
    cur.close()

def execute_returning(sql, args=()):
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
            dish_id VARCHAR(20) UNIQUE,
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

    db.commit()
    print("✅ PostgreSQL database initialized!")

def get_recipe_by_dish_id(dish_id):
    recipe = query('SELECT * FROM recipes WHERE dish_id = %s', (dish_id,), one=True)
    if not recipe:
        return None
    recipe = dict(recipe)
    recipe['ingredients'] = query('SELECT * FROM ingredients WHERE recipe_id = %s', (recipe['id'],))
    recipe['steps'] = query('SELECT * FROM steps WHERE recipe_id = %s ORDER BY step_number', (recipe['id'],))
    return recipe

def get_recipe_by_id(recipe_id):
    recipe = query('SELECT * FROM recipes WHERE id = %s', (recipe_id,), one=True)
    if not recipe:
        return None
    recipe = dict(recipe)
    recipe['ingredients'] = query('SELECT * FROM ingredients WHERE recipe_id = %s', (recipe_id,))
    recipe['steps'] = query('SELECT * FROM steps WHERE recipe_id = %s ORDER BY step_number', (recipe_id,))
    return recipe

def search_recipes(q='', category='', cuisine='', region=''):
    conditions = []
    params = []

    if q:
        conditions.append("(title ILIKE %s OR cuisine ILIKE %s OR region ILIKE %s OR dish_id ILIKE %s)")
        params += [f'%{q}%', f'%{q}%', f'%{q}%', f'%{q}%']
    if category:
        conditions.append("category ILIKE %s")
        params.append(f'%{category}%')
    if cuisine:
        conditions.append("cuisine ILIKE %s")
        params.append(f'%{cuisine}%')
    if region:
        conditions.append("region ILIKE %s")
        params.append(f'%{region}%')

    where = "WHERE " + " AND ".join(conditions) if conditions else ""
    sql = f"SELECT * FROM recipes {where} ORDER BY title"
    return query(sql, params)