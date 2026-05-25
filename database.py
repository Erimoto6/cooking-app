import sqlite3
from datetime import datetime
from flask import g
import os

DATABASE = os.path.join(os.path.dirname(__file__), 'instance', 'recipes.db')

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        db.row_factory = sqlite3.Row
    return db

def init_db():
    """Initialize database with all tables and sample data"""
    db = get_db()
    cursor = db.cursor()
    
    # Users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            phone_number TEXT UNIQUE,
            password TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Recipes table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS recipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            cuisine TEXT,
            region TEXT,
            category TEXT,
            prep_time INTEGER,
            cook_time INTEGER,
            difficulty TEXT,
            image_url TEXT,
            user_id INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    # Ingredients table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS ingredients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER,
            name TEXT NOT NULL,
            quantity TEXT,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id)
        )
    ''')
    
    # Procedure steps table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER,
            step_number INTEGER,
            instruction TEXT NOT NULL,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id)
        )
    ''')
    
    # Shopping list table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS shopping_list (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            ingredient_name TEXT NOT NULL,
            quantity TEXT,
            checked BOOLEAN DEFAULT 0,
            recipe_id INTEGER,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    # User favorites
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
            user_id INTEGER,
            recipe_id INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (recipe_id) REFERENCES recipes (id),
            PRIMARY KEY (user_id, recipe_id)
        )
    ''')
    
    # User's custom recipes folder (for "Your Recipe Folder")
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS recipe_folders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            folder_name TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    # Recipe-folder association
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS folder_recipes (
            folder_id INTEGER,
            recipe_id INTEGER,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (folder_id) REFERENCES recipe_folders (id),
            FOREIGN KEY (recipe_id) REFERENCES recipes (id)
        )
    ''')
    
    # Insert sample data
    insert_sample_users(cursor)
    insert_sample_recipes(cursor)
    insert_sample_folders(cursor)
    
    db.commit()
    print("✅ Database initialized with all recipes!")

def insert_sample_users(cursor):
    """Insert demo user"""
    cursor.execute("SELECT * FROM users WHERE username = 'cook_user'")
    if not cursor.fetchone():
        cursor.execute('''
            INSERT INTO users (username, phone_number, password) 
            VALUES (?, ?, ?)
        ''', ('cook_user', '1234567890', 'password123'))

def insert_sample_folders(cursor):
    """Create recipe folders for user"""
    cursor.execute("SELECT id FROM users WHERE username = 'cook_user'")
    user = cursor.fetchone()
    if user:
        user_id = user['id']
        
        # Check if folders exist
        cursor.execute("SELECT * FROM recipe_folders WHERE user_id = ? AND folder_name = ?", 
                      (user_id, 'For Breakfast'))
        if not cursor.fetchone():
            cursor.execute('INSERT INTO recipe_folders (user_id, folder_name) VALUES (?, ?)',
                          (user_id, 'For Breakfast'))
            cursor.execute('INSERT INTO recipe_folders (user_id, folder_name) VALUES (?, ?)',
                          (user_id, 'For Dinner'))

