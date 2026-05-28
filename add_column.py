import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432'),
    dbname=os.getenv('DB_NAME', 'dishlydb'),
    user=os.getenv('DB_USER', 'dishly'),
    password=os.getenv('DB_PASSWORD', '')
)

cur = conn.cursor()

try:
    cur.execute('ALTER TABLE recipes ADD COLUMN dish_id VARCHAR(20) UNIQUE;')
    conn.commit()
    print('✅ Added dish_id column to recipes table')
except Exception as e:
    if 'duplicate column' in str(e).lower():
        print('⚠️ dish_id column already exists')
    else:
        print(f'Error: {e}')

cur.close()
conn.close()