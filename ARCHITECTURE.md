# Architecture Documentation

This document describes the architecture and design decisions of the Interactive Pet Agent.

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                          macOS System                                │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    Interactive Pet Agent                      │  │
│  │                                                                │  │
│  │  ┌────────────┐         ┌─────────────┐                      │  │
│  │  │  Menu Bar  │◄────────┤ AppDelegate │                      │  │
│  │  │ Status Item│         └──────┬──────┘                      │  │
│  │  └────────────┘                │                              │  │
│  │                                 │                              │  │
│  │         ┌──────────────────────┼──────────────────┐          │  │
│  │         │                       │                   │          │  │
│  │         ▼                       ▼                   ▼          │  │
│  │  ┌─────────────┐        ┌─────────────┐    ┌─────────────┐  │  │
│  │  │  Settings   │        │    Timer    │    │     Pet     │  │  │
│  │  │   Window    │        │   Service   │    │ Controller  │  │  │
│  │  └─────────────┘        └──────┬──────┘    └──────┬──────┘  │  │
│  │         │                       │                   │          │  │
│  │         │                       │                   │          │  │
│  │         ▼                       ▼                   ▼          │  │
│  │  ┌─────────────┐        ┌─────────────┐    ┌─────────────┐  │  │
│  │  │ UserDefaults│        │Notifications│    │  PetWindow  │  │  │
│  │  │  (Storage)  │        │   Center    │    │(Transparent)│  │  │
│  │  └─────────────┘        └─────────────┘    └──────┬──────┘  │  │
│  │                                                     │          │  │
│  │                                                     ▼          │  │
│  │                                              ┌─────────────┐  │  │
│  │                                              │  PetScene   │  │  │
│  │                                              │ (SpriteKit) │  │  │
│  │                                              └─────────────┘  │  │
│  │                                                                │  │
│  │  Supporting Services:                                         │  │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐     │  │
│  │  │   Cursor    │  │   Emotion    │  │     Quartz     │     │  │
│  │  │  Tracker    │  │   Engine     │  │Window Services │     │  │
│  │  └─────────────┘  └──────────────┘  └────────────────┘     │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## Component Relationships

### 1. AppDelegate (Coordinator)

**Responsibilities:**
- Application lifecycle management
- Component initialization and wiring
- Menu bar status item management
- Global event coordination

**Dependencies:**
- NSApplication (AppKit)
- TimerService
- PetController
- SettingsWindow
- PetWindow

**Key Methods:**
```swift
- applicationDidFinishLaunching()
- setupStatusBar()
- showPet()
- showSettings()
```

### 2. Timer Service (Business Logic)

**Responsibilities:**
- Work/break session management
- Time tracking and countdown
- Session transitions
- Persistence of timer settings

**Design Pattern:** Delegate Pattern

**State Machine:**
```
┌──────────┐         Timer Expires         ┌──────────┐
│   WORK   │─────────────────────────────►│  BREAK   │
│ Session  │                               │ Session  │
└──────────┘◄─────────────────────────────└──────────┘
                Timer Expires
```

**Key Methods:**
```swift
- start()
- stop()
- pause()
- resume()
- reset()
```

### 3. Pet Controller (Behavior Orchestrator)

**Responsibilities:**
- Pet behavior state machine
- Emotion-based behavior selection
- Cursor tracking coordination
- Window positioning logic

**State Machine:**
```
         ┌──────────┐
         │  HIDDEN  │
         └────┬─────┘
              │ Break Starts
              ▼
         ┌──────────┐
         │APPEARING │
         └────┬─────┘
              │ Animation Complete
              ▼
         ┌──────────┐
         │INTERACTIVE│◄──┐
         └────┬─────┘    │ Cursor Movement
              │           │
              │ Break    │
              │ Ending    │
              ▼           │
         ┌──────────┐    │
         │ RESTING  │────┘
         └────┬─────┘
              │ Break Ends
              ▼
         ┌──────────┐
         │DISAPPEARING│
         └────┬─────┘
              │ Animation Complete
              ▼
         ┌──────────┐
         │  HIDDEN  │
         └──────────┘
```

**Key Methods:**
```swift
- transitionTo(_ state:)
- workSessionStarted()
- breakSessionStarted()
- timerTick()
```

### 4. Pet Window (View)

**Responsibilities:**
- Transparent floating window management
- Window positioning and animation
- SpriteKit view hosting
- Always-on-top behavior

**Properties:**
```swift
- isOpaque: false
- backgroundColor: .clear
- level: .floating
- collectionBehavior: [.canJoinAllSpaces, .stationary]
```

