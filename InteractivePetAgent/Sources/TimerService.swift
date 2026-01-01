//
//  TimerService.swift
//  InteractivePetAgent
//
//  Manages focus/break timer intervals
//

import Foundation

protocol TimerServiceDelegate: AnyObject {
    func workSessionStarted()
    func breakSessionStarted()
    func timerTick(workTimeRemaining: TimeInterval, breakTimeRemaining: TimeInterval)
}

class TimerService {
    
    weak var delegate: TimerServiceDelegate?
    
    private var timer: Timer?
    private var currentSession: SessionType = .work
    private var timeRemaining: TimeInterval = 0
    private var isRunning = false
    
    // User configurable settings
    var workDuration: TimeInterval = 25 * 60 // 25 minutes default
    var breakDuration: TimeInterval = 5 * 60  // 5 minutes default
    
    init() {
        loadSettings()
    }
    
    // MARK: - Timer Control
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startWorkSession()
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resume() {
        guard !isRunning else { return }
        isRunning = true
        startTimer()
    }
    
    func reset() {
        stop()
        timeRemaining = workDuration
        currentSession = .work
    }
    
    // MARK: - Session Management
    
    private func startWorkSession() {
        currentSession = .work
        timeRemaining = workDuration
        delegate?.workSessionStarted()
        startTimer()
        
        NotificationCenter.default.post(name: .workTimeStarted, object: nil)
    }
    
    private func startBreakSession() {
        currentSession = .break
        timeRemaining = breakDuration
        delegate?.breakSessionStarted()
        startTimer()
        
        NotificationCenter.default.post(name: .breakTimeStarted, object: nil)
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    private func timerTick() {
        guard isRunning else { return }
        
        timeRemaining -= 1
        
        let workTime = currentSession == .work ? timeRemaining : 0
        let breakTime = currentSession == .break ? timeRemaining : 0
        delegate?.timerTick(workTimeRemaining: workTime, breakTimeRemaining: breakTime)
        
        if timeRemaining <= 0 {
            sessionCompleted()
        }
    }
    
    private func sessionCompleted() {
        switch currentSession {
        case .work:
            startBreakSession()
        case .break:
            startWorkSession()
        }
    }
    
    // MARK: - Settings
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        workDuration = defaults.double(forKey: "workDuration")
        if workDuration == 0 {
            workDuration = 25 * 60
        }
        
        breakDuration = defaults.double(forKey: "breakDuration")
        if breakDuration == 0 {
            breakDuration = 5 * 60
        }
    }
    
    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(workDuration, forKey: "workDuration")
        defaults.set(breakDuration, forKey: "breakDuration")
    }
}

// MARK: - Session Type

enum SessionType {
    case work
    case `break`
}

// MARK: - Notifications

extension Notification.Name {
    static let workTimeStarted = Notification.Name("workTimeStarted")
    static let breakTimeStarted = Notification.Name("breakTimeStarted")
}
