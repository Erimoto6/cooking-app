from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from database import *
import psycopg2.extras
import hashlib
import os
import sys

app = Flask(__name__)
app.secret_key = 'whats_cookin_secret_key_2024'

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
            flash('Account created successfully! Please login.', 'success')
            return redirect(url_for('login'))
        except Exception:
            db.rollback()
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
    
    # Get folders - using proper dictionary access
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
    
    # Get recent views
    cursor.execute("""
        SELECT r.* FROM recent_views rv
        JOIN recipes r ON rv.recipe_id = r.id
        WHERE rv.user_id = %s
        ORDER BY rv.viewed_at DESC
        LIMIT 5
    """, (session['user_id'],))
    recent_views = cursor.fetchall()
    
    # Use recent_views if available, otherwise use recent_recipes
    display_recipes = recent_views if recent_views else recent_recipes
    
    return render_template('index.html', 
                           username=session.get('username'),
                           recent_recipes=display_recipes,
                           favorite_dishes=favorite_dishes,
                           folders=folders_list)

@app.route('/cuisine/<cuisine>')
def view_cuisine(cuisine):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    cursor.execute('SELECT DISTINCT region FROM recipes WHERE cuisine = %s ORDER BY region', (cuisine,))
    regions = cursor.fetchall()
    
    recipes_by_region = {}
    for region in regions:
        region_name = region['region']
        cursor.execute('SELECT * FROM recipes WHERE cuisine = %s AND region = %s ORDER BY title', 
                      (cuisine, region_name))
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
    
    # Track this view - DON'T close the connection manually
    try:
        db = get_db()
        cur = db.cursor()
        cur.execute("""
            DELETE FROM recent_views 
            WHERE user_id = %s AND recipe_id = %s
        """, (session['user_id'], recipe['id']))
        cur.execute("""
            INSERT INTO recent_views (user_id, recipe_id) 
            VALUES (%s, %s)
        """, (session['user_id'], recipe['id']))
        db.commit()
        # DON'T close cur or db here - let Flask manage it
    except Exception as e:
        print(f"Track view error (non-fatal): {e}")
    
    # Use get_cursor for the favorites query
    cursor = get_cursor()
    cursor.execute("""
        SELECT * FROM favorites 
        WHERE user_id = %s AND recipe_id = %s
    """, (session['user_id'], recipe['id']))
    is_favorite = cursor.fetchone() is not None
    # DON'T close cursor here
    
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
        title = request.form.get('title')
        description = request.form.get('description')
        cuisine = request.form.get('cuisine')
        region = request.form.get('region')
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
        
        recipe_id = create_custom_recipe(
            session['user_id'], title, description, cuisine, region,
            int(prep_time) if prep_time else 0,
            int(cook_time) if cook_time else 0,
            difficulty, ingredients, steps
        )
        
        flash('Recipe created successfully!', 'success')
        return redirect(url_for('view_recipe_by_id', recipe_id=recipe_id))
    
    return render_template('create_recipe.html')

@app.route('/recipe/id/<int:recipe_id>')
def view_recipe_by_id(recipe_id):
    """Fallback route for custom recipes that only have numeric ID"""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    recipe = get_recipe_by_id(recipe_id)
    
    cursor = get_cursor()
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND recipe_id = %s', 
                  (session['user_id'], recipe_id))
    is_favorite = cursor.fetchone() is not None
    
    return render_template('recipe_detail.html', recipe=recipe, is_favorite=is_favorite)

@app.route('/shopping_list')
def view_shopping_list_old():
    """Legacy shopping list route - redirect to new one"""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    return redirect(url_for('view_shopping_list'))

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
def toggle_shopping_item_route_old(item_id):
    """Legacy GET route - redirect to POST version"""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    toggle_shopping_item(item_id)
    return redirect(url_for('view_shopping_list'))

@app.route('/remove_shopping_item/<int:item_id>')
def remove_shopping_item_route_old(item_id):
    """Legacy GET route - redirect to POST version"""
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

# ============ SHOPPING LIST ROUTES (NEW) ============

