//
//  AppDelegate.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let keyboard: KeyboardGUIHandler = KeyboardGUIHandler()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        keyboard.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        keyboard.stop()
    }
}
