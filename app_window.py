import webview
import threading
import os
import sys
import time
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
    
    # Wait for Flask to start (3 seconds)
    print("Starting server...")
    time.sleep(3)
    
    # Create a REAL desktop window
    webview.create_window(
        title="What's Cookin'!",
        url="http://127.0.0.1:5000",
        width=450,
        height=800,
        resizable=True,
        fullscreen=False,
        min_size=(350, 600),
        confirm_close=True
    )
    
    webview.start()