@app.route('/toggle_shopping_item/<int:item_id>', methods=['POST'])
def toggle_shopping_item(item_id):
    """Toggle checkbox status of a shopping list item"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT checked FROM shopping_list 
            WHERE id = %s AND user_id = %s
        """, (item_id, session['user_id']))
        
        result = cur.fetchone()
        if result:
            new_status = not result[0]
            cur.execute("""
                UPDATE shopping_list 
                SET checked = %s 
                WHERE id = %s AND user_id = %s
            """, (new_status, item_id, session['user_id']))
            conn.commit()
            
        cur.close()
        conn.close()
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Error toggling item: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/remove_shopping_item/<int:item_id>', methods=['POST'])
def remove_shopping_item(item_id):
    """Remove a single item from shopping list"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            DELETE FROM shopping_list 
            WHERE id = %s AND user_id = %s
        """, (item_id, session['user_id']))
        conn.commit()
        
        cur.close()
        conn.close()
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Error removing item: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/clear_shopping_list', methods=['POST'])
def clear_shopping_list():
    """Clear all items from shopping list"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            DELETE FROM shopping_list 
            WHERE user_id = %s
        """, (session['user_id'],))
        conn.commit()
        
        cur.close()
        conn.close()
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Error clearing shopping list: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

# ============ PROFILE MANAGEMENT ROUTES ============

@app.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    """Edit user profile (username, phone)"""
    if 'user_id' not in session:
        flash('Please login to edit your profile', 'error')
        return redirect(url_for('login'))
    
    conn = get_db()
    cur = conn.cursor()
    
    if request.method == 'POST':
        username = request.form.get('username')
        phone_number = request.form.get('phone_number')
        
        if not username or not phone_number:
            flash('All fields are required', 'error')
            return redirect(url_for('edit_profile'))
        
        try:
            cur.execute("""
                SELECT id FROM users 
                WHERE username = %s AND id != %s
            """, (username, session['user_id']))
            if cur.fetchone():
                flash('Username already taken', 'error')
                return redirect(url_for('edit_profile'))
            
            cur.execute("""
                SELECT id FROM users 
                WHERE phone_number = %s AND id != %s
            """, (phone_number, session['user_id']))
            if cur.fetchone():
                flash('Phone number already registered', 'error')
                return redirect(url_for('edit_profile'))
            
            cur.execute("""
                UPDATE users 
                SET username = %s, phone_number = %s 
                WHERE id = %s
            """, (username, phone_number, session['user_id']))
            conn.commit()
            
            session['username'] = username
            flash('Profile updated successfully!', 'success')
            return redirect(url_for('profile'))
            
        except Exception as e:
            conn.rollback()
            print(f"Edit profile error: {e}")
            flash('Error updating profile', 'error')
            return redirect(url_for('edit_profile'))
    
    cur.execute("""
        SELECT username, phone_number 
        FROM users 
        WHERE id = %s
    """, (session['user_id'],))
    user = cur.fetchone()
    
    cur.close()
    conn.close()
    
    if not user:
        flash('User not found', 'error')
        return redirect(url_for('profile'))
    
    user_data = {
        'username': user[0],
        'phone_number': user[1]
    }
    
    return render_template('edit_profile.html', user=user_data)

@app.route('/change_password', methods=['GET', 'POST'])
def change_password():
    """Change user password"""
    if 'user_id' not in session:
        flash('Please login to change your password', 'error')
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        current_password = request.form.get('current_password')
        new_password = request.form.get('new_password')
        confirm_password = request.form.get('confirm_password')
        
        # Validation
        if not current_password or not new_password or not confirm_password:
            flash('All fields are required', 'error')
            return redirect(url_for('change_password'))
        
        if new_password != confirm_password:
            flash('New passwords do not match', 'error')
            return redirect(url_for('change_password'))
        
        if len(new_password) < 4:
            flash('Password must be at least 4 characters', 'error')
            return redirect(url_for('change_password'))
        
        conn = get_db()
        cur = conn.cursor()
        
        # Verify current password
        current_hash = hash_password(current_password)
        cur.execute("SELECT id FROM users WHERE id = %s AND password = %s", 
                   (session['user_id'], current_hash))
        
        if not cur.fetchone():
            cur.close()
            conn.close()
            flash('Current password is incorrect', 'error')
            return redirect(url_for('change_password'))
        
        # Update password
        new_hash = hash_password(new_password)
        cur.execute("UPDATE users SET password = %s WHERE id = %s", 
                   (new_hash, session['user_id']))
        conn.commit()
        
        cur.close()
        conn.close()
        
        flash('Password changed successfully! Please login again.', 'success')
        session.clear()
        return redirect(url_for('login'))
    
    return render_template('change_password.html')

