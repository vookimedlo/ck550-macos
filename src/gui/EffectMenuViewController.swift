//
//  EffectMenuViewController.swift
//  ck550
//
//  Created by Michal Duda on 19/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class EffectMenuViewController: NSViewController {
    @IBOutlet weak var effectTextField: NSTextField!
    @IBOutlet weak var enablingSegmentedControl: NSSegmentedControl!

    var effect: Effect?
    var effectEnabled: Bool {
        get {
            return enablingSegmentedControl.isSelected(forSegment: 0)
        }
        set(value) {
            enablingSegmentedControl.selectedSegment = value ? 0 : 1
        }
    }

    func setup(effect: Effect) {
        self.effect = effect
        effectTextField.stringValue = self.effect?.name ?? ""
    }

    @IBAction func configurationAction(_ sender: NSButton) {
        let userInfo = ["effect": effect!]
        let notification = Notification(name: .CustomEffectConfigure,
                                        object: self,
                                        userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }

    @IBAction func enablingToggledAction(_ sender: NSSegmentedControl) {
        let userInfo = ["isEnabled": sender.isSelected(forSegment: 0),
                        "effect": effect!] as [String: Any]
        let notification = Notification(name: .CustomEffectToggled,
                                        object: self,
                                        userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
}
