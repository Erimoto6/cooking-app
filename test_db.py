import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

print("Trying to connect...")
try:
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432'),
        dbname=os.getenv('DB_NAME', 'dishlydb'),
        user=os.getenv('DB_USER', 'dishly'),
        password=os.getenv('DB_PASSWORD', 'Dishly2026')
    )
    print("✅ Connected successfully!")
    conn.close()
except Exception as e:
    print(f"❌ Error: {e}")