//
//  EffectNotification.swift
//  ck550
//
//  Created by Michal Duda on 20/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomEffectToggled = Notification.Name("kCustomEffectToggled")
}

@objc protocol EffectToggledHandler {
    @objc func effectToggled(notification: Notification)
}

extension EffectToggledHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(effectToggled(notification:)), name: Notification.Name.CustomEffectToggled, object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomEffectToggled, object: nil)
    }
}