//
//  PetScene.swift
//  InteractivePetAgent
//
//  SpriteKit scene for pet animations
//

import SpriteKit

class PetScene: SKScene {
    
    private var petSprite: SKSpriteNode?
    private var currentState: PetState = .idle
    private var isAnimating = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        setupPet()
    }
    
    private func setupPet() {
        // Create pet sprite with default or user-provided image
        let petImage = loadPetImage()
        petSprite = SKSpriteNode(texture: SKTexture(image: petImage))
        petSprite?.size = CGSize(width: 150, height: 150)
        petSprite?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        if let petSprite = petSprite {
            addChild(petSprite)
        }
    }
    
    private func loadPetImage() -> NSImage {
        // Try to load user's pet image
        if let imageData = UserDefaults.standard.data(forKey: "petImage"),
           let image = NSImage(data: imageData) {
            return image
        }
        
        // Fallback to default pet icon
        return NSImage(systemSymbolName: "pawprint.circle.fill", accessibilityDescription: "Pet")
            ?? NSImage()
    }
    
    func startAnimating() {
        guard !isAnimating else { return }
        isAnimating = true
        performIdleAnimation()
    }
    
    func stopAnimating() {
        isAnimating = false
        petSprite?.removeAllActions()
    }
    
    func setState(_ state: PetState) {
        currentState = state
        
        switch state {
        case .idle:
            performIdleAnimation()
        case .active:
            performActiveAnimation()
        case .playing:
            performPlayingAnimation()
        case .resting:
            performRestingAnimation()
        }
    }
    
    // MARK: - Animations
    
    private func performIdleAnimation() {
        guard isAnimating else { return }
        
        let breathe = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 2.0),
            SKAction.scale(to: 1.0, duration: 2.0)
        ])
        let breatheForever = SKAction.repeatForever(breathe)
        petSprite?.run(breatheForever, withKey: "idle")
    }
    
    private func performActiveAnimation() {
        petSprite?.removeAction(forKey: "idle")
        
        let jump = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 30, duration: 0.3),
            SKAction.moveBy(x: 0, y: -30, duration: 0.3)
        ])
        let wiggle = SKAction.sequence([
            SKAction.rotate(byAngle: 0.2, duration: 0.2),
            SKAction.rotate(byAngle: -0.4, duration: 0.4),
            SKAction.rotate(byAngle: 0.2, duration: 0.2)
        ])
        
        let combined = SKAction.group([jump, wiggle])
        let repeat3 = SKAction.repeat(combined, count: 3)
        
        petSprite?.run(SKAction.sequence([
            repeat3,
            SKAction.run { [weak self] in
                self?.setState(.idle)
            }
        ]))
    }
    
    private func performPlayingAnimation() {
        petSprite?.removeAction(forKey: "idle")
        
        let spinAndJump = SKAction.sequence([
            SKAction.group([
                SKAction.rotate(byAngle: .pi * 2, duration: 1.0),
                SKAction.sequence([
                    SKAction.moveBy(x: 0, y: 50, duration: 0.5),
                    SKAction.moveBy(x: 0, y: -50, duration: 0.5)
                ])
            ]),
            SKAction.wait(forDuration: 0.5)
        ])
        
        petSprite?.run(SKAction.repeatForever(spinAndJump), withKey: "playing")
    }
    
    private func performRestingAnimation() {
        petSprite?.removeAllActions()
        
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        let rest = SKAction.sequence([fadeOut, fadeIn])
        
        petSprite?.run(SKAction.repeatForever(rest), withKey: "resting")
    }
    
    // MARK: - Mouse Tracking
    
    override func mouseEntered(with event: NSEvent) {
        if currentState == .idle {
            setState(.active)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        // Pet follows cursor
        let location = event.location(in: self)
        followCursor(to: location)
    }
    
    private func followCursor(to point: CGPoint) {
        let distance = hypot(
            point.x - (petSprite?.position.x ?? 0),
            point.y - (petSprite?.position.y ?? 0)
        )
        
        if distance > 30 && distance < 200 {
            let angle = atan2(
                point.y - (petSprite?.position.y ?? 0),
                point.x - (petSprite?.position.x ?? 0)
            )
            
            let moveDistance: CGFloat = 5
            let newX = (petSprite?.position.x ?? 0) + cos(angle) * moveDistance
            let newY = (petSprite?.position.y ?? 0) + sin(angle) * moveDistance
            
            petSprite?.position = CGPoint(x: newX, y: newY)
        }
    }
}

// MARK: - Pet State

enum PetState {
    case idle
    case active
    case playing
    case resting
}
