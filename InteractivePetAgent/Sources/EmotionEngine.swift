//
//  EmotionEngine.swift
//  InteractivePetAgent
//
//  AI-based emotion determination for pet behavior
//

import Foundation

class EmotionEngine {
    
    private var emotionHistory: [Emotion] = []
    private let maxHistorySize = 10
    
    func determineEmotion(workTimeRemaining: TimeInterval, breakTimeRemaining: TimeInterval) -> Emotion {
        let emotion: Emotion
        
        if workTimeRemaining > 0 {
            // During work session
            if workTimeRemaining > 15 * 60 {
                emotion = .calm
            } else if workTimeRemaining > 5 * 60 {
                emotion = .happy
            } else {
                emotion = .excited
            }
        } else if breakTimeRemaining > 0 {
            // During break session
            if breakTimeRemaining > 3 * 60 {
                emotion = .happy
            } else if breakTimeRemaining > 1 * 60 {
                emotion = .calm
            } else {
                emotion = .sleepy
            }
        } else {
            emotion = .calm
        }
        
        // Add to history
        emotionHistory.append(emotion)
        if emotionHistory.count > maxHistorySize {
            emotionHistory.removeFirst()
        }
        
        return emotion
    }
    
    func determineEmotionFromContext(_ context: EmotionContext) -> Emotion {
        var score = 0.0
        
        // Factor in cursor proximity
        if context.cursorDistance < 100 {
            score += 2.0
        } else if context.cursorDistance < 300 {
            score += 1.0
        }
        
        // Factor in time of day
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            score += 1.0 // Morning energy
        } else if hour > 18 {
            score -= 1.0 // Evening tiredness
        }
        
        // Factor in session duration
        if context.sessionDuration > 30 * 60 {
            score -= 2.0 // Long session = tired
        }
        
        // Factor in recent interactions
        score += Double(context.recentInteractions) * 0.5
        
        // Determine emotion based on score
        if score > 3.0 {
            return .excited
        } else if score > 1.0 {
            return .happy
        } else if score > -1.0 {
            return .calm
        } else {
            return .sleepy
        }
    }
    
    func getEmotionTrend() -> EmotionTrend {
        guard emotionHistory.count >= 3 else { return .stable }
        
        let recent = Array(emotionHistory.suffix(3))
        let energyLevels = recent.map { $0.energyLevel }
        
        if energyLevels[2] > energyLevels[1] && energyLevels[1] > energyLevels[0] {
            return .increasing
        } else if energyLevels[2] < energyLevels[1] && energyLevels[1] < energyLevels[0] {
            return .decreasing
        } else {
            return .stable
        }
    }
}

// MARK: - Emotion Types

enum Emotion {
    case happy
    case excited
    case calm
    case sleepy
    
    var energyLevel: Int {
        switch self {
        case .excited: return 3
        case .happy: return 2
        case .calm: return 1
        case .sleepy: return 0
        }
    }
}

struct EmotionContext {
    let cursorDistance: CGFloat
    let sessionDuration: TimeInterval
    let recentInteractions: Int
}

enum EmotionTrend {
    case increasing
    case decreasing
    case stable
}