@app.route('/my_recipes')
def my_recipes():
    """View all recipes created by the user"""
    if 'user_id' not in session:
        flash('Please login to view your recipes', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT id, title, cuisine, region, category, prep_time, created_at
            FROM recipes 
            WHERE user_id = %s 
            ORDER BY created_at DESC
        """, (session['user_id'],))
        recipes = cur.fetchall()
        
        recipes_list = [
            {
                'id': r[0], 
                'title': r[1], 
                'cuisine': r[2] or 'Various',
                'region': r[3] or '',
                'category': r[4] or 'Recipe',
                'prep_time': r[5],
                'created_at': r[6]
            }
            for r in recipes
        ]
        
        cur.close()
        conn.close()
        
        return render_template('my_recipes.html', recipes=recipes_list)
        
    except Exception as e:
        print(f"My recipes error: {e}")
        flash('Error loading your recipes', 'error')
        return redirect(url_for('profile'))

@app.route('/favorites')
def favorites():
    """View all favorite recipes"""
    if 'user_id' not in session:
        flash('Please login to view your favorites', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT r.id, r.title, r.cuisine, r.region, r.category, r.prep_time
            FROM favorites f
            JOIN recipes r ON f.recipe_id = r.id
            WHERE f.user_id = %s
            ORDER BY f.created_at DESC
        """, (session['user_id'],))
        favorites = cur.fetchall()
        
        favorites_list = [
            {
                'id': r[0], 
                'title': r[1], 
                'cuisine': r[2] or 'Various',
                'region': r[3] or '',
                'category': r[4] or 'Recipe',
                'prep_time': r[5]
            }
            for r in favorites
        ]
        
        cur.close()
        conn.close()
        
        return render_template('favorites.html', favorites=favorites_list)
        
    except Exception as e:
        print(f"Favorites error: {e}")
        flash('Error loading favorites', 'error')
        return redirect(url_for('profile'))

