# Code Examples and Usage

This document provides practical code examples for extending and customizing the Interactive Pet Agent.

## Basic Usage Examples

### 1. Adding a Custom Animation

To add a new animation state to your pet:

```swift
// In PetScene.swift

// 1. Add new state to PetState enum
enum PetState {
    case idle
    case active
    case playing
    case resting
    case celebrating  // NEW!
}

// 2. Add animation method
private func performCelebratingAnimation() {
    petSprite?.removeAllActions()
    
    // Create firework-like effect
    let scaleUp = SKAction.scale(to: 1.3, duration: 0.3)
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
    let rotate = SKAction.rotate(byAngle: .pi * 4, duration: 0.6)
    
    let celebrate = SKAction.group([
        SKAction.sequence([scaleUp, scaleDown]),
        rotate
    ])
    
    petSprite?.run(SKAction.repeat(celebrate, count: 3), withKey: "celebrating")
}

// 3. Add to setState method
func setState(_ state: PetState) {
    currentState = state
    
    switch state {
    case .celebrating:
        performCelebratingAnimation()
    // ... other cases
    }
}
```

### 2. Adding a New Emotion

To add a new emotion type:

```swift
// In EmotionEngine.swift

// 1. Add to Emotion enum
enum Emotion {
    case happy
    case excited
    case calm
    case sleepy
    case curious     // NEW!
    
    var energyLevel: Int {
        switch self {
        case .excited: return 3
        case .happy: return 2
        case .curious: return 2  // NEW!
        case .calm: return 1
        case .sleepy: return 0
        }
    }
}

// 2. Add determination logic
func determineEmotion(workTimeRemaining: TimeInterval, breakTimeRemaining: TimeInterval) -> Emotion {
    // Check for curious conditions
    if breakTimeRemaining > 0 && breakTimeRemaining < 2 * 60 {
        // Near end of break, pet is curious about returning to work
        return .curious
    }
    
    // ... existing logic
}
```

### 3. Adding Custom Settings

To add a new user-configurable setting:

```swift
// In SettingsWindow.swift

// 1. Add UI element
private var soundEnabledCheckbox: NSButton?

private func setupUI() {
    // ... existing UI setup
    
    // Add checkbox for sound
    soundEnabledCheckbox = NSButton(
        checkboxWithTitle: "Enable Sound Effects",
        target: self,
        action: #selector(soundCheckboxChanged)
    )
    soundEnabledCheckbox?.frame = NSRect(x: 200, y: 120, width: 200, height: 20)
    contentView.addSubview(soundEnabledCheckbox!)
}

// 2. Add action handler
@objc private func soundCheckboxChanged() {
    let enabled = soundEnabledCheckbox?.state == .on
    UserDefaults.standard.set(enabled, forKey: "soundEnabled")
}

// 3. Load setting on startup
private func loadCurrentSettings() {
    // ... existing load code
    
    let soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
    soundEnabledCheckbox?.state = soundEnabled ? .on : .off
}
```

### 4. Adding Sound Effects

To play sounds when pet performs actions:

```swift
// In PetScene.swift

import AVFoundation

class PetScene: SKScene {
    private var soundEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "soundEnabled")
    }
    
    private func playSound(_ soundName: String) {
        guard soundEnabled else { return }
        
        if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            let player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        }
    }
    
    private func performActiveAnimation() {
        // ... existing animation code
        
        playSound("pet_excited")  // Play sound when active
    }
}
```

### 5. Adding Statistics Tracking

To track and display usage statistics:

```swift
// Create new file: StatisticsService.swift

import Foundation

class StatisticsService {
    private let defaults = UserDefaults.standard
    
    func recordWorkSession(duration: TimeInterval) {
        let totalWorkTime = defaults.double(forKey: "totalWorkTime")
        defaults.set(totalWorkTime + duration, forKey: "totalWorkTime")
        
        let sessionsCompleted = defaults.integer(forKey: "sessionsCompleted")
        defaults.set(sessionsCompleted + 1, forKey: "sessionsCompleted")
    }
    
    func recordBreakSession(duration: TimeInterval) {
        let totalBreakTime = defaults.double(forKey: "totalBreakTime")
        defaults.set(totalBreakTime + duration, forKey: "totalBreakTime")
    }
    
    func getStatistics() -> Statistics {
        return Statistics(
            totalWorkTime: defaults.double(forKey: "totalWorkTime"),
            totalBreakTime: defaults.double(forKey: "totalBreakTime"),
            sessionsCompleted: defaults.integer(forKey: "sessionsCompleted")
        )
    }
}

struct Statistics {
    let totalWorkTime: TimeInterval
    let totalBreakTime: TimeInterval
    let sessionsCompleted: Int
    
    var formattedWorkTime: String {
        let hours = Int(totalWorkTime) / 3600
        return "\(hours)h"
    }
}
```

## Advanced Customization

### 6. Multiple Pet Support

To support switching between multiple pets:

