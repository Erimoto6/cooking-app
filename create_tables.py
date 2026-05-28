# create_tables.py
from app import app
from database import init_db

print("Creating database tables...")
with app.app_context():
    init_db()
print("✅ Tables created successfully!")
print("Tables: users, recipes, ingredients, steps, shopping_list, favorites, recipe_folders, voice_command")