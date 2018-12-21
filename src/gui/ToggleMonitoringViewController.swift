//
//  ToggleMonitoringViewController.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

class ToggleMonitoringViewController: NSViewController {
    @IBAction func toggledAction(_ sender: NSSegmentedCell) {
        let userInfo = ["isEnabled": sender.isSelected(forSegment: 0)]
        let notification = Notification(name: .CustomMonitoringToggled, object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
}
