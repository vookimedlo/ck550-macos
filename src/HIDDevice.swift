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

class HIDDevice: HIDDeviceProtocol {

    private let manager: IOHIDManager
    private let device: IOHIDDevice

    private let inputBufferSize = 64
    private let inputBuffer: UnsafeMutablePointer<UInt8>

// swiftlint:disable force_cast
    var manufacturer: String? {
        return IOHIDDeviceGetProperty(device, "Manufacturer" as CFString) as! String?
    }
    var product: String? {
        return IOHIDDeviceGetProperty(device, "Product" as CFString) as! String?
    }
    var vendorID: UInt32 {
        return (IOHIDDeviceGetProperty(device, "VendorID" as CFString) as! UInt32)
    }
    var productID: UInt32 {
        return (IOHIDDeviceGetProperty(device, "ProductID" as CFString) as! UInt32)
    }
    var usagePage: UInt32 {
        return (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)
    }
    var usage: UInt32 {
        return (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)
    }
// swiftlint:enable force_cast

    required init(manager: IOHIDManager, device: IOHIDDevice) {
        self.manager = manager
        self.device = device
        self.inputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: inputBufferSize)
    }

    deinit {
        self.inputBuffer.deallocate()
    }

    func open(options: IOOptionBits = IOOptionBits(kIOHIDOptionsTypeNone)) -> Bool {
        guard kIOReturnSuccess == IOHIDDeviceOpen(device, IOOptionBits(kIOHIDOptionsTypeNone))
                else {
            return false
        }

        let inputCallback: IOHIDReportCallback = { context, result, sender, type, reportId, inputBuffer, inputBufferLength in
            guard kIOReturnSuccess == result else {
                return
            }
            let this: HIDDevice = Unmanaged<HIDDevice>.fromOpaque(context!).takeUnretainedValue()
            let buffer = UnsafeMutableBufferPointer(start: inputBuffer, count: inputBufferLength)
            let receivedData = [uint8](buffer)
            this.dataReceived(buffer: receivedData)
        }

        let this = Unmanaged.passRetained(self).toOpaque()
        IOHIDDeviceRegisterInputReportCallback(device, inputBuffer, inputBufferSize, inputCallback, this)
        IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

        return true
    }

    func close(options: IOOptionBits) -> Bool {
        return kIOReturnSuccess == IOHIDDeviceClose(device, IOOptionBits(kIOHIDOptionsTypeNone))
    }

    func write(command: [uint8]) -> Bool {
        let pointerToCommand = UnsafePointer<uint8>(command)
        return kIOReturnSuccess == IOHIDDeviceSetReport(device, kIOHIDReportTypeOutput, 0, pointerToCommand, command.count)
    }

    func dataReceived(buffer: [uint8]) {
        // Override in a subclass
    }
}
