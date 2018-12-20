//
//  StatusMenuController.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject, MonitoringToggledHandler, EffectToggledHandler, EffectConfigureHandler {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var statusEffectMenu: NSMenu!
    @IBOutlet weak var toggleMonitoringViewController: ToggleMonitoringViewController!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var aboutWindowController: AboutWindowController?
    private var effectViewControllers = [Effect: EffectMenuViewController]()

    override func awakeFromNib() {
        let monitoringPlaceHolder = statusMenu.item(withTag: 1)
        monitoringPlaceHolder?.view = toggleMonitoringViewController.view

        populateEffects()

        statusItem.button?.title = Bundle.appName()
        statusItem.menu = statusMenu
        
        (self as EffectConfigureHandler).startObserving()
        (self as EffectToggledHandler).startObserving()
        (self as MonitoringToggledHandler).startObserving()
    }
    
    deinit {
        (self as MonitoringToggledHandler).stopObserving()
        (self as EffectToggledHandler).stopObserving()
        (self as EffectConfigureHandler).stopObserving()
    }
    
    func effectConfigure(notification: Notification) {
        guard notification.name == Notification.Name.CustomEffectConfigure else {return}
        guard let effect = notification.userInfo?["effect"] as? Effect else {return}
        logDebug("effect[configure] %@", effect.name())
        
        // Hide whole menu
        statusMenu.cancelTracking()
    }

    func effectToggled(notification: Notification) {
        guard notification.name == Notification.Name.CustomEffectToggled else {return}
        guard let effect = notification.userInfo?["effect"] as? Effect else {return}
        guard let isEnabled = notification.userInfo?["isEnabled"] as? Bool else {return}
        logDebug("effect[on/off] %@",
                 effect.name(),
                 isEnabled ? "enabled" : "disabled")
        
        if isEnabled {
            Effect.allCases.forEach() { item in
                if item != effect {
                    effectViewControllers[item]?.effectEnabled = false
                }
            }
        }
        
        // Hide whole menu
        statusMenu.cancelTracking()
    }
    
    func monitoringToggled(notification: Notification) {
        guard notification.name == Notification.Name.CustomMonitoringToggled else {return}
        guard let isEnabled = notification.userInfo?["isEnabled"] as? Bool else {return}
        logDebug("monitoring %@", isEnabled)
    }
    
    private func populateEffects() {
        Effect.allCases.forEach {item in
            let menuItem = statusEffectMenu.addItem(withTitle: "", action: #selector(effectHandler(sender:)), keyEquivalent: "")
            // This is a file-owner
            let controller = EffectMenuViewController(nibName: NSNib.Name("EffectMenuView"), bundle: nil)
            controller.loadView()
            
            // This is the real controller defined in XIB
            if let controller = controller.view.findViewController(type: EffectMenuViewController.self) {
                effectViewControllers[item] = controller
                controller.setup(effect: item)
            }
            menuItem.view = controller.view
        }
    }
    
    @objc private func windowWillClose(notification: Notification) {
        guard let object = notification.object as? NSWindow else { return }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: object)
        if object.isEqual(aboutWindowController?.window) {
            aboutWindowController = nil
        }
    }
    
    @objc private func effectHandler(sender: NSMenuItem) {
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
