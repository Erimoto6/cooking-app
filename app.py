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
    
    cursor.execute('SELECT * FROM recipes ORDER BY created_at DESC LIMIT 6')
    recent_recipes = cursor.fetchall()
    
    cursor.execute("SELECT * FROM recipes WHERE region IN ('Philippines', 'United States') LIMIT 3")
    favorite_dishes = cursor.fetchall()
    
    cursor.execute('SELECT * FROM recipe_folders WHERE user_id = %s', (session['user_id'],))
    folders = cursor.fetchall()
    
    return render_template('index.html', 
                           username=session.get('username'),
                           recent_recipes=recent_recipes,
                           favorite_dishes=favorite_dishes,
                           folders=folders)

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

@app.route('/recipe/<int:recipe_id>')
def view_recipe(recipe_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    recipe = get_recipe_by_id(recipe_id)
    
    cursor = get_cursor()
    cursor.execute('SELECT * FROM favorites WHERE user_id = %s AND recipe_id = %s', 
                  (session['user_id'], recipe_id))
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
    
    return jsonify({'success': True, 'is_favorite': is_favorite})

@app.route('/search')
def search():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    query = request.args.get('q', '')
    results = []
    if query:
        results = search_recipes(query)
    
    return render_template('search.html', results=results, query=query)

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
        return redirect(url_for('view_recipe', recipe_id=recipe_id))
    
    return render_template('create_recipe.html')

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
def add_recipe_to_shopping_list(recipe_id):
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
    return redirect(url_for('view_recipe', recipe_id=recipe_id))

@app.route('/profile')
def profile():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = get_cursor()
    
    cursor.execute('SELECT * FROM users WHERE id = %s', (session['user_id'],))
    user = cursor.fetchone()
    
    cursor.execute('SELECT * FROM recipes WHERE user_id = %s ORDER BY created_at DESC', (session['user_id'],))
    my_recipes = cursor.fetchall()
    
    favorites = get_favorite_recipes(session['user_id'])
    
    return render_template('profile.html', user=user, my_recipes=my_recipes, favorites=favorites)

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

@app.route("/api/recipe/<int:recipe_id>")
def api_recipe(recipe_id):
    recipe = get_recipe_by_id(recipe_id)
    if not recipe:
        return jsonify({'error': 'Recipe not found'}), 404
    return jsonify(recipe)

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