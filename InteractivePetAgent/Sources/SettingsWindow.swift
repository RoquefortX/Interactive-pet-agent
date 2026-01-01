//
//  SettingsWindow.swift
//  InteractivePetAgent
//
//  User settings and configuration interface
//

import Cocoa
import UniformTypeIdentifiers

class SettingsWindow: NSWindow {
    
    private var petImageView: NSImageView?
    private var workDurationField: NSTextField?
    private var breakDurationField: NSTextField?
    private var selectImageButton: NSButton?
    private var saveButton: NSButton?
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        title = "Interactive Pet Agent Settings"
        center()
        setupUI()
        loadCurrentSettings()
    }
    
    private func setupUI() {
        let contentView = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 400))
        self.contentView = contentView
        
        // Title
        let titleLabel = NSTextField(labelWithString: "Pet Settings")
        titleLabel.font = NSFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.frame = NSRect(x: 20, y: 350, width: 460, height: 30)
        contentView.addSubview(titleLabel)
        
        // Pet Image Section
        let imageLabel = NSTextField(labelWithString: "Pet Image:")
        imageLabel.frame = NSRect(x: 20, y: 300, width: 100, height: 20)
        contentView.addSubview(imageLabel)
        
        petImageView = NSImageView(frame: NSRect(x: 20, y: 150, width: 150, height: 150))
        petImageView?.imageScaling = .scaleProportionallyUpOrDown
        petImageView?.image = NSImage(systemSymbolName: "pawprint.circle.fill", accessibilityDescription: "Pet")
        petImageView?.wantsLayer = true
        petImageView?.layer?.cornerRadius = 10
        petImageView?.layer?.borderWidth = 2
        petImageView?.layer?.borderColor = NSColor.gray.cgColor
        contentView.addSubview(petImageView!)
        
        selectImageButton = NSButton(title: "Select Pet Image", target: self, action: #selector(selectImage))
        selectImageButton?.frame = NSRect(x: 20, y: 110, width: 150, height: 30)
        contentView.addSubview(selectImageButton!)
        
        // Timer Settings Section
        let timerLabel = NSTextField(labelWithString: "Timer Settings")
        timerLabel.font = NSFont.systemFont(ofSize: 16, weight: .semibold)
        timerLabel.frame = NSRect(x: 200, y: 300, width: 280, height: 20)
        contentView.addSubview(timerLabel)
        
        // Work Duration
        let workLabel = NSTextField(labelWithString: "Work Duration (minutes):")
        workLabel.frame = NSRect(x: 200, y: 260, width: 200, height: 20)
        contentView.addSubview(workLabel)
        
        workDurationField = NSTextField(frame: NSRect(x: 200, y: 230, width: 100, height: 24))
        workDurationField?.placeholderString = "25"
        contentView.addSubview(workDurationField!)
        
        // Break Duration
        let breakLabel = NSTextField(labelWithString: "Break Duration (minutes):")
        breakLabel.frame = NSRect(x: 200, y: 190, width: 200, height: 20)
        contentView.addSubview(breakLabel)
        
        breakDurationField = NSTextField(frame: NSRect(x: 200, y: 160, width: 100, height: 24))
        breakDurationField?.placeholderString = "5"
        contentView.addSubview(breakDurationField!)
        
        // Info Text
        let infoLabel = NSTextField(labelWithString: """
        Your pet will appear during breaks to remind you to rest!
        
        • Upload a photo of your pet for a personalized experience
        • Set work and break intervals that suit your schedule
        • The pet will interact with your cursor and play around
        """)
        infoLabel.isEditable = false
        infoLabel.isBordered = false
        infoLabel.backgroundColor = .clear
        infoLabel.frame = NSRect(x: 200, y: 40, width: 280, height: 100)
        infoLabel.maximumNumberOfLines = 0
        infoLabel.cell?.wraps = true
        contentView.addSubview(infoLabel)
        
        // Save Button
        saveButton = NSButton(title: "Save Settings", target: self, action: #selector(saveSettings))
        saveButton?.frame = NSRect(x: 350, y: 20, width: 130, height: 32)
        saveButton?.bezelStyle = .rounded
        saveButton?.keyEquivalent = "\r"
        contentView.addSubview(saveButton!)
    }
    
    @objc private func selectImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        panel.begin { [weak self] response in
            if response == .OK, let url = panel.url {
                self?.loadImage(from: url)
            }
        }
    }
    
    private func loadImage(from url: URL) {
        if let image = NSImage(contentsOf: url) {
            petImageView?.image = image
            
            // Save image data
            if let tiffData = image.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData),
               let imageData = bitmap.representation(using: .png, properties: [:]) {
                UserDefaults.standard.set(imageData, forKey: "petImage")
            }
        }
    }
    
    @objc private func saveSettings() {
        // Save timer durations
        if let workText = workDurationField?.stringValue,
           let workMinutes = Double(workText) {
            UserDefaults.standard.set(workMinutes * 60, forKey: "workDuration")
        }
        
        if let breakText = breakDurationField?.stringValue,
           let breakMinutes = Double(breakText) {
            UserDefaults.standard.set(breakMinutes * 60, forKey: "breakDuration")
        }
        
        // Show confirmation
        let alert = NSAlert()
        alert.messageText = "Settings Saved"
        alert.informativeText = "Your settings have been saved successfully. Restart the timer for changes to take effect."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: self)
    }
    
    private func loadCurrentSettings() {
        // Load pet image
        if let imageData = UserDefaults.standard.data(forKey: "petImage"),
           let image = NSImage(data: imageData) {
            petImageView?.image = image
        }
        
        // Load timer durations
        let workDuration = UserDefaults.standard.double(forKey: "workDuration")
        if workDuration > 0 {
            workDurationField?.stringValue = String(format: "%.0f", workDuration / 60)
        }
        
        let breakDuration = UserDefaults.standard.double(forKey: "breakDuration")
        if breakDuration > 0 {
            breakDurationField?.stringValue = String(format: "%.0f", breakDuration / 60)
        }
    }
}
