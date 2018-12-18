//
//  StatusMenuController.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        statusItem.button?.title = Bundle.appName()
        statusItem.menu = statusMenu
    }
    
    @IBAction func aboutAction(_ sender: NSMenuItem) {
    }
    
    @IBAction func quitAction(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