```swift
// 1. Update UserDefaults structure
extension UserDefaults {
    var selectedPetIndex: Int {
        get { integer(forKey: "selectedPetIndex") }
        set { set(newValue, forKey: "selectedPetIndex") }
    }
    
    func petImageData(at index: Int) -> Data? {
        return data(forKey: "petImage_\(index)")
    }
    
    func setPetImageData(_ data: Data, at index: Int) {
        set(data, forKey: "petImage_\(index)")
    }
}

// 2. Update PetScene to load current pet
private func loadPetImage() -> NSImage {
    let selectedIndex = UserDefaults.standard.selectedPetIndex
    
    if let imageData = UserDefaults.standard.petImageData(at: selectedIndex),
       let image = NSImage(data: imageData) {
        return image
    }
    
    return NSImage(systemSymbolName: "pawprint.circle.fill", accessibilityDescription: "Pet") ?? NSImage()
}

// 3. Add UI to SettingsWindow for pet selection
private func setupPetSelector() {
    let segmentedControl = NSSegmentedControl(
        labels: ["Pet 1", "Pet 2", "Pet 3"],
        trackingMode: .selectOne,
        target: self,
        action: #selector(petSelectionChanged)
    )
    // ... configure and add to view
}

@objc private func petSelectionChanged(_ sender: NSSegmentedControl) {
    UserDefaults.standard.selectedPetIndex = sender.selectedSegment
    loadCurrentPetImage()
}
```

### 7. Custom Window Animations

To add fancy window entrance/exit animations:

```swift
// In PetWindow.swift

func showPetWithAnimation() {
    // Start offscreen
    let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    setFrameOrigin(CGPoint(x: screenSize.width, y: 100))
    
    orderFrontRegardless()
    
    // Slide in from right
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 1.0
        context.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let finalPosition = CGPoint(x: screenSize.width - 250, y: 100)
        animator().setFrameOrigin(finalPosition)
    } completionHandler: { [weak self] in
        self?.petScene?.startAnimating()
    }
}

func hidePetWithAnimation(completion: @escaping () -> Void) {
    petScene?.stopAnimating()
    
    let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    
    NSAnimationContext.runAnimationGroup { context in
        context.duration = 1.0
        context.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let offscreenPosition = CGPoint(x: screenSize.width, y: frame.origin.y)
        animator().setFrameOrigin(offscreenPosition)
    } completionHandler: { [weak self] in
        self?.orderOut(nil)
        completion()
    }
}
```

### 8. Smart Cursor Following

To make the pet follow cursor more intelligently:

```swift
// In PetScene.swift

private var targetPosition: CGPoint?
private var followSpeed: CGFloat = 3.0

override func update(_ currentTime: TimeInterval) {
    guard let target = targetPosition,
          let petSprite = petSprite else { return }
    
    let distance = hypot(target.x - petSprite.position.x, 
                        target.y - petSprite.position.y)
    
    // Only follow if within reasonable distance
    guard distance > 30 && distance < 300 else { return }
    
    // Calculate direction
    let angle = atan2(target.y - petSprite.position.y,
                     target.x - petSprite.position.x)
    
    // Smooth following with easing
    let moveDistance = min(followSpeed, distance * 0.1)
    let newX = petSprite.position.x + cos(angle) * moveDistance
    let newY = petSprite.position.y + sin(angle) * moveDistance
    
    petSprite.position = CGPoint(x: newX, y: newY)
    
    // Rotate pet to face direction of movement
    petSprite.zRotation = angle
}

func setTargetPosition(_ position: CGPoint) {
    targetPosition = position
}
```

### 9. Contextual Behaviors

To make pet react to specific situations:

```swift
// In PetController.swift

func handleContextualBehavior() {
    let hour = Calendar.current.component(.hour, from: Date())
    let windows = cursorTracker?.getActiveWindows() ?? []
    
    // Morning greeting
    if hour == 9 && !hasGreetedToday {
        window?.petScene?.setState(.active)
        showNotification(title: "Good morning!", message: "Ready for a productive day?")
        hasGreetedToday = true
    }
    
    // Detect if user is in a meeting (certain apps open)
    let meetingApps = ["Zoom", "Microsoft Teams", "Google Meet"]
    let inMeeting = windows.contains { window in
        meetingApps.contains { window.name.contains($0) }
    }
    
    if inMeeting {
        // Be quieter during meetings
        window?.petScene?.setState(.resting)
    }
    
    // Late night warning
    if hour >= 22 {
        showNotification(title: "Time for bed?", message: "Consider wrapping up for today!")
        window?.petScene?.setState(.sleepy)
    }
}

private func showNotification(title: String, message: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = message
    NSUserNotificationCenter.default.deliver(notification)
}
```

### 10. Particle Effects

To add visual effects to animations:

