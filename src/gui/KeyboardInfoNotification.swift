//
//  KeyboardInfoNotification.swift
//  ck550
//
//  Created by Michal Duda on 31/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomKeyboardInfo = Notification.Name("kCustomKeyboardInfo")
}

@objc protocol KeyboardInfoHandler {
    @objc func keyboardInfo(notification: Notification)
}

extension KeyboardInfoHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardInfo(notification:)),
                                               name: Notification.Name.CustomKeyboardInfo,
                                               object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.CustomKeyboardInfo,
                                                  object: nil)
    }
}
