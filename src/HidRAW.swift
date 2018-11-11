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
    private let managerRef = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    private var dispatchQueue = DispatchQueue(label: "HIDRaw", qos: .utility, attributes: .concurrent)
    
    private func enumerated(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        guard result == kIOReturnSuccess else {
            return
        }

/*
        if let manufacturer = IOHIDDeviceGetProperty(device, "Manufacturer" as CFString) {
            if let product = IOHIDDeviceGetProperty(device, "Product" as CFString) {
                print("Device enumerated:", manufacturer, " - ", product)
            }
        }
 */
        
        if 0xFF00 == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32) {
            
            print(device)
            print("keybord device")
            
            let result = IOHIDDeviceOpen(device, IOOptionBits(kIOHIDOptionsTypeNone))
            print(result)
            
            let reportSize = 64
            let report = UnsafeMutablePointer<UInt8>.allocate(capacity: reportSize)
            
            let inputCallback : IOHIDReportCallback = { context, result, sender, type, reportId, report, reportLength in
                let this : HIDRaw = Unmanaged<HIDRaw>.fromOpaque(context!).takeUnretainedValue()
                print("input", result, reportLength)

                let buffer = UnsafeMutableBufferPointer(start: report, count: reportLength)
                
                print(Data(buffer: buffer).hexString())
            }
            
            let this = Unmanaged.passRetained(self).toOpaque()
            IOHIDDeviceRegisterInputReportCallback(device!, report, reportSize, inputCallback, this)
            IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue);

            var arrayToSend = Array.init(repeating: UInt8(0x00), count: 64)
            arrayToSend[0] = 0x52
            arrayToSend[1] = 0x00
            
            //var data = Data(bytes: arrayToSend)
            var pointer = UnsafePointer<uint8>(arrayToSend)
            
            let ret = IOHIDDeviceSetReport(device, kIOHIDReportTypeOutput, 0, pointer, arrayToSend.count);
            print("write", ret)
        }
    }
    
    private func removed(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        print("disconnect")
        print(result)
    }
    
    private func write(buffer: [uint8]) -> Bool {
        return true
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
        IOHIDManagerRegisterDeviceMatchingCallback(managerRef, matchingCallback, this)
        IOHIDManagerRegisterDeviceRemovalCallback(managerRef, removalCallback, this)
        
        IOHIDManagerSetDeviceMatching(managerRef, deviceMatch as CFDictionary?)
        IOHIDManagerScheduleWithRunLoop(managerRef, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        return kIOReturnSuccess == IOHIDManagerOpen(managerRef, 0)
    }

}
