//
//  PetWindow.swift
//  InteractivePetAgent
//
//  Transparent floating window for the pet character
//

import Cocoa
import SpriteKit

class PetWindow: NSWindow {
    
    var petScene: PetScene?
    
    init() {
        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
        let windowSize = CGSize(width: 200, height: 200)
        let initialPosition = CGPoint(x: screenSize.width - windowSize.width - 50, y: 100)
        
        super.init(
            contentRect: NSRect(origin: initialPosition, size: windowSize),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        setupWindow()
        setupScene()
    }
    
    private func setupWindow() {
        // Make window transparent and floating
        isOpaque = false
        backgroundColor = NSColor.clear
        hasShadow = false
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .stationary]
        ignoresMouseEvents = false
        
        // Make window appear on all spaces
        isMovableByWindowBackground = false
    }
    
    private func setupScene() {
        let skView = SKView(frame: contentView!.bounds)
        skView.allowsTransparency = true
        skView.ignoresSiblingOrder = true
        
        petScene = PetScene(size: skView.bounds.size)
        petScene?.scaleMode = .aspectFit
        
        skView.presentScene(petScene)
        contentView = skView
    }
    
    func showPet() {
        orderFrontRegardless()
        petScene?.startAnimating()
    }
    
    func hidePet() {
        orderOut(nil)
        petScene?.stopAnimating()
    }
    
    func movePetTo(_ point: CGPoint, animated: Bool = true) {
        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                self.animator().setFrameOrigin(point)
            }
        } else {
            setFrameOrigin(point)
        }
    }
}
