//
//  HIDEnumerationNotification.swift
//  ck550-cli
//
//  Created by Michal Duda on 26/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomHIDDeviceEnumerated = Notification.Name("kCustomHIDDeviceEnumerated")
    public static let CustomHIDDeviceRemoved = Notification.Name("kCustomHIDDeviceRemoved")
}

@objc protocol HIDDeviceEnumeratedHandler {
    @objc func deviceEnumerated(notification: Notification)
    @objc func deviceRemoved(notification: Notification)
}

extension HIDDeviceEnumeratedHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceEnumerated(notification:)), name: Notification.Name.CustomHIDDeviceEnumerated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRemoved(notification:)), name: Notification.Name.CustomHIDDeviceRemoved, object: nil)
    }

    func stopObserving() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomHIDDeviceEnumerated, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomHIDDeviceRemoved, object: nil)
    }
}
