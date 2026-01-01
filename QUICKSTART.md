# Quick Start Guide

Get your Interactive Pet Agent up and running in minutes!

## Prerequisites

✅ macOS 13.0 or later  
✅ Xcode 15.0 or later (for building)  
✅ A photo of your pet (optional, but recommended!)

## Installation

### Option 1: Build from Source (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/RoquefortX/Interactive-pet-agent.git
   cd Interactive-pet-agent
   ```

2. **Build the application**
   ```bash
   make build
   ```
   
   Or using Swift directly:
   ```bash
   swift build -c release
   ```

3. **Run the application**
   ```bash
   make run
   ```
   
   Or using Swift directly:
   ```bash
   swift run
   ```

### Option 2: Install to Applications

After building, install the app:
```bash
make install
```

## First Time Setup

### Step 1: Open Settings

When you first launch the app, you'll see a paw print icon in your menu bar.

1. Click the paw print icon 🐾
2. Select "Settings"

### Step 2: Upload Your Pet's Photo

1. Click "Select Pet Image" button
2. Choose a photo of your pet from your computer
3. The photo will appear in the preview box

**Tips for best results:**
- Use a clear, well-lit photo
- Square images work best
- Your pet should be the main focus
- Transparent backgrounds look great!

### Step 3: Configure Timer

1. Set **Work Duration** (default: 25 minutes)
   - How long you want to focus before a break
   
2. Set **Break Duration** (default: 5 minutes)
   - How long your break should last

3. Click "Save Settings"

### Step 4: Start Working!

That's it! The timer starts automatically. Now:

- 🖥️ **During work**: Focus on your tasks, pet stays hidden
- ⏰ **Break time**: You'll get a notification
- 🐾 **Pet appears**: Your pet character shows up on screen
- 🎮 **Play time**: Move your cursor to interact with your pet
- 🔄 **Repeat**: After break, back to work!

## Daily Usage

### Menu Bar Controls

Click the paw print icon 🐾 for options:

- **Show Pet**: Bring your pet on screen anytime
- **Settings**: Change your photo or timer settings
- **Quit**: Exit the application

### Interacting with Your Pet

When your pet appears:

- **Move your cursor** close to the pet
- The pet will **follow** and **play** with your cursor
- Try moving quickly or slowly for different reactions
- The pet's mood changes based on:
  - Time of day
  - How long you've been working
  - Your interaction level

### Pet States

Your pet has different moods:

- 😊 **Happy**: Playful and energetic (early in break)
- 🎉 **Excited**: Very active, loves to play (when you interact)
- 😌 **Calm**: Relaxed, gentle movements (normal state)
- 😴 **Sleepy**: Tired, slow movements (end of break, late evening)

## Customization

### Changing Your Pet

1. Menu bar → Settings
2. Click "Select Pet Image"
3. Choose a new photo
4. Save settings

### Adjusting Timer

1. Menu bar → Settings
2. Change work/break durations
3. Save settings
4. New timings apply to next session

## Tips & Tricks

### 🎯 Productivity Tips

- **25-5 Rule**: Default 25 min work, 5 min break (Pomodoro technique)
- **Longer Focus**: Try 50 min work, 10 min break
- **Shorter Sprints**: Try 15 min work, 3 min break

### 🐾 Pet Tips

- **Use a square photo** for best appearance
- **Transparent backgrounds** look most professional
- **Clear, centered pets** work better than group photos
- **Try different pets** - switch between cat, dog, hamster, etc.

### ⚡ Performance Tips

- Pet window uses minimal resources
- Animations are GPU-accelerated via SpriteKit
- App stays in background when not in break time
- No internet connection required

## Troubleshooting

### Pet Doesn't Appear

1. Check if it's break time (or manually trigger with "Show Pet")
2. Verify pet image is loaded in Settings
3. Make sure the app has necessary permissions

### Image Not Loading

1. Try a different image format (PNG, JPEG work best)
2. Check file isn't corrupted
3. Try a smaller file size if very large

### Cursor Not Being Followed

1. Grant Accessibility permissions:
   - System Preferences → Security & Privacy → Accessibility
   - Add Interactive Pet Agent to allowed apps
2. Restart the application

### Timer Not Working

1. Check timer settings are valid numbers
2. Restart the application
3. Check console for errors (Console.app)

## Keyboard Shortcuts

While settings window is open:
- **⌘,**: Open Settings (from menu bar)
- **⌘Q**: Quit application
- **⌘W**: Close Settings window
- **↩**: Save Settings (when in settings)

## Uninstalling

To remove the application:

1. Quit the app (Menu bar → Quit)
2. Delete from Applications folder
3. Remove preferences (optional):
   ```bash
   defaults delete com.interactivepet.agent
   ```

## Next Steps

- ⭐ Star the repo on GitHub if you like it!
- 🐛 Report bugs or request features
- 🤝 Contribute improvements
- 📢 Share with friends who need break reminders!

## Need Help?

- 📖 Read the full [README.md](README.md)
- 🏗️ Check [BUILD.md](BUILD.md) for build issues
- 💻 See [IMPLEMENTATION.md](IMPLEMENTATION.md) for technical details
- 🤝 Review [CONTRIBUTING.md](CONTRIBUTING.md) to contribute

---

**Enjoy your productive work sessions and fun break times with your pet! 🐾❤️**
