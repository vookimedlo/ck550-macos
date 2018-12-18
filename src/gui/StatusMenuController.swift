//
//  StatusMenuController.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject, MonitoringToggledHandler {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var toggleMonitoringViewController: ToggleMonitoringViewController!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    override func awakeFromNib() {
        let monitoringPlaceHolder = statusMenu.item(withTag: 1)
        monitoringPlaceHolder?.view = toggleMonitoringViewController.view
        
        statusItem.button?.title = Bundle.appName()
        statusItem.menu = statusMenu
        
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    func monitoringToggled(notification: Notification) {
        guard notification.name == Notification.Name.CustomMonitoringToggled else {return}
        logDebug("monitoring %@", notification.userInfo?["isEnabled"] as! Bool ? "enabled" : "disabled")
    }
    
    @IBAction func aboutAction(_ sender: NSMenuItem) {
    }
    
    @IBAction func quitAction(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
