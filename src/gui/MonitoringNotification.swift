//
//  MonitoringNotification.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomMonitoringToggled = Notification.Name("kCustomMonitoringToggled")
}

@objc protocol MonitoringToggledHandler {
    @objc func monitoringToggled(notification: Notification)
}

extension MonitoringToggledHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(monitoringToggled(notification:)), name: Notification.Name.CustomMonitoringToggled, object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomMonitoringToggled, object: nil)
    }
}