@app.route('/view_shopping_list')
def view_shopping_list():
    """View shopping list page"""
    if 'user_id' not in session:
        flash('Please login to view your shopping list', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT id, ingredient_name, quantity, recipe_id, checked, added_at
            FROM shopping_list 
            WHERE user_id = %s 
            ORDER BY checked ASC, added_at DESC
        """, (session['user_id'],))
        items = cur.fetchall()
        
        shopping_items = [
            {
                'id': i[0],
                'name': i[1],
                'quantity': i[2] or '1 unit',
                'recipe_id': i[3],
                'checked': i[4],
                'added_at': i[5]
            }
            for i in items
        ]
        
        cur.close()
        conn.close()
        
        return render_template('shopping_list.html', shopping_items=shopping_items)
        
    except Exception as e:
        print(f"Shopping list error: {e}")
        flash('Error loading shopping list', 'error')
        return render_template('shopping_list.html', shopping_items=[])

@app.route('/achievements')
def achievements():
    """View user achievements and milestones"""
    if 'user_id' not in session:
        flash('Please login to view achievements', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("SELECT COUNT(*) FROM recipes WHERE user_id = %s", (session['user_id'],))
        recipe_count = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*) FROM favorites WHERE user_id = %s", (session['user_id'],))
        favorite_count = cur.fetchone()[0]
        
        milestones = {
            'recipe': [
                {'target': 5, 'title': '🥘 Apprentice Cook', 'description': 'Created 5 recipes', 'unlocked': recipe_count >= 5, 'current': recipe_count},
                {'target': 10, 'title': '🍳 Home Chef', 'description': 'Created 10 recipes', 'unlocked': recipe_count >= 10, 'current': recipe_count},
                {'target': 25, 'title': '👨‍🍳 Master Chef', 'description': 'Created 25 recipes', 'unlocked': recipe_count >= 25, 'current': recipe_count},
            ],
            'favorite': [
                {'target': 10, 'title': '❤️ Food Lover', 'description': 'Favorited 10 recipes', 'unlocked': favorite_count >= 10, 'current': favorite_count},
                {'target': 25, 'title': '⭐ Super Fan', 'description': 'Favorited 25 recipes', 'unlocked': favorite_count >= 25, 'current': favorite_count},
            ]
        }
        
        cur.close()
        conn.close()
        
        return render_template('achievements.html', 
                             milestones=milestones, 
                             recipe_count=recipe_count,
                             favorite_count=favorite_count)
        
    except Exception as e:
        print(f"Achievements error: {e}")
        flash('Error loading achievements', 'error')
        return redirect(url_for('profile'))

# ==================== PROFILE ROUTE (FIXED) ====================

@app.route('/profile')
def profile():
    """User profile page"""
    if 'user_id' not in session:
        flash('Please login to view your profile', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        # Get user info as DICTIONARY for template
        cur.execute("""
            SELECT id, username, phone_number 
            FROM users 
            WHERE id = %s
        """, (session['user_id'],))
        user_row = cur.fetchone()
        
        if not user_row:
            session.clear()
            flash('User not found', 'error')
            return redirect(url_for('login'))
        
        # Convert to dictionary so template can use user.username, user.phone_number
        user_dict = {
            'id': user_row[0],
            'username': user_row[1],
            'phone_number': user_row[2] if len(user_row) > 2 else ''
        }
        
        # Get user's created recipes count
        cur.execute("""
            SELECT COUNT(*) FROM recipes 
            WHERE user_id = %s
        """, (session['user_id'],))
        user_recipes_count = cur.fetchone()[0]
        
        # Get user's created recipes (for preview)
        cur.execute("""
            SELECT id, title, cuisine, category 
            FROM recipes 
            WHERE user_id = %s 
            ORDER BY created_at DESC 
            LIMIT 3
        """, (session['user_id'],))
        user_recipes = cur.fetchall()
        user_recipes_list = []
        for r in user_recipes:
            user_recipes_list.append({
                'id': r[0],
                'title': r[1],
                'cuisine': r[2] if r[2] else 'Various',
                'category': r[3] if r[3] else 'Recipe'
            })
        
        # Get favorite recipes count
        cur.execute("""
            SELECT COUNT(*) FROM favorites 
            WHERE user_id = %s
        """, (session['user_id'],))
        favorite_count = cur.fetchone()[0]
        
        # Get favorite recipes (for preview)
        cur.execute("""
            SELECT r.id, r.title, r.cuisine, r.category
            FROM favorites f
            JOIN recipes r ON f.recipe_id = r.id
            WHERE f.user_id = %s
            ORDER BY f.created_at DESC
            LIMIT 3
        """, (session['user_id'],))
        favorite_recipes = cur.fetchall()
        favorite_recipes_list = []
        for r in favorite_recipes:
            favorite_recipes_list.append({
                'id': r[0],
                'title': r[1],
                'cuisine': r[2] if r[2] else 'Various',
                'category': r[3] if r[3] else 'Recipe'
            })
        
        # Get shopping list count
        cur.execute("""
            SELECT COUNT(*) FROM shopping_list 
            WHERE user_id = %s AND checked = false
        """, (session['user_id'],))
        shopping_count = cur.fetchone()[0]
        
        cur.close()
        conn.close()
        
        return render_template('profile.html', 
                             user=user_dict,
                             user_recipes=user_recipes_list,
                             user_recipes_count=user_recipes_count,
                             favorite_recipes=favorite_recipes_list,
                             favorite_count=favorite_count,
                             shopping_count=shopping_count)
        
    except Exception as e:
        print(f"Profile error DETAIL: {e}")
        import traceback
        traceback.print_exc()
        flash('Error loading profile', 'error')
        return redirect(url_for('index'))
    
    # ============ RECENT VIEWED TRACKING ============

@app.route('/track_recent/<int:recipe_id>')
def track_recent(recipe_id):
    """Track recently viewed recipes"""
    if 'user_id' not in session:
        return jsonify({'success': False})
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        # Remove if already exists to move to top
        cur.execute("DELETE FROM recent_views WHERE user_id = %s AND recipe_id = %s",
                   (session['user_id'], recipe_id))
        
        # Add new view
        cur.execute("INSERT INTO recent_views (user_id, recipe_id) VALUES (%s, %s)",
                   (session['user_id'], recipe_id))
        
        # Keep only last 10
        cur.execute("""
            DELETE FROM recent_views 
            WHERE id IN (
                SELECT id FROM recent_views 
                WHERE user_id = %s 
                ORDER BY viewed_at DESC OFFSET 10
            )
        """, (session['user_id'],))
        
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Track recent error: {e}")
    
    return jsonify({'success': True})


@app.route('/recent_recipes')
def recent_recipes():
    """View all recently viewed recipes"""
    if 'user_id' not in session:
        flash('Please login to view recent recipes', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT r.* FROM recent_views rv
            JOIN recipes r ON rv.recipe_id = r.id
            WHERE rv.user_id = %s
            ORDER BY rv.viewed_at DESC
        """, (session['user_id'],))
        
        recent = cur.fetchall()
        cur.close()
        conn.close()
        
        return render_template('recent_recipes.html', recipes=recent)
    except Exception as e:
        print(f"Recent recipes error: {e}")
        flash('Error loading recent recipes', 'error')
        return redirect(url_for('index'))


# ============ RECIPE FOLDERS ============

