import os
import sys
import webbrowser
import threading
import time
import subprocess

# Get the correct path
if getattr(sys, 'frozen', False):
    base_path = os.path.dirname(sys.executable)
else:
    base_path = os.path.dirname(__file__)

# Path to the real app
app_path = os.path.join(base_path, 'WhatsCookin.exe')

# Open browser after delay
def open_browser():
    time.sleep(3)
    webbrowser.open('http://127.0.0.1:5000')

# Start browser thread
threading.Thread(target=open_browser, daemon=True).start()

# Run the actual app
if __name__ == '__main__':
    # Import and run your Flask app
    from app import app
    os.makedirs(os.path.join(base_path, 'instance'), exist_ok=True)
    with app.app_context():
        from database import init_db
        init_db()
    app.run(host='127.0.0.1', debug=False, port=5000)