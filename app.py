from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from database import *
import psycopg2.extras
import hashlib
import os
import sys
import traceback

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

    # Get recent recipes
    cursor.execute("""
        SELECT * FROM recipes 
        WHERE is_private = FALSE OR user_id = %s
        ORDER BY created_at DESC 
        LIMIT 6
    """, (session['user_id'],))
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
        cursor.execute("""
            SELECT * FROM recipes 
            WHERE (is_private = FALSE OR user_id = %s)
            AND region IN ('Philippines', 'United States') 
            LIMIT 3
        """, (session['user_id'],))
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
            AND (r.is_private = FALSE OR r.user_id = %s)
            ORDER BY rv.viewed_at DESC
            LIMIT 5
        """, (session['user_id'], session['user_id']))
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

    # Map common variations to database values
    cuisine_map = {
        'Asian': 'Asians',
        'European': 'Europe',
        'Oceanian': 'Oceania',
        'North American': 'North America',
        'South American': 'South America',
    }
    
    # Use mapped value if exists, otherwise use original
    db_cuisine = cuisine_map.get(cuisine, cuisine)
    
    cursor = get_cursor()
    user_id = session['user_id']
    
    # Get distinct regions (only public OR user's own private recipes)
    cursor.execute("""
        SELECT DISTINCT region FROM recipes 
        WHERE cuisine = %s 
        AND (is_private = FALSE OR user_id = %s)
        AND region IS NOT NULL AND region != ''
        ORDER BY region
    """, (cuisine, user_id))
    regions = cursor.fetchall()
    
    recipes_by_region = {}
    
    for region in regions:
        region_name = region['region']
        cursor.execute("""
            SELECT * FROM recipes 
            WHERE cuisine = %s AND region = %s 
            AND (is_private = FALSE OR user_id = %s)
            ORDER BY title
        """, (cuisine, region_name, user_id))
        recipes_by_region[region_name] = cursor.fetchall()
    
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
        check_and_unlock_titles(session['user_id'])

    return jsonify({'success': True, 'is_favorite': is_favorite})

@app.route('/search')
def search():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    q = request.args.get('q', '')
    category = request.args.get('category', '')
    cuisine = request.args.get('cuisine', '')
    region = request.args.get('region', '')
    user_id = session['user_id']

    results = []
    if q or category or cuisine or region:
        # Only show: public recipes OR user's own private recipes
        conditions = ["(is_private = FALSE OR user_id = %s)"]
        params = [user_id]
        
        if q:
            conditions.append("(title ILIKE %s OR cuisine ILIKE %s OR region ILIKE %s)")
            params += [f'%{q}%', f'%{q}%', f'%{q}%']
        if category:
            conditions.append("category ILIKE %s")
            params.append(f'%{category}%')
        if cuisine:
            conditions.append("cuisine ILIKE %s")
            params.append(f'%{cuisine}%')
        if region:
            conditions.append("region ILIKE %s")
            params.append(f'%{region}%')
        
        where_clause = " AND ".join(conditions)
        sql = f"SELECT * FROM recipes WHERE {where_clause} ORDER BY title"
        results = query(sql, params)

    return render_template('search.html', results=results, query=q)

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
            image_url = request.form.get('image_url')

            ingredients = []
            ingredient_names = request.form.getlist('ingredient_name[]')
            ingredient_quantities = request.form.getlist('ingredient_quantity[]')
            for name, qty in zip(ingredient_names, ingredient_quantities):
                if name.strip():
                    ingredients.append({'name': name, 'quantity': qty})

            steps = request.form.getlist('step[]')
            steps = [s for s in steps if s.strip()]

            db = get_db()
            cur = db.cursor()

            cur.execute('''
                INSERT INTO recipes (title, description, cuisine, region, category, prep_time, cook_time, difficulty, user_id, created_at, image_url, is_private)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP, %s, TRUE)
                RETURNING id
            ''', (title, description, cuisine, region, category, 
                int(prep_time) if prep_time else 0,
                int(cook_time) if cook_time else 0,
                difficulty, session['user_id'], image_url))

            recipe_id = cur.fetchone()[0]

            for ing in ingredients:
                cur.execute('''
                    INSERT INTO ingredients (recipe_id, name, quantity)
                    VALUES (%s, %s, %s)
                ''', (recipe_id, ing['name'], ing['quantity']))

            for idx, step in enumerate(steps, 1):
                cur.execute('''
                    INSERT INTO steps (recipe_id, step_number, instruction)
                    VALUES (%s, %s, %s)
                ''', (recipe_id, idx, step))

            db.commit()
            cur.close()

            check_and_unlock_titles(session['user_id'])

            flash('Recipe created successfully!', 'success')
            return redirect(url_for('view_recipe_by_id', recipe_id=recipe_id))

        except Exception as e:
            print(f"Create recipe error: {e}")
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
    return render_template('shopping_list.html', shopping_items=items)

@app.route('/add_to_shopping_list', methods=['POST'])
def add_to_shopping_list_route():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401

    data = request.get_json()
    ingredient_name = data.get('ingredient_name')
    quantity = data.get('quantity', '')
    recipe_id = data.get('recipe_id')

    add_to_shopping_list(session['user_id'], ingredient_name, quantity, recipe_id)
    return jsonify({'success': True})

@app.route('/toggle_shopping_item/<int:item_id>', methods=['POST'])
def toggle_shopping_item_route(item_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    toggle_shopping_item(item_id)
    return jsonify({'success': True})


@app.route('/remove_shopping_item/<int:item_id>', methods=['POST'])
def remove_shopping_item_route(item_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    remove_from_shopping_list(item_id)
    return jsonify({'success': True})


@app.route('/clear_shopping_list', methods=['POST'])
def clear_shopping_list_route():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    db = get_db()
    cursor = db.cursor()
    cursor.execute("DELETE FROM shopping_list WHERE user_id = %s", (session['user_id'],))
    db.commit()
    return jsonify({'success': True})

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

    db = get_db()
    cur = db.cursor()

    cur.execute("SELECT COUNT(*) FROM recipes WHERE user_id = %s", (session['user_id'],))
    recipe_count = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM favorites WHERE user_id = %s", (session['user_id'],))
    favorite_count = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM completed_recipes WHERE user_id = %s", (session['user_id'],))
    completed_count = cur.fetchone()[0]

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

        cur.execute("UPDATE user_titles SET is_active = false WHERE user_id = %s", (session['user_id'],))

        cur.execute("""
            UPDATE user_titles SET is_active = true 
            WHERE user_id = %s AND title_key = %s
        """, (session['user_id'], title_key))

        db.commit()
        cur.close()

        return jsonify({'success': True})

    except Exception as e:
        print(f"Equip title error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

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

    cursor.execute("SELECT COUNT(*) as count FROM recipes WHERE user_id = %s", (user_id,))
    recipe_result = cursor.fetchone()
    recipe_count = recipe_result['count'] if recipe_result else 0

    cursor.execute("SELECT COUNT(*) as count FROM favorites WHERE user_id = %s", (user_id,))
    favorite_result = cursor.fetchone()
    favorite_count = favorite_result['count'] if favorite_result else 0

    cursor.execute("SELECT COUNT(*) as count FROM completed_recipes WHERE user_id = %s", (user_id,))
    completed_result = cursor.fetchone()
    completed_count = completed_result['count'] if completed_result else 0

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
            cur.execute("SELECT id FROM user_titles WHERE user_id = %s AND title_key = %s", 
                       (user_id, title_key))
            if not cur.fetchone():
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

    user_id = session['user_id']
    
    try:
        cursor = get_cursor()
        cursor.execute("""
            SELECT r.* FROM recent_views rv
            JOIN recipes r ON rv.recipe_id = r.id
            WHERE rv.user_id = %s
            AND (r.is_private = FALSE OR r.user_id = %s)
            ORDER BY rv.viewed_at DESC
        """, (user_id, user_id))
        recipes = cursor.fetchall()
        return render_template('recent_recipes.html', recipes=recipes)
    except Exception as e:
        print(f"Recent recipes error: {e}")
        cursor = get_cursor()
        cursor.execute("""
            SELECT * FROM recipes 
            WHERE is_private = FALSE OR user_id = %s
            ORDER BY created_at DESC 
            LIMIT 20
        """, (user_id,))
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
        return render_template('completed_recipes.html', recipes=[])

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
        cursor.execute("SELECT id, folder_name FROM recipe_folders WHERE id = %s AND user_id = %s",
                      (folder_id, session['user_id']))
        folder = cursor.fetchone()

        if not folder:
            flash('Folder not found', 'error')
            return redirect(url_for('index'))

        # Get recipes in this folder
        cursor.execute("""
            SELECT r.*, fr.added_at 
            FROM folder_recipes fr
            JOIN recipes r ON fr.recipe_id = r.id
            WHERE fr.folder_id = %s AND fr.user_id = %s
            ORDER BY fr.added_at DESC
        """, (folder_id, session['user_id']))
        recipes = cursor.fetchall()

        return render_template('folder_view.html', 
                             recipes=recipes, 
                             folder_name=folder['folder_name'],
                             folder_id=folder_id)
    except Exception as e:
        print(f"View folder error: {e}")
        traceback.print_exc()
        flash(f'Error loading folder: {str(e)}', 'error')
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

@app.route('/check_recipe_in_folder/<int:recipe_id>/<int:folder_id>')
def check_recipe_in_folder(recipe_id, folder_id):
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

@app.route('/get_recipe_folders/<int:recipe_id>')
def get_recipe_folders(recipe_id):
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

@app.route('/remove_from_folder/<int:recipe_id>/<int:folder_id>', methods=['DELETE'])
def remove_from_folder(recipe_id, folder_id):
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

    recipe = get_recipe_by_id(recipe_id)

    if not recipe:
        flash('Recipe not found', 'error')
        return redirect(url_for('index'))

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
            image_url = request.form.get('image_url')

            db = get_db()
            cur = db.cursor()
            cur.execute("""
                UPDATE recipes 
                SET title = %s, description = %s, cuisine = %s, region = %s, 
                    category = %s, prep_time = %s, cook_time = %s, difficulty = %s,
                    image_url = %s
                WHERE id = %s AND user_id = %s
            """, (title, description, cuisine, region, category, 
                  int(prep_time) if prep_time else 0,
                  int(cook_time) if cook_time else 0,
                  difficulty, image_url, recipe_id, session['user_id']))

            cur.execute("DELETE FROM ingredients WHERE recipe_id = %s", (recipe_id,))

            ingredient_names = request.form.getlist('ingredient_name[]')
            ingredient_quantities = request.form.getlist('ingredient_quantity[]')
            for name, qty in zip(ingredient_names, ingredient_quantities):
                if name.strip():
                    cur.execute("""
                        INSERT INTO ingredients (recipe_id, name, quantity)
                        VALUES (%s, %s, %s)
                    """, (recipe_id, name.strip(), qty.strip()))

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

        cur.execute("SELECT id FROM recipes WHERE id = %s AND user_id = %s", 
                   (recipe_id, session['user_id']))
        if not cur.fetchone():
            return jsonify({'success': False, 'error': 'You can only delete your own recipes'}), 403

        cur.execute("DELETE FROM ingredients WHERE recipe_id = %s", (recipe_id,))
        cur.execute("DELETE FROM steps WHERE recipe_id = %s", (recipe_id,))
        cur.execute("DELETE FROM favorites WHERE recipe_id = %s", (recipe_id,))
        cur.execute("DELETE FROM folder_recipes WHERE recipe_id = %s", (recipe_id,))
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

        cur.execute("""
            SELECT id FROM completed_recipes 
            WHERE user_id = %s AND recipe_id = %s
        """, (session['user_id'], recipe_id))

        if cur.fetchone():
            return jsonify({'success': False, 'error': 'Recipe already marked as done'}), 400

        cur.execute("""
            INSERT INTO completed_recipes (user_id, recipe_id)
            VALUES (%s, %s)
        """, (session['user_id'], recipe_id))
        db.commit()

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

def create_custom_recipe(user_id, title, description, cuisine, region, prep_time, cook_time, difficulty, ingredients, steps):
    db = get_db()
    cursor = db.cursor()

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

# ==================== DATABASE SETUP ROUTES ====================

@app.route('/add-image-column')
def add_image_column():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        cur.execute("ALTER TABLE recipes ADD COLUMN IF NOT EXISTS image_url TEXT")
        conn.commit()
        result = "✅ image_url column added successfully!"
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

@app.route('/create-all-tables')
def create_all_tables():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()

    tables = [
        '''
        CREATE TABLE IF NOT EXISTS completed_recipes (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, recipe_id)
        )
        ''',
        '''
        CREATE TABLE IF NOT EXISTS user_titles (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            title_key VARCHAR(50) NOT NULL,
            title_name VARCHAR(100) NOT NULL,
            is_active BOOLEAN DEFAULT FALSE,
            unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, title_key)
        )
        ''',
        '''
        CREATE TABLE IF NOT EXISTS folder_recipes (
            id SERIAL PRIMARY KEY,
            folder_id INTEGER REFERENCES recipe_folders(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(folder_id, recipe_id)
        )
        ''',
        '''
        CREATE TABLE IF NOT EXISTS recent_views (
            id SERIAL PRIMARY KEY,
            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
            recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
            viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        '''
    ]

    for table_sql in tables:
        try:
            cur.execute(table_sql)
        except Exception as e:
            print(f"Table creation error (may already exist): {e}")

    conn.commit()
    cur.close()
    conn.close()

    return "✅ All tables created successfully!"

@app.route('/debug-cuisines')
def debug_cuisines():
    if 'user_id' not in session:
        return "Please login first"
    
    cursor = get_cursor()
    cursor.execute("SELECT DISTINCT cuisine FROM recipes ORDER BY cuisine")
    results = cursor.fetchall()
    
    output = "<h3>Distinct Cuisine Values in Database:</h3><ul>"
    for row in results:
        output += f"<li>'{row['cuisine']}'</li>"
    output += "</ul>"
    
    # Also check if 'Asians' exists
    cursor.execute("SELECT COUNT(*) as count FROM recipes WHERE cuisine = 'Asians'")
    asians_count = cursor.fetchone()
    output += f"<p>Recipes with cuisine='Asians': {asians_count['count']}</p>"
    
    cursor.execute("SELECT COUNT(*) as count FROM recipes WHERE cuisine = 'Asian'")
    asian_count = cursor.fetchone()
    output += f"<p>Recipes with cuisine='Asian': {asian_count['count']}</p>"
    
    return output

@app.route('/create-cuisine-template')
def create_cuisine_template():
    import os
    
    template_content = '''{% extends "base.html" %}
{% block title %}{{ cuisine }} - Dishly{% endblock %}

{% block styles %}
<style>
  @keyframes cv-float1 {
    0%,100% { transform: translate(0,0) scale(1); }
    50% { transform: translate(20px,-30px) scale(1.08); }
  }
  @keyframes cv-fadeUp {
    from { opacity: 0; transform: translateY(16px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  .cv-screen {
    min-height: 100vh;
    background: #0f0500;
    padding: 44px 20px 100px;
    position: relative;
    overflow: hidden;
  }

  .cv-blob1 {
    position: absolute;
    width: 280px; height: 280px;
    border-radius: 50%;
    background: radial-gradient(circle, #6B1A00 0%, transparent 70%);
    top: -80px; right: -60px;
    animation: cv-float1 9s ease-in-out infinite;
    opacity: 0.5;
    pointer-events: none;
  }

  .cv-overlay {
    position: absolute;
    inset: 0;
    background: rgba(5,1,0,0.55);
    pointer-events: none;
  }

  .cv-back {
    position: relative;
    z-index: 1;
    color: rgba(255,255,255,0.5);
    text-decoration: none;
    font-size: 13px;
    display: inline-block;
    margin-bottom: 16px;
    animation: cv-fadeUp 0.5s ease forwards;
  }

  .cv-header {
    position: relative;
    z-index: 1;
    margin-bottom: 20px;
    animation: cv-fadeUp 0.5s ease 0.1s both;
  }

  .cv-eyebrow {
    color: rgba(255,255,255,0.4);
    font-size: 11px;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin: 0 0 2px;
  }

  .cv-title {
    color: #ffffff;
    font-size: 32px;
    font-family: 'Georgia', serif;
    font-style: italic;
    font-weight: bold;
    margin: 0 0 4px;
  }

  .cv-count {
    color: rgba(255,255,255,0.35);
    font-size: 12px;
    margin: 0;
  }

  .cv-filters {
    position: relative;
    z-index: 1;
    display: flex;
    gap: 8px;
    overflow-x: auto;
    scrollbar-width: none;
    margin-bottom: 24px;
    padding-bottom: 2px;
    animation: cv-fadeUp 0.5s ease 0.15s both;
  }

  .cv-filters::-webkit-scrollbar { display: none; }

  .cv-filter-btn {
    flex-shrink: 0;
    padding: 7px 16px;
    border-radius: 20px;
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.12);
    font-size: 12px;
    color: rgba(255,255,255,0.6);
    cursor: pointer;
    transition: all 0.2s;
  }

  .cv-filter-btn.active {
    background: #C0392B;
    border-color: #C0392B;
    color: #ffffff;
    font-weight: 500;
  }

  .cv-region-label {
    position: relative;
    z-index: 1;
    color: rgba(255,255,255,0.4);
    font-size: 11px;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin: 0 0 12px;
  }

  .cv-grid {
    position: relative;
    z-index: 1;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
    margin-bottom: 28px;
  }

  .cv-card {
    border-radius: 14px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.08);
    overflow: hidden;
    text-decoration: none;
    transition: background 0.2s;
    display: block;
  }

  .cv-card:active {
    background: rgba(255,255,255,0.1);
  }

  .cv-card-thumb {
    height: 75px;
    background: rgba(255,255,255,0.04);
  }

  .cv-card-body {
    padding: 10px;
  }

  .cv-card-title {
    color: #ffffff;
    font-size: 12px;
    font-weight: 500;
    margin: 0 0 3px;
  }

  .cv-card-meta {
    color: rgba(255,255,255,0.35);
    font-size: 10px;
    margin: 0 0 6px;
  }

  .cv-badge {
    display: inline-block;
    font-size: 10px;
    padding: 2px 8px;
    border-radius: 10px;
  }

  .cv-badge-main    { background: rgba(192,57,43,0.2);  color: rgba(255,120,100,0.9); }
  .cv-badge-dessert { background: rgba(150,30,192,0.2); color: rgba(200,100,255,0.9); }
  .cv-badge-beverage{ background: rgba(30,150,100,0.2); color: rgba(80,200,150,0.9);  }
  .cv-badge-soup    { background: rgba(30,80,192,0.2);  color: rgba(100,150,255,0.9); }
  .cv-badge-other   { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.5); }

  .cv-empty {
    position: relative;
    z-index: 1;
    text-align: center;
    padding: 40px 20px;
    color: rgba(255,255,255,0.3);
    font-size: 13px;
  }

  .cv-section-anim { animation: cv-fadeUp 0.5s ease 0.2s both; }
</style>

<script>
  function filterRecipes(category) {
    var activeBtn = event.target;
    document.querySelectorAll('.cv-filter-btn').forEach(function(btn) {
      btn.classList.remove('active');
    });
    activeBtn.classList.add('active');

    document.querySelectorAll('.cv-card').forEach(function(card) {
      if (category === 'All' || card.getAttribute('data-category') === category) {
        card.style.display = 'block';
      } else {
        card.style.display = 'none';
      }
    });

    document.querySelectorAll('.cv-region-block').forEach(function(block) {
      var visibleCards = block.querySelectorAll('.cv-card:not([style*="display: none"])');
      block.style.display = visibleCards.length > 0 ? 'block' : 'none';
    });
  }
</script>
{% endblock %}

{% block content %}
<div class="cv-screen">
  <div class="cv-blob1"></div>
  <div class="cv-overlay"></div>

  <a href="{{ url_for('index') }}" class="cv-back">← Back</a>

  <div class="cv-header">
    <p class="cv-eyebrow">Cuisine</p>
    <h1 class="cv-title">{{ cuisine }}</h1>
    <p class="cv-count">
      {% set total = namespace(count=0) %}
      {% for region in regions %}
        {% set total.count = total.count + recipes_by_region[region.region]|length %}
      {% endfor %}
      {{ total.count }} recipe{{ 's' if total.count != 1 }} available
    </p>
  </div>

  <div class="cv-filters">
    <button class="cv-filter-btn active" onclick="filterRecipes('All')">All</button>
    <button class="cv-filter-btn" onclick="filterRecipes('Main Course')">Main Courses</button>
    <button class="cv-filter-btn" onclick="filterRecipes('Dessert')">Desserts</button>
    <button class="cv-filter-btn" onclick="filterRecipes('Beverage')">Beverages</button>
  </div>

  {% for region in regions %}
  <div class="cv-region-block cv-section-anim">
    <p class="cv-region-label">{{ region.region }}</p>
    <div class="cv-grid">
      {% for recipe in recipes_by_region[region.region] %}
      <a href="{{ url_for('view_recipe_by_id', recipe_id=recipe.id) }}"
         class="cv-card"
         data-category="{{ recipe.category or 'Other' }}">
        <div class="cv-card-thumb"></div>
        <div class="cv-card-body">
          <p class="cv-card-title">{{ recipe.title }}</p>
          <p class="cv-card-meta">
            {{ recipe.category or 'Other' }} ·
            {{ (recipe.prep_time or 0) + (recipe.cook_time or 0) }} min
          </p>
          {% set cat = recipe.category or 'Other' %}
          {% if cat == 'Main Course' %}
            <span class="cv-badge cv-badge-main">Main Course</span>
          {% elif cat == 'Dessert' %}
            <span class="cv-badge cv-badge-dessert">Dessert</span>
          {% elif cat == 'Beverage' %}
            <span class="cv-badge cv-badge-beverage">Beverage</span>
          {% elif cat == 'Soup' %}
            <span class="cv-badge cv-badge-soup">Soup</span>
          {% else %}
            <span class="cv-badge cv-badge-other">{{ cat }}</span>
          {% endif %}
        </div>
      </a>
      {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="cv-empty">No recipes found for this cuisine yet.</div>
  {% endfor %}

</div>
{% endblock %}'''
    
    os.makedirs('templates', exist_ok=True)
    
    with open('templates/cuisine_view.html', 'w') as f:
        f.write(template_content)
    
    return "✅ Original cuisine_view.html restored!"

@app.route('/add-private-column')
def add_private_column():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        cur.execute("ALTER TABLE recipes ADD COLUMN IF NOT EXISTS is_private BOOLEAN DEFAULT TRUE")
        conn.commit()
        result = "✅ is_private column added! User-created recipes will now be private by default."
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

@app.route('/fix-public-recipes')
def fix_public_recipes():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        # Set all recipes with NULL is_private to FALSE (public)
        cur.execute("UPDATE recipes SET is_private = FALSE WHERE is_private IS NULL")
        conn.commit()
        
        # Check how many were updated
        cur.execute("SELECT COUNT(*) FROM recipes WHERE is_private = FALSE")
        public_count = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*) FROM recipes WHERE is_private = TRUE")
        private_count = cur.fetchone()[0]
        
        result = f"""
        <h3>✅ Fixed!</h3>
        <p>Public recipes (is_private = FALSE): {public_count}</p>
        <p>Private recipes (is_private = TRUE): {private_count}</p>
        <p>Now go back to the homepage and refresh.</p>
        """
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

@app.route('/make-imported-public')
def make_imported_public():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        # Set ALL recipes to FALSE first (public)
        cur.execute("UPDATE recipes SET is_private = FALSE")
        conn.commit()
        
        cur.execute("SELECT COUNT(*) FROM recipes")
        total = cur.fetchone()[0]
        
        result = f"""
        <h3>✅ All {total} recipes are now public!</h3>
        <p>Now go back to the homepage and refresh.</p>
        <p>New recipes you create will automatically be private.</p>
        """
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

@app.route('/debug-asian')
def debug_asian():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    import psycopg2
    import os
    import traceback
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    result = "<h3>Debugging Asian Cuisine</h3>"
    
    try:
        # Check if is_private column exists
        cur.execute("""
            SELECT column_name FROM information_schema.columns 
            WHERE table_name = 'recipes' AND column_name = 'is_private'
        """)
        col_exists = cur.fetchone()
        result += f"<p>is_private column exists: {col_exists is not None}</p>"
        
        # Try the query that's failing
        user_id = session['user_id']
        cuisine = 'Asians'
        
        cur.execute("""
            SELECT DISTINCT region FROM recipes 
            WHERE cuisine = %s 
            AND (is_private = FALSE OR user_id = %s)
            AND region IS NOT NULL AND region != ''
            ORDER BY region
        """, (cuisine, user_id))
        regions = cur.fetchall()
        result += f"<p>Regions found: {len(regions)}</p>"
        
        for region in regions:
            result += f"<p>Region: {region[0]}</p>"
        
    except Exception as e:
        result += f"<p style='color:red'>Error: {e}</p>"
        result += f"<pre>{traceback.format_exc()}</pre>"
    
    cur.close()
    conn.close()
    return result

@app.route('/debug-asian-error')
def debug_asian_error():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    import traceback
    import psycopg2
    import os
    
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    result = "<h3>Debugging Asian Cuisine Error</h3>"
    
    try:
        cuisine = 'Asian'
        user_id = session['user_id']
        
        # Check what cuisine values exist
        cur.execute("SELECT DISTINCT cuisine FROM recipes")
        cuisines = cur.fetchall()
        result += "<p><strong>Cuisines in database:</strong></p><ul>"
        for c in cuisines:
            result += f"<li>'{c[0]}'</li>"
        result += "</ul>"
        
        # Try the query that's failing
        cur.execute("""
            SELECT DISTINCT region FROM recipes 
            WHERE cuisine = %s 
            AND region IS NOT NULL AND region != ''
            ORDER BY region
        """, (cuisine,))
        regions = cur.fetchall()
        result += f"<p>Regions found for '{cuisine}': {len(regions)}</p>"
        
        for region in regions:
            result += f"<p>Region: {region[0]}</p>"
        
    except Exception as e:
        result += f"<p style='color:red'>Error: {e}</p>"
        result += f"<pre>{traceback.format_exc()}</pre>"
    
    cur.close()
    conn.close()
    return result

@app.route('/test-asian')
def test_asian():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    cursor.execute("SELECT * FROM recipes WHERE cuisine = 'Asian' LIMIT 5")
    recipes = cursor.fetchall()
    
    result = "<h3>Test Asian Cuisine</h3>"
    result += f"<p>Found {len(recipes)} recipes</p>"
    for r in recipes:
        result += f"<p>{r['title']} - {r['region']}</p>"
    
    return result

@app.route('/fix-asian-cuisine')
def fix_asian_cuisine():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        # Update all recipes with cuisine = 'Asians' to 'Asian'
        cur.execute("UPDATE recipes SET cuisine = 'Asian' WHERE cuisine = 'Asians'")
        conn.commit()
        count = cur.rowcount
        result = f"✅ Updated {count} recipes from 'Asians' to 'Asian'"
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

@app.route('/debug-shopping')
def debug_shopping():
    if 'user_id' not in session:
        return "Not logged in"
    
    items = get_shopping_list(session['user_id'])
    result = "<h3>Shopping List Debug</h3>"
    for item in items:
        result += f"<p>Item: {item}</p>"
    return result

@app.route('/sync-images')
def sync_images():
    if 'user_id' not in session:
        return "Please login first", 401
    
    import cloudinary
    import cloudinary.api
    
    cloudinary.config(
        cloud_name="dybaojdge",
        api_key="324229828458714",
        api_secret="O_4BAZfVhMYWdsr1pbQeOYEgvYE"
    )
    
    # Get all images from Cloudinary
    result = cloudinary.api.resources(type="upload", prefix="cooking_app", max_results=500)
    
    # Create mapping
    image_map = {}
    for resource in result['resources']:
        public_id = resource['public_id']
        filename = public_id.split('/')[-1].replace('.jpg', '').replace('.jpeg', '').replace('.png', '')
        image_map[filename.lower()] = resource['secure_url']
    
    # Update recipes
    cursor = get_cursor()
    updated = 0
    for img_name, url in image_map.items():
        cursor.execute("UPDATE recipes SET image_url = %s WHERE title ILIKE %s AND image_url IS NULL", 
                      (url, f'%{img_name}%'))
        updated += cursor.rowcount
    
    return f"Updated {updated} recipes with images!"
@app.route('/make-my-recipes-private')
def make_my_recipes_private():
    if 'user_id' not in session:
        return "Please login first"
    
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        # Set ALL recipes created by current user to private
        cur.execute("UPDATE recipes SET is_private = TRUE WHERE user_id = %s", (session['user_id'],))
        conn.commit()
        count = cur.rowcount
        result = f"✅ Updated {count} of your recipes to private (only visible to you)"
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

@app.route('/debug-private-status')
def debug_private_status():
    if 'user_id' not in session:
        return "Please login first"
    
    cursor = get_cursor()
    cursor.execute("SELECT id, title, is_private FROM recipes WHERE user_id = %s ORDER BY id DESC LIMIT 5", (session['user_id'],))
    recipes = cursor.fetchall()
    
    result = "<h3>Your recent recipes:</h3>"
    for r in recipes:
        result += f"<p>ID: {r['id']} - {r['title']} - is_private: {r['is_private']}</p>"
    
    return result

@app.route('/fix-imported-public')
def fix_imported_public():
    import psycopg2
    import os
    database_url = os.environ.get('DATABASE_URL')
    conn = psycopg2.connect(database_url)
    cur = conn.cursor()
    
    try:
        # Set recipes where user_id IS NULL (imported) to public
        cur.execute("UPDATE recipes SET is_private = FALSE WHERE user_id IS NULL OR is_private IS NULL")
        conn.commit()
        count = cur.rowcount
        result = f"✅ Updated {count} imported recipes to public (is_private = FALSE)"
    except Exception as e:
        result = f"❌ Error: {e}"
    
    cur.close()
    conn.close()
    return result

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)