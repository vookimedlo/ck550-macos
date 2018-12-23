//
//  PreferencesViewController.swift
//  ck550
//
//  Created by Michal Duda on 22/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var listView: NSOutlineView!
    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var footerView: NSView!
    @IBOutlet weak var headerTitleTextField: NSTextField!
 
    private var effectPreferenceViewControllers = [Effect: PreferenceViewController]()
    
    required override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.wantsLayer = true
        footerView.wantsLayer = true
        
        self.listView.expandItem(nil, expandChildren: true)
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
    }
    
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self, name: NSWindow.didResignKeyNotification, object: view.window)
        logDebug("time to save all configuration changes")
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
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
    
    private func createEffectPreferenceViewController<T: PreferenceViewController>(name: NSNib.Name, type: T.Type) -> PreferenceViewController? {
        var resultingController: PreferenceViewController?
        
        // This is a file-owner
        let controller = (T.self as! NSViewController.Type).init(nibName: name, bundle: nil)
        controller.loadView()
        
        // This is the real controller defined in XIB
        if let controller = controller.view.findViewController(type: T.self) {
            controller.setup()
            resultingController = controller
        } else {
            logError("Unknown effect preference controller")
        }
        
        return resultingController
    }
    
    private func useEffectPreferenceViewController(for effect: Effect, controller: PreferenceViewController?) {
        if let controller = controller {
            effectPreferenceViewControllers[effect] = controller
            mainView.addSubview(controller.view)
        }
    }
    
    func preferenceSelected(effect: Effect) {
        headerTitleTextField.stringValue = effect.name()
        removeMainViewSubviews()

        if let controller = effectPreferenceViewControllers[effect] {
            logDebug("restoring a preference mainView")
            mainView.addSubview(controller.view)
        } else {
            switch effect {
            case .off:
                let controller = createEffectPreferenceViewController(name: NSNib.Name("EffectNoPreferenceView"),
                                                  type: EffectNoPreferenceViewController.self)
                useEffectPreferenceViewController(for: effect, controller: controller)
            default:
                let controller = createEffectPreferenceViewController(name: NSNib.Name("EffectPreferenceView"),
                                                  type: EffectPreferenceViewController.self)
                useEffectPreferenceViewController(for: effect, controller: controller)
            }
        }
    }
    
    func preferenceSelected() {
        headerTitleTextField.stringValue = "Effect Preferences"
        removeMainViewSubviews()
    }
    
    func preferenceNotSelected() {
        headerTitleTextField.stringValue = "Preferences"
        removeMainViewSubviews()
    }
    
    @IBAction func closeAction(_ sender: NSButton) {
        view.window?.performClose(self)
    }
}
