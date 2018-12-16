//
//  HIDDevice.swift
//  ck550
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class HIDDevice: HIDDeviceProtocol {

    private let manager: IOHIDManager
    private let device: IOHIDDevice

    private let inputBufferSize = 64
    private let inputBuffer: UnsafeMutablePointer<UInt8>

    var manufacturer: String? {
        get {
            return IOHIDDeviceGetProperty(device, "Manufacturer" as CFString) as! String?
        }
    }
    var product: String? {
        get {
            return IOHIDDeviceGetProperty(device, "Product" as CFString) as! String?
        }
    }
    var vendorID: UInt32 {
        get {
            return (IOHIDDeviceGetProperty(device, "VendorID" as CFString) as! UInt32)
        }
    }
    var productID: UInt32 {
        get {
            return (IOHIDDeviceGetProperty(device, "ProductID" as CFString) as! UInt32)
        }
    }
    var usagePage: UInt32 {
        get {
            return (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)
        }
    }
    var usage: UInt32 {
        get {
            return (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)
        }
    }

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
            let receivedData = Array<uint8>(buffer)
            this.dataReceived(buffer: receivedData)
        }

        let this = Unmanaged.passRetained(self).toOpaque()
        IOHIDDeviceRegisterInputReportCallback(device, inputBuffer, inputBufferSize, inputCallback, this)
        IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue);

        return true
    }

    func close(options: IOOptionBits) -> Bool {
        return kIOReturnSuccess == IOHIDDeviceClose(device, IOOptionBits(kIOHIDOptionsTypeNone))
    }

    func write(command: [uint8]) -> Bool {
        let pointerToCommand = UnsafePointer<uint8>(command)
        return kIOReturnSuccess == IOHIDDeviceSetReport(device, kIOHIDReportTypeOutput, 0, pointerToCommand, command.count);
    }

    func dataReceived(buffer: [uint8]) -> Void {
        // Override in a subclass
    }
}
