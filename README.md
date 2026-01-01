# Interactive Pet Agent

A macOS application that transforms your pet's photo into a living character that appears during work breaks to remind you to rest and have fun!

## Features

🐾 **Personalized Pet Character**
- Upload your pet's photo to create a unique animated character
- Your pet comes to life with smooth SpriteKit animations

⏰ **Smart Focus Timer**
- Pomodoro-style work/break intervals
- Customizable work and break durations
- Automatic break reminders

🎮 **Interactive Behavior**
- Pet follows and plays with your cursor
- Multiple animation states (idle, active, playing, resting)
- AI-driven emotion system adapts pet behavior

🪟 **Floating Pet Window**
- Transparent, always-on-top window
- Pet appears across all workspaces
- Non-intrusive design

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building from source)

## Installation

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/RoquefortX/Interactive-pet-agent.git
cd Interactive-pet-agent
```

2. Open the project in Xcode or build with Swift Package Manager:
```bash
swift build -c release
```

3. Run the application:
```bash
swift run
```

## Usage

### First Time Setup

1. Launch the application - it will appear in your menu bar with a paw print icon
2. Click the paw print and select "Settings"
3. Upload a photo of your pet
4. Configure your preferred work and break durations
5. Click "Save Settings"

### Daily Use

1. The timer starts automatically when you launch the app
2. During work sessions, your pet stays hidden
3. When break time arrives:
   - A notification will remind you to take a break
   - Your pet will appear on screen
   - The pet will play around and interact with your cursor
4. After the break, your pet disappears and the work timer resumes

### Menu Bar Options

- **Show Pet**: Manually show your pet at any time
- **Settings**: Open the settings window to customize your experience
- **Quit**: Exit the application

## Architecture

The application is built with a clean, modular architecture:

- **AppDelegate**: Main application coordinator
- **PetWindow**: Transparent floating window manager
- **PetScene**: SpriteKit-based animation system
- **PetController**: State machine and behavior logic
- **TimerService**: Focus/break timer implementation
- **CursorTracker**: Mouse and window tracking
- **EmotionEngine**: AI-based emotion determination
- **SettingsWindow**: User preferences interface

## Configuration

Settings are persisted using UserDefaults:

- **Pet Image**: Stored as PNG data
- **Work Duration**: In seconds (default: 1500 = 25 minutes)
- **Break Duration**: In seconds (default: 300 = 5 minutes)

## Development

### Project Structure

```
InteractivePetAgent/
├── Sources/
│   ├── AppDelegate.swift          # Main app coordinator
│   ├── PetWindow.swift            # Floating window
│   ├── PetScene.swift             # SpriteKit animations
│   ├── PetController.swift        # Behavior controller
│   ├── TimerService.swift         # Timer management
│   ├── CursorTracker.swift        # Cursor tracking
│   ├── EmotionEngine.swift        # AI emotions
│   └── SettingsWindow.swift       # Settings UI
├── Resources/
│   ├── Info.plist                 # App metadata
│   └── InteractivePetAgent.entitlements
└── Tests/
    ├── TimerServiceTests.swift
    └── EmotionEngineTests.swift
```

### Running Tests

```bash
swift test
```

### Building for Distribution

1. Archive the application in Xcode
2. Export with Developer ID signing
3. Notarize with Apple
4. Distribute via DMG or ZIP

## Technologies Used

- **Swift 5.9+**: Modern Swift language
- **SpriteKit**: 2D animations and sprite management
- **Cocoa/AppKit**: Native macOS UI
- **Quartz Window Services**: Window tracking
- **UserDefaults**: Settings persistence

## Privacy & Permissions

The app requires the following permissions:

- **File Access**: To select and save your pet's photo (user-selected files only)
- **Accessibility**: For cursor tracking across all applications

All data is stored locally on your Mac. No data is sent to external servers.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the Pomodoro Technique for productivity
- Built with love for pet owners who need break reminders

## Support

If you encounter any issues or have suggestions:
- Open an issue on GitHub
- Check existing issues for solutions

---

Made with ❤️ for pet lovers everywhere