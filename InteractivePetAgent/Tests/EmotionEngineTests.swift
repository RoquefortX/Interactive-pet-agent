//
//  EmotionEngineTests.swift
//  InteractivePetAgentTests
//
//  Tests for EmotionEngine functionality
//

import XCTest
@testable import InteractivePetAgent

final class EmotionEngineTests: XCTestCase {
    
    var emotionEngine: EmotionEngine!
    
    override func setUp() {
        super.setUp()
        emotionEngine = EmotionEngine()
    }
    
    override func tearDown() {
        emotionEngine = nil
        super.tearDown()
    }
    
    func testEmotionDuringLongWorkSession() {
        let emotion = emotionEngine.determineEmotion(
            workTimeRemaining: 20 * 60,
            breakTimeRemaining: 0
        )
        XCTAssertEqual(emotion, .calm)
    }
    
    func testEmotionDuringShortWorkSession() {
        let emotion = emotionEngine.determineEmotion(
            workTimeRemaining: 3 * 60,
            breakTimeRemaining: 0
        )
        XCTAssertEqual(emotion, .excited)
    }
    
    func testEmotionDuringBreak() {
        let emotion = emotionEngine.determineEmotion(
            workTimeRemaining: 0,
            breakTimeRemaining: 4 * 60
        )
        XCTAssertEqual(emotion, .happy)
    }
    
    func testEmotionFromContext() {
        let context = EmotionContext(
            cursorDistance: 50,
            sessionDuration: 10 * 60,
            recentInteractions: 3
        )
        
        let emotion = emotionEngine.determineEmotionFromContext(context)
        XCTAssertTrue([.happy, .excited].contains(emotion))
    }
    
    func testEmotionTrend() {
        // Build up emotion history
        _ = emotionEngine.determineEmotion(workTimeRemaining: 20 * 60, breakTimeRemaining: 0)
        _ = emotionEngine.determineEmotion(workTimeRemaining: 10 * 60, breakTimeRemaining: 0)
        _ = emotionEngine.determineEmotion(workTimeRemaining: 3 * 60, breakTimeRemaining: 0)
        
        let trend = emotionEngine.getEmotionTrend()
        XCTAssertEqual(trend, .increasing)
    }
}
