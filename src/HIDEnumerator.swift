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
import IOKit

class HIDEnumerator {
    private let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    private var usagePage: UInt32 = 0
    private var usage: UInt32 = 0
    private var enumeratedDevices: [IOHIDDevice: HIDDeviceProtocol] = [IOHIDDevice: HIDDeviceProtocol]()
    private let hidDeviceType: HIDDeviceProtocol.Type

    required init<HIDDEVICE: HIDDeviceProtocol>(_ deviceType: HIDDEVICE.Type) {
        hidDeviceType = deviceType
    }

    private func enumerated(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) {
        guard result == kIOReturnSuccess else {
            return
        }
// swiftlint:disable force_cast
        if (usagePage == 0 || usagePage == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)) && (usage == 0 || usage == (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)) {
// swiftlint:enable force_cast

            let hidDevice = hidDeviceType.init(manager: manager, device: device)
            let userInfo = ["device": hidDevice]
            let notification = Notification(name: .CustomHIDDeviceEnumerated, object: self, userInfo: userInfo)

            enumeratedDevices[device] = hidDevice
            NotificationCenter.default.post(notification)
        }
    }

    private func removed(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) {
// swiftlint:disable force_cast
        if (usagePage == 0 || usagePage == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)) && (usage == 0 || usage == (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)) {
// swiftlint:enable force_cast

            if let removedDevice = enumeratedDevices[device] {
                let userInfo = ["device": removedDevice]
                let notification = Notification(name: .CustomHIDDeviceRemoved, object: self, userInfo: userInfo)
                NotificationCenter.default.post(notification)
                enumeratedDevices[device] = nil
            }
        }
    }

    func monitorEnumeration(vid: Int, pid: Int) -> Bool {
        return monitorEnumeration(vid: vid, pid: pid, usagePage: 0, usage: 0)
    }

    func monitorEnumeration(vid: Int, pid: Int, usagePage: UInt32, usage: UInt32) -> Bool {
        let deviceMatch = [kIOHIDProductIDKey: pid, kIOHIDVendorIDKey: vid]
        self.usagePage = usagePage
        self.usage = usage

        let matchingCallback: IOHIDDeviceCallback = { context, result, sender, device in
            let this: HIDEnumerator = Unmanaged<HIDEnumerator>.fromOpaque(context!).takeUnretainedValue()
            this.enumerated(result: result, sender: sender!, device: device)
        }

        let removalCallback: IOHIDDeviceCallback = { context, result, sender, device in
            let this: HIDEnumerator = Unmanaged<HIDEnumerator>.fromOpaque(context!).takeUnretainedValue()
            this.removed(result: result, sender: sender!, device: device)
        }

        let this = Unmanaged.passRetained(self).toOpaque()
        IOHIDManagerRegisterDeviceMatchingCallback(manager, matchingCallback, this)
        IOHIDManagerRegisterDeviceRemovalCallback(manager, removalCallback, this)

        IOHIDManagerSetDeviceMatching(manager, deviceMatch as CFDictionary?)
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

        return kIOReturnSuccess == IOHIDManagerOpen(manager, 0)
    }
}