@app.route('/create_folder', methods=['POST'])
def create_folder():
    """Create a new recipe folder"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    data = request.get_json()
    folder_name = data.get('name')
    
    if not folder_name:
        return jsonify({'success': False, 'error': 'Folder name required'}), 400
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        # Use 'folder_name' column, not 'name'
        cur.execute("""
            INSERT INTO recipe_folders (user_id, folder_name)
            VALUES (%s, %s)
            RETURNING id
        """, (session['user_id'], folder_name))
        folder_id = cur.fetchone()[0]
        conn.commit()
        
        cur.close()
        conn.close()
        
        return jsonify({'success': True, 'folder_id': folder_id})
        
    except Exception as e:
        print(f"Create folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/folder/<int:folder_id>')
def view_folder(folder_id):
    """View recipes in a folder"""
    if 'user_id' not in session:
        flash('Please login to view folder', 'error')
        return redirect(url_for('login'))
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        # Use 'folder_name' column
        cur.execute("SELECT folder_name FROM recipe_folders WHERE id = %s AND user_id = %s",
                   (folder_id, session['user_id']))
        folder = cur.fetchone()
        
        if not folder:
            flash('Folder not found', 'error')
            return redirect(url_for('index'))
        
        cur.execute("""
            SELECT r.* FROM folder_recipes fr
            JOIN recipes r ON fr.recipe_id = r.id
            WHERE fr.folder_id = %s AND fr.user_id = %s
            ORDER BY fr.added_at DESC
        """, (folder_id, session['user_id']))
        
        recipes = cur.fetchall()
        
        cur.close()
        conn.close()
        
        return render_template('folder_view.html', recipes=recipes, folder_name=folder[0])
    except Exception as e:
        print(f"View folder error: {e}")
        flash('Error loading folder', 'error')
        return redirect(url_for('index'))

@app.route('/add_to_folder/<int:recipe_id>', methods=['POST'])
def add_to_folder(recipe_id):
    """Add a recipe to a folder"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    data = request.get_json()
    folder_id = data.get('folder_id')
    
    if not folder_id:
        return jsonify({'success': False, 'error': 'Folder ID required'}), 400
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        # Check if already in folder
        cur.execute("""
            SELECT id FROM folder_recipes 
            WHERE folder_id = %s AND recipe_id = %s AND user_id = %s
        """, (folder_id, recipe_id, session['user_id']))
        
        if cur.fetchone():
            return jsonify({'success': False, 'error': 'Recipe already in folder'}), 400
        
        cur.execute("""
            INSERT INTO folder_recipes (folder_id, recipe_id, user_id)
            VALUES (%s, %s, %s)
        """, (folder_id, recipe_id, session['user_id']))
        conn.commit()
        
        cur.close()
        conn.close()
        
        return jsonify({'success': True})
    except Exception as e:
        print(f"Add to folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500
    
@app.route('/delete_folder/<int:folder_id>', methods=['DELETE'])
def delete_folder(folder_id):
    """Delete a recipe folder and its contents"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'Not logged in'}), 401
    
    try:
        conn = get_db()
        cur = conn.cursor()
        
        # Check if folder exists and belongs to user
        cur.execute("SELECT id FROM recipe_folders WHERE id = %s AND user_id = %s",
                   (folder_id, session['user_id']))
        folder = cur.fetchone()
        
        if not folder:
            return jsonify({'success': False, 'error': 'Folder not found'}), 404
        
        # Delete folder (cascade will delete folder_recipes entries automatically)
        cur.execute("DELETE FROM recipe_folders WHERE id = %s AND user_id = %s",
                   (folder_id, session['user_id']))
        conn.commit()
        
        cur.close()
        conn.close()
        
        return jsonify({'success': True})
        
    except Exception as e:
        print(f"Delete folder error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

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
    cursor = get_cursor()
    
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

if __name__ == '__main__':
    import threading
    import webbrowser
    import time
    
    if getattr(sys, 'frozen', False):
        base_path = os.path.dirname(sys.executable)
    else:
        base_path = os.path.dirname(__file__)
    
    instance_path = os.path.join(base_path, 'instance')
    os.makedirs(instance_path, exist_ok=True)
    
    with app.app_context():
        init_db()
    
    def open_browser():
        time.sleep(2)
        webbrowser.open('http://127.0.0.1:5000')
    
    browser_thread = threading.Thread(target=open_browser)
    browser_thread.daemon = True
    browser_thread.start()
    
    print("Starting What's Cookin' app...")
    print("Open your browser to: http://127.0.0.1:5000")
    app.run(host='127.0.0.1', debug=False, port=5000)