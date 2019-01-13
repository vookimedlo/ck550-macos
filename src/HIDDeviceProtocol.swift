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

/// HIDEnumerator creates a HIDDeviceProtocol compatible instances
/// and provides them to registered observers.
protocol HIDDeviceProtocol {
    /// The USB Msnufacturer string representation.
    var manufacturer: String? { get }

    /// The USB Product string representation.
    var product: String? { get }

    /// The USB Vendor ID.
    var vendorID: UInt32 { get }

    /// The USB Product ID.
    var productID: UInt32 { get }

    /// The USB HID Usage Page ID.
    var usagePage: UInt32 { get }

    /// The USB HID Usage ID
    var usage: UInt32 { get }

    /// Creates a device.
    ///
    /// - Parameters:
    ///   - manager: Instance of a IOHIDManager, which was responsible for a device enumeration.
    ///   - device: Underlying device reported by the 'manager'.
    init(manager: IOHIDManager, device: IOHIDDevice)

    /// Opens the device.
    ///
    /// - Parameter options: <#options description#>
    /// - Returns: <#return value description#>
    func open(options: IOOptionBits) -> Bool

    /// Closes the device
    ///
    /// - Parameter options: <#options description#>
    /// - Returns: True if the device was closed successfully.
    @discardableResult func close(options: IOOptionBits) -> Bool

    /// A callback providing data received from the device.
    ///
    /// - Parameter buffer: Bytes received from the device.
    func dataReceived(buffer: [uint8])

    /// Writes data to the device.
    ///
    /// - Parameter buffer: Bytes which shall be sent to the device.
    /// - Returns: True if data was written successfuly. False otherwise
    func write(buffer: [uint8]) -> Bool
}
