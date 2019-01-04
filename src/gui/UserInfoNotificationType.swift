//
//  UserInfoNotificationType.swift
//  ck550
//
//  Created by Michal Duda on 01/01/2019.
//  Copyright © 2019 Michal Duda. All rights reserved.
//

import Foundation

enum UserInfoNotificationType: String {
    case isMonitoringEnabled, isSleepWakeEnabled
    case isEnabled
    case configuration
    case effect
    case isPlugged
    case fwVersion
    case product
    case manufacturer
    case customizationFile
    case isValid
    case isSelected
}

struct UserInfo {
    typealias UserInfoType = [AnyHashable: Any]

    private var internalData = UserInfoType()

    var userInfo: UserInfoType {
        return internalData
    }

    init() {
        internalData = UserInfoType()
    }

    init?(_ userInfo: UserInfoType?) {
        guard let userInfo = userInfo else {return nil}
        internalData = userInfo
    }

    init?(notification: Notification, expected: Notification.Name) {
        guard notification.name == expected else {return nil}
        self.init(notification.userInfo)
    }

    subscript(key: UserInfoNotificationType) -> Any? {
        get {
            return internalData[key]
        }
        set(newValue) {
            internalData[key] = newValue
        }
    }
}
