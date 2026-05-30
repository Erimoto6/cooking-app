import psycopg2
import os

# This will run on Railway's server
database_url = os.environ.get('DATABASE_URL')
print(f"Connecting to: {database_url[:30]}...")

conn = psycopg2.connect(database_url)
cur = conn.cursor()
cur.execute('SELECT DISTINCT cuisine FROM recipes')
cuisines = cur.fetchall()

print('Cuisines in database:')
for c in cuisines:
    print(f'  - {c[0]}')

conn.close()