# test_db.py
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

print("=== Testing Database Connection ===")
print(f"DB_NAME: {os.getenv('DB_NAME')}")
print(f"DB_USER: {os.getenv('DB_USER')}")
print(f"DB_HOST: {os.getenv('DB_HOST')}")
print(f"DB_PORT: {os.getenv('DB_PORT')}")

try:
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST'),
        port=os.getenv('DB_PORT'),
        dbname=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD')
    )
    
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM recipes")
    count = cur.fetchone()[0]
    print(f"\n✅ Connected successfully!")
    print(f"📊 Total recipes in database: {count}")
    
    cur.execute("SELECT id, title, dish_id FROM recipes LIMIT 3")
    rows = cur.fetchall()
    print("\n📋 Sample recipes:")
    for row in rows:
        print(f"  ID: {row[0]} | Title: {row[1]} | dish_id: {row[2]}")
    
    cur.close()
    conn.close()
    
except Exception as e:
    print(f"\n❌ Error: {e}")