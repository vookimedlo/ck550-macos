//
//  HIDRaw.swift
//  ck550
//
//  Created by Michal Duda on 10/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import IOKit

class HIDRaw {
    
    class HIDDevice {
        private let manager : IOHIDManager
        private let device : IOHIDDevice
        
        private let inputBufferSize = 64
        private let inputBuffer : UnsafeMutablePointer<UInt8>
        
        var manufacturer : String? {
            get {
                return IOHIDDeviceGetProperty(device, "Manufacturer" as CFString) as! String?
            }
        }
        var product : String? {
            get {
                return IOHIDDeviceGetProperty(device, "Product" as CFString) as! String?
            }
        }
        var vendorID : UInt32 {
            get {
                return (IOHIDDeviceGetProperty(device, "VendorID" as CFString) as! UInt32)
            }
        }
        var productID : UInt32 {
            get {
                return (IOHIDDeviceGetProperty(device, "ProductID" as CFString) as! UInt32)
            }
        }
        var usagePage : UInt32 {
            get {
                return (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)
            }
        }
        var usage : UInt32 {
            get {
                return (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)
            }
        }
        
        init(manager: IOHIDManager, device: IOHIDDevice) {
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

            let inputCallback : IOHIDReportCallback = { context, result, sender, type, reportId, inputBuffer, inputBufferLength in
                guard kIOReturnSuccess == result else {
                    return
                }
                let this : HIDRaw = Unmanaged<HIDRaw>.fromOpaque(context!).takeUnretainedValue()
                let buffer = UnsafeMutableBufferPointer(start: inputBuffer, count: inputBufferLength)
                print(Data(buffer: buffer).hexString())
            }
            
            let this = Unmanaged.passRetained(self).toOpaque()
            IOHIDDeviceRegisterInputReportCallback(device, inputBuffer, inputBufferSize, inputCallback, this)
            IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue);
            
            return true
        }
        
        func write(command: [uint8]) -> Bool {
            let pointerToCommand = UnsafePointer<uint8>(command)
            return kIOReturnSuccess == IOHIDDeviceSetReport(device, kIOHIDReportTypeOutput, 0, pointerToCommand, command.count);
        }
        
    }
    
    private let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    private var dispatchQueue = DispatchQueue(label: "HIDRaw", qos: .utility, attributes: .concurrent)
    
    private func enumerated(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        guard result == kIOReturnSuccess else {
            return
        }
        
        if 0xFF00 == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32) {
            
            print(device)
            print("keybord device")
            
            let hidDevice = HIDDevice(manager: manager, device: device)
            hidDevice.open()
            

  //          _ = hidDevice.write(command: CK550Command.setManualControl)
    //        _ = hidDevice.write(command: CK550Command.turnLEDsOff)
//            _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 1))
            let res = hidDevice.write(command: CK550Command.setFirmwareControl)
            print("write", res)
        }
    }
    
    private func removed(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        print("disconnect")
        print(result)
    }
    
    func monitorEnumeration(vid: Int, pid: Int) -> Bool {

        let deviceMatch = [kIOHIDProductIDKey: pid, kIOHIDVendorIDKey: vid]
        
        let matchingCallback : IOHIDDeviceCallback = { context, result, sender, device in
            let this : HIDRaw = Unmanaged<HIDRaw>.fromOpaque(context!).takeUnretainedValue()
            this.enumerated(result: result, sender: sender!, device: device)
        }
        
        let removalCallback : IOHIDDeviceCallback = { context, result, sender, device in
           let this : HIDRaw = Unmanaged<HIDRaw>.fromOpaque(context!).takeUnretainedValue()
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
