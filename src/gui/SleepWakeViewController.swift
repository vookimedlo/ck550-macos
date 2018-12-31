//
//  SleepWakeViewController.swift
//  ck550
//
//  Created by Michal Duda on 01/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class SleepWakeViewController: NSViewController {
    @IBAction func sleepWakeToggledAction(_ sender: NSSegmentedControl) {
        let userInfo = [UserInfoNotificationType.isSleepWakeEnabled.rawValue: sender.isSelected(forSegment: 0)]
        let notification = Notification(name: .CustomMenuToggled,
                                        object: self,
                                        userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
}
