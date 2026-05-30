# init_db.py
from app import app
from database import init_db

with app.app_context():
    init_db()
    print("✅ Database tables created successfully!")
    print("Tables created: users, recipes, ingredients, steps, shopping_list, favorites, recipe_folders, voice_command")

