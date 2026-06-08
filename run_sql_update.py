import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

# Use your actual credentials from .env
conn = psycopg2.connect(
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432'),
    dbname=os.getenv('DB_NAME', 'dishlydb'),
    user=os.getenv('DB_USER', 'postgres'),
    password=os.getenv('DB_PASSWORD', 'haikyuu321')
)
cur = conn.cursor()

# Read the SQL file
try:
    with open('update_images.sql', 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    # Split into individual statements
    statements = [s.strip() for s in sql_content.split(';') if s.strip() and not s.strip().startswith('--')]
    
    print(f"Found {len(statements)} SQL statements to execute")
    print("=" * 50)
    
    executed = 0
    for statement in statements:
        try:
            cur.execute(statement)
            executed += 1
            if executed % 100 == 0:
                print(f"✅ Executed {executed} statements...")
        except Exception as e:
            print(f"❌ Error: {e[:100]}")
    
    conn.commit()
    print("=" * 50)
    print(f"✅ Successfully executed {executed} statements!")
    
except FileNotFoundError:
    print("❌ update_images.sql not found. Run generate_image_sql.py first.")
    
cur.close()
conn.close()