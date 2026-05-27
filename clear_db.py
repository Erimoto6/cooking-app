import psycopg2
from import_recipes import DB_CONFIG

print("Wiping out old recipe data...")
try:
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    # This deletes all data in recipes and cleans up ingredients/steps tied to them
    cur.execute("TRUNCATE recipes CASCADE;")
    
    conn.commit()
    cur.close()
    conn.close()
    print("✨ Database successfully cleared!")
except Exception as e:
    print(f"❌ Error clearing database: {e}")