def insert_sample_recipes(cursor):
    """Insert all recipes from your UI designs"""
    
    # Get user id
    cursor.execute("SELECT id FROM users WHERE username = 'cook_user'")
    user = cursor.fetchone()
    user_id = user['id'] if user else 1
    
    # Complete recipe database from your UI
    recipes_data = [
        # African Cuisine
        ('Jollof Rice', 'West African rice dish cooked in tomato sauce', 'African', 'Nigeria', 'Main', 15, 45, 'Medium', '🍚', user_id),
        ('Egusi Soup', 'Nigerian melon seed soup with vegetables', 'African', 'Nigeria', 'Soup', 20, 60, 'Hard', '🥣', user_id),
        ('Ful Medames', 'Egyptian fava bean stew', 'African', 'Egypt', 'Breakfast', 10, 120, 'Easy', '🫘', user_id),
        ('Koshari', 'Egyptian rice, lentils, and pasta', 'African', 'Egypt', 'Main', 20, 45, 'Medium', '🍲', user_id),
        ('Biltong', 'South African dried cured meat', 'African', 'South Africa', 'Snack', 15, 720, 'Medium', '🥩', user_id),
        ('Bobotie', 'South African spiced meat bake', 'African', 'South Africa', 'Main', 20, 60, 'Medium', '🍲', user_id),
        
        # Asian - China
        ('Dumpling', 'Chinese pork and cabbage dumplings', 'Asian', 'China', 'Appetizer', 30, 20, 'Medium', '🥟', user_id),
        ('Kung Pao Chicken', 'Spicy stir-fried chicken with peanuts', 'Asian', 'China', 'Main', 15, 20, 'Medium', '🍗', user_id),
        ('Peking Duck', 'Crispy duck with pancakes', 'Asian', 'China', 'Main', 60, 120, 'Hard', '🦆', user_id),
        
        # Asian - India
        ('Biryani', 'Fragrant rice with spiced meat', 'Asian', 'India', 'Main', 30, 60, 'Hard', '🍛', user_id),
        ('Butter Chicken', 'Creamy tomato chicken curry', 'Asian', 'India', 'Main', 20, 40, 'Medium', '🍗', user_id),
        ('Masala Dosa', 'Crispy fermented crepe with potato filling', 'Asian', 'India', 'Breakfast', 180, 30, 'Hard', '🌯', user_id),
        
        # Asian - Japan
        ('Ramen', 'Japanese noodle soup with pork broth', 'Asian', 'Japan', 'Soup', 30, 120, 'Hard', '🍜', user_id),
        ('Sushi', 'Vinegared rice with fresh fish', 'Asian', 'Japan', 'Main', 45, 30, 'Hard', '🍱', user_id),
        ('Teppanyaki', 'Japanese grilled meat and vegetables', 'Asian', 'Japan', 'Main', 20, 30, 'Medium', '🥩', user_id),
        
        # Asian - Philippines
        ('Adobo', 'Filipino chicken and pork stew', 'Asian', 'Philippines', 'Main', 10, 60, 'Easy', '🍗', user_id),
        ('Sinigang na Baboy', 'Sour tamarind soup with pork', 'Asian', 'Philippines', 'Soup', 15, 45, 'Medium', '🍲', user_id),
        ('Lechon Kawali', 'Crispy fried pork belly', 'Asian', 'Philippines', 'Main', 15, 60, 'Medium', '🥓', user_id),
        
        # European - France
        ('Coq Au Vin', 'French chicken braised in red wine', 'European', 'France', 'Main', 20, 90, 'Hard', '🍷', user_id),
        ('Croissant', 'Flaky French pastry', 'European', 'France', 'Breakfast', 120, 20, 'Hard', '🥐', user_id),
        ('Ratatouille', 'French vegetable stew', 'European', 'France', 'Side', 20, 45, 'Medium', '🍆', user_id),
        
        # European - Italy
        ('Pasta Carbonara', 'Italian pasta with eggs, cheese, pancetta', 'European', 'Italy', 'Main', 10, 20, 'Medium', '🍝', user_id),
        ('Pizza Margherita', 'Classic Italian pizza', 'European', 'Italy', 'Main', 60, 15, 'Medium', '🍕', user_id),
        ('Tiramisu', 'Italian coffee-flavored dessert', 'European', 'Italy', 'Dessert', 30, 0, 'Medium', '🍰', user_id),
        
        # European - Spain
        ('Paella', 'Spanish rice dish with seafood', 'European', 'Spain', 'Main', 20, 60, 'Hard', '🥘', user_id),
        ('Tapas', 'Spanish small plates', 'European', 'Spain', 'Appetizer', 15, 20, 'Easy', '🍢', user_id),
        ('Patatas Bravas', 'Spanish fried potatoes with spicy sauce', 'European', 'Spain', 'Side', 10, 20, 'Easy', '🥔', user_id),
        
        # North American
        ('Hamburger', 'Classic American burger', 'North American', 'United States', 'Main', 10, 15, 'Easy', '🍔', user_id),
        ('BBQ Ribs', 'Slow-cooked pork ribs', 'North American', 'United States', 'Main', 20, 180, 'Medium', '🍖', user_id),
        ('Apple Pie', 'Classic American apple pie', 'North American', 'United States', 'Dessert', 30, 60, 'Medium', '🥧', user_id),
        ('Poutine', 'Canadian fries with gravy and cheese curds', 'North American', 'Canada', 'Main', 10, 20, 'Easy', '🍟', user_id),
        ('Butter Tart', 'Canadian sweet tart', 'North American', 'Canada', 'Dessert', 20, 25, 'Easy', '🥧', user_id),
        ('Guacamole', 'Mexican avocado dip', 'North American', 'Mexico', 'Appetizer', 10, 0, 'Easy', '🥑', user_id),
        ('Mole Poblano', 'Mexican chocolate-chili sauce', 'North American', 'Mexico', 'Sauce', 30, 120, 'Hard', '🍫', user_id),
        
        # Oceanian
        ('Lamington', 'Australian chocolate coconut cake', 'Oceanian', 'Australia', 'Dessert', 30, 25, 'Medium', '🍰', user_id),
        ('Pavlova', 'Australian meringue dessert with fruit', 'Oceanian', 'Australia', 'Dessert', 20, 90, 'Medium', '🍰', user_id),
        ('Meat Pie', 'Australian savory pie', 'Oceanian', 'Australia', 'Main', 20, 40, 'Medium', '🥧', user_id),
        ('Boil Up', 'New Zealand pork and vegetable stew', 'Oceanian', 'New Zealand', 'Soup', 15, 120, 'Medium', '🍲', user_id),
        ('Lamb Roast', 'New Zealand roasted lamb', 'Oceanian', 'New Zealand', 'Main', 15, 90, 'Medium', '🍖', user_id),
        
        # South American
        ('Asado', 'Argentinian barbecue', 'South American', 'Argentina', 'Main', 30, 120, 'Medium', '🥩', user_id),
        ('Dulce de Leche', 'Argentinian caramel spread', 'South American', 'Argentina', 'Dessert', 10, 120, 'Easy', '🍯', user_id),
        ('Empanada', 'Argentinian stuffed pastry', 'South American', 'Argentina', 'Appetizer', 30, 25, 'Medium', '🥟', user_id),
        ('Feijoada', 'Brazilian black bean stew', 'South American', 'Brazil', 'Main', 20, 120, 'Hard', '🫘', user_id),
        ('Brigadeiro', 'Brazilian chocolate truffle', 'South American', 'Brazil', 'Dessert', 10, 15, 'Easy', '🍫', user_id),
        ('Ceviche', 'Peruvian raw fish in citrus', 'South American', 'Peru', 'Appetizer', 20, 0, 'Medium', '🐟', user_id),
        ('Lomo Saltado', 'Peruvian beef stir-fry', 'South American', 'Peru', 'Main', 15, 20, 'Medium', '🥩', user_id),
    ]
    
    for recipe in recipes_data:
        cursor.execute("SELECT * FROM recipes WHERE title = ?", (recipe[0],))
        if not cursor.fetchone():
            cursor.execute('''
                INSERT INTO recipes (title, description, cuisine, region, category, 
                                   prep_time, cook_time, difficulty, image_url, user_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', recipe)
            recipe_id = cursor.lastrowid
            
            # Add details for this recipe
            add_recipe_details(cursor, recipe_id, recipe[0])

def add_recipe_details(cursor, recipe_id, title):
    """Add ingredients and steps for each recipe"""
    
    recipe_details = {
        # Filipino Recipes
        'Sinigang na Baboy': {
            'ingredients': [
                ('Pork belly', '1 kg'),
                ('Tamarind soup mix', '2 packs'),
                ('Radish', '1 piece, sliced'),
                ('Eggplant', '2 pieces, sliced'),
                ('String beans', '1 cup, cut into 2" pieces'),
                ('Water spinach (Kangkong)', '1 bunch'),
                ('Tomatoes', '2 pieces, quartered'),
                ('Onion', '1 piece, sliced'),
                ('Fish sauce', '3 tbsp'),
                ('Water', '8 cups')
            ],
            'steps': [
                'In a pot, boil water and add pork. Simmer for 30-40 minutes until tender.',
                'Add onions and tomatoes. Cook for 5 minutes.',
                'Add tamarind soup mix and fish sauce. Stir well.',
                'Add radish and eggplant. Cook for 5 minutes.',
                'Add string beans and cook for 3 minutes.',
                'Finally, add water spinach and turn off the heat.',
                'Serve hot with steamed rice.'
            ]
        },
        'Adobo': {
            'ingredients': [
                ('Chicken thighs', '1 kg'),
                ('Soy sauce', '1/2 cup'),
                ('Vinegar', '1/2 cup'),
                ('Garlic', '10 cloves, crushed'),
                ('Bay leaves', '3 pieces'),
                ('Black peppercorns', '1 tsp'),
                ('Water', '1 cup'),
                ('Sugar', '1 tbsp (optional)'),
                ('Cooking oil', '2 tbsp')
            ],
            'steps': [
                'Marinate chicken in soy sauce and garlic for 30 minutes.',
                'In a pot, brown the chicken in oil.',
                'Add the marinade, vinegar (don\'t stir), bay leaves, and peppercorns.',
                'Bring to a boil, then simmer for 30-40 minutes until chicken is tender.',
                'Add sugar if desired and reduce sauce to desired consistency.',
                'Serve hot with steamed rice.'
            ]
        },
        
        # Japanese
        'Ramen': {
            'ingredients': [
                ('Pork bones', '2 kg'),
                ('Chicken bones', '1 kg'),
                ('Ramen noodles', '4 servings'),
                ('Pork belly', '500g'),
                ('Eggs', '4 pieces'),
                ('Green onions', '1 bunch, sliced'),
                ('Nori seaweed', '4 pieces'),
                ('Soy sauce', '1/4 cup'),
                ('Mirin', '1/4 cup'),
                ('Garlic', '6 cloves'),
                ('Ginger', '1 thumb-sized piece')
            ],
            'steps': [
                'For the broth: Boil pork and chicken bones for 12 hours, skimming foam.',
                'For chashu pork: Marinate pork belly in soy sauce, mirin, garlic, and ginger.',
                'Roast pork belly at 180°C for 1 hour, then slice thinly.',
                'Soft boil eggs for 6-7 minutes, then marinate in soy sauce mixture.',
                'Cook ramen noodles according to package instructions.',
                'Assemble bowl: noodles, broth, sliced chashu, halved egg, nori.',
                'Garnish with green onions and serve immediately.'
            ]
        },
        
        # Nigerian
        'Jollof Rice': {
            'ingredients': [
                ('Long grain rice', '2 cups, rinsed'),
                ('Tomatoes', '4 large, blended'),
                ('Tomato paste', '2 tbsp'),
                ('Onion', '1 large, diced'),
                ('Red bell peppers', '2 pieces, blended'),
                ('Scotch bonnet peppers', '2 pieces'),
                ('Chicken stock', '3 cups'),
                ('Thyme', '1 tsp'),
                ('Curry powder', '1 tsp'),
                ('Bay leaves', '2 pieces'),
                ('Cooking oil', '1/2 cup'),
                ('Salt', 'to taste')
            ],
            'steps': [
                'Blend tomatoes, bell peppers, and scotch bonnet until smooth.',
                'In a pot, sauté onions in oil until translucent.',
                'Add tomato paste and fry for 2 minutes.',
                'Add blended tomato mixture and fry for 10-15 minutes until reduced.',
                'Add thyme, curry powder, bay leaves, and stock. Bring to boil.',
                'Add rice, reduce heat, cover and cook for 20-25 minutes.',
                'Fluff with fork and serve with fried plantains or chicken.'
            ]
        },
        'Egusi Soup': {
            'ingredients': [
                ('Egusi seeds (melon)', '2 cups, ground'),
                ('Palm oil', '1/2 cup'),
                ('Beef', '500g, cubed'),
                ('Spinach or bitter leaf', '2 cups, chopped'),
                ('Onion', '1 large, diced'),
                ('Stockfish', '100g, soaked'),
                ('Crayfish', '2 tbsp, ground'),
                ('Pepper', 'to taste'),
                ('Stock cubes', '2 pieces'),
                ('Water', '4 cups')
            ],
            'steps': [
                'Season beef with salt and stock cubes. Cook until tender.',
                'In a separate pot, heat palm oil. Add onions and sauté.',
                'Add ground egusi and fry for 5-7 minutes until it changes color.',
                'Add water gradually while stirring to prevent lumps.',
                'Add cooked beef, stockfish, crayfish, and pepper.',
                'Simmer for 10 minutes.',
                'Add chopped spinach and cook for 2 more minutes.',
                'Serve with fufu, pounded yam, or eba.'
            ]
        },
        
        # Italian
        'Pasta Carbonara': {
            'ingredients': [
                ('Spaghetti', '400g'),
                ('Pancetta or guanciale', '200g, diced'),
                ('Eggs', '4 large'),
                ('Pecorino Romano cheese', '1 cup, grated'),
                ('Parmesan cheese', '1/2 cup, grated'),
                ('Black pepper', '2 tsp, freshly ground'),
                ('Salt', 'to taste')
            ],
            'steps': [
                'Bring a large pot of salted water to boil. Cook pasta until al dente.',
                'While pasta cooks, fry pancetta until crispy.',
                'In a bowl, whisk eggs, both cheeses, and black pepper.',
                'Reserve 1 cup of pasta water, then drain pasta.',
                'Working quickly, add hot pasta to pancetta. Remove from heat.',
                'Pour egg mixture over pasta and toss vigorously.',
                'Add pasta water as needed to create creamy sauce.',
                'Serve immediately with extra cheese and pepper.'
            ]
        },
        
        # American
        'Hamburger': {
            'ingredients': [
                ('Ground beef (80/20)', '500g'),
                ('Burger buns', '4 pieces'),
                ('Salt', '1 tsp'),
                ('Black pepper', '1/2 tsp'),
                ('Garlic powder', '1/2 tsp'),
                ('Lettuce', '4 leaves'),
                ('Tomato', '1, sliced'),
                ('Onion', '1, sliced'),
                ('Pickles', '8 slices'),
                ('Cheese slices', '4 pieces'),
                ('Ketchup', 'to taste'),
                ('Mustard', 'to taste')
            ],
            'steps': [
                'Divide ground beef into 4 equal portions and form into patties.',
                'Season both sides with salt, pepper, and garlic powder.',
                'Heat a skillet or grill over high heat.',
                'Cook patties for 3-4 minutes per side for medium.',
                'Add cheese in the last minute of cooking.',
                'Toast burger buns on the grill.',
                'Assemble: bottom bun, lettuce, patty, tomato, onion, pickles.',
                'Add ketchup and mustard on top bun.',
                'Serve immediately with fries.'
            ]
        },
        
        # Mexican
        'Guacamole': {
            'ingredients': [
                ('Avocados', '3 ripe'),
                ('Red onion', '1/4 cup, finely diced'),
                ('Tomato', '1, diced'),
                ('Cilantro', '1/4 cup, chopped'),
                ('Jalapeño', '1, minced'),
                ('Lime juice', '2 tbsp'),
                ('Salt', '1/2 tsp'),
                ('Garlic', '1 clove, minced')
            ],
            'steps': [
                'Cut avocados in half, remove pit, and scoop flesh into bowl.',
                'Mash avocados with fork to desired consistency.',
                'Add lime juice immediately to prevent browning.',
                'Stir in onion, tomato, cilantro, jalapeño, and garlic.',
                'Season with salt to taste.',
                'Serve immediately with tortilla chips.'
            ]
        },
        
        # Brazilian
        'Brigadeiro': {
            'ingredients': [
                ('Sweetened condensed milk', '1 can (395g)'),
                ('Unsweetened cocoa powder', '3 tbsp'),
                ('Butter', '1 tbsp'),
                ('Chocolate sprinkles', '1 cup')
            ],
            'steps': [
                'In a saucepan, combine condensed milk, cocoa powder, and butter.',
                'Cook over medium heat, stirring constantly with a wooden spoon.',
                'Continue cooking until mixture thickens and starts to pull away from pan.',
                'Remove from heat and let cool completely.',
                'Butter your hands and roll mixture into small balls.',
                'Roll each ball in chocolate sprinkles.',
                'Place in mini cupcake liners and serve.'
            ]
        },
        
        # Peruvian
        'Ceviche': {
            'ingredients': [
                ('Fresh white fish', '500g, cubed'),
                ('Lime juice', '1 cup, freshly squeezed'),
                ('Red onion', '1, thinly sliced'),
                ('Aji limo or jalapeño', '2, minced'),
                ('Cilantro', '1/4 cup, chopped'),
                ('Salt', '1 tsp'),
                ('Pepper', '1/2 tsp'),
                ('Sweet potato', '1, boiled and sliced'),
                ('Corn kernels', '1/2 cup, cooked')
            ],
            'steps': [
                'Cube fish into 1-inch pieces and place in glass bowl.',
                'Season with salt and pepper.',
                'Cover fish with lime juice and let "cook" for 5-10 minutes.',
                'Add red onion, chili, and cilantro. Mix gently.',
                'Taste and adjust seasoning.',
                'Serve immediately with sweet potato and corn on the side.',
                'Best eaten within 30 minutes of preparation.'
            ]
        },
        
        # Australian
        'Pavlova': {
            'ingredients': [
                ('Egg whites', '4 large'),
                ('Caster sugar', '1 cup'),
                ('Cornstarch', '1 tsp'),
                ('White vinegar', '1 tsp'),
                ('Vanilla extract', '1 tsp'),
                ('Heavy cream', '1 cup, whipped'),
                ('Mixed berries', '2 cups'),
                ('Passion fruit pulp', '2 fruits')
            ],
            'steps': [
                'Preheat oven to 150°C (300°F). Line baking sheet with parchment.',
                'Beat egg whites until soft peaks form.',
                'Gradually add sugar, beating until stiff and glossy.',
                'Fold in cornstarch, vinegar, and vanilla.',
                'Mound mixture onto baking sheet, shaping into a circle.',
                'Reduce oven to 120°C (250°F) and bake for 1 hour.',
                'Turn off oven and leave pavlova inside to cool completely.',
                'Top with whipped cream, berries, and passion fruit.',
                'Serve immediately.'
            ]
        }
    }
    
    # Add default details for recipes without specific instructions
    if title in recipe_details:
        details = recipe_details[title]
        for name, qty in details['ingredients']:
            cursor.execute('INSERT INTO ingredients (recipe_id, name, quantity) VALUES (?, ?, ?)',
                          (recipe_id, name, qty))
        for idx, step in enumerate(details['steps'], 1):
            cursor.execute('INSERT INTO steps (recipe_id, step_number, instruction) VALUES (?, ?, ?)',
                          (recipe_id, idx, step))
    else:
        # Default details for any recipe not specifically defined
        default_ingredients = [
            ('Main ingredient', '500g'),
            ('Secondary ingredient', '2 pieces'),
            ('Seasoning', 'to taste'),
            ('Oil', '2 tbsp')
        ]
        default_steps = [
            'Prepare all ingredients as listed.',
            'Cook according to your preferred method.',
            'Season to taste.',
            'Serve hot and enjoy!'
        ]
        
        for name, qty in default_ingredients:
            cursor.execute('INSERT INTO ingredients (recipe_id, name, quantity) VALUES (?, ?, ?)',
                          (recipe_id, name, qty))
        for idx, step in enumerate(default_steps, 1):
            cursor.execute('INSERT INTO steps (recipe_id, step_number, instruction) VALUES (?, ?, ?)',
                          (recipe_id, idx, step))

def close_db(e=None):
    db = g.pop('_database', None)
    if db is not None:
        db.close()

# Database query helper functions
def get_recipes_by_cuisine(cuisine):
    """Get all recipes for a specific cuisine"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('SELECT * FROM recipes WHERE cuisine = ? ORDER BY title', (cuisine,))
    return cursor.fetchall()

def get_recipes_by_region(cuisine, region):
    """Get recipes by region (e.g., Asian -> Japan)"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('SELECT * FROM recipes WHERE cuisine = ? AND region = ? ORDER BY title', 
                  (cuisine, region))
    return cursor.fetchall()

def get_recipe_by_id(recipe_id):
    """Get complete recipe with ingredients and steps"""
    db = get_db()
    cursor = db.cursor()
    
    # Get recipe info
    cursor.execute('SELECT * FROM recipes WHERE id = ?', (recipe_id,))
    recipe = cursor.fetchone()
    
    if recipe:
        recipe = dict(recipe)
        # Get ingredients
        cursor.execute('SELECT * FROM ingredients WHERE recipe_id = ?', (recipe_id,))
        recipe['ingredients'] = cursor.fetchall()
        # Get steps
        cursor.execute('SELECT * FROM steps WHERE recipe_id = ? ORDER BY step_number', (recipe_id,))
        recipe['steps'] = cursor.fetchall()
    
    return recipe

def search_recipes(query):
    """Search recipes by title or description"""
    db = get_db()
    cursor = db.cursor()
    search_term = f'%{query}%'
    cursor.execute('''
        SELECT * FROM recipes 
        WHERE title LIKE ? OR description LIKE ? OR cuisine LIKE ? OR region LIKE ?
        ORDER BY title
    ''', (search_term, search_term, search_term, search_term))
    return cursor.fetchall()

def get_favorite_recipes(user_id):
    """Get user's favorite recipes"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('''
        SELECT r.* FROM recipes r
        JOIN favorites f ON r.id = f.recipe_id
        WHERE f.user_id = ?
        ORDER BY f.created_at DESC
    ''', (user_id,))
    return cursor.fetchall()

def add_to_favorites(user_id, recipe_id):
    """Add recipe to user's favorites"""
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute('INSERT INTO favorites (user_id, recipe_id) VALUES (?, ?)',
                      (user_id, recipe_id))
        db.commit()
        return True
    except sqlite3.IntegrityError:
        return False

def remove_from_favorites(user_id, recipe_id):
    """Remove recipe from favorites"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('DELETE FROM favorites WHERE user_id = ? AND recipe_id = ?',
                  (user_id, recipe_id))
    db.commit()
    return cursor.rowcount > 0

def add_to_shopping_list(user_id, ingredient_name, quantity, recipe_id=None):
    """Add ingredient to shopping list"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('''
        INSERT INTO shopping_list (user_id, ingredient_name, quantity, recipe_id)
        VALUES (?, ?, ?, ?)
    ''', (user_id, ingredient_name, quantity, recipe_id))
    db.commit()
    return cursor.lastrowid

def get_shopping_list(user_id):
    """Get user's shopping list"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('''
        SELECT * FROM shopping_list 
        WHERE user_id = ? 
        ORDER BY checked ASC, added_at DESC
    ''', (user_id,))
    return cursor.fetchall()

def toggle_shopping_item(item_id):
    """Mark shopping item as checked/unchecked"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('''
        UPDATE shopping_list 
        SET checked = NOT checked 
        WHERE id = ?
    ''', (item_id,))
    db.commit()
    return cursor.rowcount > 0

def remove_from_shopping_list(item_id):
    """Remove item from shopping list"""
    db = get_db()
    cursor = db.cursor()
    cursor.execute('DELETE FROM shopping_list WHERE id = ?', (item_id,))
    db.commit()
    return cursor.rowcount > 0

def create_custom_recipe(user_id, title, description, cuisine, region, prep_time, cook_time, difficulty, ingredients, steps):
    """Create a user-generated recipe"""
    db = get_db()
    cursor = db.cursor()
    
    cursor.execute('''
        INSERT INTO recipes (title, description, cuisine, region, category, prep_time, cook_time, difficulty, user_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (title, description, cuisine, region, 'Custom', prep_time, cook_time, difficulty, user_id))
    
    recipe_id = cursor.lastrowid
    
    for ingredient in ingredients:
        cursor.execute('INSERT INTO ingredients (recipe_id, name, quantity) VALUES (?, ?, ?)',
                      (recipe_id, ingredient['name'], ingredient['quantity']))
    
    for idx, step in enumerate(steps, 1):
        cursor.execute('INSERT INTO steps (recipe_id, step_number, instruction) VALUES (?, ?, ?)',
                      (recipe_id, idx, step))
    
    db.commit()
    return recipe_id