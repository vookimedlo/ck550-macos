//
//  PreferencesViewController.swift
//  ck550
//
//  Created by Michal Duda on 22/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

class PreferencesViewController: NSViewController, EffectSelectConfigurationHandler, EffectDefaultConfigurationHandler {
    @IBOutlet weak var listView: NSOutlineView!
    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var footerView: NSView!
    @IBOutlet weak var headerTitleTextField: NSTextField!

    private var configuration = AppPreferences()
    private var effectPreferenceViewControllers = [Effect: PreferenceViewController]()
    private var effectsPreferenceViewController: PreferenceViewController?
    var effectListViewContainer: NSView?
    var effectListViewItems = [Effect: NSView]()

    required override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.wantsLayer = true
        footerView.wantsLayer = true

        self.listView.expandItem(nil,
                                 expandChildren: true)
    }

    override func viewWillAppear() {
        headerView.layer?.backgroundColor = NSColor.black.cgColor
        headerView.layer?.borderColor = NSColor.red.cgColor
        headerView.addBottomBorder(color: NSColor.white, width: 2)
        headerTitleTextField.textColor = NSColor.white
        footerView.addTopBorder(color: NSColor.white, width: 2)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didResignKeyNotification(notification:)),
                                               name: NSWindow.didResignKeyNotification,
                                               object: view.window)

        createAndRegisterEffectPreferenceViewControllers()

        configuration.read()
        populateConfigurationToViews()

        // Select an 'Effects' item in shown in a list view
        if let effectPreferencesView = self.effectListViewContainer {
            let index = listView.row(for: effectPreferencesView)
            listView.selectRowIndexes(IndexSet(integer: index),
                                      byExtendingSelection: false)
        }

        (self as EffectDefaultConfigurationHandler).startObserving()
        (self as EffectSelectConfigurationHandler).startObserving()
    }

    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSWindow.didResignKeyNotification,
                                                  object: view.window)
        logDebug("time to save all configuration changes")

        (self as EffectSelectConfigurationHandler).stopObserving()
        (self as EffectDefaultConfigurationHandler).stopObserving()

        var json = JSON()
        effectPreferenceViewControllers.forEach { controller in
            json[controller.key.name] = controller.value.settings
        }

        configuration[.effect] = json
        configuration.write()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func populateConfigurationToViews() {
        for effect in effectPreferenceViewControllers.keys {
            effectPreferenceViewControllers[effect]?.settings = configuration[.effect][effect.name]
        }
    }

    func effectSelectConfiguration(notification: Notification) {
        guard notification.name == Notification.Name.CustomEffectSelectConfiguration else {return}
        guard let effect = notification.userInfo?["effect"] as? Effect else {return}
        logDebug("effect[config selection] %@", effect.name)

        // Select an 'Effects' item in shown in a list view
        if let effectPreferenceView = self.effectListViewItems[effect] {
            let index = listView.row(for: effectPreferenceView)
            listView.selectRowIndexes(IndexSet(integer: index),
                                      byExtendingSelection: false)
        }
    }

    func effectDefaultConfiguration(notification: Notification) {
        guard notification.name == Notification.Name.CustomEffectDefaultConfiguration else {return}
        logDebug("using a default configuration")
        configuration.readDefaultPreferences()
        populateConfigurationToViews()
    }

    @objc private func didResignKeyNotification(notification: Notification) {
        guard let object = notification.object as? NSWindow else { return }
        if object.isEqual(view.window) {
            view.window?.performClose(self)
        }
    }

    private func removeMainViewSubviews() {
        mainView.subviews.forEach { subview in
            if let index = effectPreferenceViewControllers.values.firstIndex(where: { controller in
                return controller.view == subview
            }) {
                effectPreferenceViewControllers[index].value.deactivated()
            }
        }

        // Remove a previously used effect preference view
        mainView.subviews = []
    }

    private func createEffectPreferenceViewController<T: PreferenceViewController>(name: NSNib.Name,
                                                                                   type: T.Type) -> PreferenceViewController? {

        // This is a file-owner
        guard let controllerType = T.self as? NSViewController.Type else {return nil}
        let controller = controllerType.init(nibName: name, bundle: nil)
        controller.loadView()

        var resultingController: PreferenceViewController?

        // This is the real controller defined in XIB
        if let controller = controller.view.findViewController(type: T.self) {
            controller.setup()
            resultingController = controller
        } else {
            logError("Unknown effect preference controller")
        }

        return resultingController
    }

    private func useEffectPreferenceViewController(for effect: Effect,
                                                   controller: PreferenceViewController?) {
        if let controller = controller {
            effectPreferenceViewControllers[effect] = controller
        }
    }

    private func createEffectPreferenceViewController(showColor: Bool = true,
                                                      showRandom: Bool = true,
                                                      showBackgroundColor: Bool = true,
                                                      showSpeed: Bool = true,
                                                      showDirection: Bool = false) -> EffectPreferenceViewController? {
        let controller = createEffectPreferenceViewController(name: NSNib.Name("EffectPreferenceView"),
                                                              type: EffectPreferenceViewController.self) as? EffectPreferenceViewController
        controller?.adjustView(showColor: showColor,
                               showRandom: showRandom,
                               showBackgroundColor: showBackgroundColor,
                               showSpeed: showSpeed,
                               showDirection: showDirection)
        return controller
    }

    func createAndRegisterEffectPreferenceViewControllers() {
        Effect.allCases.forEach { effect in
            switch effect {
            case .star,
                 .crossMode,
                 .singleKey,
                 .ripple,
                 .snowing:
                let controller = createEffectPreferenceViewController(showRandom: false)
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            case .reactivePunch,
                 .heartbeat,
                 .fireball,
                 .waterRipple:
                let controller = createEffectPreferenceViewController()
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            case .circleSpectrum,
                 .reactiveTornado:
                let controller = createEffectPreferenceViewController(showColor: false,
                                                                      showRandom: false,
                                                                      showBackgroundColor: false,
                                                                      showDirection: true)
                controller?.setupDirectionComboBox(item: "clockwise")
                controller?.setupDirectionComboBox(item: "counterclockwise")
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            case .breathing:
                let controller = createEffectPreferenceViewController(showBackgroundColor: false)
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            case .wave:
                let controller = createEffectPreferenceViewController(showRandom: false,
                                                                      showBackgroundColor: false,
                                                                      showDirection: true)
                controller?.setupDirectionComboBox(item: "left to right")
                controller?.setupDirectionComboBox(item: "top to bottom")
                controller?.setupDirectionComboBox(item: "right to left")
                controller?.setupDirectionComboBox(item: "bottom to top")
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            case .staticKeys:
                let controller = createEffectPreferenceViewController(showRandom: false,
                                                                      showBackgroundColor: false,
                                                                      showSpeed: false)
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            case .colorCycle:
                let controller = createEffectPreferenceViewController(showColor: false,
                                                                      showRandom: false,
                                                                      showBackgroundColor: false)
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            default:
                let controller = createEffectPreferenceViewController(name: NSNib.Name("EffectNoPreferenceView"),
                                                                      type: EffectNoPreferenceViewController.self)
                useEffectPreferenceViewController(for: effect,
                                                  controller: controller)
            }
        }
    }

    func preferenceSelected(effect: Effect) {
        headerTitleTextField.stringValue = effect.name
        removeMainViewSubviews()

        if let controller = effectPreferenceViewControllers[effect] {
            logDebug("restoring a preference mainView")
            mainView.addSubview(controller.view)
        } else {
            logError("unknown preference mainView")
        }
    }

    func preferenceSelected() {
        headerTitleTextField.stringValue = "Effect Preferences"
        removeMainViewSubviews()

        if let controller = effectsPreferenceViewController {
            mainView.addSubview(controller.view)
        } else if let controller = createEffectPreferenceViewController(
            name: NSNib.Name("EffectsPreferenceView"),
            type: EffectsPreferenceViewController.self) {

            effectsPreferenceViewController = controller
            mainView.addSubview(controller.view)
        }
    }

    func preferenceNotSelected() {
        headerTitleTextField.stringValue = "Preferences"
        removeMainViewSubviews()
    }

    @IBAction func closeAction(_ sender: NSButton) {
        NSColorPanel.shared.orderOut(nil)
        view.window?.performClose(self)
    }
}
