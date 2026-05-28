// Text-to-Speech function for AI voice
function speakText(text) {
    if ('speechSynthesis' in window) {
        // Cancel any ongoing speech
        window.speechSynthesis.cancel();
        
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.rate = 0.9;      // Slightly slower for cooking
        utterance.pitch = 1.0;     // Normal pitch
        utterance.volume = 1.0;    // Full volume
        
        // Try to use a female voice if available
        const voices = window.speechSynthesis.getVoices();
        const femaleVoice = voices.find(voice => 
            voice.name.includes('Google UK English Female') || 
            voice.name.includes('Samantha') ||
            voice.name.includes('Female')
        );
        if (femaleVoice) {
            utterance.voice = femaleVoice;
        }
        
        window.speechSynthesis.speak(utterance);
    } else {
        alert('Text-to-speech is not supported in your browser. Try Chrome, Safari, or Edge!');
    }
}

// Stop speaking function
function stopSpeaking() {
    if ('speechSynthesis' in window) {
        window.speechSynthesis.cancel();
    }
}

// Add to shopping list with animation
function addToShoppingList(ingredientName, quantity, recipeId) {
    fetch('/add_to_shopping_list', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            ingredient_name: ingredientName,
            quantity: quantity,
            recipe_id: recipeId
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast(`✅ Added: ${ingredientName}`);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('❌ Failed to add item');
    });
}

// Add all ingredients from recipe to shopping list
function addAllToShoppingList(recipeId) {
    const btn = event.target;
    btn.textContent = 'Adding...';
    btn.disabled = true;
    
    window.location.href = `/add_recipe_to_shopping_list/${recipeId}`;
}

// Toast notification
function showToast(message) {
    // Remove existing toast
    const existingToast = document.querySelector('.toast-message');
    if (existingToast) {
        existingToast.remove();
    }
    
    // Create toast
    const toast = document.createElement('div');
    toast.className = 'toast-message';
    toast.textContent = message;
    toast.style.cssText = `
        position: fixed;
        bottom: 80px;
        left: 50%;
        transform: translateX(-50%);
        background: #333;
        color: white;
        padding: 10px 20px;
        border-radius: 25px;
        font-size: 14px;
        z-index: 2000;
        animation: slideUp 0.3s ease;
    `;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.remove();
    }, 2000);
}

// Add CSS animation for toast
const style = document.createElement('style');
style.textContent = `
    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateX(-50%) translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }
    }
`;
document.head.appendChild(style);

