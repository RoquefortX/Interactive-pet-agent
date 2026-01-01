//
//  PetController.swift
//  InteractivePetAgent
//
//  Controls pet behavior and state management
//

import Foundation
import Cocoa

class PetController: NSObject, TimerServiceDelegate {
    
    weak var window: PetWindow?
    private var currentState: PetBehaviorState = .hidden
    private var emotionEngine: EmotionEngine
    private var cursorTracker: CursorTracker?
    
    override init() {
        emotionEngine = EmotionEngine()
        super.init()
        cursorTracker = CursorTracker(delegate: self)
    }
    
    // MARK: - State Management
    
    func transitionTo(_ state: PetBehaviorState) {
        currentState = state
        
        switch state {
        case .hidden:
            window?.hidePet()
        case .appearing:
            window?.showPet()
            window?.petScene?.setState(.active)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.transitionTo(.interactive)
            }
        case .interactive:
            window?.petScene?.setState(.playing)
            cursorTracker?.startTracking()
        case .resting:
            window?.petScene?.setState(.resting)
            cursorTracker?.stopTracking()
        case .disappearing:
            window?.petScene?.setState(.idle)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.transitionTo(.hidden)
            }
        }
    }
    
    // MARK: - TimerServiceDelegate
    
    func workSessionStarted() {
        transitionTo(.hidden)
    }
    
    func breakSessionStarted() {
        transitionTo(.appearing)
        
        // Show notification
        let notification = NSUserNotification()
        notification.title = "Time for a break!"
        notification.informativeText = "Your pet friend is here to remind you to take a break."
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func timerTick(workTimeRemaining: TimeInterval, breakTimeRemaining: TimeInterval) {
        // Update pet emotion based on remaining time
        let emotion = emotionEngine.determineEmotion(
            workTimeRemaining: workTimeRemaining,
            breakTimeRemaining: breakTimeRemaining
        )
        updatePetWithEmotion(emotion)
    }
    
    private func updatePetWithEmotion(_ emotion: Emotion) {
        switch emotion {
        case .happy:
            window?.petScene?.setState(.playing)
        case .excited:
            window?.petScene?.setState(.active)
        case .calm:
            window?.petScene?.setState(.idle)
        case .sleepy:
            window?.petScene?.setState(.resting)
        }
    }
}

// MARK: - CursorTrackerDelegate

extension PetController: CursorTrackerDelegate {
    func cursorMovedTo(_ point: NSPoint) {
        // Move pet window towards cursor
        if currentState == .interactive {
            let windowFrame = window?.frame ?? .zero
            let distance = hypot(
                point.x - windowFrame.midX,
                point.y - windowFrame.midY
            )
            
            if distance > 100 && distance < 500 {
                let newOrigin = CGPoint(
                    x: point.x - windowFrame.width / 2,
                    y: point.y - windowFrame.height / 2
                )
                window?.movePetTo(newOrigin, animated: true)
            }
        }
    }
}

// MARK: - Pet Behavior State

enum PetBehaviorState {
    case hidden
    case appearing
    case interactive
    case resting
    case disappearing
}
