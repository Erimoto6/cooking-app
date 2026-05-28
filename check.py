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
cur.execute("SELECT cuisine, region, COUNT(*) FROM recipes GROUP BY cuisine, region ORDER BY cuisine, region")

for row in cur.fetchall():
    print(f"{row[0]} - {row[1]}: {row[2]} recipes")

cur.close()
conn.close()py 