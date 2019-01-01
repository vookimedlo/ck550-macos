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
        var userInfoBuilder = UserInfo()
        userInfoBuilder[.effect] = effect!
        let notification = Notification(name: .CustomEffectConfigure,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)
    }

    @IBAction func enablingToggledAction(_ sender: NSSegmentedControl) {
        var userInfoBuilder = UserInfo()
        userInfoBuilder[.isEnabled] = sender.isSelected(forSegment: 0)
        userInfoBuilder[.effect] = effect!
        let notification = Notification(name: .CustomEffectToggled,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)
    }
}
