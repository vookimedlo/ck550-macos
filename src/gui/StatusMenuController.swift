//
//  StatusMenuController.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject, EffectToggledHandler, EffectConfigureHandler, KeyboardInfoHandler {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var statusEffectMenu: NSMenu!
    @IBOutlet weak var toggleMonitoringViewController: MonitoringViewController!
    @IBOutlet weak var keyboardInfoViewController: KeyboardInfoViewController!
    @IBOutlet weak var sleepWakeViewController: SleepWakeViewController!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var aboutWindowController: AboutWindowController?
    private var preferencesWindowController: NSWindowController?
    private var effectViewControllers = [Effect: EffectMenuViewController]()

    override func awakeFromNib() {
        let monitoringPlaceHolder = statusMenu.item(withTag: 1)
        monitoringPlaceHolder?.view = toggleMonitoringViewController.view

        let sleepWakePlaceHolder = statusMenu.item(withTag: 3)
        sleepWakePlaceHolder?.view = sleepWakeViewController.view

        populateEffects()

        let icon = NSImage(named: "statusMenuIcon")
        icon?.isTemplate = true
        statusItem.button?.image = icon
        statusItem.button?.toolTip = Bundle.appName()
//        statusItem.button?.title = Bundle.appName()
        statusItem.menu = statusMenu

        (self as EffectConfigureHandler).startObserving()
        (self as EffectToggledHandler).startObserving()
        (self as KeyboardInfoHandler).startObserving()
        keyboardInfoViewController.startObserving()
    }

    deinit {
        (self as EffectToggledHandler).stopObserving()
        (self as EffectConfigureHandler).stopObserving()
        (self as KeyboardInfoHandler).stopObserving()
        keyboardInfoViewController.stopObserving()
    }

    func keyboardInfo(notification: Notification) {
        guard notification.name == Notification.Name.CustomKeyboardInfo else {return}
        guard let isPlugged = notification.userInfo?["isPlugged"] as? Bool else {return}
        guard let keyboardInfoPlaceHolder = statusMenu.item(withTag: 2) else {return}

        DispatchQueue.main.sync {
            keyboardInfoPlaceHolder.view = isPlugged ? keyboardInfoViewController.view : nil
        }
    }

    func effectConfigure(notification: Notification) {
        guard notification.name == Notification.Name.CustomEffectConfigure else {return}
        guard let effect = notification.userInfo?["effect"] as? Effect else {return}
        logDebug("effect[configure] %@", effect.name)

        // Hide whole menu
        statusMenu.cancelTracking()

        showPreferences()

        let userInfo = ["effect": effect]
        let notification = Notification(name: .CustomEffectSelectConfiguration, object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }

    func effectToggled(notification: Notification) {
        guard notification.name == Notification.Name.CustomEffectToggled else {return}
        guard let effect = notification.userInfo?["effect"] as? Effect else {return}
        guard let isEnabled = notification.userInfo?["isEnabled"] as? Bool else {return}
        logDebug("effect[on/off] %@",
                 effect.name,
                 isEnabled ? "enabled" : "disabled")

        if isEnabled {
            Effect.allCases.forEach { item in
                if item != effect {
                    effectViewControllers[item]?.effectEnabled = false
                }
            }
        }

        // Hide whole menu
        statusMenu.cancelTracking()
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
        } else if object.isEqual(preferencesWindowController?.window) {
            preferencesWindowController = nil
        }
    }

    @objc private func effectHandler(sender: NSMenuItem) {
    }

    func showPreferences() {
        guard preferencesWindowController == nil else {
            preferencesWindowController?.window?.makeKeyAndOrderFront(self)
            preferencesWindowController?.window?.makeMain()
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        if let controller = NSStoryboard(name: .preferences, bundle: nil).instantiateInitialController() as? NSWindowController {
            preferencesWindowController = controller
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(windowWillClose(notification:)),
                                                   name: NSWindow.willCloseNotification,
                                                   object: preferencesWindowController?.window)
            preferencesWindowController?.window?.makeKeyAndOrderFront(self)
            preferencesWindowController?.window?.makeMain()
            NSApp.activate(ignoringOtherApps: true)
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

    @IBAction func preferencesAction(_ sender: NSMenuItem) {
        showPreferences()
    }

    @IBAction func quitAction(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