```swift
// In PetScene.swift

func addSparkleEffect() {
    // Create particle emitter
    if let sparkle = SKEmitterNode(fileNamed: "Sparkle.sks") {
        sparkle.position = petSprite?.position ?? .zero
        sparkle.particleLifetime = 2.0
        sparkle.particleSpeed = 50
        sparkle.numParticlesToEmit = 20
        
        addChild(sparkle)
        
        // Remove after particles are done
        let wait = SKAction.wait(forDuration: 2.0)
        let remove = SKAction.removeFromParent()
        sparkle.run(SKAction.sequence([wait, remove]))
    }
}

// Call during special events
func celebrateSuccess() {
    addSparkleEffect()
    petSprite?.run(SKAction.sequence([
        SKAction.scale(to: 1.2, duration: 0.2),
        SKAction.scale(to: 1.0, duration: 0.2)
    ]))
}
```

## Integration Examples

### 11. Calendar Integration

To sync with system calendar for break scheduling:

```swift
import EventKit

class CalendarService {
    private let eventStore = EKEventStore()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            completion(granted)
        }
    }
    
    func hasUpcomingMeeting() -> Bool {
        let predicate = eventStore.predicateForEvents(
            withStart: Date(),
            end: Date().addingTimeInterval(3600), // Next hour
            calendars: nil
        )
        
        let events = eventStore.events(matching: predicate)
        return !events.isEmpty
    }
    
    func scheduleBreakReminder(at date: Date) {
        // Add calendar reminder for break
        let event = EKEvent(eventStore: eventStore)
        event.title = "Break Time with Your Pet"
        event.startDate = date
        event.endDate = date.addingTimeInterval(300) // 5 minutes
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        try? eventStore.save(event, span: .thisEvent)
    }
}
```

### 12. Shortcuts Integration

To support macOS Shortcuts:

```swift
// In AppDelegate.swift

func application(_ application: NSApplication, 
                continue userActivity: NSUserActivity,
                restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
    
    switch userActivity.activityType {
    case "com.interactivepet.showPet":
        showPet()
        return true
        
    case "com.interactivepet.startBreak":
        timerService?.startBreakSession()
        return true
        
    case "com.interactivepet.startWork":
        timerService?.startWorkSession()
        return true
        
    default:
        return false
    }
}
```

## Testing Examples

### 13. Unit Test Examples

```swift
// Test emotion engine context awareness
func testEmotionEngineRespondsToProximity() {
    let engine = EmotionEngine()
    
    let closeContext = EmotionContext(
        cursorDistance: 50,
        sessionDuration: 600,
        recentInteractions: 5
    )
    
    let closeEmotion = engine.determineEmotionFromContext(closeContext)
    XCTAssertTrue([.excited, .happy].contains(closeEmotion))
    
    let farContext = EmotionContext(
        cursorDistance: 500,
        sessionDuration: 600,
        recentInteractions: 0
    )
    
    let farEmotion = engine.determineEmotionFromContext(farContext)
    XCTAssertTrue([.calm, .sleepy].contains(farEmotion))
}

// Test state transitions
func testPetControllerStateTransitions() {
    let controller = PetController()
    
    controller.transitionTo(.appearing)
    // Wait for animation
    let expectation = XCTestExpectation(description: "Transition to interactive")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
        // Should have transitioned to interactive
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
}
```

## Performance Optimization Examples

### 14. Reducing Animation Overhead

```swift
// In PetScene.swift

private var lastUpdateTime: TimeInterval = 0
private let updateInterval: TimeInterval = 0.016 // ~60 FPS

override func update(_ currentTime: TimeInterval) {
    // Throttle updates to maintain consistent frame rate
    guard currentTime - lastUpdateTime >= updateInterval else { return }
    lastUpdateTime = currentTime
    
    // Only update if visible
    guard view?.window?.isVisible == true else { return }
    
    // Perform updates
    updatePetPosition()
    updateAnimations()
}
```

### 15. Memory-Efficient Image Caching

```swift
// In SettingsWindow.swift

private func loadImage(from url: URL) {
    if let image = NSImage(contentsOf: url) {
        // Compress image to reasonable size
        let maxSize = CGSize(width: 512, height: 512)
        let resizedImage = image.resized(to: maxSize)
        
        petImageView?.image = resizedImage
        
        // Save compressed version
        if let tiffData = resizedImage.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let imageData = bitmap.representation(using: .png, properties: [:]) {
            UserDefaults.standard.set(imageData, forKey: "petImage")
        }
    }
}
```

## Debugging Tips

### 16. Debug Logging

```swift
// Add throughout your code for debugging

#if DEBUG
private func log(_ message: String, function: String = #function) {
    print("[PetController.\(function)] \(message)")
}
#else
private func log(_ message: String, function: String = #function) {}
#endif

// Usage
log("Transitioning to state: \(newState)")
log("Cursor moved to: \(point)")
log("Emotion changed to: \(emotion)")
```

---

These examples provide a solid foundation for extending and customizing the Interactive Pet Agent. Feel free to mix and match these patterns to create your perfect pet companion!
