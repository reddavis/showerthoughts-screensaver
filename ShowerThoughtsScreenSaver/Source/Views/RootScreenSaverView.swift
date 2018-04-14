//
//  ScreenSaverView.swift
//  ShowerThoughtsScreenSaver
//
//  Created by Red Davis on 13/04/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import AppKit
import ScreenSaver


@objc internal final class RootScreenSaverView: ScreenSaverView
{
    // Internal
    internal override var hasConfigureSheet: Bool {
        return false
    }
    
    // Private
    private let apiClient = ShowerThoughtsAPIClient()
    
    private var textAlpha: CGFloat = 1.0 {
        didSet
        {
            if self.textAlpha <= 0.0
            {
                self.selectNewThought()
                self.fadeDirection = .up
            }
            else if self.textAlpha >= 1.0
            {
                self.fadeDirection = .down
            }
        }
    }
    
    private var fadeDirection = FadeDirection.down
    private var timer: Timer?
    
    private let loadingThought = ShowerThoughtsAPIClient.Thought(value: "Loading today's thoughts...", author: "Shower Thought Screen Saver")
    private var currentThought: ShowerThoughtsAPIClient.Thought
    private var thoughts: [ShowerThoughtsAPIClient.Thought]
    
    // MARK: Initialization
    
    internal override init?(frame: NSRect, isPreview: Bool)
    {
        self.currentThought = self.loadingThought
        self.thoughts = [self.loadingThought]
        
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1.0/30.0
        
        self.wantsLayer = true
    }
    
    internal required init?(coder decoder: NSCoder)
    {
        abort()
    }
    
    deinit
    {
        self.timer?.invalidate()
    }
    
    // MARK: Lifecycle
    
    internal override func startAnimation()
    {
        self.reloadData()
    }
    
    internal override func stopAnimation()
    {
        
    }
    
    internal override func animateOneFrame()
    {
        
    }
    
    // MARK: Data
    
    private func reloadData()
    {
        self.apiClient.fetchThoughts { (thoughts, error) in
            guard let unwrappedThoughts = thoughts else
            {
                return
            }
            
            DispatchQueue.main.async {
                self.thoughts = unwrappedThoughts
                self.startThoughtPresentation()
            }
        }
    }
    
    private func selectNewThought()
    {
        self.currentThought = self.thoughts.randomElement() ?? self.loadingThought
    }
    
    // MARK: Animation
    
    private func startThoughtPresentation()
    {
        self.selectNewThought()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    // MARK: Actions
    
    @objc private func timerFired(_ sender: Any)
    {
        switch self.fadeDirection
        {
        case .down:
            self.textAlpha -= 0.02
        case .up:
            self.textAlpha += 0.02
        }
        
        self.needsDisplay = true
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: NSRect)
    {
        super.draw(rect)
        
        // Background color
        NSColor.black.setFill()
        NSBezierPath.fill(self.bounds)
        
        // Thought
        let thought = self.currentThought.value
        
        let thoughtAttributes: [NSAttributedStringKey : Any] = [
            .font : NSFont.systemFont(ofSize: 50.0, weight: .regular),
            .foregroundColor : NSColor(white: 1.0, alpha: self.textAlpha)
        ]
        
        let thoughtString = NSAttributedString(string: thought, attributes: thoughtAttributes)
        
        // Author
        let author = "\n\n- \(self.currentThought.author)"
        
        let authorAttributes: [NSAttributedStringKey : Any] = [
            .font : NSFont.systemFont(ofSize: 25.0, weight: .regular),
            .foregroundColor : NSColor(white: 1.0, alpha: self.textAlpha)
        ]
        
        let authorString = NSAttributedString(string: author, attributes: authorAttributes)
        
        // String
        let string = NSMutableAttributedString(attributedString: thoughtString)
        string.append(authorString)
        
        // Draw string
        let maxSize = CGSize(width: rect.width * 0.8, height: rect.height)
        var stringRect = string.boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin])
        stringRect.origin.x = self.bounds.width / 2.0 - stringRect.width / 2.0
        stringRect.origin.y = self.bounds.height / 2.0 - stringRect.height / 2.0
        
        string.draw(in: stringRect)
    }
}


// MARK: Fade direction

private extension RootScreenSaverView
{
    private enum FadeDirection
    {
        case up
        case down
    }
}
