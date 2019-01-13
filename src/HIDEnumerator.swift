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

/// Provides an access to HID enumeration.
class HIDEnumerator {
    private let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    private var usagePage: UInt32 = 0
    private var usage: UInt32 = 0
    private var enumeratedDevices: [IOHIDDevice: HIDDeviceProtocol] = [IOHIDDevice: HIDDeviceProtocol]()
    private let hidDeviceType: HIDDeviceProtocol.Type

    /// Creates a HIDEnumerator instance.
    ///
    /// - Parameters:
    ///   - deviceType: `HIDDeviceProtocol` compatible type, which is used for an instantiation
    ///                 when passing an enumeration or removal result.
    required init<HIDDEVICE: HIDDeviceProtocol>(_ deviceType: HIDDEVICE.Type) {
        hidDeviceType = deviceType
    }

    /// A callback to be used by `IOHIDManager` when a device is enumerated.
    ///
    /// - Parameters:
    ///   - result: The IOHIDManager operation result.
    ///   - sender: IOHIDManager instance, which called this callback
    ///   - device: The enumerated device.
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

    /// A callback to be used by `IOHIDManager` when any enumerated device is removed.
    ///
    /// - Parameters:
    ///   - result: The IOHIDManager operation result.
    ///   - sender: IOHIDManager instance, which called this callback
    ///   - device: The removed device.
    private func removed(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) {
        guard result == kIOReturnSuccess else {
            return
        }
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

    /// Starts a HID enumeration monitoring and filters enumerated results by provided USB IDs.
    ///
    /// - Parameters:
    ///   - vid: The USB Vendor ID.
    ///   - pid: The USB Product ID.
    /// - Returns: True when monitring has started. False otherwise.
    func monitorEnumeration(vid: Int, pid: Int) -> Bool {
        return monitorEnumeration(vid: vid, pid: pid, usagePage: 0, usage: 0)
    }

    /// Starts a HID enumeration monitoring and filters enumerated results by provided USB IDs.
    ///
    /// - Parameters:
    ///   - vid: The USB Vendor ID.
    ///   - pid: The USB Product ID.
    ///   - usagePage: The USB HID Usage Page ID.
    ///   - usage: The USB HID Usage ID.
    /// - Returns: True when monitring has started. False otherwise.
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
