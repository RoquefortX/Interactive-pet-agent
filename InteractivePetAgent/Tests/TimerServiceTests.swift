//
//  TimerServiceTests.swift
//  InteractivePetAgentTests
//
//  Tests for TimerService functionality
//

import XCTest
@testable import InteractivePetAgent

final class TimerServiceTests: XCTestCase {
    
    var timerService: TimerService!
    var delegate: MockTimerDelegate!
    
    override func setUp() {
        super.setUp()
        timerService = TimerService()
        delegate = MockTimerDelegate()
        timerService.delegate = delegate
    }
    
    override func tearDown() {
        timerService.stop()
        timerService = nil
        delegate = nil
        super.tearDown()
    }
    
    func testTimerInitialization() {
        XCTAssertNotNil(timerService)
        XCTAssertEqual(timerService.workDuration, 25 * 60)
        XCTAssertEqual(timerService.breakDuration, 5 * 60)
    }
    
    func testWorkSessionStart() {
        timerService.start()
        
        // Wait briefly for async operations
        let expectation = XCTestExpectation(description: "Work session started")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.delegate.workSessionStartedCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCustomWorkDuration() {
        timerService.workDuration = 10 * 60
        timerService.saveSettings()
        
        let newTimerService = TimerService()
        XCTAssertEqual(newTimerService.workDuration, 10 * 60)
    }
}

class MockTimerDelegate: TimerServiceDelegate {
    var workSessionStartedCalled = false
    var breakSessionStartedCalled = false
    var tickCount = 0
    
    func workSessionStarted() {
        workSessionStartedCalled = true
    }
    
    func breakSessionStarted() {
        breakSessionStartedCalled = true
    }
    
    func timerTick(workTimeRemaining: TimeInterval, breakTimeRemaining: TimeInterval) {
        tickCount += 1
    }
}
