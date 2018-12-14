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
    private let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    private var usagePage: UInt32 = 0
    private var usage: UInt32 = 0
    private var enumeratedDevs: Dictionary<IOHIDDevice, HIDDeviceProtocol> = Dictionary<IOHIDDevice, HIDDeviceProtocol>()
    private let hidDeviceType: HIDDeviceProtocol.Type
    
    
    required init<HID_DEVICE: HIDDeviceProtocol>(_ deviceType: HID_DEVICE.Type) {
        hidDeviceType = deviceType
    }
    
    private func enumerated(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        guard result == kIOReturnSuccess else {
            return
        }
        
        if (usagePage == 0 || usagePage == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)) && (usage == 0 || usage == (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)) {
            
            let hidDevice = hidDeviceType.init(manager: manager, device: device)
            let userInfo = ["device": hidDevice]
            let notification = Notification(name: .CustomHIDDeviceEnumerated, object: self, userInfo: userInfo)
            
            enumeratedDevs[device] = hidDevice
            NotificationCenter.default.post(notification)
        }
    }
    
    private func removed(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
            if (usagePage == 0 || usagePage == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)) && (usage == 0 || usage == (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)) {
                
                if let removedDevice = enumeratedDevs[device] {
                    let userInfo = ["device": removedDevice]
                    let notification = Notification(name: .CustomHIDDeviceRemoved, object: self, userInfo: userInfo)
                    NotificationCenter.default.post(notification)
                    enumeratedDevs[device] = nil
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
