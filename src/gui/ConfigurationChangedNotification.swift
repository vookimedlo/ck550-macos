//
//  ConfigurationChangedNotification.swift
//  ck550
//
//  Created by Michal Duda on 30/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomConfigurationChanged = Notification.Name("kCustomConfigurationChanged")
}

@objc protocol ConfigurationChangedHandler {
    @objc func configurationChanged(notification: Notification)
}

extension ConfigurationChangedHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(configurationChanged(notification:)),
                                               name: Notification.Name.CustomConfigurationChanged,
                                               object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.CustomConfigurationChanged,
                                                  object: nil)
    }
}
