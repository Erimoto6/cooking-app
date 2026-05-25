import webview
import os
import sys

# Fix for paths when running as EXE
if getattr(sys, 'frozen', False):
    os.chdir(os.path.dirname(sys.executable))

# Just open the window - assume Flask is already running
webview.create_window(
    title="What's Cookin'!",
    url="http://127.0.0.1:5000",
    width=450,
    height=800,
    resizable=True
)
webview.start()