//
//  AppDelegate.swift
//  Demo
//
//  Created by Red Davis on 13/04/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import Cocoa


@NSApplicationMain
internal final class AppDelegate: NSObject, NSApplicationDelegate
{
    // Internal
    @IBOutlet weak var window: NSWindow!

    // MARK: NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        guard let contentView = self.window.contentView else
        {
            return
        }
        
        let screenSaver = RootScreenSaverView(frame: .zero, isPreview: false)!
        screenSaver.frame = contentView.bounds
        screenSaver.autoresizingMask = [.width, .height]
        contentView.addSubview(screenSaver)
        
        screenSaver.startAnimation()
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        
    }
}