// Toggle favorite
function toggleFavorite(recipeId) {
    fetch(`/favorite/${recipeId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const btn = document.querySelector('.favorite-btn');
                if (data.is_favorite) {
                    btn.classList.add('active');
                    btn.innerHTML = '<span>❤️</span> Saved';
                    showToast('⭐ Added to favorites!');
                } else {
                    btn.classList.remove('active');
                    btn.innerHTML = '<span>❤️</span> Save';
                    showToast('Removed from favorites');
                }
            }
        });
}

// Search with debounce
let searchTimeout;
function debouncedSearch() {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        const query = document.querySelector('.search-input').value;
        if (query.length > 2) {
            window.location.href = `/search?q=${encodeURIComponent(query)}`;
        }
    }, 500);
}

// Load voices for text-to-speech (preload for better performance)
if ('speechSynthesis' in window) {
    window.speechSynthesis.getVoices();
}

// Smooth scrolling for navigation
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({ behavior: 'smooth' });
        }
    });
});

// Confirm before deleting
function confirmDelete(message) {
    return confirm(message || 'Are you sure you want to delete this?');
}

// Handle offline mode detection
window.addEventListener('online', () => {
    showToast('📡 Back online!');
});

window.addEventListener('offline', () => {
    showToast('⚠️ You are offline. Some features may not work.');
});

// Save scroll position when navigating
window.addEventListener('beforeunload', () => {
    sessionStorage.setItem('scrollPosition', window.scrollY);
});

window.addEventListener('load', () => {
    const scrollPosition = sessionStorage.getItem('scrollPosition');
    if (scrollPosition) {
        window.scrollTo(0, parseInt(scrollPosition));
        sessionStorage.removeItem('scrollPosition');
    }
});

// Progressive Web App (PWA) - Ask user to install
let deferredPrompt;
window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferredPrompt = e;
    
    // Show install button (optional)
    const installBtn = document.createElement('button');
    installBtn.textContent = '📱 Install App';
    installBtn.style.cssText = `
        position: fixed;
        bottom: 80px;
        right: 10px;
        background: #FF6B35;
        color: white;
        border: none;
        border-radius: 50px;
        padding: 10px 15px;
        font-size: 12px;
        cursor: pointer;
        z-index: 1000;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    `;
    installBtn.onclick = async () => {
        if (deferredPrompt) {
            deferredPrompt.prompt();
            const { outcome } = await deferredPrompt.userChoice;
            if (outcome === 'accepted') {
                console.log('User accepted install');
            }
            deferredPrompt = null;
            installBtn.remove();
        }
    };
    
    // Only show after user has been on the site for a while
    setTimeout(() => {
        if (!localStorage.getItem('installDismissed')) {
            document.body.appendChild(installBtn);
        }
    }, 30000);
});

// Save shopping list locally for offline access
function saveShoppingListLocally() {
    const items = [];
    document.querySelectorAll('.shopping-item').forEach(item => {
        items.push({
            name: item.querySelector('.item-name')?.textContent,
            quantity: item.querySelector('.item-quantity')?.textContent,
            checked: item.classList.contains('checked')
        });
    });
    localStorage.setItem('shoppingList', JSON.stringify(items));
}

function loadShoppingListLocally() {
    const saved = localStorage.getItem('shoppingList');
    if (saved) {
        console.log('Found saved shopping list');
    }
}

// Auto-save shopping list when modified
document.addEventListener('click', (e) => {
    if (e.target.closest('.check-btn') || e.target.closest('.delete-btn')) {
        setTimeout(saveShoppingListLocally, 100);
    }
});

// Recipe search filter
function filterRecipesByCuisine(cuisine) {
    const recipes = document.querySelectorAll('.recipe-grid-card');
    recipes.forEach(recipe => {
        const recipeCuisine = recipe.dataset.cuisine;
        if (cuisine === 'all' || recipeCuisine === cuisine) {
            recipe.style.display = 'block';
        } else {
            recipe.style.display = 'none';
        }
    });
}

// Share recipe function
function shareRecipe(recipeTitle, recipeId) {
    if (navigator.share) {
        navigator.share({
            title: recipeTitle,
            text: `Check out this recipe: ${recipeTitle}`,
            url: window.location.href
        }).catch(console.error);
    } else {
        // Fallback
        navigator.clipboard.writeText(window.location.href);
        showToast('📋 Recipe link copied!');
    }
}

// Print recipe
function printRecipe() {
    const recipeContent = document.querySelector('.recipe-detail-screen').cloneNode(true);
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <html>
            <head>
                <title>Print Recipe</title>
                <style>
                    body { font-family: Arial, sans-serif; padding: 20px; }
                    .recipe-hero { text-align: center; }
                    .recipe-section { margin-bottom: 20px; }
                    .step-item { margin-bottom: 15px; }
                    .ingredient-item { margin-bottom: 10px; }
                </style>
            </head>
            <body>
                ${recipeContent.innerHTML}
            </body>
        </html>
    `);
    printWindow.document.close();
    printWindow.print();
}

// Display current time for cooking
function updateCookingTimer() {
    const timerDisplay = document.getElementById('timerDisplay');
    if (timerDisplay) {
        const now = new Date();
        timerDisplay.textContent = now.toLocaleTimeString();
    }
}
setInterval(updateCookingTimer, 1000);

// Page load initialization
document.addEventListener('DOMContentLoaded', () => {
    console.log('What\'s Cookin\' App Ready! 🍳');
    loadShoppingListLocally();
});

// Auto-hide flash messages after 3 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.animation = 'flashFadeOut 0.3s ease forwards';
            setTimeout(() => {
                if (alert.parentNode) alert.remove();
            }, 300);
        }, 3000);
    });
});

// Custom Modal Function
function showConfirmModal(options) {
    return new Promise((resolve) => {
        // Create modal elements
        const modal = document.createElement('div');
        modal.className = 'modal-overlay';
        modal.innerHTML = `
            <div class="modal-container">
                <div class="modal-icon">${options.icon || '❓'}</div>
                <div class="modal-title">${options.title || 'Confirm'}</div>
                <div class="modal-message">${options.message || 'Are you sure?'}</div>
                <div class="modal-buttons">
                    <button class="modal-btn modal-cancel" id="modalCancel">${options.cancelText || 'Cancel'}</button>
                    <button class="modal-btn modal-confirm ${options.danger ? 'modal-danger' : ''}" id="modalConfirm">${options.confirmText || 'OK'}</button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Show modal
        setTimeout(() => modal.classList.add('active'), 10);
        
        // Handle buttons
        const cancelBtn = modal.querySelector('#modalCancel');
        const confirmBtn = modal.querySelector('#modalConfirm');
        
        cancelBtn.onclick = () => {
            modal.classList.remove('active');
            setTimeout(() => modal.remove(), 300);
            resolve(false);
        };
        
        confirmBtn.onclick = () => {
            modal.classList.remove('active');
            setTimeout(() => modal.remove(), 300);
            resolve(true);
        };
        
        // Close on overlay click
        modal.onclick = (e) => {
            if (e.target === modal) {
                modal.classList.remove('active');
                setTimeout(() => modal.remove(), 300);
                resolve(false);
            }
        };
    });
}