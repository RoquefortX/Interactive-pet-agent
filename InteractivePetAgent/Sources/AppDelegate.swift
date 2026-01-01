//
//  AppDelegate.swift
//  InteractivePetAgent
//
//  Created by Interactive Pet Agent
//

import Cocoa
import SpriteKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?
    var petWindow: PetWindow?
    var timerService: TimerService?
    var petController: PetController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Setup status bar item
        setupStatusBar()
        
        // Initialize services
        timerService = TimerService()
        petController = PetController()
        
        // Show settings window on first launch
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            showSettings()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        
        // Start timer service
        timerService?.delegate = petController
        timerService?.start()
        
        // Setup observers
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(breakTimeStarted),
            name: .breakTimeStarted,
            object: nil
        )
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        timerService?.stop()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - Status Bar
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Pet Agent")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Pet", action: #selector(showPet), keyEquivalent: "p"))
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc private func showPet() {
        if petWindow == nil {
            petWindow = PetWindow()
            petController?.window = petWindow
        }
        petWindow?.showPet()
    }
    
    @objc private func showSettings() {
        if settingsWindow == nil {
            settingsWindow = SettingsWindow()
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc private func breakTimeStarted() {
        showPet()
    }
}
