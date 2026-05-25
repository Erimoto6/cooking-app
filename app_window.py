import webview
import threading
import os
import sys
from app import app

def run_flask():
    """Run the Flask app in background"""
    os.makedirs('instance', exist_ok=True)
    with app.app_context():
        from database import init_db
        init_db()
    app.run(host='127.0.0.1', port=5000, debug=False)

if __name__ == '__main__':
    # Start Flask in background thread
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()
    
    # Create a REAL desktop window (not a browser)
    webview.create_window(
        title="What's Cookin'!",           # Window title
        url="http://127.0.0.1:5000",       # Your Flask app
        width=450,                          # Phone-sized width
        height=800,                         # Phone-sized height
        resizable=True,                     # Can resize
        fullscreen=False,                   # Not fullscreen
        min_size=(350, 600),                # Minimum size
        confirm_close=True,                 # Ask before closing
        background_color="#FF6B35"          # Orange accent color
    )
    
    webview.start()