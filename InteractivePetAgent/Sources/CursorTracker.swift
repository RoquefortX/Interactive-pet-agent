//
//  CursorTracker.swift
//  InteractivePetAgent
//
//  Tracks mouse cursor position and window elements
//

import Cocoa

protocol CursorTrackerDelegate: AnyObject {
    func cursorMovedTo(_ point: NSPoint)
}

class CursorTracker {
    
    weak var delegate: CursorTrackerDelegate?
    private var eventMonitor: Any?
    private var trackingTimer: Timer?
    private var isTracking = false
    
    init(delegate: CursorTrackerDelegate?) {
        self.delegate = delegate
    }
    
    deinit {
        stopTracking()
    }
    
    func startTracking() {
        guard !isTracking else { return }
        isTracking = true
        
        // Monitor global mouse movements
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            let location = NSEvent.mouseLocation
            self?.delegate?.cursorMovedTo(location)
        }
        
        // Also monitor local events
        NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            let location = NSEvent.mouseLocation
            self?.delegate?.cursorMovedTo(location)
            return event
        }
        
        // Periodic tracking for when mouse is idle
        trackingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            let location = NSEvent.mouseLocation
            self?.delegate?.cursorMovedTo(location)
        }
    }
    
    func stopTracking() {
        guard isTracking else { return }
        isTracking = false
        
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        
        trackingTimer?.invalidate()
        trackingTimer = nil
    }
    
    // MARK: - Window Tracking
    
    func getActiveWindows() -> [WindowInfo] {
        var windowList: [WindowInfo] = []
        
        // Get list of all windows using Quartz Window Services
        let options = CGWindowListOption([.optionOnScreenOnly, .excludeDesktopElements])
        guard let windows = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
            return windowList
        }
        
        for window in windows {
            if let bounds = window[kCGWindowBounds as String] as? [String: CGFloat],
               let x = bounds["X"],
               let y = bounds["Y"],
               let width = bounds["Width"],
               let height = bounds["Height"],
               let name = window[kCGWindowName as String] as? String {
                
                let windowInfo = WindowInfo(
                    frame: CGRect(x: x, y: y, width: width, height: height),
                    name: name
                )
                windowList.append(windowInfo)
            }
        }
        
        return windowList
    }
}

// MARK: - Window Info

struct WindowInfo {
    let frame: CGRect
    let name: String
}
