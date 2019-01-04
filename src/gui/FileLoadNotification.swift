//
//  FileLoadNotification.swift
//  ck550
//
//  Created by Michal Duda on 02/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let CustomFileLoaded = Notification.Name("kCustomFileLoaded")
}

@objc protocol FileLoadedHandler {
    @objc func fileLoaded(notification: Notification)
}

extension FileLoadedHandler {
    func startObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fileLoaded(notification:)),
                                               name: Notification.Name.CustomFileLoaded,
                                               object: nil)
    }
    func stopObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.CustomFileLoaded,
                                                  object: nil)
    }
}
