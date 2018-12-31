//
//  MonitoringNotification.swift
//  ck550
//
//  Created by Michal Duda on 18/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomMenuToggled = Notification.Name("kCustomMenuToggled")
}

@objc protocol MenuToggledHandler {
    @objc func menuToggled(notification: Notification)
}

extension MenuToggledHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(menuToggled(notification:)),
                                               name: Notification.Name.CustomMenuToggled,
                                               object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.CustomMenuToggled,
                                                  object: nil)
    }
}
