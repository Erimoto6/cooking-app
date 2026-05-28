import psycopg2
from database import DB_CONFIG

def run_migration():
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True
        cur = conn.cursor()
        
        migrations = [
            """
            CREATE TABLE IF NOT EXISTS recent_views (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
                viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """,
            """
            CREATE INDEX IF NOT EXISTS idx_recent_views_user_id ON recent_views(user_id)
            """,
            """
            CREATE TABLE IF NOT EXISTS recipe_folders (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                name VARCHAR(100) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """,
            """
            CREATE TABLE IF NOT EXISTS folder_recipes (
                id SERIAL PRIMARY KEY,
                folder_id INTEGER REFERENCES recipe_folders(id) ON DELETE CASCADE,
                recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(folder_id, recipe_id)
            )
            """,
            """
            CREATE INDEX IF NOT EXISTS idx_folder_recipes_folder_id ON folder_recipes(folder_id)
            """,
            """
            CREATE INDEX IF NOT EXISTS idx_folder_recipes_recipe_id ON folder_recipes(recipe_id)
            """
        ]
        
        for sql in migrations:
            print(f"Running: {sql[:50]}...")
            cur.execute(sql)
            print("  ✓ Done")
        
        print("\n✅ All migrations completed!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    run_migration()