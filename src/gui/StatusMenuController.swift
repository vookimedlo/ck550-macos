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
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var aboutWindowController: AboutWindowController?

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
    
    @objc private func windowWillClose(notification: Notification) {
        guard let object = notification.object as? NSWindow else { return }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: object)
        if object.isEqual(aboutWindowController?.window) {
            aboutWindowController = nil
        }
    }
    
    @IBAction func aboutAction(_ sender: NSMenuItem) {
        guard aboutWindowController == nil else {
            aboutWindowController?.window?.orderFrontRegardless()
            return
        }
        aboutWindowController = AboutWindowController(windowNibName: NSNib.Name("AboutWindow"))
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(notification:)), name: NSWindow.willCloseNotification, object: aboutWindowController?.window)
        aboutWindowController?.window?.orderFrontRegardless()
    }
    
    @IBAction func quitAction(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
