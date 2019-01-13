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

extension Notification.Name {
    /// Sent upon an USB device enumeration.
    public static let CustomHIDDeviceEnumerated = Notification.Name("kCustomHIDDeviceEnumerated")

    /// Sent upon an USB device removal.
    public static let CustomHIDDeviceRemoved = Notification.Name("kCustomHIDDeviceRemoved")
}

/// Protocol for receiving notifications from a `HIDEnumerator`
@objc protocol HIDDeviceEnumeratedHandler {
    /// Callback notifying about an USB device enumeration.
    ///
    /// - Parameter notification: *notification.userInfo["device"]* is an enumerated device,
    ///                           compatible with the `HIDDeviceProtocol`.
    @objc func deviceEnumerated(notification: Notification)

    /// Callback notifying about an USB device removal.
    ///
    /// - Parameter notification: *notification.userInfo["device"]* is a removed device,
    ///                           compatible with the `HIDDeviceProtocol`.
    @objc func deviceRemoved(notification: Notification)
}

extension HIDDeviceEnumeratedHandler {
    /// Registers itself as an observer of `Notification.CustomHIDDeviceEnumerated`
    /// and `Notification.CustomHIDDeviceRemoved`
    func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceEnumerated(notification:)), name: Notification.Name.CustomHIDDeviceEnumerated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRemoved(notification:)), name: Notification.Name.CustomHIDDeviceRemoved, object: nil)
    }

    /// Deregisters itself as an observer of `Notification.CustomHIDDeviceEnumerated`
    /// and `Notification.CustomHIDDeviceRemoved`
    func stopObserving() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomHIDDeviceEnumerated, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.CustomHIDDeviceRemoved, object: nil)
    }
}
