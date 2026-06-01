from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from database import *
import psycopg2.extras
import hashlib
import os
import sys

app = Flask(__name__)
app.secret_key = 'whats_cookin_secret_key_2024'

# Initialize database tables on startup
with app.app_context():
    print("Creating database tables...")
    init_db()
    print("Database tables created!")

@app.before_request
def before_request():
    get_db()

@app.teardown_appcontext
def teardown_db(exception):
    close_db()

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# ==================== AUTHENTICATION ROUTES ====================

@app.route('/')
def welcome():
    return render_template('welcome.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        phone_number = request.form.get('phone_number')
        password = hash_password(request.form.get('password'))
        
        cursor = get_cursor()
        cursor.execute('SELECT * FROM users WHERE phone_number = %s AND password = %s', 
                      (phone_number, password))
        user = cursor.fetchone()
        
        if user:
            session['user_id'] = user['id']
            session['username'] = user['username']
            flash('Welcome back!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid phone number or password', 'error')
    
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form.get('username')
        phone_number = request.form.get('phone_number')
        password = hash_password(request.form.get('password'))
        
        db = get_db()
        cursor = get_cursor()
        
        try:
            cursor.execute('INSERT INTO users (username, phone_number, password) VALUES (%s, %s, %s)',
                          (username, phone_number, password))
            db.commit()
            
            # Get the newly created user's ID
            cursor.execute('SELECT id FROM users WHERE username = %s', (username,))
            user = cursor.fetchone()
            user_id = user['id']
            
            # Initialize titles for the new user
            init_user_titles(user_id)
            
            flash('Account created successfully! Please login.', 'success')
            return redirect(url_for('login'))
        except Exception as e:
            db.rollback()
            print(f"Signup error: {e}")
            flash('Username or phone number already exists', 'error')
    
    return render_template('signup.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('Logged out successfully', 'success')
    return redirect(url_for('welcome'))

# ==================== MAIN APP ROUTES ====================

@app.route('/home')
def index():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    
    # Get recent recipes (global)
    cursor.execute('SELECT * FROM recipes ORDER BY created_at DESC LIMIT 6')
    recent_recipes = cursor.fetchall()
    
    # Get user's favorite dishes
    cursor.execute("""
        SELECT r.* FROM recipes r
        JOIN favorites f ON r.id = f.recipe_id
        WHERE f.user_id = %s
        ORDER BY f.created_at DESC
        LIMIT 5
    """, (session['user_id'],))
    favorite_dishes = cursor.fetchall()
    
    # If no favorites, show some default recipes
    if not favorite_dishes:
        cursor.execute("SELECT * FROM recipes WHERE region IN ('Philippines', 'United States') LIMIT 3")
        favorite_dishes = cursor.fetchall()
    
    # Get user's own recipes
    cursor.execute("""
        SELECT * FROM recipes 
        WHERE user_id = %s 
        ORDER BY created_at DESC 
        LIMIT 5
    """, (session['user_id'],))
    my_recipes = cursor.fetchall()
    
    # Get completed recipes count
    try:
        cursor.execute("""
            SELECT COUNT(*) as count FROM completed_recipes 
            WHERE user_id = %s
        """, (session['user_id'],))
        completed_result = cursor.fetchone()
        completed_count = completed_result['count'] if completed_result else 0
    except Exception as e:
        print(f"Completed count error: {e}")
        completed_count = 0
    
    # Get recently completed recipes
    try:
        cursor.execute("""
            SELECT r.* FROM completed_recipes cr
            JOIN recipes r ON cr.recipe_id = r.id
            WHERE cr.user_id = %s
            ORDER BY cr.completed_at DESC
            LIMIT 5
        """, (session['user_id'],))
        recent_completed = cursor.fetchall()
    except Exception as e:
        print(f"Recent completed error: {e}")
        recent_completed = []
    
    # Get folders with recipe counts
    try:
        cursor.execute("""
            SELECT f.id, f.folder_name as name, COUNT(fr.recipe_id) as recipe_count
            FROM recipe_folders f
            LEFT JOIN folder_recipes fr ON f.id = fr.folder_id
            WHERE f.user_id = %s
            GROUP BY f.id, f.folder_name
            ORDER BY f.created_at DESC
        """, (session['user_id'],))
        folders_data = cursor.fetchall()
        
        folders_list = []
        for folder in folders_data:
            folders_list.append({
                'id': folder['id'],
                'name': folder['name'],
                'recipe_count': folder['recipe_count'] if folder['recipe_count'] else 0
            })
    except Exception as e:
        print(f"Folders error: {e}")
        folders_list = []
    
    # Get recent views
    try:
        cursor.execute("""
            SELECT r.* FROM recent_views rv
            JOIN recipes r ON rv.recipe_id = r.id
            WHERE rv.user_id = %s
            ORDER BY rv.viewed_at DESC
            LIMIT 5
        """, (session['user_id'],))
        recent_views = cursor.fetchall()
    except Exception as e:
        print(f"Recent views error: {e}")
        recent_views = []
    
    # Use recent_views if available, otherwise use recent_recipes
    display_recipes = recent_views if recent_views else recent_recipes
    
    return render_template('index.html', 
                           username=session.get('username'),
                           recent_recipes=display_recipes,
                           favorite_dishes=favorite_dishes,
                           my_recipes=my_recipes,
                           folders=folders_list,
                           completed_count=completed_count,
                           recent_completed=recent_completed)

@app.route('/cuisine/<cuisine>')
def view_cuisine(cuisine):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    
    # Get all recipes for this cuisine
    cursor.execute("SELECT * FROM recipes WHERE cuisine = %s ORDER BY title", (cuisine,))
    all_recipes = cursor.fetchall()
    
    # Get distinct regions
    cursor.execute("""
        SELECT DISTINCT region FROM recipes 
        WHERE cuisine = %s AND region IS NOT NULL AND region != ''
        ORDER BY region
    """, (cuisine,))
    regions = cursor.fetchall()
    
    recipes_by_region = {}
    
    # Group recipes by region
    for region in regions:
        region_name = region['region']
        cursor.execute("""
            SELECT * FROM recipes 
            WHERE cuisine = %s AND region = %s 
            ORDER BY title
        """, (cuisine, region_name))
        recipes_by_region[region_name] = cursor.fetchall()
    
    # If no regions found but we have recipes, put them in "All Recipes"
    if not recipes_by_region and all_recipes:
        recipes_by_region['All Recipes'] = all_recipes
    
    return render_template('cuisine_view.html', 
                           cuisine=cuisine,
                           regions=regions,
                           recipes_by_region=recipes_by_region)

@app.route('/recipe/<string:dish_id>')
def view_recipe(dish_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    recipe = get_recipe_by_dish_id(dish_id)
    
    if not recipe:
        flash('Recipe not found', 'error')
        return redirect(url_for('index'))
    
    # Track this view
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("DELETE FROM recent_views WHERE user_id = %s AND recipe_id = %s",
                   (session['user_id'], recipe['id']))
        cur.execute("INSERT INTO recent_views (user_id, recipe_id) VALUES (%s, %s)",
                   (session['user_id'], recipe['id']))
        db.commit()
    except Exception as e:
        print(f"Track view error (non-fatal): {e}")
    
    cursor = get_cursor()
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND recipe_id = %s', 
                  (session['user_id'], recipe['id']))
    is_favorite = cursor.fetchone() is not None
    
    return render_template('recipe_detail.html', recipe=recipe, is_favorite=is_favorite)

@app.route('/favorite/<int:recipe_id>')
def toggle_favorite(recipe_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'})
    
    cursor = get_cursor()
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND recipe_id = %s', 
                  (session['user_id'], recipe_id))
    
    if cursor.fetchone():
        remove_from_favorites(session['user_id'], recipe_id)
        is_favorite = False
    else:
        add_to_favorites(session['user_id'], recipe_id)
        is_favorite = True
        # Check for title unlocks after favoriting
        check_and_unlock_titles(session['user_id'])
    
    return jsonify({'success': True, 'is_favorite': is_favorite})

@app.route('/search')
def search():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    q        = request.args.get('q', '')
    category = request.args.get('category', '')
    cuisine  = request.args.get('cuisine', '')
    region   = request.args.get('region', '')

    results = []
    if q or category or cuisine or region:
        results = search_recipes(q, category, cuisine, region)

    return render_template('search.html',
                           results=results,
                           query=q)

@app.route('/create_recipe', methods=['GET', 'POST'])
def create_recipe():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        try:
            title = request.form.get('title')
            description = request.form.get('description')
            cuisine = request.form.get('cuisine')
            region = request.form.get('region')
            category = request.form.get('category')
            prep_time = request.form.get('prep_time')
            cook_time = request.form.get('cook_time')
            difficulty = request.form.get('difficulty')
            
            ingredients = []
            ingredient_names = request.form.getlist('ingredient_name[]')
            ingredient_quantities = request.form.getlist('ingredient_quantity[]')
            for name, qty in zip(ingredient_names, ingredient_quantities):
                if name.strip():
                    ingredients.append({'name': name, 'quantity': qty})
            
            steps = request.form.getlist('step[]')
            steps = [s for s in steps if s.strip()]
            
            # Direct database insert without helper function
            db = get_db()
            cur = db.cursor()
            
            # Insert recipe
            cur.execute('''
                INSERT INTO recipes (title, description, cuisine, region, category, prep_time, cook_time, difficulty, user_id, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP)
                RETURNING id
            ''', (title, description, cuisine, region, category, 
                  int(prep_time) if prep_time else 0,
                  int(cook_time) if cook_time else 0,
                  difficulty, session['user_id']))
            
            recipe_id = cur.fetchone()[0]
            
            # Insert ingredients
            for ing in ingredients:
                cur.execute('''
                    INSERT INTO ingredients (recipe_id, name, quantity)
                    VALUES (%s, %s, %s)
                ''', (recipe_id, ing['name'], ing['quantity']))
            
            # Insert steps
            for idx, step in enumerate(steps, 1):
                cur.execute('''
                    INSERT INTO steps (recipe_id, step_number, instruction)
                    VALUES (%s, %s, %s)
                ''', (recipe_id, idx, step))
            
            db.commit()
            cur.close()
            
            # Check and unlock titles after creating recipe
            check_and_unlock_titles(session['user_id'])
            
            flash('Recipe created successfully!', 'success')
            return redirect(url_for('view_recipe_by_id', recipe_id=recipe_id))
            
        except Exception as e:
            print(f"Create recipe error: {e}")
            import traceback
            traceback.print_exc()
            flash(f'Error creating recipe: {str(e)}', 'error')
            return redirect(url_for('create_recipe'))
    
    return render_template('create_recipe.html')

@app.route('/recipe/id/<int:recipe_id>')
def view_recipe_by_id(recipe_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    recipe = get_recipe_by_id(recipe_id)
    
    cursor = get_cursor()
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND recipe_id = %s', 
                  (session['user_id'], recipe_id))
    is_favorite = cursor.fetchone() is not None
    
    return render_template('recipe_detail.html', recipe=recipe, is_favorite=is_favorite)

@app.route('/shopping_list')
def view_shopping_list():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    items = get_shopping_list(session['user_id'])
    return render_template('shopping_list.html', items=items)

@app.route('/add_to_shopping_list', methods=['POST'])
def add_to_shopping_list_route():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'})
    
    data = request.get_json()
    ingredient_name = data.get('ingredient_name')
    quantity = data.get('quantity', '')
    recipe_id = data.get('recipe_id')
    
    add_to_shopping_list(session['user_id'], ingredient_name, quantity, recipe_id)
    return jsonify({'success': True})

@app.route('/toggle_shopping_item/<int:item_id>')
def toggle_shopping_item_route(item_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    toggle_shopping_item(item_id)
    return redirect(url_for('view_shopping_list'))

@app.route('/remove_shopping_item/<int:item_id>')
def remove_shopping_item_route(item_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    remove_from_shopping_list(item_id)
    flash('Item removed from shopping list', 'success')
    return redirect(url_for('view_shopping_list'))

@app.route('/add_recipe_to_shopping_list/<int:recipe_id>')
def add_recipe_to_shopping_list_route(recipe_id):
    if 'user_id' not in session:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return jsonify({'success': False, 'error': 'Not logged in'}), 401
        return redirect(url_for('login'))
    
    recipe = get_recipe_by_id(recipe_id)
    if recipe and 'ingredients' in recipe:
        for ingredient in recipe['ingredients']:
            add_to_shopping_list(session['user_id'], ingredient['name'], ingredient['quantity'], recipe_id)
            
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return jsonify({'success': True, 'message': 'All ingredients added!'})
        
    flash('All ingredients added to shopping list!', 'success')
    return redirect(url_for('view_recipe_by_id', recipe_id=recipe_id))

# ==================== PROFILE ROUTES ====================

@app.route('/profile')
def profile():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    
    cursor.execute('SELECT id, username, phone_number FROM users WHERE id = %s', (session['user_id'],))
    user = cursor.fetchone()
    
    cursor.execute('SELECT * FROM recipes WHERE user_id = %s ORDER BY created_at DESC', (session['user_id'],))
    user_recipes = cursor.fetchall()
    
    favorites = get_favorite_recipes(session['user_id'])
    
    user_recipes_count = len(user_recipes) if user_recipes else 0
    favorite_count = len(favorites) if favorites else 0
    
    cursor.execute('SELECT COUNT(*) as count FROM shopping_list WHERE user_id = %s', (session['user_id'],))
    shopping_result = cursor.fetchone()
    shopping_count = shopping_result['count'] if shopping_result else 0
    
    return render_template('profile.html', 
                          user=user, 
                          user_recipes=user_recipes,
                          user_recipes_count=user_recipes_count,
                          favorite_recipes=favorites,
                          favorite_count=favorite_count,
                          shopping_count=shopping_count)

@app.route('/favorites')
def favorites():
    if 'user_id' not in session:
        flash('Please login to view favorites', 'error')
        return redirect(url_for('login'))
    
    favorites_list = get_favorite_recipes(session['user_id'])
    return render_template('favorites.html', favorites=favorites_list)

@app.route('/my_recipes')
def my_recipes():
    if 'user_id' not in session:
        flash('Please login to view your recipes', 'error')
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    cursor.execute("""
        SELECT id, dish_id, title, description, cuisine, region, category, 
               prep_time, cook_time, difficulty, created_at
        FROM recipes 
        WHERE user_id = %s 
        ORDER BY created_at DESC
    """, (session['user_id'],))
    recipes = cursor.fetchall()
    
    return render_template('my_recipes.html', recipes=recipes)

@app.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    
    if request.method == 'POST':
        username = request.form.get('username')
        phone_number = request.form.get('phone_number')
        
        cursor.execute('UPDATE users SET username = %s, phone_number = %s WHERE id = %s',
                      (username, phone_number, session['user_id']))
        get_db().commit()
        session['username'] = username
        flash('Profile updated successfully!', 'success')
        return redirect(url_for('profile'))
    
    cursor.execute('SELECT id, username, phone_number FROM users WHERE id = %s', (session['user_id'],))
    user = cursor.fetchone()
    return render_template('edit_profile.html', user=user)

@app.route('/change_password', methods=['GET', 'POST'])
def change_password():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        current = hash_password(request.form.get('current_password'))
        new = hash_password(request.form.get('new_password'))
        confirm = hash_password(request.form.get('confirm_password'))
        
        if new != confirm:
            flash('New passwords do not match', 'error')
            return redirect(url_for('change_password'))
        
        cursor = get_cursor()
        cursor.execute('SELECT * FROM users WHERE id = %s AND password = %s', (session['user_id'], current))
        if not cursor.fetchone():
            flash('Current password is incorrect', 'error')
            return redirect(url_for('change_password'))
        
        cursor.execute('UPDATE users SET password = %s WHERE id = %s', (new, session['user_id']))
        get_db().commit()
        flash('Password changed successfully! Please login again.', 'success')
        session.clear()
        return redirect(url_for('login'))
    
    return render_template('change_password.html')

@app.route('/achievements')
def achievements():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Use existing database connection
    db = get_db()
    cur = db.cursor()
    
    # Get counts
    cur.execute("SELECT COUNT(*) FROM recipes WHERE user_id = %s", (session['user_id'],))
    recipe_count = cur.fetchone()[0]
    
    cur.execute("SELECT COUNT(*) FROM favorites WHERE user_id = %s", (session['user_id'],))
    favorite_count = cur.fetchone()[0]
    
    cur.execute("SELECT COUNT(*) FROM completed_recipes WHERE user_id = %s", (session['user_id'],))
    completed_count = cur.fetchone()[0]
    
    # Get active title
    cur.execute("""
        SELECT title_name FROM user_titles 
        WHERE user_id = %s AND is_active = true
        LIMIT 1
    """, (session['user_id'],))
    active_result = cur.fetchone()
    
    active_title = active_result[0] if active_result else 'No Title'
    
    return render_template('achievements.html', 
                          recipe_count=recipe_count,
                          favorite_count=favorite_count,
                          completed_count=completed_count,
                          active_title=active_title)


@app.route('/equip_title/<title_key>', methods=['POST'])
def equip_title(title_key):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        db = get_db()
        cur = db.cursor()
        
        # First, deactivate all titles for this user
        cur.execute("UPDATE user_titles SET is_active = false WHERE user_id = %s", (session['user_id'],))
        
        # Then activate the selected title
        cur.execute("""
            UPDATE user_titles SET is_active = true 
            WHERE user_id = %s AND title_key = %s
        """, (session['user_id'], title_key))
        
        db.commit()
        
        # Close and reopen connection to force refresh
        cur.close()
        
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Equip title error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
    
@app.route('/debug_active_title')
def debug_active_title():
    if 'user_id' not in session:
        return "Not logged in"
    
    db = get_db()
    cur = db.cursor()
    cur.execute("SELECT title_key, title_name, is_active FROM user_titles WHERE user_id = %s", (session['user_id'],))
    results = cur.fetchall()
    
    output = f"User ID: {session['user_id']}<br>"
    for row in results:
        output += f"Title: {row[1]}, Active: {row[2]}<br>"
    
    return output

def init_user_titles(user_id):
    """Initialize all possible titles for a new user"""
    db = get_db()
    cur = db.cursor()
    
    all_titles = [
        ('apprentice_cook', 'Apprentice Cook'),
        ('home_chef', 'Home Chef'),
        ('master_chef', 'Master Chef'),
        ('food_lover', 'Food Lover'),
        ('super_fan', 'Super Fan'),
        ('home_cook', 'Home Cook'),
        ('dedicated_chef', 'Dedicated Chef'),
        ('completion_master', 'Completion Master'),
    ]
    
    for title_key, title_name in all_titles:
        cur.execute("""
            INSERT INTO user_titles (user_id, title_key, title_name, is_active)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (user_id, title_key) DO NOTHING
        """, (user_id, title_key, title_name, False))
    
    db.commit()
    print(f"Initialized titles for user {user_id}")
    
# ==================== TITLE UNLOCKING FUNCTION ====================

def check_and_unlock_titles(user_id):
    """Check if user has reached any new title milestones and unlock them"""
    cursor = get_cursor()
    
    # Get user's current counts
    cursor.execute("SELECT COUNT(*) as count FROM recipes WHERE user_id = %s", (user_id,))
    recipe_result = cursor.fetchone()
    recipe_count = recipe_result['count'] if recipe_result else 0
    
    cursor.execute("SELECT COUNT(*) as count FROM favorites WHERE user_id = %s", (user_id,))
    favorite_result = cursor.fetchone()
    favorite_count = favorite_result['count'] if favorite_result else 0
    
    cursor.execute("SELECT COUNT(*) as count FROM completed_recipes WHERE user_id = %s", (user_id,))
    completed_result = cursor.fetchone()
    completed_count = completed_result['count'] if completed_result else 0
    
    # Define title requirements
    titles_to_check = [
        ('apprentice_cook', 'Apprentice Cook', recipe_count >= 5),
        ('home_chef', 'Home Chef', recipe_count >= 10),
        ('master_chef', 'Master Chef', recipe_count >= 25),
        ('food_lover', 'Food Lover', favorite_count >= 10),
        ('super_fan', 'Super Fan', favorite_count >= 25),
        ('home_cook', 'Home Cook', completed_count >= 5),
        ('dedicated_chef', 'Dedicated Chef', completed_count >= 15),
        ('completion_master', 'Completion Master', completed_count >= 30),
    ]
    
    db = get_db()
    cur = db.cursor()
    
    for title_key, title_name, condition in titles_to_check:
        if condition:
            # Check if title already exists for this user
            cur.execute("SELECT id FROM user_titles WHERE user_id = %s AND title_key = %s", 
                       (user_id, title_key))
            if not cur.fetchone():
                # Insert new title
                cur.execute("""
                    INSERT INTO user_titles (user_id, title_key, title_name, is_active)
                    VALUES (%s, %s, %s, %s)
                """, (user_id, title_key, title_name, False))
                print(f"🎉 Unlocked new title for user {user_id}: {title_name}")
    
    db.commit()

@app.route('/recent_recipes')
def recent_recipes():
    if 'user_id' not in session:
        flash('Please login to view recent recipes', 'error')
        return redirect(url_for('login'))
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT r.* FROM recent_views rv
            JOIN recipes r ON rv.recipe_id = r.id
            WHERE rv.user_id = %s
            ORDER BY rv.viewed_at DESC
        """, (session['user_id'],))
        recipes = cursor.fetchall()
        return render_template('recent_recipes.html', recipes=recipes)
    except Exception as e:
        print(f"Recent recipes error: {e}")
        cursor = get_cursor()
        cursor.execute('SELECT * FROM recipes ORDER BY created_at DESC LIMIT 20')
        recipes = cursor.fetchall()
        return render_template('recent_recipes.html', recipes=recipes)
    
@app.route('/completed_recipes')
def completed_recipes():
    if 'user_id' not in session:
        flash('Please login to view completed recipes', 'error')
        return redirect(url_for('login'))
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT r.* FROM completed_recipes cr
            JOIN recipes r ON cr.recipe_id = r.id
            WHERE cr.user_id = %s
            ORDER BY cr.completed_at DESC
        """, (session['user_id'],))
        recipes = cursor.fetchall()
        
        return render_template('completed_recipes.html', recipes=recipes)
    except Exception as e:
        print(f"Completed recipes error: {e}")
        # If table doesn't exist, just show empty
        return render_template('completed_recipes.html', recipes=[])
    
@app.route('/update_achievement_titles', methods=['POST'])
def update_achievement_titles():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    data = request.get_json()
    
    try:
        db = get_db()
        cur = db.cursor()
        
        cur.execute("""
            UPDATE users SET
                apprentice_title = %s,
                home_chef_title = %s,
                master_chef_title = %s,
                food_lover_title = %s,
                super_fan_title = %s,
                home_cook_title = %s,
                dedicated_chef_title = %s,
                master_completed_title = %s
            WHERE id = %s
        """, (
            data.get('apprentice_title'),
            data.get('home_chef_title'),
            data.get('master_chef_title'),
            data.get('food_lover_title'),
            data.get('super_fan_title'),
            data.get('home_cook_title'),
            data.get('dedicated_chef_title'),
            data.get('master_completed_title'),
            session['user_id']
        ))
        db.commit()
        
        return jsonify({'success': True})
    except Exception as e:
        print(f"Update titles error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
    

# ==================== RECIPE FOLDERS ROUTES ====================

@app.route('/create_folder', methods=['POST'])
def create_folder():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    data = request.get_json()
    folder_name = data.get('name')
    
    if not folder_name:
        return jsonify({'success': False, 'error': 'Folder name required'}), 400
    
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            INSERT INTO recipe_folders (user_id, folder_name)
            VALUES (%s, %s)
            RETURNING id
        """, (session['user_id'], folder_name))
        folder_id = cur.fetchone()[0]
        db.commit()
        return jsonify({'success': True, 'folder_id': folder_id})
    except Exception as e:
        print(f"Create folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/folder/<int:folder_id>')
def view_folder(folder_id):
    if 'user_id' not in session:
        flash('Please login to view folder', 'error')
        return redirect(url_for('login'))
    
    try:
        cursor = get_cursor()
        cursor.execute("SELECT folder_name FROM recipe_folders WHERE id = %s AND user_id = %s",
                      (folder_id, session['user_id']))
        folder = cursor.fetchone()
        
        if not folder:
            flash('Folder not found', 'error')
            return redirect(url_for('index'))
        
        cursor.execute("""
            SELECT r.* FROM folder_recipes fr
            JOIN recipes r ON fr.recipe_id = r.id
            WHERE fr.folder_id = %s AND fr.user_id = %s
            ORDER BY fr.added_at DESC
        """, (folder_id, session['user_id']))
        recipes = cursor.fetchall()
        
        return render_template('folder_view.html', 
                             recipes=recipes, 
                             folder_name=folder['folder_name'],
                             folder_id=folder_id)  # Pass folder_id to template
    except Exception as e:
        print(f"View folder error: {e}")
        flash('Error loading folder', 'error')
        return redirect(url_for('index'))

@app.route('/delete_folder/<int:folder_id>', methods=['DELETE'])
def delete_folder(folder_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("DELETE FROM recipe_folders WHERE id = %s AND user_id = %s",
                   (folder_id, session['user_id']))
        db.commit()
        return jsonify({'success': True})
    except Exception as e:
        print(f"Delete folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

# ==================== VOICE COMMAND ROUTES ====================

@app.route('/voice-commands', methods=['POST'])
def save_voice_command():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'})
    
    data = request.get_json()
    db = get_db()
    cursor = get_cursor()
    cursor.execute('''
        INSERT INTO voice_command (user_id, command, action, recipe_id)
        VALUES (%s, %s, %s, %s)
    ''', (session['user_id'], data['command'], 
          data.get('action'), data.get('recipe_id')))
    db.commit()
    return jsonify({'success': True})

@app.route('/voice-commands/recent', methods=['GET'])
def get_recent_commands():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'})
    
    cursor = get_cursor()
    cursor.execute('''
        SELECT * FROM voice_command 
        WHERE user_id = %s
        ORDER BY created_at DESC 
        LIMIT 10
    ''', (session['user_id'],))
    commands = cursor.fetchall()
    return jsonify([dict(c) for c in commands])

@app.route("/api/recipe/<string:dish_id>")
def api_recipe(dish_id):
    recipe = get_recipe_by_dish_id(dish_id)
    if not recipe:
        return jsonify({'error': 'Recipe not found'}), 404
    return jsonify(recipe)

@app.route("/api/recipe/id/<int:recipe_id>")
def api_recipe_by_id(recipe_id):
    recipe = get_recipe_by_id(recipe_id)
    if not recipe or recipe.get('title') == 'Recipe Not Found':
        return jsonify({'error': 'Recipe not found'}), 404
    return jsonify(recipe)

# ==================== GET FOLDERS ====================


@app.route('/get_folders')
def get_folders():
    """Get all folders for the current user"""
    if 'user_id' not in session:
        return jsonify({'folders': []})
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT id, folder_name as name 
            FROM recipe_folders 
            WHERE user_id = %s 
            ORDER BY created_at DESC
        """, (session['user_id'],))
        folders = cursor.fetchall()
        
        folders_list = [{'id': f['id'], 'name': f['name']} for f in folders]
        return jsonify({'folders': folders_list})
    except Exception as e:
        print(f"Get folders error: {e}")
        return jsonify({'folders': []})

@app.route('/add_to_folder', methods=['POST'])
def add_to_folder():
    """Add a recipe to a folder"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    data = request.get_json()
    recipe_id = data.get('recipe_id')
    folder_id = data.get('folder_id')
    
    if not recipe_id or not folder_id:
        return jsonify({'success': False, 'error': 'Missing recipe_id or folder_id'}), 400
    
    try:
        db = get_db()
        cur = db.cursor()
        
        # Check if already in folder
        cur.execute("""
            SELECT id FROM folder_recipes 
            WHERE folder_id = %s AND recipe_id = %s AND user_id = %s
        """, (folder_id, recipe_id, session['user_id']))
        
        if cur.fetchone():
            return jsonify({'success': False, 'error': 'Recipe already in this folder'}), 400
        
        cur.execute("""
            INSERT INTO folder_recipes (folder_id, recipe_id, user_id)
            VALUES (%s, %s, %s)
        """, (folder_id, recipe_id, session['user_id']))
        db.commit()
        
        return jsonify({'success': True})
    except Exception as e:
        print(f"Add to folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
    
# Check if recipe is in a specific folder
@app.route('/check_recipe_in_folder/<int:recipe_id>/<int:folder_id>')
def check_recipe_in_folder(recipe_id, folder_id):
    """Check if a recipe is already in a folder"""
    if 'user_id' not in session:
        return jsonify({'in_folder': False})
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT id FROM folder_recipes 
            WHERE folder_id = %s AND recipe_id = %s AND user_id = %s
        """, (folder_id, recipe_id, session['user_id']))
        
        exists = cursor.fetchone() is not None
        return jsonify({'in_folder': exists})
    except Exception as e:
        print(f"Check folder error: {e}")
        return jsonify({'in_folder': False})


# Get all folders that contain this recipe
@app.route('/get_recipe_folders/<int:recipe_id>')
def get_recipe_folders(recipe_id):
    """Get all folders that contain this recipe"""
    if 'user_id' not in session:
        return jsonify({'folders': []})
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT f.id, f.folder_name as name 
            FROM recipe_folders f
            JOIN folder_recipes fr ON f.id = fr.folder_id
            WHERE fr.recipe_id = %s AND fr.user_id = %s
            ORDER BY f.created_at DESC
        """, (recipe_id, session['user_id']))
        
        folders = cursor.fetchall()
        folders_list = [{'id': f['id'], 'name': f['name']} for f in folders]
        return jsonify({'folders': folders_list})
    except Exception as e:
        print(f"Get recipe folders error: {e}")
        return jsonify({'folders': []})


# Remove recipe from a folder
@app.route('/remove_from_folder/<int:recipe_id>/<int:folder_id>', methods=['DELETE'])
def remove_from_folder(recipe_id, folder_id):
    """Remove a recipe from a folder"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            DELETE FROM folder_recipes 
            WHERE folder_id = %s AND recipe_id = %s AND user_id = %s
        """, (folder_id, recipe_id, session['user_id']))
        db.commit()
        
        return jsonify({'success': True})
    except Exception as e:
        print(f"Remove from folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
    
# ==================== EDIT AND DELETE RECIPES ====================

@app.route('/edit_recipe/<int:recipe_id>', methods=['GET', 'POST'])
def edit_recipe(recipe_id):
    if 'user_id' not in session:
        flash('Please login to edit recipes', 'error')
        return redirect(url_for('login'))
    
    # Get the recipe
    recipe = get_recipe_by_id(recipe_id)
    
    # Check if recipe exists
    if not recipe:
        flash('Recipe not found', 'error')
        return redirect(url_for('index'))
    
    # Check if user owns this recipe
    if recipe['user_id'] != session['user_id']:
        flash('You can only edit your own recipes', 'error')
        return redirect(url_for('index'))
    
    if request.method == 'POST':
        try:
            title = request.form.get('title')
            description = request.form.get('description')
            cuisine = request.form.get('cuisine')
            region = request.form.get('region')
            category = request.form.get('category')
            prep_time = request.form.get('prep_time')
            cook_time = request.form.get('cook_time')
            difficulty = request.form.get('difficulty')
            
            # Update recipe
            db = get_db()
            cur = db.cursor()
            cur.execute("""
                UPDATE recipes 
                SET title = %s, description = %s, cuisine = %s, region = %s, 
                    category = %s, prep_time = %s, cook_time = %s, difficulty = %s
                WHERE id = %s AND user_id = %s
            """, (title, description, cuisine, region, category, 
                  int(prep_time) if prep_time else 0,
                  int(cook_time) if cook_time else 0,
                  difficulty, recipe_id, session['user_id']))
            
            # Update ingredients (delete old, add new)
            cur.execute("DELETE FROM ingredients WHERE recipe_id = %s", (recipe_id,))
            
            ingredient_names = request.form.getlist('ingredient_name[]')
            ingredient_quantities = request.form.getlist('ingredient_quantity[]')
            for name, qty in zip(ingredient_names, ingredient_quantities):
                if name.strip():
                    cur.execute("""
                        INSERT INTO ingredients (recipe_id, name, quantity)
                        VALUES (%s, %s, %s)
                    """, (recipe_id, name.strip(), qty.strip()))
            
            # Update steps (delete old, add new)
            cur.execute("DELETE FROM steps WHERE recipe_id = %s", (recipe_id,))
            
            steps = request.form.getlist('step[]')
            steps = [s for s in steps if s.strip()]
            for idx, step in enumerate(steps, 1):
                cur.execute("""
                    INSERT INTO steps (recipe_id, step_number, instruction)
                    VALUES (%s, %s, %s)
                """, (recipe_id, idx, step))
            
            db.commit()
            cur.close()
            
            flash('Recipe updated successfully!', 'success')
            return redirect(url_for('view_recipe_by_id', recipe_id=recipe_id))
            
        except Exception as e:
            print(f"Edit recipe error: {e}")
            flash('Error updating recipe', 'error')
            return redirect(url_for('edit_recipe', recipe_id=recipe_id))
    
    return render_template('edit_recipe.html', recipe=recipe)


@app.route('/delete_recipe/<int:recipe_id>', methods=['POST'])
def delete_recipe(recipe_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        db = get_db()
        cur = db.cursor()
        
        # Check if user owns the recipe
        cur.execute("SELECT id FROM recipes WHERE id = %s AND user_id = %s", 
                   (recipe_id, session['user_id']))
        if not cur.fetchone():
            return jsonify({'success': False, 'error': 'You can only delete your own recipes'}), 403
        
        # Delete ingredients first (due to foreign key)
        cur.execute("DELETE FROM ingredients WHERE recipe_id = %s", (recipe_id,))
        
        # Delete steps
        cur.execute("DELETE FROM steps WHERE recipe_id = %s", (recipe_id,))
        
        # Delete from favorites
        cur.execute("DELETE FROM favorites WHERE recipe_id = %s", (recipe_id,))
        
        # Delete from folders
        cur.execute("DELETE FROM folder_recipes WHERE recipe_id = %s", (recipe_id,))
        
        # Delete recipe
        cur.execute("DELETE FROM recipes WHERE id = %s AND user_id = %s", 
                   (recipe_id, session['user_id']))
        
        db.commit()
        cur.close()
        
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Delete recipe error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
    
# ==================== COMPLETED RECIPES ====================

@app.route('/mark_recipe_done/<int:recipe_id>', methods=['POST'])
def mark_recipe_done(recipe_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        db = get_db()
        cur = db.cursor()
        
        # Check if already marked as done
        cur.execute("""
            SELECT id FROM completed_recipes 
            WHERE user_id = %s AND recipe_id = %s
        """, (session['user_id'], recipe_id))
        
        if cur.fetchone():
            return jsonify({'success': False, 'error': 'Recipe already marked as done'}), 400
        
        # Mark as done
        cur.execute("""
            INSERT INTO completed_recipes (user_id, recipe_id)
            VALUES (%s, %s)
        """, (session['user_id'], recipe_id))
        db.commit()
        
        # Check and unlock titles after marking as done
        check_and_unlock_titles(session['user_id'])
        
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Mark done error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/unmark_recipe_done/<int:recipe_id>', methods=['POST'])
def unmark_recipe_done(recipe_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        db = get_db()
        cur = db.cursor()
        
        cur.execute("""
            DELETE FROM completed_recipes 
            WHERE user_id = %s AND recipe_id = %s
        """, (session['user_id'], recipe_id))
        db.commit()
        
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Unmark done error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/check_recipe_done/<int:recipe_id>')
def check_recipe_done(recipe_id):
    if 'user_id' not in session:
        return jsonify({'is_done': False})
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT id FROM completed_recipes 
            WHERE user_id = %s AND recipe_id = %s
        """, (session['user_id'], recipe_id))
        
        is_done = cursor.fetchone() is not None
        return jsonify({'is_done': is_done})
        
    except Exception as e:
        print(f"Check done error: {e}")
        return jsonify({'is_done': False})

# ==================== HELPER FUNCTIONS ====================

def init_user_titles(user_id):
    """Initialize all possible titles for a new user"""
    db = get_db()
    cur = db.cursor()
    
    all_titles = [
        ('apprentice_cook', 'Apprentice Cook'),
        ('home_chef', 'Home Chef'),
        ('master_chef', 'Master Chef'),
        ('food_lover', 'Food Lover'),
        ('super_fan', 'Super Fan'),
        ('home_cook', 'Home Cook'),
        ('dedicated_chef', 'Dedicated Chef'),
        ('completion_master', 'Completion Master'),
    ]
    
    for title_key, title_name in all_titles:
        cur.execute("""
            INSERT INTO user_titles (user_id, title_key, title_name, is_active)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (user_id, title_key) DO NOTHING
        """, (user_id, title_key, title_name, False))
    
    db.commit()
    print(f"✅ Initialized {len(all_titles)} titles for user {user_id}")

def add_to_favorites(user_id, recipe_id):
    db = get_db()
    cursor = get_cursor()
    cursor.execute('INSERT INTO favorites (user_id, recipe_id) VALUES (%s, %s)', (user_id, recipe_id))
    db.commit()

def remove_from_favorites(user_id, recipe_id):
    db = get_db()
    cursor = get_cursor()
    cursor.execute('DELETE FROM favorites WHERE user_id = %s AND recipe_id = %s', (user_id, recipe_id))
    db.commit()

def get_favorite_recipes(user_id):
    cursor = get_cursor()
    cursor.execute('''
        SELECT r.* FROM recipes r
        JOIN favorites f ON r.id = f.recipe_id
        WHERE f.user_id = %s
        ORDER BY f.created_at DESC
    ''', (user_id,))
    return cursor.fetchall()

def get_shopping_list(user_id):
    cursor = get_cursor()
    cursor.execute('SELECT * FROM shopping_list WHERE user_id = %s ORDER BY checked, added_at', (user_id,))
    return cursor.fetchall()

def add_to_shopping_list(user_id, ingredient_name, quantity, recipe_id=None):
    db = get_db()
    cursor = get_cursor()
    cursor.execute('''
        INSERT INTO shopping_list (user_id, ingredient_name, quantity, recipe_id)
        VALUES (%s, %s, %s, %s)
    ''', (user_id, ingredient_name, quantity, recipe_id))
    db.commit()

def toggle_shopping_item(item_id):
    db = get_db()
    cursor = get_cursor()
    cursor.execute('UPDATE shopping_list SET checked = NOT checked WHERE id = %s', (item_id,))
    db.commit()

def remove_from_shopping_list(item_id):
    db = get_db()
    cursor = get_cursor()
    cursor.execute('DELETE FROM shopping_list WHERE id = %s', (item_id,))
    db.commit()

# ========== FIXED create_custom_recipe FUNCTION ==========
def create_custom_recipe(user_id, title, description, cuisine, region, prep_time, cook_time, difficulty, ingredients, steps):
    db = get_db()
    cursor = db.cursor()  # Use db.cursor() directly instead of get_cursor()
    
    try:
        cursor.execute('''
            INSERT INTO recipes (title, description, cuisine, region, category, prep_time, cook_time, difficulty, user_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id
        ''', (title, description, cuisine, region, 'Main Course', prep_time, cook_time, difficulty, user_id))
        
        recipe_id = cursor.fetchone()[0]
        
        for ing in ingredients:
            cursor.execute('INSERT INTO ingredients (recipe_id, name, quantity) VALUES (%s, %s, %s)',
                          (recipe_id, ing['name'], ing['quantity']))
        
        for idx, step in enumerate(steps, 1):
            cursor.execute('INSERT INTO steps (recipe_id, step_number, instruction) VALUES (%s, %s, %s)',
                          (recipe_id, idx, step))
        
        db.commit()
        return recipe_id
        
    except Exception as e:
        db.rollback()
        print(f"Error creating recipe: {e}")
        raise e
    finally:
        cursor.close()

# ==================== IMPORT ROUTES ====================

@app.route('/import')
def import_route():
    import subprocess
    result = subprocess.run(['python', 'import_recipes.py'], capture_output=True, text=True)
    return f"<pre>{result.stdout}\n\n{result.stderr}</pre>"

@app.route('/reimport')
def reimport():
    import subprocess
    result = subprocess.run(['python3', 'import_recipes.py'], capture_output=True, text=True, cwd='/app')
    return f"<pre>STDOUT:\n{result.stdout}\n\nSTDERR:\n{result.stderr}</pre>"

@app.route('/create-tables')
def create_tables():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    # Create recent_views table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS recent_views (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    cur.close()
    conn.close()
    
    return "✅ recent_views table created successfully!"

@app.route('/create-missing-tables')
def create_missing_tables():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    # Create completed_recipes table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS completed_recipes (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, recipe_id)
        )
    ''')
    
    # Create user_titles table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS user_titles (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            title_key VARCHAR(50) NOT NULL,
            title_name VARCHAR(100) NOT NULL,
            is_active BOOLEAN DEFAULT FALSE,
            unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, title_key)
        )
    ''')
    
    conn.commit()
    cur.close()
    conn.close()
    
    return "✅ completed_recipes and user_titles tables created successfully!"

