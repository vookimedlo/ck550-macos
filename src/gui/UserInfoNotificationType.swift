/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

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
