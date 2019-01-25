/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import Cocoa
import Foundation
import Sparkle

class StatusMenuController: NSObject, EffectToggledHandler, EffectConfigureHandler, KeyboardInfoHandler {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var statusEffectMenu: NSMenu!
    @IBOutlet weak var statusUpdateMenuItem: NSMenuItem!
    @IBOutlet weak var toggleMonitoringViewController: MonitoringViewController!
    @IBOutlet weak var keyboardInfoViewController: KeyboardInfoViewController!
    @IBOutlet weak var sleepWakeViewController: SleepWakeViewController!
    @IBOutlet weak var updater: SUUpdater!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var aboutWindowController: AboutWindowController?
    private var preferencesWindowController: NSWindowController?
    private var effectViewControllers = [Effect: EffectMenuViewController]()

    override func awakeFromNib() {
        if Bundle.isUpdaterEnabled() == false {
            updater.automaticallyChecksForUpdates = false
            updater.automaticallyDownloadsUpdates = false
            statusUpdateMenuItem.isEnabled = false
            statusUpdateMenuItem.isHidden = true
        }

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
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomKeyboardInfo)
            else {return}
        guard let isPlugged = userInfo[.isPlugged] as? Bool else {return}
        guard let keyboardInfoPlaceHolder = statusMenu.item(withTag: 2) else {return}

        DispatchQueue.main.sync {
            keyboardInfoPlaceHolder.view = isPlugged ? keyboardInfoViewController.view : nil
        }
    }

    func effectConfigure(notification: Notification) {
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomEffectConfigure)
            else {return}
        guard let effect = userInfo[.effect] as? Effect else {return}
        logDebug("effect[configure] %@", effect.name)

        // Hide whole menu
        statusMenu.cancelTracking()

        showPreferences()

        var userInfoBuilder = UserInfo()
        userInfoBuilder[.effect] = effect
        let notification = Notification(name: .CustomEffectSelectConfiguration,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)
    }

    func effectToggled(notification: Notification) {
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomEffectToggled)
            else {return}
        guard let effect = userInfo[.effect] as? Effect else {return}
        guard let isEnabled = userInfo[.isEnabled] as? Bool else {return}
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

    @IBAction func checkForUpdateAction(_ sender: NSMenuItem) {
        updater.checkForUpdates(sender)
    }

    @IBAction func preferencesAction(_ sender: NSMenuItem) {
        showPreferences()
    }

    @IBAction func quitAction(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