@app.route('/create-all-tables')
def create_all_tables():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    # Create completed_recipes table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS completed_recipes (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, recipe_id)
        )
    ''')
    
    # Create user_titles table
    cur.execute('''
        CREATE TABLE IF NOT EXISTS user_titles (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            title_key VARCHAR(50) NOT NULL,
            title_name VARCHAR(100) NOT NULL,
            is_active BOOLEAN DEFAULT FALSE,
            unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, title_key)
        )
    ''')
    
    # Create folder_recipes table (this is the missing one!)
    cur.execute('''
        CREATE TABLE IF NOT EXISTS folder_recipes (
            id SERIAL PRIMARY KEY,
            folder_id INTEGER REFERENCES recipe_folders(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(folder_id, recipe_id)
        )
    ''')
    
    # Create recent_views table (if not exists)
    cur.execute('''
        CREATE TABLE IF NOT EXISTS recent_views (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    cur.close()
    conn.close()
    
    return """
    <h2>✅ All tables created successfully!</h2>
    <ul>
        <li>completed_recipes</li>
        <li>user_titles</li>
        <li>folder_recipes</li>
        <li>recent_views</li>
    </ul>
    """

@app.route('/fix-folder-tables')
def fix_folder_tables():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    # Check what columns exist in folder_recipes
    try:
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'folder_recipes'")
        columns = cur.fetchall()
        result = "Existing columns in folder_recipes:<br>"
        for col in columns:
            result += f"- {col[0]}<br>"
    except Exception as e:
        result = f"Error checking columns: {e}<br>"
    
    # Recreate folder_recipes table properly
    try:
        cur.execute("DROP TABLE IF EXISTS folder_recipes CASCADE")
        cur.execute('''
            CREATE TABLE folder_recipes (
                id SERIAL PRIMARY KEY,
                folder_id INTEGER REFERENCES recipe_folders(id) ON DELETE CASCADE,
                recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        result += "<br>✅ folder_recipes table recreated successfully!"
    except Exception as e:
        result += f"<br>❌ Error recreating table: {e}"
    
    conn.commit()
    cur.close()
    conn.close()
    
    return result

@app.route('/check-folders')
def check_folders():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    result = "<h3>Recipe Folders:</h3>"
    cur.execute("SELECT id, folder_name, user_id FROM recipe_folders")
    folders = cur.fetchall()
    for f in folders:
        result += f"ID: {f[0]}, Name: {f[1]}, User: {f[2]}<br>"
    
    result += "<h3>Folder Recipes:</h3>"
    cur.execute("SELECT * FROM folder_recipes")
    fr = cur.fetchall()
    for row in fr:
        result += f"{row}<br>"
    
    cur.close()
    conn.close()
    
    return result

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)