**Key Methods:**
```swift
- showPet()
- hidePet()
- movePetTo(_ point:, animated:)
```

### 5. Pet Scene (Animation)

**Responsibilities:**
- SpriteKit scene management
- Pet sprite rendering
- Animation state execution
- Mouse interaction handling

**Animation States:**

```
IDLE
├─► Breathing animation (scale: 1.0 ↔ 1.05)
└─► Loop forever until state change

ACTIVE
├─► Jump (y += 30, then y -= 30)
├─► Wiggle (rotate ±0.2 radians)
└─► Repeat 3x, then return to IDLE

PLAYING
├─► Spin (rotate 360°)
├─► Jump (y += 50, then y -= 50)
└─► Loop forever until state change

RESTING
├─► Fade out (alpha → 0.5)
├─► Fade in (alpha → 1.0)
└─► Loop forever until state change
```

**Key Methods:**
```swift
- startAnimating()
- stopAnimating()
- setState(_ state:)
- performIdleAnimation()
- performActiveAnimation()
- performPlayingAnimation()
- performRestingAnimation()
```

### 6. Settings Window (UI)

**Responsibilities:**
- User preferences interface
- Pet image selection
- Timer configuration
- Settings persistence

**UI Layout:**
```
┌─────────────────────────────────────────┐
│     Interactive Pet Agent Settings      │
├─────────────────────────────────────────┤
│                                         │
│  Pet Image:                             │
│  ┌───────────┐                          │
│  │           │  Pet Settings            │
│  │   Photo   │                          │
│  │  Preview  │  Work Duration: [25] min │
│  │           │                          │
│  └───────────┘  Break Duration: [5] min │
│  [Select Image]                         │
│                                         │
│  Your pet will appear during breaks... │
│                                         │
│                        [Save Settings]  │
└─────────────────────────────────────────┘
```

**Key Methods:**
```swift
- selectImage()
- loadImage(from:)
- saveSettings()
- loadCurrentSettings()
```

### 7. Cursor Tracker (Input Handler)

**Responsibilities:**
- Global mouse movement monitoring
- Window information gathering
- Cursor position broadcasting

**Implementation:**
```swift
// Global event monitoring
NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved)

// Periodic polling
Timer.scheduledTimer(withTimeInterval: 0.1)

// Quartz window list
CGWindowListCopyWindowInfo()
```

**Key Methods:**
```swift
- startTracking()
- stopTracking()
- getActiveWindows()
```

### 8. Emotion Engine (AI Logic)

**Responsibilities:**
- Context-aware emotion calculation
- Time-based behavior adjustment
- Emotion history tracking
- Trend analysis

**Emotion Calculation:**
```
score = 0

// Cursor proximity
if distance < 100: score += 2
else if distance < 300: score += 1

// Time of day
if hour < 12: score += 1        // Morning energy
else if hour > 18: score -= 1   // Evening tiredness

// Session duration
if duration > 30min: score -= 2  // Tired from long session

// Interactions
score += interactions * 0.5

// Result
if score > 3: return .excited
else if score > 1: return .happy
else if score > -1: return .calm
else: return .sleepy
```

**Key Methods:**
```swift
- determineEmotion(workTimeRemaining:, breakTimeRemaining:)
- determineEmotionFromContext(_ context:)
- getEmotionTrend()
```

## Data Flow

### Work Session Flow

```
1. AppDelegate.start()
   ↓
2. TimerService.startWorkSession()
   ↓
3. TimerService → PetController.workSessionStarted()
   ↓
4. PetController.transitionTo(.hidden)
   ↓
5. PetWindow.hidePet()
   ↓
6. Pet is hidden, user works
```

### Break Session Flow

```
1. TimerService.sessionCompleted()
   ↓
2. TimerService.startBreakSession()
   ↓
3. TimerService → PetController.breakSessionStarted()
   ↓
4. NSUserNotification → "Time for a break!"
   ↓
5. PetController.transitionTo(.appearing)
   ↓
6. PetWindow.showPet()
   ↓
7. PetScene.startAnimating()
   ↓
8. PetController.transitionTo(.interactive)
   ↓
9. CursorTracker.startTracking()
   ↓
10. User interacts with pet
```

### Settings Flow

```
1. User: Menu → Settings
   ↓
2. AppDelegate.showSettings()
   ↓
3. SettingsWindow.makeKeyAndOrderFront()
   ↓
4. User selects image → NSOpenPanel
   ↓
5. SettingsWindow.loadImage()
   ↓
6. Image → UserDefaults (PNG data)
   ↓
7. User configures timer
   ↓
8. SettingsWindow.saveSettings()
   ↓
9. Timer durations → UserDefaults
```

