//
//  EffectSelectConfigurationNotification.swift
//  ck550
//
//  Created by Michal Duda on 28/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomEffectSelectConfiguration = Notification.Name("kCustomEffectSelectConfiguration")
}

@objc protocol EffectSelectConfigurationHandler {
    @objc func effectSelectConfiguration(notification: Notification)
}

extension EffectSelectConfigurationHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(effectSelectConfiguration(notification:)),
                                               name: Notification.Name.CustomEffectSelectConfiguration,
                                               object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.CustomEffectSelectConfiguration,
                                                  object: nil)
    }
}
