//
//  EffectDefaultConfigurationNotification.swift
//  ck550
//
//  Created by Michal Duda on 28/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomEffectDefaultConfiguration = Notification.Name("kCustomEffectDefaultConfiguration")
}

@objc protocol EffectDefaultConfigurationHandler {
    @objc func effectDefaultConfiguration(notification: Notification)
}

extension EffectDefaultConfigurationHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(effectDefaultConfiguration(notification:)),
                                               name: Notification.Name.CustomEffectDefaultConfiguration,
                                               object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.CustomEffectDefaultConfiguration,
                                                  object: nil)
    }
}