## Design Patterns Used

### 1. Delegate Pattern
- **TimerService** ↔ **PetController**
- Allows loose coupling between timer and behavior
- PetController doesn't need to know about timer internals

### 2. Observer Pattern
- **NotificationCenter** for app-wide events
- Breaktime notifications, work session starts
- Decouples event producers from consumers

### 3. State Machine Pattern
- **PetBehaviorState** enum
- **PetState** enum
- Clear state transitions
- Predictable behavior

### 4. MVC Pattern
- **Model**: EmotionEngine, TimerService (business logic)
- **View**: PetWindow, PetScene, SettingsWindow (UI)
- **Controller**: PetController, AppDelegate (coordination)

### 5. Strategy Pattern
- **EmotionEngine** determines behavior strategies
- Different emotions → different animation states
- Easily extensible with new emotions

## Threading Model

### Main Thread (UI)
- All UI updates
- SpriteKit animations
- Window management
- User interactions

### Background Processing
- Minimal: Most operations are lightweight
- Timer ticks run on main thread (1s interval)
- Image loading uses system APIs (automatically async)

### Concurrency Considerations
- UserDefaults is thread-safe
- SpriteKit animations are GPU-accelerated
- No heavy computational tasks

## Memory Management

### Weak References
```swift
weak var delegate: TimerServiceDelegate?
weak var window: PetWindow?
```

### Resource Lifecycle
- **Images**: Loaded once, cached in UserDefaults
- **Timers**: Invalidated on stop/deinit
- **Event Monitors**: Removed on stopTracking/deinit
- **Windows**: Managed by AppKit

## Error Handling

### Defensive Programming
```swift
// Optional chaining
if let button = statusItem?.button { ... }

// Default values
let workDuration = defaults.double(forKey: "workDuration")
if workDuration == 0 {
    workDuration = 25 * 60  // Default
}

// Guard statements
guard isRunning else { return }
```

### User Feedback
- Alerts for save confirmations
- Notifications for break reminders
- Visual feedback in settings window

## Performance Considerations

### Optimizations
1. **GPU Acceleration**: SpriteKit uses Metal/OpenGL
2. **Lazy Initialization**: Windows created when needed
3. **Efficient Timers**: 1-second granularity sufficient
4. **Minimal Tracking**: 0.1s polling for cursor (only during breaks)

### Resource Usage
- **Memory**: ~20-30 MB typical
- **CPU**: <1% when idle, ~2-5% during animations
- **GPU**: Minimal, mostly idle
- **Disk**: <1 MB for app + settings

## Testing Strategy

### Unit Tests
- **TimerService**: Core timer logic
- **EmotionEngine**: Emotion determination
- Mock delegates for isolation

### Integration Testing
- Manual testing required for:
  - UI interactions
  - Window behavior
  - Animation smoothness
  - System permissions

### Future Test Coverage
- State machine transitions
- Cursor tracking accuracy
- Settings persistence
- Error handling paths

## Extension Points

### Easy to Add
1. **New Emotions**: Add to `Emotion` enum, update logic
2. **New Animations**: Add to `PetScene` animation methods
3. **New Settings**: Add UI field, UserDefaults key
4. **Sound Effects**: Add audio files, integrate in PetScene

### Moderate Effort
1. **Multiple Pets**: Refactor to support pet selection
2. **Statistics**: Add tracking service, persistence layer
3. **Themes**: Create theme engine, multiple animation sets
4. **Cloud Sync**: Add iCloud integration

### Major Refactoring
1. **iOS/iPadOS Support**: SwiftUI rewrite
2. **Cross-Platform**: Different architecture needed
3. **Multiplayer**: Networking layer required

## Security Considerations

### App Sandbox
- Enabled in entitlements
- User-selected file access only
- No network access required

### Privacy
- All data stored locally
- No telemetry or analytics
- No external API calls
- User controls all images and settings

### Permissions
- **File Access**: User-initiated (NSOpenPanel)
- **Accessibility**: Optional, for cursor tracking
- **Notifications**: Standard macOS notifications

## Deployment

### Distribution Options
1. **Direct Download**: DMG or ZIP
2. **App Store**: Requires App Store entitlements
3. **Homebrew Cask**: Community package
4. **GitHub Releases**: Attached to releases

### Requirements
- Code signing certificate
- Notarization (for direct distribution)
- App Store review (if using App Store)

---

This architecture provides a solid foundation for a maintainable, extensible, and performant macOS application.
